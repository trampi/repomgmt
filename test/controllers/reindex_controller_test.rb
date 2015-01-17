require 'test_helper'

class ReindexControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test 'should not reindex if wrong secret is used' do
		old_index_date = repositories(:repository_one).last_index_date
		get 'index'
		assert_response :success
		assert_equal old_index_date, Repository.find(repositories(:repository_one).id).last_index_date
	end

	test 'should be reindexed if right secret is used' do
		old_index_date = repositories(:repository_one).last_index_date
		get 'index', {secret: Rails.configuration.repomgmt.reindex_secret}
		assert_response :success
		assert_not_equal old_index_date, Repository.find(repositories(:repository_one).id).last_index_date
	end

end
