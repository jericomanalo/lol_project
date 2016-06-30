class RenameProfilesToSummoners < ActiveRecord::Migration
  def change
    rename_table :profiles, :summoners
  end
end
