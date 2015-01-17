require 'test_helper'

class Admin::StatisticsRepositoriesControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test 'index should get repositories' do
		sign_in users(:admin)
		get :index
		assert_response :success

		assert_equal 2, assigns['repositories'].count
		assert_equal 'repository_one', assigns['repositories'][0].name
	end

	test 'show should get repository details' do
		sign_in users(:admin)
		get :show, {id: repositories(:repository_one).id}
		assert_response :success

		statistics = assigns[:statistics]

		assert_equal 'repository_one', statistics[:repository][:name]

		commit_history = statistics[:commits_history][0]
		assert_equal Date.new(2014, 8, 12), commit_history[:date]
		assert_equal 3, commit_history[:commits]

		committer_info = statistics[:committer][0]
		assert_equal 'user_with_long_public_key', committer_info[:name]
		assert_equal 3, committer_info[:commits]
	end

end
