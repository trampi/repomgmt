require 'test_helper'

class ProjectsHelperTest < ActionView::TestCase
  include ProjectsHelper

  test 'get task class should provide the right css class' do
    assert_equal 'success', task_class(tasks(:solved))
    assert_equal 'warning', task_class(tasks(:in_progress))
    assert_equal 'danger', task_class(tasks(:not_assigned))
  end

end
