class AddMdScoreToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :mdScore, :integer
  end
end
