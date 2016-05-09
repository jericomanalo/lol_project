class RemoveRefsFromProfiles < ActiveRecord::Migration
  def change
    remove_reference :profiles, :champion_masteries
    remove_reference :profiles, :matches
  end
end
