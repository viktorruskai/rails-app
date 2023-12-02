require 'test_helper'

class VideosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @video = videos(:first)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Video.count' do
      post videos_path, params: { video: { content: "Lorem ipsum", title: "Lorem" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong video" do
    log_in_as(users(:michael))
    video = videos(:first)
    assert_no_difference 'Video.count' do
      delete video_path(video)
    end
    assert_redirected_to root_url
  end
end
