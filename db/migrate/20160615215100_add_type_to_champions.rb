class AddTypeToChampions < ActiveRecord::Migration
  def change
    add_column :champions, :type, :string
  end
end
