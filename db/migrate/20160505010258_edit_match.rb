class EditMatch < ActiveRecord::Migration
  def change
  	add_reference :matches, :profile, index: true, foreign_key: true
  end
end
