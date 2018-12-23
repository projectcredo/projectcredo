class PaperBase < ApplicationRecord
  self.table_name = 'papers'

  validates :title, presence: true

  include HasBookmarks

end
