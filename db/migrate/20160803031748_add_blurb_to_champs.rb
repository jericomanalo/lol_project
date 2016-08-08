class AddBlurbToChamps < ActiveRecord::Migration
  def change
    add_column :champions, :blurb, :text
  end
end
