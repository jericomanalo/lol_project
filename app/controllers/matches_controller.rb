class MatchesController < ApplicationController
  def create
    Md.create_match(params[:summonerId], params[:championId], params[:region], params[:summonerName], params[:id])
    redirect_to controller: "profiles", action: "show_graph", id: params[:id], championId: params[:championId]
  end

  def show
    @match = Match.find_by(:matchId => params[:id])
    @champion = Champion.find_by(:championId => @match.championId)
    @profile = Profile.find(@match.profile_id)
    @personal_best_gold = Match.where(:profile_id => @match.profile_id, :championId => @match.championId).order(goldEarned: :desc).first
    @pb_totalHeal = Match.where(:profile_id => @match.profile_id, :championId => @match.championId).order(totalHeal: :desc).first
    @pb_totalCcDealt = Match.where(:profile_id => @match.profile_id, :championId => @match.championId).order(totalCcDealt: :desc).first
    @pb_wardsPlaced = Match.where(:profile_id => @match.profile_id, :championId => @match.championId).order(wardsPlaced: :desc).first
    @pb_cs = Match.where(:profile_id => @match.profile_id, :championId => @match.championId).order(cs: :desc).first
    @pb_jungleCs = Match.where(:profile_id => @match.profile_id, :championId => @match.championId).order(jungleCs: :desc).first
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
  end

	def update
	end
end
