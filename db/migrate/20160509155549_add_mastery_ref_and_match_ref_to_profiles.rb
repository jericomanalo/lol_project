class AddMasteryRefAndMatchRefToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :matches
    add_reference :profiles, :champion_masteries
  end
end
