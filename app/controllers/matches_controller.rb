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
          mdScore = 0
          mdScore += ((this['stats']['kills']) * 10)
          mdScore -=  ((this['stats']['deaths']) * 5)
          mdScore += ((this['stats']['assists']) * 2.5)
          mdScore += (((this['stats']['goldEarned']) /500) * 4)
          mdScore += ((this['stats']['champLevel']) * 2)
          mdScore += (((this['stats']['minionsKilled']) / 50) * 4)
          mdScore += ((this['stats']['neutralMinionsKilled']) * 3)
          mdScore += (((this['stats']['totalDamageDealt']) / 1000) * 2)
          mdScore += (((this['stats']['totalTimeCrowdControlDealt']) / 100) * 5)
          mdScore += (((this['stats']['totalHeal']) / 1000) * 4)
          mdScore += (((this['stats']['magicDamageDealt']) / 1000) * 5)
          mdScore += (((this['stats']['physicalDamageDealt']) / 1000) * 2)
          mdScore -= (((this['stats']['totalDamageTaken']) / 1000) * 1)
          mdScore += ((this['stats']['wardsPlaced']) * 4)
          mdScore += ((this['stats']['doubleKills']) * 10)
          mdScore += ((this['stats']['tripleKills']) * 18)
          mdScore += ((this['stats']['quadraKills']) * 25)
          mdScore += ((this['stats']['pentaKills']) * 40)
          if this['stats']['winner'] == 't'
            mdScore += 100
            puts "MDSCORE::::::::::::::::::::::::::::::"
            puts mdScore
          else
            puts "MDSCOOOOREEE:::::::::::::::::::::::::"
            puts mdScore
            mdScore -= 100
          end
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
				    championId: params[:championId],
            win: this['stats']['winner'],
            masteryPoints: points,
            mdScore: mdScore
			     )
        if counter == (@matches.count) - 1 then
          puts "heluuuuu"
          next
        else
          points += average_ppm
        end
				counter += 1
        mdScore = 0
	    end
		#WE MIGHT NEED TO INJECT THE PARAMS BACK INTO HERE IE: REGION, SUMMONERNAME, SUMMONERID
  		redirect_to controller: "profiles", action: "show_graph", id: params[:id], championId: params[:championId]
  	else
      @matches = Match.where(:championId => params[:championId]).where(:summonerId =>params[:summonerId])
  		redirect_to controller: "profiles", action: "show_graph", id: params[:id], championId: params[:championId], summonerId: params[:summonerId]
  	end
end



	def update
	end
end
