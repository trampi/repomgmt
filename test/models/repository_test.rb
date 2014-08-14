require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

	test "repository has many users" do
		assert repositories(:repository_one).users.count == 2
		assert repositories(:repository_two).users.count == 1
	end

	test "project has many tasks" do
		assert repositories(:repository_one).tasks.count > 0
	end

	test "project has many versions" do
		assert repositories(:repository_one).versions.count > 0
	end

	test "needs at least one user" do
		repository = repositories(:repository_one)
		repository.users.clear
		assert_not repository.valid?
	end

	test "should be able to provide a repository path" do
		repository = repositories(:repository_one)
		assert repository.size_in_bytes > 1024*10
	end

	test "should be able to get commits from repository" do
		repository = repositories(:repository_one)
		assert repository.read_all_commits.count == 3
	end

	test "a repository should have a first commit" do
		repository = repositories(:repository_one)
		assert repository.get_first_commit.date.to_s == "2014-08-12 20:52:16 +0200"
	end

	test "a repository should have a last commit" do
		repository = repositories(:repository_one)
		assert repository.get_last_commit.date.to_s == "2014-08-12 20:53:01 +0200"
	end

	test "a repository should have url" do
		# url prefix is set in global_setup.rb
		assert repositories(:repository_one).get_url == "ssh://gitolite@127.0.0.1/repository_one"
	end
end
