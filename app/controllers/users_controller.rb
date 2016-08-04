class UsersController < ApplicationController
  # before_action :authorize, except: [:index]
  def index
    current_user
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
    @current_user = current_user
    @user = User.find(params[:id])
  end

  def search
    user = User.find_by("name ILIKE ?", params[:user][:name])
    if user
      redirect_to user
    else
      flash[:error] = "Sorry, no users found with that name, try again."
    end
  end

  def edit
    @current_user = current_user
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(update_params)
      redirect_to '/dashboard'
    else
      redirect_to :back
    end
  end
  def favorite
    current_user
    summoner= Summoner.find_by(:summonerId => params[:summonerId])
    puts "IDDDDDSSSS________________"
    puts @current_user.id, summoner.id
    Favorite.create(
      user_id: @current_user.id,
      summoner_id: summoner.id
    )
    redirect_to "/summoners/" + summoner.summonerName + "/" + summoner.region
  end
  def unfavorite
    current_user
    summoner= Summoner.find_by(:summonerId => params[:summonerId])
    puts "IDDDDDSSSS________________"
    puts @current_user.id, summoner.id
    Favorite.find_by(
      user_id: @current_user.id,
      summoner_id: summoner.id
    ).destroy
    redirect_to "/summoners/" + summoner.summonerName + "/" + summoner.region
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
