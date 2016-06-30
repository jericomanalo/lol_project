class ChangeProfilesReferenceToSummoners < ActiveRecord::Migration
  def change
    rename_column :champion_masteries, :profile_id, :summoners_id
    rename_column :matches, :profile_id, :summoner_ids
    add_reference :users, :summoners
  end
end
