require 'test_helper'

class TaskTest < ActiveSupport::TestCase
	test "in progress should be true, if it has someone assigned" do
		task = tasks(:in_progress)
		assert task.in_progress?
		assert_not task.not_assigned?
		assert_not task.solved?
	end

	test "not assigned should be true, if nobody is assigned to a task" do
		task = tasks(:not_assigned)
		assert task.not_assigned?
		assert_not task.in_progress?
		assert_not task.solved?
	end

	test "when task solved it should not be in progress or not assigned" do
		task = tasks(:invisible_task_for_user_with_long_public_key_2)
		assert_not task.not_assigned?
		assert_not task.in_progress?
		assert task.solved? 
	end
end
