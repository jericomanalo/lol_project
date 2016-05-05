class CreateChampionMasteries < ActiveRecord::Migration
  def change
    create_table :champion_masteries do |t|
      t.references :profile, index: true, foreign_key: true
      t.integer :championId
      t.integer :championPointsSinceLastLevel
      t.integer :championPointsUntilNextLevel
      t.string :highestGrade
      t.integer :championLevel
      t.integer :lastPlayTime

      t.timestamps null: false
    end
  end
end
