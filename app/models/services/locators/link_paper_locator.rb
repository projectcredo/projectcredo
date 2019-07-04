require 'link_thumbnailer'

class LinkPaperLocator
  attr_accessor :locator_id, :paper_title, :errors

  def initialize locator_params={}
    self.locator_id = locator_params[:id].strip
    self.paper_title = locator_params[:title]
    self.errors = []
  end

  def find_or_import_paper
    if (link = Link.find_by url: locator_id)
      return link.paper
    else
      if self.paper_title.blank?
        data = LinkThumbnailer.generate(locator_id).as_json
        self.paper_title = data[:title]
      end

      return Paper.create title: self.paper_title, import_source: 'url', links_attributes: [{url: locator_id}]
    end
  end

  def valid?
    is_url = !!locator_id.match(URI::regexp(%w(http https)))
    title_present = paper_title.present?

    errors << 'You must enter a title.' unless title_present
    errors << "\"#{locator_id}\" does not match URL format. Ex: \"http://example.org/article\"." unless is_url

    is_url && title_present
  end
end
