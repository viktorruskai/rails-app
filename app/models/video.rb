class Video < ApplicationRecord
  belongs_to :user
  has_many :video_notes, dependent: :destroy
  has_one_attached :video

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 240 }
  validates :video,   content_type: { in: %w[video/mp4 video/quicktime],
                                      message: "must be a valid video format" },
                      size: { less_than: 5.megabytes,
                              message:   "should be less than 5MB" }

  # Returns notes for a video.
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
