class LinkPaperLocator
  attr_accessor :locator_id, :paper_title

  def initialize locator_id: , paper_title:
    self.locator_id = locator_id.strip
    self.paper_title = paper_title.strip
  end

  def find_or_import_paper
    if (link = Link.find_by url: locator_id)
      return link.paper
    else
      return Paper.create title: paper_title, links_attributes: [{url: locator_id}]
    end
  end

  def valid?
    !!locator_id.match(URI::regexp(%w(http https)))
  end
end
