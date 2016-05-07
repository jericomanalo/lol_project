class AddTimestampToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :timestamp, :integer, :limit => 8
  end
end
