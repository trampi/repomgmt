require 'test_helper'

class StatisticsUsersControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_response :success
  end

  test "should get detail" do
    get :detail
    assert_response :success
  end

end
