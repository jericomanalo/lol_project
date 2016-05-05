class EditMatch < ActiveRecord::Migration
  def change
  	remove_foreign_key :matches, name: "index_matches_on_user_id"
  	add_reference :matches, :profile, index: true, foreign_key: true
  end
end
