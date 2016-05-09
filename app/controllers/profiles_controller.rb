class ProfilesController < ApplicationController
	def index
	end

	def search
		search_for_profile
		if @profile != nil
			redirect_to action: "show", id: @profile.id
		else
			create
			redirect_to controller: "champion_masteries", action: "create", id: @profile.id, summonerName: @profile.summonerName, region: @profile.region, summonerId: @profile.summonerId
		end
	end

	def create

      # if no profile exists in our db yet:
      search_for_summoner
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
        else
          redirect_to '/'
        end
    end


	def show
		@champions = Champion.all
		@profile = Profile.find(params[:id])
		@champion_masteries = ChampionMastery.where(profile_id: params[:id])
		@matches = Match.where(profile_id: params[:id])

	end
	def show_graph
		@champion = Champion.find_by(:championId => params[:championId])
		@matches = Match.where(:summonerId => params[:summonerId]).where(:championId => params[:championId])
	end

	private
	def profile_params
		params.require(:profile).permit(:summonerName, :region)
	end
end
