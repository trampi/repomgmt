require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

	test "repository has many users" do
		assert_equal repositories(:repository_one).users.count, 2
		assert_equal repositories(:repository_two).users.count, 1
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

end
