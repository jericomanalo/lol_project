class UsersController < ApplicationController
  def index

  end

  def show

  end

  


  def create
    if search_for_summoner == nil
      redirect_to '/'
    else
      # if no profile exists in our db yet:
      search_for_profile
      if @profile == nil
        profile = Profile.new(
          summonerName: @summoner[0], 
          summonerId: @lol[@summoner[0]]['id'], 
          region: params[:profile][:region], 
          icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/profileicon/" + (@lol[@summoner[0]]['profileIconId']).to_s + ".png",
          summonerLevel: @lol[@summoner[0]]['summonerLevel']
          )
          #save that profile
        if profile.save
          @profile = profile
          puts "@PROFILE AFTER NEW_SAVE"
          puts @profile.summonerId
          #create champion_masteries for new
          create_champion_masteries
          get_match_info
          #create matches for new profile
          # create_matches

          get_match_info
          user = User.new(user_params)
          user.profile_id = profile.id
          if user.save
            session[:user_id] = user.id
            puts '~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~'
            puts user
            puts profile
            puts search_for_summoner
            redirect_to '/profiles'
        else
          redirect_to '/'
        end
      end
      else
        user = User.new(user_params)
        user.profile_id = @profile.id
        if user.save
          session[:user_id] = user.id
          puts user
          puts @profile
          puts search_for_summoner
          redirect_to '/profiles'
        else
          redirect_to '/'
        end

      end #search for profile

    end
  
  end

  def guest
    @guest_token = 1234
    search_for_summoner
    get_summoner_match_history
    get_match_info
    get_summoner_champ_mastery
    @champions = Champion.all
  end

  def login
    user = User.find_by(:email => params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/profiles'
    else
      redirect_to '/'
    end
  end

  def logout
    session.clear
    puts '~~~~~~~~~'
    puts session[:user_id]
    redirect_to '/'
  end

  def update

  end

  def delete

  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def profile_params
    params.require(:profile).permit(:summonerName, :region)
  end
end
