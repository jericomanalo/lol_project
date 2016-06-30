class ChampionMasteriesController < ApplicationController

  def create
    Md.create_champion_mastery(params[:region], params[:summonerId], params[:id])
    redirect_to controller: "profiles", action: "show", summonerName: params[:summonerName], region: params[:region]
  end

  def update
  end

end
