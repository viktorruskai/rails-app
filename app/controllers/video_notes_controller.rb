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
    else
      flash[:error] = "Note was not successfully added."
    end

    redirect_to @video
  end

  # Edit a video note.
  def edit
    @video_note = VideoNote.find(params[:id])
  end

   # Update a video note.
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
  def destroy
    video = @video_note.video

    @video_note.destroy
    flash[:success] = "Note was successfully deleted."

    streams = [
      turbo_stream.update("flash", partial: "layouts/flash"),
      turbo_stream.replace(@video_note, partial: "videos/video_note", locals: { video_note: nil })
    ]

    render turbo_stream: streams

#     redirect_to video
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
