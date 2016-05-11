class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :matchId
      t.integer :summonerId
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :goldEarned
      t.integer :summonerSpell1
      t.integer :summonerSpell2
      t.integer :item1
      t.integer :item2
      t.integer :item3
      t.integer :item4
      t.integer :item5
      t.integer :item6
      t.integer :mastery
      t.integer :cs
      t.integer :jungleCs
      t.integer :totalDamage
      t.integer :totalHeal
      t.integer :totalCcDealt
      t.integer :magicDamage
      t.integer :physicalDamage
      t.integer :damageTaken
      t.integer :wardsPlaced
      t.integer :doubleKills
      t.integer :tripleKills
      t.integer :quadraKills
      t.integer :pentaKills
      t.boolean :win

      t.timestamps null: false
    end
  end
end
