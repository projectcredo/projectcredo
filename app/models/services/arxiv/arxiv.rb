class Arxiv
  attr_accessor :resource

  def initialize locator_id: nil
    self.resource = Arxiv::Resource.new locator_id
  end

  def self.get_arxiv_from_doi
    # stand in
  end
end