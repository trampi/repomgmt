require 'test_helper'

class RepositoryAccessTest < ActiveSupport::TestCase
  test 'repository accesses has a user' do
    repository_access = repository_accesses(:user_one_repository_one)
    assert_equal 'user_with_long_public_key', repository_access.user.name
  end

  test 'repository accesses has a repository' do
    repository_access = repository_accesses(:user_one_repository_one)
    assert_equal 'repository_one', repository_access.repository.name
  end

  test 'repository accesses are not valid without a user' do
    repository_access = repository_accesses(:user_one_repository_one)
    repository_access.user = nil
    assert_not repository_access.valid?
  end

  test 'repository accesses are not valid without a repository' do
    repository_access = repository_accesses(:user_one_repository_one)
    repository_access.repository = nil
    assert_not repository_access.valid?
  end

  test 'repository access commit push' do
    skip_on_travis_ci
    assert RepositoryAccess.rewrite_auth, 'Undefined error while rewriting keys and / or while committing and pushing'
    expected = <<END
repo gitolite-admin
    RW+ = admin
repo repository_one
    RW+ = user_with_long_public_key_2
    RW+ = user_with_long_public_key
repo repository_two
    RW+ = user_with_long_public_key
END
    assert_equal expected, File.read(Rails.configuration.repomgmt.gitolite_repository + '/conf/gitolite.conf')
  end
end
