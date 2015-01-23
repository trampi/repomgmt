require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test 'closed tasks should get closed tasks' do
    assert_equal 0, versions(:version_one).closed_tasks.count
    assert_equal 2, versions(:version_two).closed_tasks.count
  end

  test 'open tasks should get open tasks' do
    assert_equal 1, versions(:version_one).open_tasks.count
    assert_equal 0, versions(:version_two).open_tasks.count
  end

  test 'progress should be in percent of 100' do
    assert_equal 0, versions(:version_one).progress_in_percent
    assert_equal 100, versions(:version_two).progress_in_percent
  end
end
