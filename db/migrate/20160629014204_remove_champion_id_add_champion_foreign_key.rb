class RemoveChampionIdAddChampionForeignKey < ActiveRecord::Migration
  def change
    add_reference :matches, :champions
    add_reference :champion_masteries, :champions
  end
end
