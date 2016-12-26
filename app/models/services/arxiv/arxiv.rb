class Arxiv
# wrapper for Arxiv API
# to use arxiv gem
  attr_accessor :resource

  def initialize locator_id: nil
    self.resource = ProjectCredoArxiv
end