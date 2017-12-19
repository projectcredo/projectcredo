class DoiPaperLocator
  attr_accessor :locator_id, :errors

  def initialize locator_params={}
    self.locator_id = locator_params[:id].strip
    self.errors = []
  end

  def find_or_import_paper
    existing_paper = Paper.find_by doi: locator_id
    return existing_paper if existing_paper

    resource = Crossref.get_by_doi locator_id
    paper_attributes = resource.paper_attributes

    if paper_attributes
      response = resource.response
      paper = Paper.create paper_attributes

      return nil if paper.errors.any?

      paper.api_import_responses.create(json: JSON.parse(response.body), source_uri: response.uri.to_s)
      return paper
    else
      return nil
    end
  end

  def valid?
    # Stolen from http://blog.crossref.org/2015/08/doi-regular-expressions.html
    is_doi = locator_id.match(/^10.\d{4,9}\/[^\s]+$/)

    errors << "\"#{locator_id}\" does not match DOI format. Ex: \"10.1371/journal.pone.0001897\"" unless is_doi

    is_doi
  end
end
