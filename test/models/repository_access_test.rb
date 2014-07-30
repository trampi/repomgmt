require 'test_helper'

class RepositoryAccessTest < ActiveSupport::TestCase
	test "repository accesses has a user" do
		repository_access = repository_accesses(:user_one_repository_one)
		assert_equal(repository_access.user.name, "user_with_long_public_key")
	end

	test "repository accesses has a repository" do
		repository_access = repository_accesses(:user_one_repository_one)
		assert_equal(repository_access.repository.name, "repository_one")
	end

	test "repository accesses are not valid without a user" do
		repository_access = repository_accesses(:user_one_repository_one)
		repository_access.user = nil
		assert_not repository_access.valid?
	end

	test "repository accesses are not valid without a repository" do
		repository_access = repository_accesses(:user_one_repository_one)
		repository_access.repository = nil
		assert_not repository_access.valid?
	end

	test "repository access commit push" do
		assert RepositoryAccess.rewrite_auth
		assert_equal File.read(Rails.configuration.repomgmt.gitolite_repository + "/conf/gitolite.conf"), <<END
repo gitolite-admin
    RW+ = admin
repo repository_one
    RW+ = user_with_long_public_key_2
    RW+ = user_with_long_public_key
repo repository_two
    RW+ = user_with_long_public_key
END
	end
end
