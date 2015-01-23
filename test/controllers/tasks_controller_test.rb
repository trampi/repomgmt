require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'should show task detail page with no one assigned' do
    sign_in users(:admin)
    get :show, {id: tasks(:not_assigned).id}
    assert_response :success
    assert_select '#task_author', 'Author: Nobody'
    assert_select '#task_assignee', 'Assignee: Nobody'
    assert_select '#task_solve'
  end

  test 'should show task detail page with right users' do
    sign_in users(:admin)
    get :show, {id: tasks(:author_user_one_assignee_user_without_public_key_unsolved).id}
    assert_response :success
    assert_select '#task_author', 'Author: user_with_long_public_key'
    assert_select '#task_assignee', 'Assignee: user_with_long_public_key_2'
    assert_select '#task_solve'
  end
end
