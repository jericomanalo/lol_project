class MatchesController < ApplicationController
  def create
<<<<<<< HEAD
    Md.create_match(params[:summonerId], params[:championId], params[:region], params[:summonerName], params[:id])
    redirect_to controller: "summoners", action: "show_graph", id: params[:id], championId: params[:championId]
=======
    last_known_match = Match.where(:summonerId => params[:summonerId], :championId => params[:championId]).order('timestamp desc').first
      if last_known_match != nil
<<<<<<< HEAD
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

    # Check to see if the particular summoner has no matches played with this champion and redirect back to the profile page with a flash message
    if matchlist['totalGames'] == 0
      flash[:error] = "Sorry, this summoner currently has no matches played with this Champion for the 2016 Season."
      redirect_to controller: "profiles", action: "show", summonerName: params[:summonerName], region: params[:region]
    else

      matchlist["matches"].each do |match|
        unless Match.exists?(matchId: match["matchId"])
          match = Riot.get_match(params[:region], match["matchId"])
            participant = match['participantIdentities'].find { |p| p['player']['summonerId'] == params[:summonerId].to_i }
            participantId = participant['participantId']
            participant_info = match['participants'][participantId - 1]
            ## math to calculate mdScore:::::: ##
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
=======
      matchlist = Riot.get_matchlist(params[:region], params[:summonerId], {
        championIds: params[:championId],
        seasons: 'SEASON2016',
        startTime: last_known_match[:timestamp]
      })
      else
      matchlist = Riot.get_matchlist(params[:region], params[:summonerId], {
        championIds: params[:championId],
        seasons: 'SEASON2016',
      })
      end
      puts matchlist['totalGames'], "############ ~  MATCHLIST ~ ############"




      if matchlist["totalGames"] == 0
        flash[:error] = "Sorry, this Summoner currently has no matches played with this Champion for the 2016 Season."
        redirect_to controller: "profiles", action: "show", summonerName: params[:summonerName], region: params[:region]
      else
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
>>>>>>> origin/master
  end

  def show
    @match = Match.find_by(:matchId => params[:id])
    @champion = Champion.find(@match.champion_id)
    @summoner = Summoner.find(@match.summoner_id)
    @personal_best_gold = Match.where(:summoner_id => @match.summoner_id, :champion_id => @champion.id).order(goldEarned: :desc).first
    @pb_totalHeal = Match.where(:summoner_id => @match.summoner_id, :champion_id => @champion.id).order(totalHeal: :desc).first
    @pb_totalCcDealt = Match.where(:summoner_id => @match.summoner_id, :champion_id => @champion.id).order(totalCcDealt: :desc).first
    @pb_wardsPlaced = Match.where(:summoner_id => @match.summoner_id, :champion_id => @champion.id).order(wardsPlaced: :desc).first
    @pb_cs = Match.where(:summoner_id => @match.summoner_id, :champion_id => @champion.id).order(cs: :desc).first
    @pb_jungleCs = Match.where(:summoner_id => @match.summoner_id, :champion_id => @champion.id).order(jungleCs: :desc).first
    summonerSpells =  {
        "SummonerBoost" => 1,
        "SummonerTeleport" => 12,
        "SummonerPoroRecall" => 30,
        "SummonerDot" => 14,
        "SummonerHaste" => 6,
        "SummonerSnowball" => 32,
        "SummonerHeal" => 7,
        "SummonerSmite" => 11,
        "SummonerPoroThrow" => 31,
        "SummonerExhaust" => 3,
        "SummonerMana" => 13,
        "SummonerClairvoyance" => 2,
        "SummonerBarrier" => 21,
        "SummonerFlash" => 4
    }

    puts "!!!!!!!!!!!!!!!!!!!!!!!!! @SUMMONERSPELLLLLLLLL!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @summspell1 = summonerSpells.key(@match.summonerSpell1)
    @summspell2 = summonerSpells.key(@match.summonerSpell2)
    puts @summspell1
    puts @summspell2
>>>>>>> upstream/master
  end

	def update
	end
end
