require 'test_helper'

class VideosControllerTest < ActionDispatch::IntegrationTest

  def setup
    @video = videos(:first)
  end

  test "user should create a note to a video" do
    log_in_as(users(:michael))
    get video_path(@video)

    assert_difference 'VideoNote.count', 1 do
      post video_notes_path, params: { video_note: { note: "Lorem ipsum", video_id: @video.id } }
    end

    assert_redirected_to video_path(@video)
  end

  test "user should not create a note to a video if not logged in" do
    get video_path(@video)

    assert_no_difference 'VideoNote.count' do
      post video_notes_path, params: { video_note: { note: "Lorem ipsum", video_id: @video.id } }
    end

    assert_redirected_to login_url
  end
end
