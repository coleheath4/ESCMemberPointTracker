require 'test_helper'

class RewardsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get rewards_index_url
    assert_response :success
  end

  test 'should get show' do
    get rewards_show_url
    assert_response :success
  end

  test 'should get new' do
    get rewards_new_url
    assert_response :success
  end

  test 'should get edit' do
    get rewards_edit_url
    assert_response :success
  end

  test 'should get delete' do
    get rewards_delete_url
    assert_response :success
  end
end
