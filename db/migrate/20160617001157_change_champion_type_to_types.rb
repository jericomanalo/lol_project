class ChangeChampionTypeToTypes < ActiveRecord::Migration
  def change
    remove_column :champions, :type
    add_column :champions, :tag, :string
  end
end
