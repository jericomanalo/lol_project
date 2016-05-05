class EditUsersTable < ActiveRecord::Migration
  def change
  	remove_column :users, :summonerName, :string
  	remove_column :users, :summonerId, :integer
  	remove_column :users, :region, :string
  	add_reference :users, :profile, index: true, foreign_key: true
  end
end
