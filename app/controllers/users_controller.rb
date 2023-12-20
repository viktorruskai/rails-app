# This controller handles the operations for users.
# It includes actions for listing, showing, creating, editing, updating, and deleting users.
# Only logged in users can perform these actions.
# The correct user or an admin user is confirmed before editing or updating a user.
# Only admin users can list, show, and delete users.
#
# Actions:
# - `index`: Lists all users with pagination, ordered by admin status and name.
# - `show`: Displays a specific user's profile based on the provided ID.
# - `new`: Initializes a new user instance.
# - `new_admin`: Initializes a new admin user instance.
# - `create`: Creates a new user with the provided parameters.
# - `create_admin`: Creates a new admin user with the provided parameters.
# - `edit`: Finds a specific user based on the provided ID for editing.
# - `update`: Updates a specific user based on the provided ID and parameters.
# - `destroy`: Deletes a specific user based on the provided ID.
#
# Private methods:
# - `user_params`: Strong parameters for creating and updating a user.
# - `correct_user`: Confirms the correct user before allowing certain actions.
# - `admin_user`: Confirms the user is an admin before allowing certain actions.
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :show, :destroy]

  # List all users
  #
  # URL Params:
  # - `page` (optional) - The page of users to show.
  def index
    @users = User.order(admin: :desc, name: :asc).paginate(page: params[:page])
  end

  # Show user profile.
  #
  # URL Params:
  # - `id` - The id of the user to show.
  # - `page` (optional) - The page of users to show.
  def show
    @user = User.find(params[:id])
    @videos = @user.videos.paginate(page: params[:page])
  end

  # Create a new user empty model.
  def new
    @user = User.new
  end

  # Create a new user (Teacher / Administrator) empty model.
  def new_admin
    @user = User.new
  end

  # Create a new user (Student) with params.
  #
  # Post Params:
  # - `name` - The name of the user.
  # - `email` - The email of the user.
  # - `password` - The password of the user.
  # - `password_confirmation` - The password confirmation of the user.
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  # Create a new user (Teacher / Administrator) with params.
  #
  # Post Params:
  # - `name` - The name of the user.
  # - `email` - The email of the user.
  # - `password` - The password of the user.
  # - `password_confirmation` - The password confirmation of the user.
  def create_admin
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      @user.update_attribute(:admin, true)
      flash[:info] = "Please check your email to activate your account."
      redirect_to users_url
    else
      render "new_teacher"
    end
  end

  # Edit user profile.
  #
  # URL Params:
  # - `id` - The id of the user to edit.
  def edit
    @user = User.find(params[:id])
  end

  # Update user profile.
  #
  # URL Params:
  # - `id` - The id of the user to update.
  # Post Params:
  # - `name` - The name of the user.
  # - `email` - The email of the user.
  # - `password` - The password of the user.
  # - `password_confirmation` - The password confirmation of the user.
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  # Delete user.
  #
  # URL Params:
  # - `id` - The id of the user to delete.
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    # Params for user.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
