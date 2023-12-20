# This controller handles the operations for password resets.
# It includes actions for creating, editing, and updating password resets.
# Before the edit and update actions, it gets the user, confirms the user is valid, and checks the expiration of the reset token.
#
# Actions:
# - `new`: Renders the password reset form.
# - `create`: Resets the password based on the provided email. If the user exists, it creates a reset digest, sends a password reset email, and redirects to the root URL. If the user does not exist, it renders the new form again.
# - `edit`: Renders the form for updating the password.
# - `update`: Updates the password. If the password is empty, it renders the edit form again. If the password is updated successfully, it logs in the user and redirects to the user's profile.
#
# Private methods:
# - `user_params`: Strong parameters for updating a user's password.
# - `get_user`: Finds a user based on the provided email.
# - `valid_user`: Confirms the user is valid.
# - `check_expiration`: Checks the expiration of the reset token.
class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # Render password reset form.
  def new
  end

  # Reset password based on email.
  #
  # Post Params:
  # - `email` - The email of the user to reset.
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # Render password reset form.
  def edit
  end

  # Update password.
  #
  # Post Params:
  # - `password` - The new password.
  # - `password_confirmation` - The new password confirmation.
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      reset_session
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    # Params for user.
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Get user by email.
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
