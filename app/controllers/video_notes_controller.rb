class VideoNotesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :find_note, only: [:edit, :update, :destroy]

  # Save new video note.
  def create
    @video = Video.find(video_note_params[:video_id])
    @video_note = @video.video_notes.build(video_note_params)
    @video_note.user = current_user

    if @video_note.save
      flash[:success] = "Note was successfully added."
      redirect_to @video
    else
      flash[:error] = "Note was not successfully added."
      redirect_to @video
    end
  end

  # Edit a video note.
  def edit
    @video_note = VideoNote.find(params[:id])
  end

   # Update a video note.
  def update
    if @video_note.update(video_note_params)
      flash[:success] = "Note was successfully updated."
      redirect_to @video_note.video
    else
      flash[:error] = "Note was not successfully updated."
      redirect_to @video_note.video
    end
  end

  # Delete a video note.
  def destroy
    video = @video_note.video

    @video_note.destroy
    flash[:success] = "Note was successfully deleted."

    redirect_to video
  end

  private

  def find_note
    @video_note = VideoNote.find(params[:id])

    # Check if note belongs to current user.
    if @video_note.user_id != current_user.id
      flash[:error] = "You are not authorized to delete this note."
      redirect_to videos_path
      return
    end
  end

  def video_note_params
    params.require(:video_note).permit(:video_id, :note)
  end

  def video_params
    params.require(:video).permit(:title, :content, :video)
  end
end
