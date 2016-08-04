class ChangeBlurbToLore < ActiveRecord::Migration
  def change
    rename_column :champions, :blurb, :lore
  end
end
