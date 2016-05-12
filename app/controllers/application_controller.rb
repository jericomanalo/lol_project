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
  $lol_key = ENV['LOL_SECRET']
  $lol_uri = "https://global.api.pvp.net"
  $summoner_uri = "https://na.api.pvp.net"
  def get_lol_champions
    champion_query = "/api/lol/static-data/na/v1.2/champion?&api_key="
    uri = URI.parse($summoner_uri+champion_query+$lol_key)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    #store the body of the requested URI (Uniform Resource Identifier)
    data = response.body
    #to parse JSON string; you may also use JSON.parse()
    #JSON.load() turns the data into a hash
    champions = JSON.load(data)
    champions = champions["data"]
    champions.each do |this|

      champ = Champion.new(championId: this[1]['id'], name: this[1]['name'], title: this[1]['title'], icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/champion/"+this[1]['key']+".png", splash: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/"+this[1]['key']+"_0.jpg")
      puts "champion image::"
      champ.save!
      puts champ.splash
    end
  end
  # getting summoners basic info
  def search_for_summoner
  	# $summoner_query = "/api/lol/" +  params[:region] + "/v1.4/summoner/by-name/" + params[:summonerName] + "?api_key="

  	uri = URI.parse($summoner_uri + "/api/lol/" + params[:profile][:region] + "/v1.4/summoner/by-name/" + params[:profile][:summonerName] + "?api_key=" + $lol_key)
  	http = Net::HTTP.new(uri.host, uri.port)
  	http.use_ssl = true
  	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  	request = Net::HTTP::Get.new(uri.request_uri)
  	response = http.request(request)
      #store the body of the requested URI (Uniform Resource Identifier)
      data = response.body
      #to parse JSON string; you may also use JSON.parse()
      #JSON.load() turns the data into a hash
      # returns summoner name
      @summoner = []
      # full response
      @lol = JSON.load(data)

      # CLEAN UP / RENAME LOL VAR
      @lol.each do |this|
      	@summoner.push(this[0])
      end
    end
  # gets all id for all the matches and basic info for the matches for the particular user
  def get_summoner_match_history

  	match_history_query = "/api/lol/" + params[:region] + "/v2.2/matchlist/by-summoner/" + params[:summonerId] + "?championIds=" + params[:championId] + "&seasons=SEASON2016&api_key="

  	uri = URI.parse($summoner_uri+match_history_query+$lol_key)
  	http = Net::HTTP.new(uri.host, uri.port)
  	http.use_ssl = true
  	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  	request = Net::HTTP::Get.new(uri.request_uri)
  	response = http.request(request)
    #store the body of the requested URI (Uniform Resource Identifier)
    data = response.body
    #to parse JSON string; you may also use JSON.parse()
    #JSON.load() turns the data into a hash
    @match_history = JSON.parse(data)
    # @match_history = @match_history['matches']
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@ MATCH HISTORY @@@@@@@@@@@@@@@@@@@@@"
     # @match_history.length
  end
       # sending the API a match id to return back match STATS
  def get_match_info
        count = Match.where(:summonerId => params[:summonerId]).where(:championId => params[:championId]).count
        counter = @match_history.length
        puts "COUNTERRRR!!!!"
        asdf = 0
        puts counter
        puts "MATCH HISTORRRRRRYYYYY"
        puts @match_history
        
      if @match_history.length == 0 || count != counter
        puts "MATCH HISTORY LENGTH!!!!!!!!!!!!!!"
          @matches = []
           (count..(counter -1)).each do |this|
              match_id = @match_history[this]['matchId']
             	# REGION DICTIONARY
             	match_query = "/api/lol/na/v2.2/match/"+(match_id).to_s+"?includeTimeline=false&api_key="
             	uri = URI.parse($summoner_uri+match_query+$lol_key)
             	http = Net::HTTP.new(uri.host, uri.port)
             	http.use_ssl = true
             	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
             	request = Net::HTTP::Get.new(uri.request_uri)
             	response = http.request(request)
              #store the body of the requested URI (Uniform Resource Identifier)
              data = response.body
              #to parse JSON string; you may also use JSON.parse()
              #JSON.load() turns the data into a hash
              match = JSON.parse(data)
              puts "~~~~~~~~~~~~~~~~~~~match~~~~~~~~~~~~~~~~~~~~"
              puts match
              asdf
              participant = match['participantIdentities'].find { |p| p['player']['summonerId'] == params[:summonerId].to_i }
              participantId = participant['participantId']
              puts participant
              puts match['participants'][participantId - 1]
              participant_info = match['participants'][participantId - 1]
              asdf += 1
              @matches.push(participant_info)
            end
        end
    end

  # getting champion info
  def get_summoner_champ_mastery
  	# takes in two params region/summonerId
  	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  	# Region Convert as Dictionary { "NA" : "NA1"}
  	# Dont forget Region selector -> LA1/LA2 etc
  	puts "IN GET_SUMMONER_CHAMP_MASTERY, @PROFILE.SUMMONERID.TO_S"
  	puts params[:summonerId]
  	champ_mast_query = "/championmastery/location/na1/player/"+ params[:summonerId] + "/champions?api_key="
  	champ_uri = URI.parse($summoner_uri+champ_mast_query+$lol_key)
  	champ_http = Net::HTTP.new(champ_uri.host, champ_uri.port)
  	champ_http.use_ssl = true
  	champ_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  	champ_request = Net::HTTP::Get.new(champ_uri.request_uri)
  	champ_response = champ_http.request(champ_request)
    #store the body of the requested URI (Uniform Resource Identifier)
    champ_data = champ_response.body
    #to parse JSON string; you may also use JSON.parse()
    #JSON.load() turns the data into a hash
    @champion_masteries = JSON.load(champ_data)
    #Query for all Champions in our database and pass back to front-end
    # render :text => data
  end

  # checks if the summoner database is GOOCHI
  def get_summoner_profile

  end

  def search_for_profile
    puts "@@@@@@@@@@@@@@@@@@PARAMAS@@@@@@@@@@@@@"
    puts params
    @profile = Profile.find_by(:summonerName => params[:summonerName], :region => params[:region])
    puts "~!~!~!~!~!~!~ THIS IS THE PROFILE REQUESTED FROM SEARCH_FOR_PROFILE ~!~!~!~!~"
    puts @profile
  end
  def search_for_champion_masteries
    ChampionMastery.where(:profile_id => @profile.id)
  end
  def search_for_matches
    Match.where(:profile_id => @profile.id)
  end
  def search_for_champions
    Champion.all
  end

  def create_matches
          # new_match = Match.create(
          #   matchId: match['matchId'],
          #   summonerId: that['player']['summonerId'],
          #   kills: match['participants'][this_participant]['stats']['kills'],
          #   deaths: match['participants'][this_participant]['stats']['deaths'],
          #   assists: match['participants'][this_participant]['stats']['assists'],
          #   goldEarned: match['participants'][this_participant]['stats']['goldEarned'],
          #   championLevel: match['participants'][this_participant]['stats']['champLevel'],
          #   summonerSpell1: match['participants'][this_participant]['spell1Id'],
          #   summonerSpell2: match['participants'][this_participant]['spell2Id'],
          #   item1: match['participants'][this_participant]['stats']['item0'],
          #   item2: match['participants'][this_participant]['stats']['item1'],
          #   item3: match['participants'][this_participant]['stats']['item2'],
          #   item4: match['participants'][this_participant]['stats']['item3'],
          #   item5: match['participants'][this_participant]['stats']['item4'],
          #   item6: match['participants'][this_participant]['stats']['item5'],
          #   mastery: match['participants'][this_participant]['masteries'].last['masteryId'],
          #   cs: match['participants'][this_participant]['stats']['minionsKilled'],
          #   jungleCs: match['participants'][this_participant]['stats']['neutralMinionsKilled'],
          #   totalDamage: match['participants'][this_participant]['stats']['totalDamageDealt'],
          #   totalCcDealt: match['participants'][this_participant]['stats']['totalTimeCrowdControlDealt'],
          #   totalHeal: match['participants'][this_participant]['stats']['totalHeal'],
          #   magicDamage: match['participants'][this_participant]['stats']['magicDamageDealt'],
          #   physicalDamage: match['participants'][this_participant]['stats']['physicalDamageDealt'],
          #   damageTaken: match['participants'][this_participant]['stats']['totalDamageTaken'],
          #   wardsPlaced: match['participants'][this_participant]['stats']['wardsPlaced'],
          #   doubleKills: match['participants'][this_participant]['stats']['doubleKills'],
          #   tripleKills: match['participants'][this_participant]['stats']['tripleKills'],
          #   quadraKills: match['participants'][this_participant]['stats']['quadraKills'],
          #   pentaKills: match['participants'][this_participant]['stats']['pentaKills'],
          #   profile_id: @profile.id
          #   )
  end

end
