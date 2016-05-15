class MatchesController < ApplicationController
  def create
    last_known_match = Match.where(:summonerId => params[:summonerId], :championId => params[:championId]).order('timestamp desc').first
      if last_known_match != nil
      matchlist = Riot.get_matchlist(params[:region], params[:summonerId], {
        championIds: params[:championId],
        seasons: 'SEASON2016',
        endTime: last_known_match[:timestamp]
      })
      else
      matchlist = Riot.get_matchlist(params[:region], params[:summonerId], {
        championIds: params[:championId],
        seasons: 'SEASON2016',
      })
      end

    matchlist["matches"].each do |match|
      unless Match.exists?(matchId: match["matchId"])
        match = Riot.get_match(params[:region], match["matchId"])
          participant = match['participantIdentities'].find { |p| p['player']['summonerId'] == params[:summonerId].to_i }
          participantId = participant['participantId']
          participant_info = match['participants'][participantId - 1]
          ##math to calculate mdScore:::::: ##
            mdScore = 0
            mdScore += ((participant_info['stats']['kills']) * 10)
            mdScore -=  ((participant_info['stats']['deaths']) * 5)
            mdScore += ((participant_info['stats']['assists']) * 2.5)
            mdScore += (((participant_info['stats']['goldEarned']) /500) * 4)
            mdScore += ((participant_info['stats']['champLevel']) * 2)
            mdScore += (((participant_info['stats']['minionsKilled']) / 50) * 4)
            mdScore += ((participant_info['stats']['neutralMinionsKilled']) * 3)
            mdScore += (((participant_info['stats']['totalDamageDealt']) / 1000) * 2)
            mdScore += (((participant_info['stats']['totalTimeCrowdControlDealt']) / 100) * 5)
            mdScore += (((participant_info['stats']['totalHeal']) / 1000) * 4)
            mdScore += (((participant_info['stats']['magicDamageDealt']) / 1000) * 5)
            mdScore += (((participant_info['stats']['physicalDamageDealt']) / 1000) * 2)
            mdScore -= (((participant_info['stats']['totalDamageTaken']) / 1000) * 1)
            mdScore += ((participant_info['stats']['wardsPlaced']) * 4)
            mdScore += ((participant_info['stats']['doubleKills']) * 10)
            mdScore += ((participant_info['stats']['tripleKills']) * 18)
            mdScore += ((participant_info['stats']['quadraKills']) * 25)
            mdScore += ((participant_info['stats']['pentaKills']) * 40)
            if participant_info['stats']['winner'] == 't'
              mdScore += 100
              puts "MDSCORE::::::::::::::::::::::::::::::"
              puts mdScore
            else
              puts "MDSCOOOOREEE:::::::::::::::::::::::::"
              puts mdScore
              mdScore -= 100
            end
            timestamp = matchlist["matches"].find { |t| t['matchId'].to_i == match["matchId"].to_i}
        Match.create(
              matchId: match['matchId'],
              summonerId: params[:summonerId],
              kills: participant_info['stats']['kills'],
              deaths: participant_info['stats']['deaths'],
              assists: participant_info['stats']['assists'],
              goldEarned: participant_info['stats']['goldEarned'],
              championLevel: participant_info['stats']['champLevel'],
              summonerSpell1: participant_info['spell1Id'],
              summonerSpell2: participant_info['spell2Id'],
              item1: participant_info['stats']['item0'],
              item2: participant_info['stats']['item1'],
              item3: participant_info['stats']['item2'],
              item4: participant_info['stats']['item3'],
              item5: participant_info['stats']['item4'],
              item6: participant_info['stats']['item5'],
              mastery: participant_info['masteries'].last['masteryId'],
              cs: participant_info['stats']['minionsKilled'],
              jungleCs: participant_info['stats']['neutralMinionsKilled'],
              totalDamage: participant_info['stats']['totalDamageDealt'],
              totalCcDealt: participant_info['stats']['totalTimeCrowdControlDealt'],
              totalHeal: participant_info['stats']['totalHeal'],
              magicDamage: participant_info['stats']['magicDamageDealt'],
              physicalDamage: participant_info['stats']['physicalDamageDealt'],
              damageTaken: participant_info['stats']['totalDamageTaken'],
              wardsPlaced: participant_info['stats']['wardsPlaced'],
              doubleKills: participant_info['stats']['doubleKills'],
              tripleKills: participant_info['stats']['tripleKills'],
              quadraKills: participant_info['stats']['quadraKills'],
              pentaKills: participant_info['stats']['pentaKills'],
              profile_id: params[:id],
              timestamp: timestamp['timestamp'],
              championId: params[:championId],
              win: participant_info['stats']['winner'],
              mdScore: mdScore
          )
          mdScore = 0
      end
    end
      redirect_to controller: "profiles", action: "show_graph", id: params[:id], championId: params[:championId]
  end

	def update
	end
end
