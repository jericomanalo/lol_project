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
			puts "SEARCH FOR SUMM"
			puts search_for_summoner
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
		# Populate global variables to separate the Champions with Masteries and those without
    @progress = []
    @no_progress = []
    # Loop through all 130 champions via the @champions (== Champion.all) variable and compare all 130 against each of the heroes in @champion_masteries ( == ChampionMastery.where(profile_id: params[:id]))
    @champions.each do |this|
        if @champion_masteries.find {|t| t['championId'] == this.championId }
            @progress.push(this)
        end
        if not @champion_masteries.find {|t| t['championId'] == this.championId }
            @no_progress.push(this)
        end
    end
	end
	def show_graph
		@profile = Profile.find(params[:id])
		@champion_mastery = ChampionMastery.where(:championId => params[:championId]).where(:profile_id => params[:id])
		@champion = Champion.find_by(:championId => params[:championId])
		@matches = Match.where(:summonerId => params[:summonerId]).where(:championId => params[:championId])
	end
	def compare
		@champion = Champion.find_by(:championId => params[:championId])
		search_for_profile
		puts "IN COMPARE"
		puts params[:profile][:summonerName]
		puts params[:profile][:region]
		puts search_for_profile
		if search_for_profile != nil
			puts "COMPARE RESULTTTT::::"
			@compare_profile = @profile
			@compare_mastery = ChampionMastery.where(:profile_id => @profile.id).where(:championId => params[:championId])
			@compare_matches = Match.where(:profile_id => @profile.id).where(:championId => params[:championId])
			if @compare_mastery != nil && @compare_matches != nil
				puts @compare_mastery
				puts @compare_matches
				puts "CUUURENT UUSAHHH"
				@profile = Profile.find_by(:summonerName => params[:summonerName])
				puts @profile.summonerId
				@champion_mastery = ChampionMastery.where(:profile_id => @profile.id).where(:championId => params[:championId])
				@matches = search_for_matches
				redirect_to action: "show_compare", summonerName: @profile.summonerName, championId: params[:championId], summonerName2: @compare_profile.summonerName

			end
		end


	end
	def show_compare
		@champion = Champion.find_by(:championId => params[:championId])
		@profile = Profile.find_by(:summonerName => params[:summonerName])
		@champion_mastery = ChampionMastery.where(:championId => params[:championId]).where(:profile_id => @profile.id)
		@compare_profile = Profile.find_by(:summonerName => params[:summonerName2])
		@compare_mastery = ChampionMastery.where(:profile_id => @compare_profile.id).where(:championId => params[:championId])
		@compare_matches = Match.where(:championId => params[:championId]).where(:profile_id => [@profile.id, @compare_profile.id] )
		puts "FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUCK YAHHHHH"
		puts @profile.id
		puts @compare_profile.id
	end

	private
	def profile_params
		params.require(:profile).permit(:summonerName, :region)
	end
end
