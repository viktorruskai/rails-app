class VideosController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @video = current_user.videos.build(video_params)
    @video.video.attach(params[:video][:video])
    if @video.save
      flash[:success] = "video created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @video.destroy
    flash[:success] = "video deleted"
    if request.referrer.nil? || request.referrer == videos_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  private

    def video_params
      params.require(:video).permit(:content, :image)
    end

    def correct_user
      @video = current_user.videos.find_by(id: params[:id])
      redirect_to root_url if @video.nil?
    end
end
