require 'test_helper'

class VideoTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @video = @user.videos.build(content: "Lorem ipsum", title: "Lorem ipsum")
  end

  test "should be valid" do
    assert @video.valid?
  end

  test "user id should be present" do
    @video.user_id = nil
    assert_not @video.valid?
  end

  test "content should be present" do
    @video.content = "   "
    assert_not @video.valid?
  end

  test "content should be at most 240 characters" do
    @video.content = "a" * 241
    assert_not @video.valid?
  end
end
