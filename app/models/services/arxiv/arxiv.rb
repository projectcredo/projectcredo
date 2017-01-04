module Arxiv
# wrapper for Arxiv API
# extension on Arxiv gem from scholastica
# made into a module since module level seemed more appropriate
# also to properly extend the Arxiv gem

  attr_accessor :resource

  def initialize locator_id: nil
    self.resource = Arxiv::Resource.new locator_id
  end

  def self.get_uid_from_doi
    # stand in
  end

end