class VideosController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :new, :update, :show, :destroy]
  before_action :admin_user, only: [:create, :edit, :update, :new, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # Show all videos.
  def index
     @videos = Video.paginate(page: params[:page])
  end

  def new
    @video = current_user.videos.build
  end

  # Show a video.
  def show
    @video = Video.find(params[:id])
  end

  # Edit a video.
  def edit
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

  # Update a video.
  def update
    @video = Video.find(params[:id])
    if @video.update(edit_video_params)
      flash[:success] = "Video was successfully updated."
      redirect_to @video
    else
      render 'edit'
    end
  end

  # Delete a video.
  def destroy
    @video.destroy
    flash[:success] = "Video was successfully deleted."
    redirect_to request.referrer || root_url
  end

  private

  # Params for video.
  def video_params
    params.require(:video).permit(:title, :content, :video)
  end

  # Params for edit video.
  def edit_video_params
    params.require(:video).permit(:title, :content)
  end

  # Confirms the correct user.
  def correct_user
    @video = current_user.videos.find_by(id: params[:id])
    redirect_to root_url if @video.nil?
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
