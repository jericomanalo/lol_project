class CreateChamps < ActiveRecord::Migration
  def change
    create_table :champs do |t|
      t.references :champion, index: true, foreign_key: true
      t.references :match, index: true, foreign_key: true
      t.references :champion_mastery, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
