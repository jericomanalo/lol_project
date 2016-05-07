class AddChampionIdToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :championId, :integer
  end
end
