class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.integer :championId
      t.string :name
      t.string :title
      t.string :icon
      t.string :splash

      t.timestamps null: false
    end
  end
end
