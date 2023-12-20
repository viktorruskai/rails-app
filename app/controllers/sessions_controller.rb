# This controller handles the operations for user sessions.
# It includes actions for creating and destroying sessions.
#
# Actions:
# - `new`: Renders the login form.
# - `create`: Logs in a user with the provided email and password.
# - `destroy`: Logs out the current user and redirects to the root URL.
class SessionsController < ApplicationController

  # Render the login form.
  def new
  end

  # Create a new session (Login).
  # If the user is not activated, it redirects to the root URL and displays a warning message.
  # If the login is successful, it redirects to the forwarding URL or the root URL.
  #
  # Post Params:
  # - `email` - The email of the user to login.
  # - `password` - The password of the user to login.
  # - `remember_me` - Whether to remember the user.
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || root_url
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new'
    end
  end

  # Destroy a session (Logout).
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
