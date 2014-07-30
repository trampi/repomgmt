class RepositoryAccess < ActiveRecord::Base
	belongs_to :user
	belongs_to :repository

	validates :user, presence: true
	validates :repository, presence: true

	def self.rewrite_auth
		logger.info "Rewriting auth"

		auth_file = File.open Repository.gitolite_repository_config_path, "w"
		auth_file.write generate_auth_contents
		auth_file.close

		rewrite_keys

		gitolite_repository = Git.open Repository.gitolite_repository_path
		begin
			gitolite_repository.add(:all=>true)
			gitolite_repository.commit_all "Repomgmt refresh"
		rescue Git::GitExecuteError => e
			logger.info "Commiting: error"
			logger.info e
			return false
		end

		begin
			gitolite_repository.push
		rescue Git::GitExecuteError => e
			logger.info "Pushing to gitolite: error"
			logger.info e
			return false
		end
		return true
	end

	private
	def self.generate_auth_contents
		authorization = ""

		authorization << "repo gitolite-admin\n"
		User.where(:admin => true).each do |admin|
			authorization << "    RW+ = #{admin.name}\n"
		end

		Repository.uncached do
			Repository.all.each do |repo|
				authorization << "repo #{repo.name}\n"
				repo.repository_access.each do |user_access|
					authorization << "    RW+ = #{user_access.user.name}\n"
				end
			end
		end

		return authorization
	end

	def self.remove_all_keyfiles
		FileUtils.rm_r Repository.gitolite_keys
	end

	def self.rewrite_keys
		remove_all_keyfiles
		User.uncached do
			User.all.to_a.keep_if { |u| u.has_public_key? }.each do |user|
				file = File.new Repository.gitolite_keys_path.join("#{user.name}.pub"), "w"
				file.write user.public_key
				file.close
			end
		end
	end
end
