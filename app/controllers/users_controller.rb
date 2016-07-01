class UsersController < ApplicationController
  # before_action :authorize, except: [:index]
  def index
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/dashboard'
    else
      redirect_to '/signup'
    end
  end

  def show
  end

  def edit
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(update_params)
      redirect_to '/dashboard'
    else
      redirect_to :back
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
