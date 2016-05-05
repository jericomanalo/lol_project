class AddChampionLevelToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :championLevel, :integer, :limit => 8
  end
end
