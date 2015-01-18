class User < ActiveRecord::Base
	extend MapDaysToCommits
	include MarkForRefreshAuthentication

	attr_accessor :gauth_token

	default_scope { order(name: :asc) }

	has_many :repositories, through: :repository_access, after_add: :mark_authentication_for_rewrite, after_remove: :mark_authentication_for_rewrite
	has_many :repository_access, dependent: :destroy, after_add: :mark_authentication_for_rewrite, after_remove: :mark_authentication_for_rewrite
	has_many :tasks_assigned, class_name: 'Task', inverse_of: :assignee, foreign_key: 'assignee_id'
	has_many :tasks_authored, class_name: 'Task', inverse_of: :author, foreign_key: 'author_id'
	has_many :commits

	# email is automatically validated by devise
	validates :name, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9_]+\z/, message: 'darf nur Buchstaben, Zahlen und Unterstriche enthalten'}
	validates :public_key, public_key: true, uniqueness: true, allow_blank: true

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	if Rails.configuration.repomgmt.disable_public_registration
		devise :google_authenticatable, :database_authenticatable, :rememberable, :trackable, :validatable
	else
		devise :google_authenticatable, :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
	end

	before_save do
		mark_authentication_for_rewrite if admin_changed? || name_changed? || public_key_changed?
		true # we don't want to interfere with other callbacks
	end

	before_destroy :mark_authentication_for_rewrite

	def has_public_key?
		SSHKey.valid_ssh_public_key? public_key
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
			repository_commits[repository] = commits.where repository: repository
		end
		repository_commits
	end

	def get_commits_per_day
		User.map_days_to_commits commits
	end

	def last_commit
		commits.order(date: :desc).take
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
