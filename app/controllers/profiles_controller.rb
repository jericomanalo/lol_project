class ProfilesController < ApplicationController
	def index
		if Champion.all.count < 130
			all_champions = Riot.get_all_champions(params)
			all_champions = all_champions['data']
			all_champions.each do |this|
				tag = this[1]["tags"][0].to_s
				Champion.create(championId: this[1]["id"], name: this[1]["name"], title: this[1]["title"], icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/champion/"+this[1]['key']+".png", splash: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/"+this[1]['key']+"_0.jpg", tag: tag)
			end
		end
		randomInt = rand(1...(Profile.count)+1)
		if Profile.count > 0
		@randomProfile = Profile.find(randomInt)
		puts "@PROOOOOOOOFIIIIIIIIIILES"
		puts @randomProfile
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
		############################# FIX THE REDIRECT ##########################################
		# checking if the summoner that is being looked up does not exist from the api response #

		############################# FIX THE REDIRECT ##########################################
		name = params[:profile][:summonerName]
		if profile[name]
	        Profile.create(
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
	        flash[:error] = "Sorry, the Summoner you wish to search for does not exist in the Riot Games database, please try again."
	     	redirect_to '/'
	          	############### - ADD FLASH MESSAGES LOGIC - ##########################
		end
	end

	def show
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################
		@champions = Champion.all
		@profile = Profile.find_by(:summonerName => params[:summonerName], :region => params[:region])
		@champion_masteries = ChampionMastery.where(profile_id: @profile.id)
		top_champion = ChampionMastery.where(profile_id: @profile.id).order(current_points: :desc).first
		@top_champion = @champions.find { |t| t['championId'] == top_champion['championId']}
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################

		# Populate global variables to separate the Champions with Masteries and those without
			@mastered_supports = []
			@mastered_tanks = []
			@mastered_fighters = []
			@mastered_mages = []
			@mastered_assassins = []
			@mastered_marksmen = []

			@unmastered_supports = []
			@unmastered_tanks = []
			@unmastered_fighters = []
			@unmastered_mages = []
			@unmastered_assassins = []
			@unmastered_marksmen = []

	    @no_progress = []
	    # Loop through all 130 champions via the @champions (== Champion.all) variable and compare all 130 against each of the heroes in @champion_masteries ( == ChampionMastery.where(profile_id: params[:id]))
	    @champions.each do |this|
	        if @champion_masteries.find {|t| t['championId'] == this.championId }
						if this.tag == 'Support'
							@mastered_supports.push(this)
						elsif this.tag == 'Tank'
							@mastered_tanks.push(this)
						elsif this.tag == 'Fighter'
							@mastered_fighters.push(this)
						elsif this.tag == 'Mage'
							@mastered_mages.push(this)
						elsif this.tag == 'Assassin'
							@mastered_assassins.push(this)
						elsif this.tag == 'Marksman'
							@mastered_marksmen.push(this)
						end
	        end
	        if not @champion_masteries.find {|t| t['championId'] == this.championId }
						if this.tag == 'Support'
							@unmastered_supports.push(this)
						elsif this.tag == 'Tank'
							@unmastered_tanks.push(this)
						elsif this.tag == 'Fighter'
							@unmastered_fighters.push(this)
						elsif this.tag == 'Mage'
							@unmastered_mages.push(this)
						elsif this.tag == 'Assassin'
							@unmastered_assassins.push(this)
						elsif this.tag == 'Marksman'
							@unmastered_marksmen.push(this)
						end
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
	def compare
		@champion = Champion.find_by(:championId => params[:championId])
		puts "IN COMPARE"
		puts params[:profile][:summonerName]
		puts params[:profile][:region]
		puts params[:summonerName]
		puts params[:region]
		profile = Profile.find_by(:summonerName => params[:summonerName], :region => params[:region])
		compare_profile = Profile.find_by(:summonerName => params[:profile][:summonerName], :region => params[:profile][:region])
		match_search = Profile.where(:championId => @champion.championId).where(:summonerId => [compare_profile.summonerId])
		if profile.summonerName != nil && compare_profile != nil && match_search != nil
				 redirect_to action: "show_compare", summonerName1: profile.summonerName, region1: profile.region, championId: params[:championId], summonerName2: compare_profile.summonerName, region2: compare_profile.region
		elsif profile.summonerName != nil && compare_profile == nil
			redirect_to action: "create"
		else
			 	redirect_to action: "show_graph", id: profile.id, championId: params[:championId]
		end
			# redirect_to action: "show_graph", id: @profile.id, championId: params[:championId]
		# end
	end
	def show_compare
		@champion = Champion.find_by(:championId => params[:championId])
		@profile = Profile.find_by(:summonerName => params[:summonerName1], :region => params[:region1])
		@champion_mastery = ChampionMastery.where(:championId => params[:championId]).where(:profile_id => @profile.id)
		@compare_profile = Profile.find_by(:summonerName => params[:summonerName2], :region => params[:region2])
		@compare_mastery = ChampionMastery.where(:profile_id => @compare_profile.id).where(:championId => params[:championId])
		@matches = Match.where(:championId => params[:championId], :profile_id => @profile.id)
		@compare_matches = Match.where(:championId => params[:championId], :profile_id => @compare_profile.id)
		params[:championId] = @champion.championId
		puts "COMPARE NAMESSSSSSSSSSSSSSSSSSSSSSSS"
		puts @profile.summonerName
		puts @compare_profile.summonerName
	end

	private
	def profile_params
		params.require(:profile).permit(:summonerName, :region)
	end
end
