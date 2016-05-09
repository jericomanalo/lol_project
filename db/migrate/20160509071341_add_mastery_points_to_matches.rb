class AddMasteryPointsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :masteryPoints, :integer
  end
end
