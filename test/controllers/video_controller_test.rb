require "test_helper"

class VideoControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get video_show_url
    assert_response :success
  end

  test "should get new" do
    get video_new_url
    assert_response :success
  end

  test "should get create" do
    get video_create_url
    assert_response :success
  end
end
