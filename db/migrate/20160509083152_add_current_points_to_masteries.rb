class AddCurrentPointsToMasteries < ActiveRecord::Migration
  def change
    add_column :champion_masteries, :current_points, :integer
  end
end
