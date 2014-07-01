class User < ActiveRecord::Base
	attr_accessor :gauth_token
	include RepositoryAccessRefresher
	extend MapDaysToCommits

	default_scope { order(name: :asc) }

	has_many :repositories, through: :repository_access
	has_many :repository_access, dependent: :destroy
	has_many :tasks_assigned, class_name: "Task", inverse_of: :assignee, foreign_key: "assignee_id"
	has_many :tasks_authored, class_name: "Task", inverse_of: :author, foreign_key: "author_id"

	# email is automatically validated by devise
	validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\z/, message: "darf nur Buchstaben und Zahlen enthalten" }
	validates :public_key, public_key: true, uniqueness: true, allow_blank: true

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :google_authenticatable, :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

	def has_public_key?
		SSHKey.valid_ssh_public_key? public_key
	end

	def commits
		if @commits.nil? then
			@commits = repositories.read_all_commits.find_all { |commit| commit.author.name == self.name || commit.author.email == self.email }
		end

		return @commits
	end

	def reset_auth
		self.gauth_enabled = false
		save
	end

	def open_tasks_assigned
		tasks_assigned.where(solved: false)
	end

	def closed_tasks_assigned
		tasks_assigned.where(solved: true)
	end

	def open_tasks_authored
		tasks_authored.where(solved: false)
	end

	def commit_count
		commits.count
	end

	def commits_per_repository
		repository_commits = Hash.new
		repositories.all.each do |repository|
			commits = repository.read_all_commits.find_all { |commit| commit.author.name == self.name || commit.author.email == self.email }
			repository_commits[repository] = commits
		end
		repository_commits
	end

	def get_commits_per_day
		User.map_days_to_commits commits
	end

	def last_commit
		commits.max_by { |commit| commit.date }
	end

	def as_json(options = {})
		super(options.merge(except: [:gauth_secret, :gauth_enabled, :gauth_tmp, :gauth_tmp_datetime]))
	end

	def tasks_visible
		tasks = []
		repositories.each { |repo| tasks += repo.tasks }
		return tasks
	end

end
