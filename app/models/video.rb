# This model represents a video uploaded by a user.
# It belongs to a user and has many video notes.
# It validates the presence of user_id, title, content, and video.
# It also validates the length of title and content, and the content type and size of the video.
# It includes methods for returning notes for a video and displaying a resized video.
#
# Associations:
# - belongs_to :user: Each video is associated with a user.
# - has_many :video_notes, dependent: :destroy: Each video can have many notes. If the video is destroyed, its notes are also destroyed.
# - has_one_attached :video: Each video has one attached video file.
#
# Validations:
# - `user_id`: Ensures the presence of user_id.
# - `title`: Ensures the presence of title and its length is maximum 100 characters.
# - `content`: Ensures the presence of content and its length is maximum 240 characters.
# - `video`: Ensures the presence of video, its content type is either video/mp4 or video/quicktime, and its size is less than 500MB.
#
# Methods:
# - notes(user): Returns notes for a video made by a specific user.
# - display_image: Returns a resized image for display.
# - display_video: Returns a resized video for display.
class Video < ApplicationRecord
  belongs_to :user
  has_many :video_notes, dependent: :destroy
  has_one_attached :video

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 240 }
  validates :video, content_type: { in: %w[video/mp4 video/quicktime], message: "must be a valid video format" },
                    presence: true,
                    size: { less_than: 500.megabytes, message: "should be less than 500MB" }

  # Returns notes for a video.
  #
  # Params:
  # - `user` - The user to get notes for.
  def notes(user)
    video_notes.where(user_id: user.id)
  end

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  # Returns a resized image for display.
    def display_video
      video.variant(resize_to_limit: [500, 500])
    end
end
