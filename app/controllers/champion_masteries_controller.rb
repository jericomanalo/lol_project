class ChampionMasteriesController < ApplicationController

  def create
  	#call to api to search for the champion masteries

  	# @profile = params[:profile]
  	# @profile = ({id: params[:id], summonerId: params[:summonerId], summonerName: params[:summonerName], region: params[:region]}).to_json
  	# puts "CHAMPION MASTERIES @PROFILE ~!~!~!~!~!~!~!~!~!~!~!~!~~!~!~~!~"
  	# puts @profile

  	get_summoner_champ_mastery
  	#begin populating the db
    @champion_masteries.each do |this|
      lastPlayTime = DateTime.strptime(this['lastPlayTime'].to_s, '%Q')
      new_champ_mastery = ChampionMastery.new(
          profile_id: params[:id],
          championId: this['championId'],
          championPointsSinceLastLevel: this['championPointsSinceLastLevel'],
          championPointsUntilNextLevel: this['championPointsUntilNextLevel'],
          highestGrade: this['highestGrade'],
          championLevel: this['championLevel'],
          lastPlayTime: lastPlayTime
      )
      new_champ_mastery.save
    end

    redirect_to controller: "profiles", action: "show", id: params[:id], summonerName: params[:summonerName], region: params[:region], summonerId: params[:summonerId] 
  end

  def show
  end

  def update
  end
	# def search
	# 	search_for_champion_masteries
	# 	if @champion_mastery != nil
	# 		puts @champion_mastery
	# 		redirect_to action: ""
	# end
end
