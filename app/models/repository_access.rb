class RepositoryAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :repository

  validates :user, presence: true
  validates :repository, presence: true

  def self.rewrite_auth
    logger.debug 'Start rewriting auth'
    prepare_keys_and_auth_file
    gitolite_repository = open_repository
    commit_changes gitolite_repository
    push gitolite_repository
    logger.debug 'Rewriting auth succeeded'
    true
  rescue
    logger.debug 'Rewriting auth failed'
    false
  end

  def self.prepare_keys_and_auth_file
    remove_all_keyfiles
    rewrite_keys
    write_auth_file
  end

  def self.write_auth_file
    auth_file = File.open(Repository.gitolite_repository_config_path, 'w')
    auth_file.write generate_auth_contents
    auth_file.close
  rescue => e
    log_error 'Failed writing users / keys to gitolite.conf', e
    raise
  end

  def self.open_repository
    Git.open Repository.gitolite_repository_path
  end

  def self.commit_changes(gitolite_repository)
    gitolite_repository.add(all: true)
    gitolite_repository.commit_all 'Repomgmt refresh'
  rescue Git::GitExecuteError => e
    log_error 'Error committing changed configuration', e
    raise
  end

  def self.generate_auth_contents
    authorization = ''

    authorization << "repo gitolite-admin\n"
    User.where(admin: true).each do |admin|
      authorization << "    RW+ = #{admin.name}\n"
    end

    Repository.uncached do
      Repository.all.each { |repo| authorization << generate_repo_auth_string(repo) }
    end

    authorization
  end

  def self.generate_repo_auth_string(repo)
    authorization_line = ''
    authorization_line << "repo #{repo.name}\n"
    repo.repository_access.each do |user_access|
      authorization_line << "    RW+ = #{user_access.user.name}\n"
    end
    authorization_line
  end

  def self.remove_all_keyfiles
    FileUtils.rm_r Repository.gitolite_keys
  rescue => e
    log_error 'Failed deleting key directory', e
  end

  def self.rewrite_keys
    User.uncached do
      User.all.to_a.keep_if(&:public_key?).each do |user|
        file = File.new Repository.gitolite_keys_path.join("#{user.name}.pub"), 'w'
        file.write user.public_key
        file.close
      end
    end
  rescue => e
    log_error 'Failed rewriting keys', e
    raise
  end

  def self.push(gitolite_repository)
    gitolite_repository.push
  rescue Git::GitExecuteError => e
    log_error 'Error pushing changes back to gitolite', e
    raise
  end

  def self.log_error(message, e)
    logger.error message
    logger.error e
  end
end
