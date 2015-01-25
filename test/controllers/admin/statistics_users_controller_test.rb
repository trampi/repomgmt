require 'test_helper'

class Admin::StatisticsUsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test 'index should get repositories' do
    sign_in users(:admin)
    get :index
    assert_response :success

    assert_equal 5, assigns[:users].count
    assert_equal 'admin', assigns[:users][0].name
  end

  test 'show should get repository details' do
    sign_in users(:user_with_long_public_key)
    get :show, id: users(:user_with_long_public_key).id
    assert_response :success

    statistics = assigns[:statistics]
    assert_equal 'user_with_long_public_key', statistics[:user][:name]

    commit_history = statistics[:commits_history][0]
    assert_equal Date.new(2014, 8, 12), commit_history[:date]
    assert_equal 3, commit_history[:commits]

    repositories = statistics[:repositories]
    assert_equal 'repository_one', repositories[0][:name]
    assert_equal 3, repositories[0][:commits]
    assert_equal 'repository_two', repositories[1][:name]
    assert_equal 0, repositories[1][:commits]
  end
end
