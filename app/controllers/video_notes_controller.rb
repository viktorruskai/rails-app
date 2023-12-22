# This controller handles the operations for video notes.
# It includes actions for creating, reading, updating, and deleting video notes.
# Only logged in users can perform these actions.
# The correct user is confirmed before editing, updating, or deleting a video note.
#
# Actions:
# - `create`: Creates a new video note with the provided parameters.
# - `edit`: Finds a specific video note based on the provided ID for editing.
# - `update`: Updates a specific video note based on the provided ID and parameters.
# - `destroy`: Deletes a specific video note based on the provided ID.
#
# Private methods:
# - `find_note`: Finds a specific video note based on the provided ID.
# - `video_note_params`: Strong parameters for creating and updating a video note.
# - `video_params`: Strong parameters for a video.
class VideoNotesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :find_note, only: [:edit, :update, :destroy]

  # Save new video note.
  #
  # Post Params:
  # - `video_id` - The id of the video to add the note to.
  # - `note` - The note to add to the video.
  def create
    @video = Video.find(video_note_params[:video_id])
    @video_note = @video.video_notes.build(video_note_params)
    @video_note.user = current_user

    if @video_note.save
      flash.now[:success] = "Note was successfully added."
    else
      flash.now[:error] = "Note was not successfully added."
    end

     streams = [
       turbo_stream.update("flash", partial: "layouts/flash"),
       turbo_stream.replace(@video, partial: "videos/video_notes", locals: { video: @video }),
     ]

     render turbo_stream: streams
  end

  # Edit a video note.
  #
  # URL Params:
  # - `id` - The id of the video note to edit.
  def edit
    @video_note = VideoNote.find(params[:id])
  end

  # Update a video note.
  #
  # URL Params:
  # - `id` - The id of the video note to update.
  # Post Params:
  # - `video_id` - The id of the video to add the note to.
  # - `note` - The note to update the video note with.
  def update
    if @video_note.update(video_note_params)
    flash[:success] = "Note was successfully updated. ----"
      flash.now[:success] = "Note was successfully updated."
    else
      flash.now[:error] = "Note was not successfully updated."
    end

    streams = [
      turbo_stream.update("flash", partial: "layouts/flash"),
      turbo_stream.replace(@video_note, partial: "videos/video_note", locals: { video_note: @video_note })
    ]

    render turbo_stream: streams
  end

  # Delete a video note.
  #
  # URL Params:
  # - `id` - The id of the video note to delete.
  def destroy
    video = @video_note.video

    @video_note.destroy
    flash.now[:success] = "Note was successfully deleted."

    streams = [
      turbo_stream.update("flash", partial: "layouts/flash"),
      turbo_stream.replace(@video_note, partial: "videos/video_note", locals: { video_note: nil })
    ]

    render turbo_stream: streams
  end

  private

  # Find a video note.
  def find_note
    @video_note = VideoNote.find(params[:id])

    # Check if note belongs to current user.
    if @video_note.user_id != current_user.id
      flash[:error] = "You are not authorized to delete this note."
      redirect_to videos_path
      return
    end
  end

  # Params for video note.
  def video_note_params
    params.require(:video_note).permit(:video_id, :note)
  end

  # Params for video.
  def video_params
    params.require(:video).permit(:title, :content, :video)
  end
end
