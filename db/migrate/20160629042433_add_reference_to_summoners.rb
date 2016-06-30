class AddReferenceToSummoners < ActiveRecord::Migration
  def change
    add_reference :users, :summoner, index: true
    add_reference :matches, :champion, index: true
    add_reference :champion_masteries, :champion, index: true
    remove_column :matches, :championId
    remove_column :champion_masteries, :championId
  end
end
