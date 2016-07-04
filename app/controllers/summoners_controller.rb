class SummonersController < ApplicationController
	def index
		if Champion.all.count < 130
			all_champions = Riot.get_all_champions(params)
			all_champions = all_champions['data']
			all_champions.each do |this|
				tag = this[1]["tags"][0].to_s
				Champion.create(championId: this[1]["id"], name: this[1]["name"], title: this[1]["title"], icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/champion/"+this[1]['key']+".png", splash: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/"+this[1]['key']+"_0.jpg", tag: tag)
			end
		end
		# Method for random summoner needs to be changed
		# randomInt = rand(1...(Summoner.count)+1)
		# if Summoner.count > 0
		# @randomsummoner = Summoner.find(randomInt)
		# end
	end

	def search
		@summoner = Summoner.find_by(:region => params[:summoner][:region], :summonerName => params[:summoner][:summonerName])
		if  @summoner != nil
			redirect_to action: "show", summonerName: @summoner.summonerName, region: @summoner.region
		else
			create
		end
	end

	def create
		region = params[:summoner][:region]
		summonerName = params[:summoner][:summonerName]
		if Md.create_summoner(region, summonerName)
			@summoner = Summoner.find_by(:summonerName => summonerName, :region => region )
      redirect_to controller: "champion_masteries", action: "create", region: @summoner.region, summonerId: @summoner.summonerId, id: @summoner.id, summonerName: @summoner.summonerName
    else
      flash[:error] = "Sorry, the Summoner you wish to search for does not exist in the Riot Games database, please try again."
      redirect_to '/'
    end
	end

	def show
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################
		@champions = Champion.all
		@summoner = Summoner.find_by(:summonerName => params[:summonerName], :region => params[:region])
		@champion_masteries = @summoner.champion_masteries.all
		@top_champion = @champion_masteries.includes(:champion).order(current_points: :desc).first
		@test_query = @summoner.champion_masteries.includes(:champions)
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################

		# Populate global variables to separate the Champions with Masteries and those without
<<<<<<< HEAD
			mastered_supports = @champion_masteries.includes(:champions).where('champions.tag = ?', 'Support').references(:champions)
			unmastered_supports = @champions.where(tag: "Support").where.not(id: mastered_supports.pluck(:champion_id).flatten)
			mastered_tanks = @champion_masteries.includes(:champions).where('champions.tag = ?', 'Tank').references(:champions)
			unmastered_tanks = @champions.where(tag: "Tank").where.not(id: mastered_tanks.pluck(:champion_id).flatten)
			mastered_assassins = @champion_masteries.includes(:champions).where('champions.tag = ?', 'Assassin').references(:champions)
			unmastered_assassins = @champions.where(tag: "Assassin").where.not(id: mastered_assassins.pluck(:champion_id).flatten)
			mastered_fighters = @champion_masteries.includes(:champions).where('champions.tag = ?', 'Fighter').references(:champions)
			unmastered_fighters = @champions.where(tag: "Fighter").where.not(id: mastered_fighters.pluck(:champion_id).flatten)
			mastered_mages = @champion_masteries.includes(:champions).where('champions.tag = ?', 'Mage').references(:champions)
			unmastered_mages = @champions.where(tag: "Mage").where.not(id: mastered_mages.pluck(:champion_id).flatten)
			mastered_marksmen = @champion_masteries.includes(:champions).where('champions.tag = ?', 'Marksman').references(:champions)
			unmastered_marksmen = @champions.where(tag: "Marksman").where.not(id: mastered_marksmen.pluck(:champion_id).flatten)
			@champion_list = {
				:Assassins => { :Mastered => mastered_assassins,
												:Unmastered => unmastered_assassins,
												:Progress => mastered_assassins.pluck(:championLevel).sum,
										},
				:Supports => { :Mastered => mastered_supports,
											 :Unmastered => unmastered_supports,
											 :Progress => mastered_supports.pluck(:championLevel).sum,
										},
				:Tanks => { :Mastered => mastered_tanks,
										:Unmastered => unmastered_tanks,
										:Progress => mastered_tanks.pluck(:championLevel).sum,
									},
				:Fighters => { :Mastered => mastered_fighters,
										   :Unmastered => unmastered_fighters,
											 :Progress => mastered_fighters.pluck(:championLevel).sum,
										 },
				:Mages => { :Mastered => mastered_mages,
										:Unmastered => unmastered_mages,
										:Progress => mastered_mages.pluck(:championLevel).sum,
										},
				:Marksmen => { :Mastered => mastered_marksmen,
										   :Unmastered => unmastered_marksmen,
											 :Progress => mastered_marksmen.pluck(:championLevel).sum,
										 }
										}

			@champion_list = @champion_list.sort_by { |key, value| value[:Mastered].count}.reverse

	    # Loop through all 130 champions via the @champions (== Champion.all) variable and compare all 130 against each of the heroes in @champion_masteries ( == ChampionMastery.where(summoner_id: params[:id]))
	end

	def show_graph
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################
		@summoner = Summoner.find(params[:id])
		@champion = Champion.find_by(:championId => params[:championId])
		@champion_mastery = ChampionMastery.find_by(:champion_id => @champion.id, :summoner_id => params[:id])
		puts "@CHAMPION_____________________________MASTERY"
		puts @champion_mastery
		@matches = Match.where(:summoner_id => @summoner.id).where(:champion_id => @champion.id)
		################### CAN WE STREAMLINE QUERIES???!?!?!??!?!? ##################

	end

	def compare
		@champion = Champion.find_by(:championId => params[:championId])
		puts "IN COMPARE"
		puts params[:summoner][:summonerName]
		puts params[:summoner][:region]
		puts params[:summonerName]
		puts params[:region]
		summoner = Summoner.find_by(:summonerName => params[:summonerName], :region => params[:region])
		compare_summoner = Summoner.find_by(:summonerName => params[:summoner][:summonerName], :region => params[:summoner][:region])
		match_search = Match.where(:champion_id => @champion.id).where(:summoner_id => [compare_summoner.id])
		if summoner.summonerName != nil && compare_summoner != nil && match_search != nil
				 redirect_to action: "show_compare", summonerName1: summoner.summonerName, region1: summoner.region, championId: params[:championId], summonerName2: compare_summoner.summonerName, region2: compare_summoner.region
		elsif summoner.summonerName != nil && compare_summoner == nil
			redirect_to action: "create"
		else
			 	redirect_to action: "show_graph", id: summoner.id, championId: params[:championId]
		end
			# redirect_to action: "show_graph", id: @summoner.id, championId: params[:championId]
		# end
	end

	def show_compare
		@champion = Champion.find_by(:championId => params[:championId])
		@summoner = Summoner.find_by(:summonerName => params[:summonerName1], :region => params[:region1])
		@champion_mastery = ChampionMastery.where(:champion_id => @champion.id).where(:summoner_id => @summoner.id)
		@compare_summoner = Summoner.find_by(:summonerName => params[:summonerName2], :region => params[:region2])
		@compare_mastery = ChampionMastery.where(:summoner_id => @compare_summoner.id).where(:champion_id => @champion.id)
		@matches = Match.where(:champion_id => @champion.id, :summoner_id => @summoner.id)
		@compare_matches = Match.where(:champion_id => @champion.id, :summoner_id => @compare_summoner.id)
		params[:championId] = @champion.championId
		puts "COMPARE NAMESSSSSSSSSSSSSSSSSSSSSSSS"
		puts @summoner.summonerName
		puts @compare_summoner.summonerName
	end

	private

	def summoner_params
		params.require(:summoner).permit(:region, :summonerName)
	end

end
