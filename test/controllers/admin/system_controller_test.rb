require 'test_helper'

class Admin::SystemControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test "should get index" do
		sign_in users(:admin)
		get :index
		assert_response :success
	end

	test "should reindex repositories" do
		sign_in users(:admin)
		old_index_date = repositories(:repository_one).last_index_date
		post :reindex_repositories
		assert_response :redirect

		assert_not_equal old_index_date, Repository.find(repositories(:repository_one).id).last_index_date
	end

end
