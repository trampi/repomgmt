require 'test_helper'

class ProjectsHelperTest < ActionView::TestCase
	include ProjectsHelper

	test "get task class should provide the right css class" do
		assert task_class(tasks(:solved)) == "success"
		assert task_class(tasks(:in_progress)) == "warning"
		assert task_class(tasks(:not_assigned)) == "danger"
	end

end
