# This controller handles the CRUD operations for videos.
# It includes actions for creating, reading, updating, and deleting videos.
# Only logged in users can perform these actions.
# Additionally, only admin users can create, edit, update, and delete videos.
# The correct user is confirmed before editing, updating, or deleting a video.
#
# Private methods:
# - `video_params`: Strong parameters for creating a new video.
# - `edit_video_params`: Strong parameters for editing a video.
# - `correct_user`: Confirms the correct user before allowing certain actions.
# - `admin_user`: Confirms the user is an admin before allowing certain actions.
class VideosController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :new, :update, :show, :destroy]
  before_action :admin_user, only: [:create, :edit, :update, :new, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # Show all videos.
  #
  # URL Params:
  # - `page` (optional) - The page of videos to show.
  def index
     @videos = Video.paginate(page: params[:page])
  end

  # Create a new video. (for view purposes only)
  #
  # This action is only available to the admin user.
  def new
    @video = current_user.videos.build
  end

  # Show a video.
  #
  # URL Params:
  # - `id` - The id of the video to show.
  def show
    @video = Video.find(params[:id])
  end

  # Edit a video.
  #
  # This action is only available to the admin user.
  # URL Params:
  # - `id` - The id of the video to edit.
  def edit
    @video = Video.find(params[:id])
  end

  # Upload a video.
  #
  # This action is only available to the admin user.
  # Post Params:
  # - `title` - The title of the video.
  # - `content` - The content of the video.
  # - `video` - The video to upload.
  def create
    @video = current_user.videos.build(video_params)
    @video.video.attach(params[:video][:video])
    if @video.save
      flash.now[:success] = "Video was successfully uploaded."
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  # Update a video.
  #
  # This action is only available to the admin user.
  # URL Params:
  # - `id` - The id of the video to update.
  # Post Params:
  # - `title` - The title of the video.
  # - `content` - The content of the video.
  def update
    @video = Video.find(params[:id])
    if @video.update(edit_video_params)
      flash.now[:success] = "Video was successfully updated."
      redirect_to @video
    else
      render 'edit'
    end
  end

  # Delete a video.
  #
  # This action is only available to the admin user.
  # URL Params:
  # - `id` - The id of the video to delete.
  def destroy
    @video.destroy
    flash.now[:success] = "Video was successfully deleted."
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
