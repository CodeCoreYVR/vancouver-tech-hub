class UsersController < ApplicationController
  before_action :find_user, only: [:update, :edit, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: "User Created!"
    else
      flash[:alert] = "Error creating user"
      render :new
    end
  end

  def edit
    
  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find params[:id]
  end
end
