class ProfilesController < ApplicationController
	def index
		if Champion.all.count < 130
			all_champions = Riot.get_all_champions(params)
			all_champions = all_champions['data']
			all_champions.each do |this|
				Champion.create(championId: this[1]["id"], name: this[1]["name"], title: this[1]["title"], icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/champion/"+this[1]['key']+".png", splash: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/"+this[1]['key']+"_0.jpg")
			end
		end
	end

	def search
		@profile = Profile.find_by(:region => params[:profile][:region], :summonerName => params[:profile][:summonerName])
		if  @profile != nil
			redirect_to action: "show", summonerName: @profile.summonerName, region: @profile.region
		else
      # if no profile exists in our db yet:
			create
		end
	end

	def create
		profile = Riot.get_summoner(params[:profile][:region], params[:profile][:summonerName], {})
		name = params[:profile][:summonerName]
        if Profile.create(
	          summonerName: name,
	          summonerId: profile[name]['id'],
	          region: params[:profile][:region],
	          icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/profileicon/" + (profile[name]['profileIconId']).to_s + ".png",
	          summonerLevel: profile[name]['summonerLevel']
          )
          @profile = Profile.find_by(:summonerName => params[:profile][:summonerName], :region => params[:profile][:region] )
          redirect_to controller: "champion_masteries", action: "create", region: @profile.region, summonerId: @profile.summonerId, id: @profile.id, summonerName: @profile.summonerName
        else
        	############### - ADD FLASH MESSAGES LOGIC - ##########################
          redirect_to '/'
          	############### - ADD FLASH MESSAGES LOGIC - ##########################
        end
	end

	def show
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################
		@champions = Champion.all
		@profile = Profile.find_by(:summonerName => params[:summonerName], :region => params[:region])
		@champion_masteries = ChampionMastery.where(profile_id: @profile.id)
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################

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
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################
		@profile = Profile.find(params[:id])
		@champion_mastery = ChampionMastery.where(:championId => params[:championId]).where(:profile_id => params[:id])
		@champion = Champion.find_by(:championId => params[:championId])
		@matches = Match.where(:summonerId => @profile.summonerId).where(:championId => params[:championId])
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################
	
	end
	######## Add Feature to Let Users Compare graph info ########
	# def compare
	# 	@champion = Champion.find_by(:championId => params[:championId])
	# 	search_for_profile
	# 	puts "IN COMPARE"
	# 	puts params[:profile][:summonerName]
	# 	puts params[:profile][:region]
	# 	puts search_for_profile
	# 	if search_for_profile != nil
	# 		puts "COMPARE RESULTTTT::::"
	# 		@compare_profile = @profile
	# 		@compare_mastery = ChampionMastery.where(:profile_id => @profile.id).where(:championId => params[:championId])
	# 		@compare_matches = Match.where(:profile_id => @profile.id).where(:championId => params[:championId])
	# 		if not @compare_mastery == nil && @compare_matches == nil
	# 			puts @compare_mastery
	# 			puts @compare_matches
	# 			puts "CUUURENT UUSAHHH"
	# 			@profile = Profile.find_by(:summonerName => params[:summonerName])
	# 			puts @profile.summonerId
	# 			@champion_mastery = ChampionMastery.where(:profile_id => @profile.id).where(:championId => params[:championId])
	# 			@matches = search_for_matches
	# 			redirect_to action: "show_compare", summonerName: @profile.summonerName, championId: params[:championId], summonerName2: @compare_profile.summonerName
	# 		else
	# 			redirect_to action: "show_graph", id: @profile.id, championId: params[:championId]
	# 		end
	# 		redirect_to action: "show_graph", id: @profile.id, championId: params[:championId]
	# 	end
	# end
	def show_compare
		@champion = Champion.find_by(:championId => params[:championId])
		@profile = Profile.find_by(:summonerName => params[:summonerName])
		@champion_mastery = ChampionMastery.where(:championId => params[:championId]).where(:profile_id => @profile.id)
		@compare_profile = Profile.find_by(:summonerName => params[:summonerName2])
		@compare_mastery = ChampionMastery.where(:profile_id => @compare_profile.id).where(:championId => params[:championId])
		@compare_matches = Match.where(:championId => params[:championId]).where(:profile_id => [@profile.id, @compare_profile.id] )
	end

	private
	def profile_params
		params.require(:profile).permit(:summonerName, :region)
	end
end
