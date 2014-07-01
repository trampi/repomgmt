require 'find'

class Repository < ActiveRecord::Base
	include RepositoryAccessRefresher
	extend MapDaysToCommits

	default_scope { order(name: :asc) }

	has_many :users, through: :repository_access
	has_many :repository_access, dependent: :destroy
	has_many :tasks
	has_many :versions

	validates :name, presence: true, uniqueness: true

	def cache_key_commits
		last_modification_date = File.mtime(get_path + "objects").to_s
		"REPOSITORY_COMMITS_" + id.to_s + "_" + last_modification_date
	end

	def cache_key_size
		last_modification_date = File.mtime(get_path + "objects").to_s
		"REPOSITORY_SIZE_" + id.to_s + "_" + last_modification_date
	end

	def get_url
		Rails.configuration.repomgmt.repository_url_prefix + name
	end

	def read_all_commits
		return Rails.cache.fetch(cache_key_commits, { expires_in: 1.month }) do
			begin
				git = Git.bare get_path
				git.log(100000).to_a
			rescue Git::GitExecuteError
				[]
			end
		end
	end

	def get_first_commit
		read_all_commits.min_by { |commit| commit.date }
	end

	def get_last_commit
		read_all_commits.max_by { |commit| commit.date }
	end

	def get_tags
		git = Git.bare get_path
		git.tags
	end

	def get_branches
		git = Git.bare get_path
		git.branches
	end

	def get_path
		Pathname.new Rails.configuration.repomgmt.repository_root_path + "/#{name}.git"
	end

	def size_in_bytes
		return Rails.cache.fetch(cache_key_size, { expires_in: 1.month }) do
			size = 0;
			Find.find(get_path) { |f| size += File.size(f) if File.file?(f) }
			size
		end
	end

	def get_commits_per_day
		Repository.map_days_to_commits read_all_commits
	end

	def commits_per_author
		commits = read_all_commits
		grouped_commits = commits.group_by { |commit| commit.author.name }
	end

	def current_version
		versions.where("delivered = ?", true).reorder(due_date: :desc).first
	end

	def next_version
		versions.where("delivered = ?", false).reorder(due_date: :asc).first
	end

	############## CLASS METHODS ##############
	def self.commits_per_author
		result = {}
		Repository.all.each do |repo|
			result.merge!(repo.commits_per_author) { |key, v1, v2| v1 + v2 }
		end
		return result
	end

	def self.read_all_commits
		Repository.all.map { |repo| repo.read_all_commits }.flatten
	end

	def self.get_commits_per_day
		repos = Repository.all
		all_commits = repos.collect_concat { |repo| repo.read_all_commits }
		map_days_to_commits all_commits
	end

	def self.storage_used_in_percent
		storage_bytes_used.to_f / storage_bytes_total * 100
	end

	def self.storage_bytes_free
		stat = Sys::Filesystem.stat "C:/"
		stat.bytes_free
	end

	def self.storage_bytes_total
		stat = Sys::Filesystem.stat "C:/"
		stat.blocks * stat.block_size
	end

	def self.storage_bytes_used
		stat = Sys::Filesystem.stat "C:/"
		(stat.blocks - stat.blocks_free) * stat.block_size
	end

	def self.gitolite_repository_path
		Pathname.new Rails.configuration.repomgmt.gitolite_repository
	end

	def self.gitolite_repository_config_path
		Pathname.new Rails.configuration.repomgmt.gitolite_repository + "/conf/gitolite.conf"
	end

	def self.gitolite_keys_path
		Pathname.new Rails.configuration.repomgmt.gitolite_repository + "/keydir"
	end

	def self.gitolite_keys
		Dir.glob gitolite_keys_path.join("*")
	end
end
