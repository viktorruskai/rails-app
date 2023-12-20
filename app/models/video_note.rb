# This model represents a note made by a user on a video.
# It belongs to a user and a video.
# It validates the presence of user_id, video_id, and note.
#
# Associations:
# - belongs_to :user: Each video note is associated with a user.
# - belongs_to :video: Each video note is associated with a video.
#
# Validations:
# - `user_id`: Ensures the presence of `user_id`.
# - `video_id`: Ensures the presence of `video_id`.
# - `note`: Ensures the presence of note.
class VideoNote < ApplicationRecord
  belongs_to :user
  belongs_to :video

  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :note, presence: true
end
