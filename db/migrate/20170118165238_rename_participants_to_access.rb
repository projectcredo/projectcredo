class RenameParticipantsToAccess < ActiveRecord::Migration[5.0]
  def change
    change_table :lists do |t|
      t.rename :participants, :access
    end
  end
end
