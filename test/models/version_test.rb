require 'test_helper'

class VersionTest < ActiveSupport::TestCase
	test "closed tasks should get closed tasks" do
		assert versions(:version_one).closed_tasks.count == 0
		assert versions(:version_two).closed_tasks.count == 2
	end

	test "open tasks should get open tasks" do
		assert versions(:version_one).open_tasks.count == 1
		assert versions(:version_two).open_tasks.count == 0
	end

	test "progress should be in percent of 100" do
	   assert versions(:version_one).progress_in_percent == 0
	   assert versions(:version_two).progress_in_percent == 100
	end
end
