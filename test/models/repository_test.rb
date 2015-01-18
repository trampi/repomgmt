require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

	test 'repository has many users' do
		assert repositories(:repository_one).users.count == 2
		assert repositories(:repository_two).users.count == 1
	end

	test 'project has many tasks' do
		assert repositories(:repository_one).tasks.count > 0
	end

	test 'project has many versions' do
		assert repositories(:repository_one).versions.count > 0
	end

	test 'needs at least one user' do
		repository = repositories(:repository_one)
		repository.users.clear
		assert_not repository.valid?
	end

	test 'should be able to provide a repository path' do
		repository = repositories(:repository_one)
		assert repository.size_in_bytes > 1024*10
	end

	test 'should be able to get commits from repository' do
		repository = repositories(:repository_one)
		assert repository.commits.count == 3
	end

	test 'a repository should have a first commit' do
		skip_on_travis_ci
		repository = repositories(:repository_one)
		expected_date = DateTime.parse('2014-08-12 20:52:16 +0200')
		assert repository.get_first_commit.date == expected_date
	end

	test 'a repository should have a last commit' do
		skip_on_travis_ci
		repository = repositories(:repository_one)
		expected_date = DateTime.parse('2014-08-12 20:53:01 +0200')
		assert repository.get_last_commit.date == expected_date
	end

	test 'a repository should have url' do
		# url prefix is set in global_setup.rb
		assert repositories(:repository_one).get_url == 'ssh://gitolite@127.0.0.1/repository_one'
	end

	test 'a repository should have tags' do
		assert repositories(:repository_one).get_tags.count == 0
	end

	test 'a repository should have branches' do
		assert repositories(:repository_one).get_branches.count == 1
	end

	test 'a repository should have commits on dates' do
		date = Date.new(2014, 8, 12)
		commit_date_hash = repositories(:repository_one).get_commits_per_day[0]
		assert_equal date, commit_date_hash[:date]
		assert_equal 3, commit_date_hash[:commits].count
	end

	test 'commits can be grouped by author' do
		user = users(:user_with_long_public_key)
		assert_equal 3, repositories(:repository_one).commits_per_author[user].count
	end

	test 'the current version should be the last delivered one' do
		assert_equal versions(:four), repositories(:repository_one).current_version
	end

	test 'the next version should be the next not delivered version' do
		assert_equal versions(:five), repositories(:repository_one).next_version
	end

	test 'some statistics about drive usage' do
		skip_on_windows
		assert Repository.storage_bytes_free > 1024 * 1024
		assert Repository.storage_bytes_total > 1024 * 1024
		assert Repository.storage_bytes_used > 1024
		assert Repository.storage_used_in_percent >= 0
		assert Repository.storage_used_in_percent <= 100
	end

	test 'should be able to index commits' do
		repo = repositories(:repository_one)
		assert_equal 3, repo.commits.count
		commit = repo.commits.order(date: :desc).take
		assert_equal "236fb0a18d4032001f4043252011f95454fe5a27", commit.sha
		assert_equal "fabian.trampusch@freenet.de", commit.committer_email
	end

	test 'repository should be marked with rewrite necessary when name changes' do
		repo = repositories(:repository_one)
		repo.name = 'new_name'
		repo.save
		assert repo.instance_variable_get(:@authentication_rewrite_necessary)

		repo.name = 'repository_one'
		repo.save
	end
end
