class ChampionMasteriesController < ApplicationController

  def create
    # PASSED THE PARAMS OF REGION AND SUMMONERID FROM THE PROFILES CONTROLLER CREATE REDIRECT AFTER PROFILE WAS CREATED
    champion_masteries = Riot.get_champion_masteries(params[:region], params[:summonerId])
  	# begin populating the db
    champion_masteries.each do |this|
      lastPlayTime = DateTime.strptime(this['lastPlayTime'].to_s, '%Q')
      ChampionMastery.create(
        profile_id: params[:id],
        championId: this['championId'],
        current_points: this['championPoints'],
        championPointsSinceLastLevel: this['championPointsSinceLastLevel'],
        championPointsUntilNextLevel: this['championPointsUntilNextLevel'],
        highestGrade: this['highestGrade'],
        championLevel: this['championLevel'],
        lastPlayTime: lastPlayTime
      )
    end

    redirect_to controller: "profiles", action: "show", summonerName: params[:summonerName], region: params[:region]
  end

  def update
#      if this exists? # sudo code update
#        if this['championPoints'] == that['championPoints'] # sudo code update
  end
end
