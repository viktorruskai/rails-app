class VideoNotesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # To-do: refactor!!!

  # save new video note
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

  # delete a video note
  def destroy
    @video_note = VideoNote.find(params[:id])
    # check if note belongs to current user
    if @video_note.user != current_user
      flash[:error] = "You are not authorized to delete this note."
      redirect_to videos_path
      return
    end

    @video_note.destroy
    flash[:success] = "Note was successfully deleted."
    redirect_back(fallback_location: root_path)
  end

  private

  def video_note_params
    params.require(:video_note).permit(:video_id, :note)
  end

  def video_params
    params.require(:video).permit(:title, :content, :video)
  end

  def correct_user
    @video = current_user.videos.find_by(id: params[:id])
    redirect_to root_url if @video.nil?
  end
end
