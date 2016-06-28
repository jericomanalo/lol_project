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

  class Riot
    def self.get_all_champions(params)
      url = self.get_static_url
      params = { champData: 'tags' }
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
      "b8a84394-c482-433d-a426-5db7d03615fc"
    end
  end

  class masteryDex

    def self.create_profile
      profile = Riot.get_summoner(params[:profile][:region], params[:profile][:summonerName], {})
      ############################# FIX THE REDIRECT ##########################################
      # checking if the summoner that is being looked up does not exist from the api response #

      ############################# FIX THE REDIRECT ##########################################
      name = params[:profile][:summonerName]
      if profile[name]
            Profile.create(
              summonerName: name,
              summonerId: profile[name]['id'],
              region: params[:profile][:region],
              icon: "http://ddragon.leagueoflegends.com/cdn/6.9.1/img/profileicon/" + (profile[name]['profileIconId']).to_s + ".png",
              summonerLevel: profile[name]['summonerLevel']
            )
              @profile = Profile.find_by(:summonerName => params[:profile][:summonerName], :region => params[:profile][:region] )
              redirect_to controller: "champion_masteries", action: "create", region: @profile.region, summonerId: @profile.summonerId, id: @profile.id, summonerName: @profile.summonerName
            else
              ############### - ADD FLASH MESSAGES LOGIC - ##########################
            flash[:error] = "Sorry, the Summoner you wish to search for does not exist in the Riot Games database, please try again."
          redirect_to '/'
                ############### - ADD FLASH MESSAGES LOGIC - ##########################
      end
    end

    def self.create_championMastery
    end

    def self.create_match
    end


  end













end
