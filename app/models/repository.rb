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
	validates_presence_of :repository_access # gitolite enforces that a repository has to have at least one user

	before_destroy { |record| record.delete_repository }
	before_save { |record| record.rename_repository record.name if record.persisted? }

	before_save do
		mark_authentication_for_rewrite if name_changed?
		true # we don't want to interfere with other callbacks
	end

	before_destroy do
		mark_authentication_for_rewrite
	end

	def get_url
		Rails.configuration.repomgmt.repository_url_prefix + name
	end

	def get_first_commit
		commits.order(date: :asc).take
	end

	def get_last_commit
		commits.order(date: :desc).take
	end

	def get_tags
		# TODO
		git = Git.bare get_path
		git.tags
	end

	def get_branches
		# TODO
		git = Git.bare get_path
		git.branches
	end

	def get_path
		Rails.configuration.repomgmt.repository_root_path + "/#{name}.git"
	end

	def get_commits_per_day
		Repository.map_days_to_commits commits
	end

	def commits_per_author
		commits.to_a.group_by { |commit| commit.user }
	end

	def current_version
		versions.where('delivered = ?', true).reorder(due_date: :desc).first
	end

	def next_version
		versions.where('delivered = ?', false).reorder(due_date: :asc).first
	end

	def index_commits
		commits.destroy_all
		transaction do
			read_all_commits.each do |commit|
				commit_model = Commit.convert(commit)
				commit_model.repository = self
				commit_model.user = User.find_by email: commit_model.committer_email
				commit_model.save
			end

			self.size_in_bytes = 0
			Find.find(get_path) { |f| self.size_in_bytes += File.size(f) if File.file?(f) }

			touch :last_index_date
			save
		end
		commits.reload
		reload
	end

	def delete_repository
		FileUtils.rm_rf get_path
	end

	def rename_repository newname
		oldpath = Repository.find(id).get_path
		newpath = Rails.configuration.repomgmt.repository_root_path + "/#{newname}.git"
		if oldpath != newpath then
			FileUtils.mv(oldpath, newpath)
		end
	end

	private

	def read_all_commits
		begin
			git = Git.bare get_path
			git.log(100000).to_a
		rescue Git::GitExecuteError => e
			logger.error 'Failed fetching commits'
			logger.error e
			[]
		end
	end

	############## CLASS METHODS ##############

	public

	def self.commits_per_author
		result = {}
		Repository.all.each do |repo|
			result.merge!(repo.commits_per_author) { |key, v1, v2| v1 + v2 }
		end
		return result
	end

	def self.get_commits_per_day
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
		logger.info "reindex begin at " + DateTime.now.to_s
		Repository.all.each { |repo| repo.index_commits }
		logger.info "reindex end at " + DateTime.now.to_s
	end

	def self.last_index_date
		Repository.maximum(:last_index_date)
	end
end
