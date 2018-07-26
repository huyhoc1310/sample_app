class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.load_user.page(params[:page]).per Settings.rows
    @microposts = @user.microposts.page(params[:page]).per Settings.rows
  end

  def show
    return unless @user
    @microposts = @user.microposts.order_mp
                       .page(params[:page]).per Settings.rows
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.profile_update"
      redirect_to @user
    else
      render :edit
    end
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def destroy
    @user.destroy
    flash[:success] = t "users.deleted"
    redirect_to users_url
  end

  def following
    @title = t "users.following"
    @users = @user.following.page(params[:page]).per Settings.rows
    render "show_follow"
  end

  def followers
    @title = t "users.followers"
    @users = @user.followers.page(params[:page]).per Settings.rows
    render "show_follow"
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.user_not_found"
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
