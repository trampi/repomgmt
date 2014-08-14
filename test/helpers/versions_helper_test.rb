require 'test_helper'

class VersionsHelperTest < ActionView::TestCase
	include VersionsHelper

	test "get task class should provide the right css class" do
		assert version_row_class(versions(:should_have_been_delivered)) == "danger"
		assert version_row_class(versions(:delivered)) == "text-muted"
		assert version_row_class(versions(:in_schedule)) == ""
	end

end
