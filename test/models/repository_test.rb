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
		assert repository.read_all_commits.count == 3
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
		assert commit_date_hash[:date] == date && commit_date_hash[:commits].count == 3
	end

	test 'commits can be grouped by author' do
		assert repositories(:repository_one).commits_per_author['Fabian Trampusch'].count == 3
	end

	test 'the current version should be the last delivered one' do
		assert repositories(:repository_one).current_version == versions(:four)
	end

	test 'the next version should be the next not delivered version' do
		assert repositories(:repository_one).next_version == versions(:five)
	end

	test 'some statistics about drive usage' do
		skip_on_windows
		assert Repository.storage_bytes_free > 1024 * 1024
		assert Repository.storage_bytes_total > 1024 * 1024
		assert Repository.storage_bytes_used > 1024
		assert Repository.storage_used_in_percent >= 0 && Repository.storage_used_in_percent <= 100
	end

end
