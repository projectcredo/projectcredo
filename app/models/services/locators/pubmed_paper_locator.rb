class PubmedPaperLocator
  attr_accessor :locator_id, :errors

  def initialize locator_params={}
    self.locator_id = locator_params[:id].strip
    self.errors = []
  end

  def find_or_import_paper
    existing_paper = Paper.find_by pubmed_id: locator_id
    return existing_paper if existing_paper

    pubmed = Pubmed.new locator_id: locator_id
    paper_attributes = pubmed.resource.paper_attributes

    if paper_attributes
      response = pubmed.resource.response
      paper = Paper.create paper_attributes
      paper.api_import_responses.create(xml: response.body, source_uri: response.uri.to_s)
      return paper
    else
      return nil
    end
  end

  def valid?
    only_numbers = !!locator_id.match(/^[0-9]+$/)

    errors << "\"#{locator_id}\" does not match Pubmed ID format. Ex: \"18365029\"" unless only_numbers

    only_numbers
  end
end
