class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  require 'json'
  require 'net/http' #to make a GET request
  require 'open-uri' #to fetch the data from the URL to then be parsed by JSON
  $lol_key = "<insert LOL KEY HERE >"
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
      champ = Champion.new(championId: this[1]['id'], name: this[1]['name'], title: this[1]['title'], icon: "http://ddragon.leagueoflegends.com/cdn/6.8.1/img/champion/"+this[1]['name']+".png")
      puts "champion::"
      puts champ
      champ.save!
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
  	match_history_query = "/api/lol/na/v2.2/matchlist/by-summoner/"+ (@profile.summonerId).to_s + "?seasons=SEASON2016&api_key="
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
           @match_history = JSON.load(data)
           @match_history = @match_history['matches']
       end
       # sending the API a match id to return back match STATS
       def get_match_info
       	@matches = []
       	@match_history.each do |this|
       		match_id = this['matchId']
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
        match = JSON.load(data)
        @matches.push(match)
    end
end
# getting champion info
def get_summoner_champ_mastery
	# takes in two params region/summonerId
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
	# Region Convert as Dictionary { "NA" : "NA1"}
	# Dont forget Region selector -> LA1/LA2 etc
	puts "IN GET_SUMMONER_CHAMP_MASTERY, @PROFILE.SUMMONERID.TO_S"
	puts (@profile.summonerId).to_s
	champ_mast_query = "/championmastery/location/na1/player/"+ (@profile.summonerId).to_s + "/champions?api_key="
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
  	@champions = Champion.all
  	if(@champions.count < 130)
  		get_lol_champions
  	end
  end
end
