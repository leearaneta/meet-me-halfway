require 'test_helper'

class MeetMesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meet_me = meet_mes(:one)
  end

  test "should get index" do
    get meet_mes_url
    assert_response :success
  end

  test "should get new" do
    get new_meet_me_url
    assert_response :success
  end

  test "should create meet_me" do
    assert_difference('MeetMe.count') do
      post meet_mes_url, params: { meet_me: { address_1: @meet_me.address_1, address_2: @meet_me.address_2, results: @meet_me.results, term: @meet_me.term } }
    end

    assert_redirected_to meet_me_url(MeetMe.last)
  end

  test "should show meet_me" do
    get meet_me_url(@meet_me)
    assert_response :success
  end

  test "should get edit" do
    get edit_meet_me_url(@meet_me)
    assert_response :success
  end

  test "should update meet_me" do
    patch meet_me_url(@meet_me), params: { meet_me: { address_1: @meet_me.address_1, address_2: @meet_me.address_2, results: @meet_me.results, term: @meet_me.term } }
    assert_redirected_to meet_me_url(@meet_me)
  end

  test "should destroy meet_me" do
    assert_difference('MeetMe.count', -1) do
      delete meet_me_url(@meet_me)
    end

    assert_redirected_to meet_mes_url
  end
end
