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
    assert_equal 'fabian.trampusch@freenet.de', committer_info[:name]
    assert_equal 3, committer_info[:commits]
  end

  test 'show with commits from a user that could not be mapped' do
    repository = repositories(:repository_one)
    Commit.create repository: repository, author_email: 'test@example.com', date: Date.new(2015, 1, 18), sha: 'a94a8fe5ccb19ba61c4c0873d391e987982fbbd3'

    sign_in users(:admin)
    get :show, {id: repositories(:repository_one).id}
    assert_response :success

    statistics = assigns[:statistics]

    commit_history = statistics[:commits_history].last
    assert_equal 1, commit_history[:commits]
    assert_equal Date.new(2015, 1, 18), commit_history[:date]

    committer_info = statistics[:committer].last
    assert_equal 'test@example.com', committer_info[:name]
    assert_equal 1, committer_info[:commits]
  end
end
