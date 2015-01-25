require 'test_helper'

class VersionsHelperTest < ActionView::TestCase
  include VersionsHelper

  test 'get task class should provide the right css class' do
    assert_equal 'danger', version_row_class(versions(:should_have_been_delivered))
    assert_equal 'text-muted', version_row_class(versions(:delivered))
    assert_equal nil, version_row_class(versions(:in_schedule))
  end
end
