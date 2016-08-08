class MatchesController < ApplicationController
  def create
    Md.create_match(params[:summonerId], params[:championId], params[:region], params[:summonerName], params[:id])
    redirect_to controller: "summoners", action: "show_graph", id: params[:id], championId: params[:championId]
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
  end

	def update
	end
end
