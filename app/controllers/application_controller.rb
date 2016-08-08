class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  require 'chartkick'
  require 'groupdate'
  require 'hightop'
  require 'active_median'
  require 'json'
  require 'net/http' #to make a GET request
  require 'open-uri' #to fetch the data from the URL to then be parsed by JSON

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user != nil
  end

  def authorize
    redirect_to '/' unless current_user
  end

  class Riot
    def self.get_all_champions(params)
      url = self.get_static_url
      params = { champData: 'all' }
      params = self.get_params(params)
      self.http_get(url, params)
    end

    def self.get_summoner(region, summonerName, params = {})
      url = self.get_summoner_url(region, summonerName)
      params = self.get_params(params)
      self.http_get(url, params)
    end

    def self.get_champion_masteries(region, summonerId, params = {})
      url = self.get_champion_mastery_url(region, summonerId)
      params = self.get_params(params)
      self.http_get(url, params)
    end

    def self.get_matchlist(region, summonerId, params = {})
      url = self.get_api_url(region, "matchlist/by-summoner/#{summonerId}")
      params = self.get_params(params)
      self.http_get(url, params)
    end

    def self.get_match(region, matchId, params = { includeTimestamp: false})
      url = self.get_api_url(region, "match/#{matchId}")
      params = self.get_params(params)
      self.http_get(url, params)
    end

  private
    def self.http_get(uri, params = nil)
      uri = URI.parse(uri)
      uri.query = URI.encode_www_form(params) unless params.nil?
      res = Net::HTTP.get(uri)
      JSON.parse(res)
    end

   def self.region_converter(region)
      if region == "br"
        "br"
      elsif region == "eune"
        "eun1"
      elsif region == "euw"
        "euw1"
      elsif region == "jp"
        "jp1"
      elsif region == "kr"
        "kr"
      elsif region == "lan"
        "la1"
      elsif region == "las"
        "la2"
      elsif region == "na"
        "na1"
      elsif region == "oce"
        "oc1"
      elsif region == "ru"
        "ru"
      else
        "tr1"
      end
   end

    def self.get_champion_mastery_url(region, summonerId)
      true_region = self.region_converter(region)
      "https://#{region}.api.pvp.net/championmastery/location/#{true_region}/player/#{summonerId}/champions"
    end

    def self.get_static_url
      "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion"
    end

    def self.get_summoner_url(region, summonerName)
      "https://#{region}.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{summonerName}"
    end

    def self.get_match_url(region)
      "https://#{region}.api.pvp.net/api/lol/#{region}/v2.2/"
    end

    def self.get_api_url(region, endpoint)
      self.get_match_url(region) + endpoint
    end

    def self.get_params(params)
      { api_key: self.get_api_key }.merge(params)
    end

    def self.get_api_key
      ENV["LOL_SECRET"]
    end
  end

  class Md

    def self.create_summoner(region, summonerName)
      summoner = Riot.get_summoner(region, summonerName, {})
      if summoner[summonerName]
        Summoner.create(
          summonerName: summonerName,
          summonerId: summoner[summonerName]['id'],
          region: region,
          icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/profileicon/" + (summoner[summonerName]['profileIconId']).to_s + ".png",
          summonerLevel: summoner[summonerName]['summonerLevel']
        )
      end
    end

    def self.create_champion_mastery(region, summonerId, id)
      champion_masteries = Riot.get_champion_masteries(region, summonerId)
      champion_masteries.each do |this|
        champion = Champion.find_by(:championId => this['championId'])
        lastPlayTime = DateTime.strptime(this['lastPlayTime'].to_s, '%Q')
        new_mastery = ChampionMastery.create(
          summoner_id: id,
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
    end

    def self.create_match(summonerId, championId, region, summonerName, id)
      champion = Champion.find_by(:championId => championId)
      last_known_match = Match.where(:summoner_id => id, :champion_id => champion.id).order('timestamp desc').first
      if last_known_match != nil
        matchlist = Riot.get_matchlist(region, summonerId, {
          championIds: championId,
          seasons: 'SEASON2016',
          startTime: last_known_match[:timestamp]
        })
      else
        matchlist = Riot.get_matchlist(region, summonerId, {
          championIds: championId,
          seasons: 'SEASON2016',
        })
      end
      if matchlist["totalGames"] == 0
        flash[:error] = "Sorry, this Summoner currently has no matches played with this Champion for the 2016 Season."
        redirect_to controller: "summoners", action: "show", summonerName: summonerName, region: region
      else
        matchlist["matches"].each do |match|

          unless Match.exists?(matchId: match["matchId"])
            match = Riot.get_match(region, match["matchId"])
              participant = match['participantIdentities'].find { |p| p['player']['summonerId'] == summonerId.to_i }
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
            new_match = Match.create(
                  matchId: match['matchId'],
                  summoner_id: id,
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
                  summoner_id: id,
                  timestamp: timestamp['timestamp'],
                  champion_id: champion.id,
                  win: participant_info['stats']['winner'],
                  mdScore: mdScore
              )
              mdScore = 0
          end
        end
      end
    end
  end

end
