class ChangeWinToString < ActiveRecord::Migration
  def change
  	change_column :matches, :win, :string
  end
end
