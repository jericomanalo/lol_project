class ChangeByteLimit < ActiveRecord::Migration
  def change
  	change_table :matches do |t|
    t.change  :matchId, :integer, :limit => 8
    t.change  :summonerId, :integer, :limit => 8
    t.change  :kills, :integer, :limit => 8
    t.change  :deaths, :integer, :limit => 8
    t.change  :assists, :integer, :limit => 8
    t.change  :goldEarned, :integer, :limit => 8
    t.change  :summonerSpell1, :integer, :limit => 8
    t.change  :summonerSpell2, :integer, :limit => 8
    t.change  :item1, :integer, :limit => 8
    t.change  :item2, :integer, :limit => 8
    t.change  :item3, :integer, :limit => 8
    t.change  :item4, :integer, :limit => 8
    t.change  :item5, :integer, :limit => 8
    t.change  :item6, :integer, :limit => 8
    t.change  :mastery, :integer, :limit => 8
    t.change  :cs, :integer, :limit => 8
    t.change  :jungleCs, :integer, :limit => 8
    t.change  :totalDamage, :integer, :limit => 8
    t.change  :totalHeal, :integer, :limit => 8
    t.change  :totalCcDealt, :integer, :limit => 8
    t.change  :magicDamage, :integer, :limit => 8
    t.change  :physicalDamage, :integer, :limit => 8
    t.change  :damageTaken, :integer, :limit => 8
    t.change  :wardsPlaced, :integer, :limit => 8
    t.change  :doubleKills, :integer, :limit => 8
    t.change  :tripleKills, :integer, :limit => 8
    t.change  :quadraKills, :integer, :limit => 8
    t.change  :pentaKills, :integer, :limit => 8
  	end
  end
end

