require 'test_helper'

class ReverseLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reverse_location = reverse_locations(:one)
  end

  test "should get index" do
    get reverse_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_reverse_location_url
    assert_response :success
  end

  test "should create reverse_location" do
    assert_difference('ReverseLocation.count') do
      post reverse_locations_url, params: { reverse_location: { address: @reverse_location.address, latitude: @reverse_location.latitude, longitude: @reverse_location.longitude } }
    end

    assert_redirected_to reverse_location_url(ReverseLocation.last)
  end

  test "should show reverse_location" do
    get reverse_location_url(@reverse_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_reverse_location_url(@reverse_location)
    assert_response :success
  end

  test "should update reverse_location" do
    patch reverse_location_url(@reverse_location), params: { reverse_location: { address: @reverse_location.address, latitude: @reverse_location.latitude, longitude: @reverse_location.longitude } }
    assert_redirected_to reverse_location_url(@reverse_location)
  end

  test "should destroy reverse_location" do
    assert_difference('ReverseLocation.count', -1) do
      delete reverse_location_url(@reverse_location)
    end

    assert_redirected_to reverse_locations_url
  end
end
