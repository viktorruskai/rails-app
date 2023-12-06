class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :show, :destroy]

  # List all users.
  def index
    @users = User.paginate(page: params[:page])
  end

  # Show user profile.
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
  def edit
    @user = User.find(params[:id])
  end

  # Update user profile.
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
