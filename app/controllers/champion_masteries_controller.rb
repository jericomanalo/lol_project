class ChampionMasteriesController < ApplicationController

  def create
    # PASSED THE PARAMS OF REGION AND SUMMONERID FROM THE PROFILES CONTROLLER CREATE REDIRECT AFTER PROFILE WAS CREATED
    champion_masteries = Riot.get_champion_masteries(params[:region], params[:summonerId])
  	# begin populating the db
    champion_masteries.each do |this|
      lastPlayTime = DateTime.strptime(this['lastPlayTime'].to_s, '%Q')
      champion = Champion.find_by(:championId => this['championId'])
      new_mastery = ChampionMastery.create(
        summoner_id: params[:id],
        champion_id: champion.id,
        current_points: this['championPoints'],
        championPointsSinceLastLevel: this['championPointsSinceLastLevel'],
        championPointsUntilNextLevel: this['championPointsUntilNextLevel'],
        tokensEarned: this['tokensEarned'],
        championLevel: this['championLevel'],
        chestGranted: (this['chestGranted']).to_s,
        lastPlayTime: lastPlayTime
      )
      Champ.create(
        champion_id: champion.id,
        champion_mastery_id: new_mastery.id
      )
    end

    redirect_to controller: "profiles", action: "show", summonerName: params[:summonerName], region: params[:region]
  end

  def update
#      if this exists? # sudo code update
#        if this['championPoints'] == that['championPoints'] # sudo code update
  end
end
