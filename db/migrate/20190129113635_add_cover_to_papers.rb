class AddCoverToPapers < ActiveRecord::Migration[5.0]
  def up
    add_attachment :papers, :cover
  end

  def down
    remove_attachment :papers, :cover
  end
end
