class ApplicationController < ActionController::Base
  include SessionsHelper

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "layouts/flash")
  end

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
