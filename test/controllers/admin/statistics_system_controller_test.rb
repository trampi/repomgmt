require 'test_helper'

class Admin::StatisticsSystemControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test 'should get statistics when signed in' do
		sign_in users(:admin)
		get :index
		assert_response :success

		statistics = assigns[:statistics]
		free = statistics[:storage][:bytes_free]
		used = statistics[:storage][:bytes_free]
		total = statistics[:storage][:bytes_total]

		assert free > 0
		assert used > 0
		assert total > 0

		assert_equal 3, statistics[:commits_history][0][:commits]

		assert_equal 'repository_one', statistics[:repositories][0][:name]
		assert_equal 3, statistics[:repositories][0][:commits]
		assert_equal 'repository_two', statistics[:repositories][1][:name]
		assert_equal 0, statistics[:repositories][1][:commits]

		assert_equal 5, statistics[:user_count]
		assert_equal 2, statistics[:repository_count]

		assert_equal 'user_with_long_public_key', statistics[:commits_per_author][0][:author]
		assert_equal 3, statistics[:commits_per_author][0][:commits]

		assert_equal 3, statistics[:commit_count]
	end

end
