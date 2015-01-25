require 'find'

class Repository < ActiveRecord::Base
  extend MapDaysToCommits
  include MarkForRefreshAuthentication

  default_scope { order(name: :asc) }

  has_many :users, through: :repository_access, after_add: :mark_authentication_for_rewrite, after_remove: :mark_authentication_for_rewrite
  has_many :repository_access, dependent: :destroy, after_add: :mark_authentication_for_rewrite, after_remove: :mark_authentication_for_rewrite
  has_many :tasks
  has_many :versions
  has_many :commits, dependent: :destroy

  validates :name, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9_]+\z/, message: 'darf nur Buchstaben, Zahlen und Unterstriche enthalten'}
  validates :repository_access, presence: true # gitolite enforces that a repository has to have at least one user

  before_destroy do |record|
    record.delete_repository
    mark_authentication_for_rewrite
  end

  before_save do |record|
    record.rename_repository record.name if record.persisted?
    mark_authentication_for_rewrite if name_changed?
    true # we don't want to interfere with other callbacks
  end

  def url
    Rails.configuration.repomgmt.repository_url_prefix + name
  end

  def first_commit
    commits.order(date: :asc).take
  end

  def last_commit
    commits.order(date: :desc).take
  end

  def tags
    # TODO: put it in the database
    git = Git.bare path
    git.tags
  end

  def branches
    # TODO: put it in the database
    git = Git.bare path
    git.branches
  end

  def path
    Rails.configuration.repomgmt.repository_root_path + "/#{name}.git"
  end

  def commits_per_day
    Repository.map_days_to_commits commits
  end

  def commits_per_author
    commits.to_a.group_by(&:user)
  end

  def current_version
    versions.where('delivered = ?', true).reorder(due_date: :desc).first
  end

  def next_version
    versions.where('delivered = ?', false).reorder(due_date: :asc).first
  end

  def index_commits_if_changed
    touch :last_check_date
    index_commits if last_index_date.nil? || last_modification_date > last_index_date
  end

  def index_commits
    commits.destroy_all
    transaction do
      read_all_commits.each do |commit|
        Commit.convert_and_save(commit, repository: self, user: User.find_by(email: commit.committer.email))
      end
      calculate_size
      touch :last_index_date
      save
    end
    reload
  end

  def last_modification_date
    heads_path = path + '/refs/**/*'
    Dir.glob(heads_path).map { |file| File.mtime(file) }.max
  end

  def calculate_size
    self.size_in_bytes = 0
    Find.find(path) { |f| self.size_in_bytes += File.size(f) if File.file?(f) }
  end

  def delete_repository
    FileUtils.rm_rf path
  end

  def rename_repository(new_name)
    old_path = Repository.find(id).path
    new_path = Rails.configuration.repomgmt.repository_root_path + "/#{new_name}.git"
    FileUtils.mv(old_path, new_path) if old_path != new_path
  end

  private

  def read_all_commits
    git = Git.bare path
    git.log(100_000).to_a
  rescue Git::GitExecuteError => e
    logger.error 'Failed fetching commits'
    logger.error e
    []
  end

  def self.commits_per_author
    result = {}
    Repository.all.each do |repo|
      result.merge!(repo.commits_per_author)  { |_key, v1, v2| v1 + v2 }
    end
    result
  end

  def self.commits_per_day
    map_days_to_commits Commit.all
  end

  def self.storage_used_in_percent
    storage_bytes_used.to_f / storage_bytes_total * 100
  end

  def self.storage_bytes_free
    stat = Sys::Filesystem.stat Rails.configuration.repomgmt.repository_root_path
    stat.bytes_free
  end

  def self.storage_bytes_total
    stat = Sys::Filesystem.stat Rails.configuration.repomgmt.repository_root_path
    stat.blocks * stat.block_size
  end

  def self.storage_bytes_used
    stat = Sys::Filesystem.stat Rails.configuration.repomgmt.repository_root_path
    (stat.blocks - stat.blocks_free) * stat.block_size
  end

  def self.gitolite_repository_path
    Pathname.new Rails.configuration.repomgmt.gitolite_repository
  end

  def self.gitolite_repository_config_path
    Pathname.new Rails.configuration.repomgmt.gitolite_repository + '/conf/gitolite.conf'
  end

  def self.gitolite_keys_path
    Pathname.new Rails.configuration.repomgmt.gitolite_repository + '/keydir'
  end

  def self.gitolite_keys
    Dir.glob gitolite_keys_path.join('*')
  end

  def self.index_commits
    logger.info 'reindex begin at ' + DateTime.now.to_s
    Repository.all.each(&:index_commits_if_changed)
    logger.info 'reindex end at ' + DateTime.now.to_s
  end

  def self.last_index_date
    Repository.maximum(:last_index_date)
  end
end
