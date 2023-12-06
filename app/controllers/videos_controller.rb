class VideosController < ApplicationController
  before_action :logged_in_user, only: [:create, :show, :destroy]
  before_action :correct_user, only: :destroy

  # Show all videos.
  def index
     @videos = Video.paginate(page: params[:page])
  end

  # Show a video.
  def show
    @video = Video.find(params[:id])
  end

  # Upload a video.
  def create
    @video = current_user.videos.build(video_params)
    @video.video.attach(params[:video][:video])
    if @video.save
      flash[:success] = "Video was successfully uploaded."
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  # Delete a video.
  def destroy
    @video.destroy
    flash[:success] = "Video was successfully deleted."
    redirect_to root_url
  end

  private

  # Params for video.
  def video_params
    params.require(:video).permit(:title, :content, :video)
  end

  # Confirms the correct user.
  def correct_user
    @video = current_user.videos.find_by(id: params[:id])
    redirect_to root_url if @video.nil?
  end
end
