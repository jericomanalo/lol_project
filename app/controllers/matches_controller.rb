class MatchesController < ApplicationController

 	def create
 		  get_summoner_match_history
      @mastery = ChampionMastery.where(:championId => params[:championId])
      puts "MASTERY"
      puts @mastery[0]
      mastery_points = (@mastery[0]['current_points'])
      points = 0
      puts "MASTERY PTS!!!!!!!!!!!!!"
      puts mastery_points
      get_match_info
	  	if @matches != nil
        current_match_count = Match.where(:championId => params[:championId]).where(:summonerId => params[:summonerId]).count
        average_ppm = (mastery_points / (current_match_count + @matches.count))
        counter = 0
		  	@matches.each do |this|
			    new_match = Match.create(
				    matchId: @match_history[counter]['matchId'],
				    summonerId: params[:summonerId],
				    kills: this['stats']['kills'],
				    deaths: this['stats']['deaths'],
				    assists: this['stats']['assists'],
				    goldEarned: this['stats']['goldEarned'],
				    championLevel: this['stats']['champLevel'],
				    summonerSpell1: this['spell1Id'],
				    summonerSpell2: this['spell2Id'],
				    item1: this['stats']['item0'],
				    item2: this['stats']['item1'],
				    item3: this['stats']['item2'],
				    item4: this['stats']['item3'],
				    item5: this['stats']['item4'],
				    item6: this['stats']['item5'],
				    mastery: this['masteries'].last['masteryId'],
				    cs: this['stats']['minionsKilled'],
				    jungleCs: this['stats']['neutralMinionsKilled'],
				    totalDamage: this['stats']['totalDamageDealt'],
				    totalCcDealt: this['stats']['totalTimeCrowdControlDealt'],
				    totalHeal: this['stats']['totalHeal'],
				    magicDamage: this['stats']['magicDamageDealt'],
				    physicalDamage: this['stats']['physicalDamageDealt'],
				    damageTaken: this['stats']['totalDamageTaken'],
				    wardsPlaced: this['stats']['wardsPlaced'],
				    doubleKills: this['stats']['doubleKills'],
				    tripleKills: this['stats']['tripleKills'],
				    quadraKills: this['stats']['quadraKills'],
				    pentaKills: this['stats']['pentaKills'],
				    profile_id: params[:id],
				    timestamp: @match_history[counter]['timestamp'],
				    win: this['stats']['winner'],
				    championId: params[:championId],
            masteryPoints: points
			     )
        points += average_ppm
				counter += 1
	    end
		#WE MIGHT NEED TO INJECT THE PARAMS BACK INTO HERE IE: REGION, SUMMONERNAME, SUMMONERID
  		redirect_to controller: "profiles", action: "show_graph", summonerName: params[:summonerName], championId: params[:championId], summonerId: params[:summonerId]
  	else
      @matches = Match.where(:championId => params[:championId]).where(:summonerId =>params[:summonerId])
  		redirect_to controller: "profiles", action: "show_graph", id: params[:id], championId: params[:championId], summonerId: params[:summonerId]
  	end
end

	def update
	end
end
