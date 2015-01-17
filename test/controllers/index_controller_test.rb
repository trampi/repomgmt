require 'test_helper'

class IndexControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test 'should get index when signed in' do
		sign_in users(:admin)
		get :index
		assert_response :success
	end

end
