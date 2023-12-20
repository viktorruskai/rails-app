# This controller handles the operations for account activations.
# It includes an action for editing (activating) account activations.
class AccountActivationsController < ApplicationController

  # Activate user account.
  # Activates a user account based on the provided email and activation token. If the user exists, is not activated, and the activation token is authenticated, it activates the user, logs in the user, and redirects to the user's profile.
  # If the user does not exist, is already activated, or the activation token is not authenticated, it redirects to the root URL.
  #
  # URL Params:
  # - `id` - The activation token.
  # - `email` - The email of the user to activate.
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
