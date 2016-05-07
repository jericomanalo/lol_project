class MatchesController < ApplicationController

 	def create
	  	get_summoner_match_history
	  	get_match_info
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
			    win: this['stats']['winner']
		    )
			counter += 1
			puts "8=========================D ~~~~~~ ( . Y . )"
			puts this['stats']['winner']
			puts "~!~!~!~!~!!~!~!~!~!~!SAVING ONE MATCH!~!~!~!~!~!!~!~!~!~!~"
	  	end
		#WE MIGHT NEED TO INJECT THE PARAMS BACK INTO HERE IE: REGION, SUMMONERNAME, SUMMONERID
  		redirect_to controller: "profiles", action: "show", id: params[:id]
	end

	def update
	end
end
