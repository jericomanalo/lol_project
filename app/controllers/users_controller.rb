class UsersController < ApplicationController
  def index

  end

  def show
  end

  def search_for_profile
    @profile = Profile.where(:summonerName => params[:profile][:summonerName]).where(:region => params[:profile][:region]).first
    puts "@PROFILE SEARCH RESULT"
    puts @profile
  end
  def search_for_champion_masteries
    ChampionMastery.where(:profile_id => @profile.id)
  end
  def search_for_matches
    Match.where(:profile_id => @profile.id)
  end
  def search_for_champions
    Champion.all
  end
  def create_champion_masteries
    get_summoner_champ_mastery

    @champion_masteries.each do |this|
      lastPlayTime = DateTime.strptime(this['lastPlayTime'].to_s, '%Q')
      new_champ_mastery = ChampionMastery.new(
          profile_id: @profile.id,
          championId: this['championId'],
          championPointsSinceLastLevel: this['championPointsSinceLastLevel'],
          championPointsUntilNextLevel: this['championPointsUntilNextLevel'],
          highestGrade: this['highestGrade'],
          championLevel: this['championLevel'],
          lastPlayTime: lastPlayTime
      )
      new_champ_mastery.save

    end
  end

  def create_matches
    puts "@GET_MATCH_INFOOOOO:"
    get_summoner_match_history
    get_match_info
    #@matches = array of match info for user
    @matches.each do |this|
      match = this
      match['participantIdentities'].each do | that |
        # checks for each match key participant identify and finds summoner id and matches it with the session users ID
        if that['player']['summonerId'] == @profile.summonerId
          this_participant = that['participantId'] - 1
          puts match['participants'][this_participant]
          puts "win", match['participants'][this_participant]['stats']['winner']
          #check if match info for this summoner already in DB
          test = Match.where(:matchId=>match['matchId']).where(:summonerId=>@profile.summonerId).first
          if test == nil
          #save info to DB
          new_match = Match.create(
            matchId: match['matchId'],
            summonerId: that['player']['summonerId'],
            kills: match['participants'][this_participant]['stats']['kills'],
            deaths: match['participants'][this_participant]['stats']['deaths'],
            assists: match['participants'][this_participant]['stats']['assists'],
            goldEarned: match['participants'][this_participant]['stats']['goldEarned'],
            championLevel: match['participants'][this_participant]['stats']['champLevel'],
            summonerSpell1: match['participants'][this_participant]['spell1Id'],
            summonerSpell2: match['participants'][this_participant]['spell2Id'],
            item1: match['participants'][this_participant]['stats']['item0'],
            item2: match['participants'][this_participant]['stats']['item1'],
            item3: match['participants'][this_participant]['stats']['item2'],
            item4: match['participants'][this_participant]['stats']['item3'],
            item5: match['participants'][this_participant]['stats']['item4'],
            item6: match['participants'][this_participant]['stats']['item5'],
            mastery: match['participants'][this_participant]['masteries'].last['masteryId'],
            cs: match['participants'][this_participant]['stats']['minionsKilled'],
            jungleCs: match['participants'][this_participant]['stats']['neutralMinionsKilled'],
            totalDamage: match['participants'][this_participant]['stats']['totalDamageDealt'],
            totalCcDealt: match['participants'][this_participant]['stats']['totalTimeCrowdControlDealt'],
            totalHeal: match['participants'][this_participant]['stats']['totalHeal'],
            magicDamage: match['participants'][this_participant]['stats']['magicDamageDealt'],
            physicalDamage: match['participants'][this_participant]['stats']['physicalDamageDealt'],
            damageTaken: match['participants'][this_participant]['stats']['totalDamageTaken'],
            wardsPlaced: match['participants'][this_participant]['stats']['wardsPlaced'],
            doubleKills: match['participants'][this_participant]['stats']['doubleKills'],
            tripleKills: match['participants'][this_participant]['stats']['tripleKills'],
            quadraKills: match['participants'][this_participant]['stats']['quadraKills'],
            pentaKills: match['participants'][this_participant]['stats']['pentaKills'],
            profile_id: @profile.id
            )
          end
        end
      end
    end
  

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
          #create matches for new profile
          create_matches
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
      redirect_to '/'
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
