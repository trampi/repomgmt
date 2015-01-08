require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test 'user without public key should not respond as if the user had one' do
		assert_not users(:user_without_public_key).has_public_key?
	end

	test 'user with public key should respond accordingly' do
		assert users(:user_with_long_public_key).has_public_key?
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
		assert tasks.count == 1 && tasks[0].title == 'Open'
	end

	test 'closed tasks assigned should only return closed tasks' do
		user = users(:user_with_long_public_key_2)
		tasks = user.closed_tasks_assigned
		assert tasks.count == 2 && tasks.all? { |task| task.title.include? 'Solved' }
	end

	test 'open tasks assigned should only return open tasks' do
		user = users(:user_with_long_public_key_2)
		tasks = user.open_tasks_assigned
		assert tasks.count == 1 && tasks[0].title == 'Open'
	end

	test 'tasks visible should only return tasks of projects where the user is part of' do
		user = users(:user_with_long_public_key_2)
		assert user.tasks_visible.count == 3
	end

	test 'user should have commits' do
		user = users(:user_with_long_public_key)
		assert user.commit_count == 3
	end

	test 'user should have last commits' do
		user = users(:user_with_long_public_key)
		assert user.last_commit.message == 'removed test2.txt'
	end

	test 'user should be able to get commits seperated by repository' do
		user = users(:user_with_long_public_key)
		repository_one = repositories(:repository_one)
		repository_two = repositories(:repository_two)
		commits = user.commits_per_repository
		assert commits[repository_one].count == 3
		assert commits[repository_two].count == 0
	end
end
