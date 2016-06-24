class ChangeHighestGradeToTokensEarned < ActiveRecord::Migration
  def change
    remove_column :champion_masteries, :highestGrade
    add_column :champion_masteries, :tokensEarned, :int
    add_column :champion_masteries, :chestGranted, :string
  end
end
