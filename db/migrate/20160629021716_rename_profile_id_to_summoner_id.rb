class RenameProfileIdToSummonerId < ActiveRecord::Migration
  def change
    remove_reference :matches, :profiles
    remove_reference :champion_masteries, :profiles
  end
end
