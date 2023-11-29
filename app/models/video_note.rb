class VideoNote < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :note, presence: true
end
