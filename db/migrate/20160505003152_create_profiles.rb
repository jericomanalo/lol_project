class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :summonerName
      t.integer :summonerId
      t.string :region
      t.string :icon
      t.integer :summonerLevel

      t.timestamps null: false
    end
  end
end
