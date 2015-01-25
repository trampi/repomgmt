require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user without public key should not respond as if the user had one' do
    assert_not users(:user_without_public_key).public_key?
  end

  test 'user with public key should respond accordingly' do
    assert users(:user_with_long_public_key).public_key?
  end

  test 'public key length should be checked' do
    assert users(:user_with_long_public_key).valid?
  end

  test 'user with too short public key (256 bit in this example) should be invalid' do
    user = users(:user_without_public_key)
    user.public_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAACEAtZGdHB9KtpoZe3YY9bZdal8i9GdyScb5mkQH2ooCDAc= rsa-key-20140727'
    user.valid?
    assert user.errors.include?(:public_key)
  end

  test 'user with invalid public key should not be saveable' do
    user = users(:user_without_public_key)
    user.public_key = 'invalid string'
    user.valid?
    assert user.errors.include?(:public_key)
  end

  test 'open tasks authored should only return open tasks' do
    user = users(:user_with_long_public_key)
    tasks = user.open_tasks_authored
    assert_equal 1, tasks.count
    assert_equal 'Open', tasks[0].title
  end

  test 'closed tasks assigned should only return closed tasks' do
    user = users(:user_with_long_public_key_2)
    tasks = user.closed_tasks_assigned
    assert_equal 2, tasks.count
    assert tasks.all? { |task| task.title.include? 'Solved' }
  end

  test 'open tasks assigned should only return open tasks' do
    user = users(:user_with_long_public_key_2)
    tasks = user.open_tasks_assigned
    assert_equal 1, tasks.count
    assert_equal 'Open', tasks[0].title
  end

  test 'tasks visible should only return tasks of projects where the user is part of' do
    user = users(:user_with_long_public_key_2)
    assert_equal 3, user.tasks_visible.count
  end

  test 'user should have commits' do
    user = users(:user_with_long_public_key)
    assert_equal 3, user.commit_count
  end

  test 'user should have last commits' do
    user = users(:user_with_long_public_key)
    assert_equal 'removed test2.txt', user.last_commit.message
  end

  test 'user should be able to get commits seperated by repository' do
    user = users(:user_with_long_public_key)
    repository_one = repositories(:repository_one)
    repository_two = repositories(:repository_two)
    commits = user.commits_per_repository
    assert_equal 3, commits[repository_one].count
    assert_equal 0, commits[repository_two].count
  end

  test 'user should be able to reset his gauth' do
    user = users(:user_one)
    assert_equal user.gauth_enabled, 't'
    user.reset_auth
    assert_equal user.gauth_enabled, 'f'
  end

  test 'user as json should not contain any sensitive informations' do
    user = users(:user_one)
    expected_keys = %w(id name created_at updated_at email admin public_key locale)
    assert_equal expected_keys, user.as_json.keys
  end

  test 'user commits should be mappable to days' do
    user = users(:user_with_long_public_key)
    assert_equal 3, user.commits_per_day[0][:commits].count
  end

  test 'user with no commits should return an empty commit array when mapping to days' do
    user = users(:user_one)
    assert_empty user.commits_per_day
  end
end
