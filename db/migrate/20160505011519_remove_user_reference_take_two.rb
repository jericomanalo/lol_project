class RemoveUserReferenceTakeTwo < ActiveRecord::Migration
  def change
  	remove_reference :matches, :user
  end
end
