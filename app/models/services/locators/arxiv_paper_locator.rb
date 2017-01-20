class ArxivPaperLocator
  attr_accessor :locator_id, :errors

  def initialize locator_params={}
    self.locator_id = locator_params[:id].strip
    self.errors = []
  end

  def find_or_import_paper
    existing_paper = Paper.find_by arxiv_id: locator_id
    return existing_paper if existing_paper

    arxiv = Arxiv.new locator_id: locator_id
    paper_attributes = arxiv.resource.paper_attributes

    if paper_attributes
      response = arxiv.resource.response
      paper = Paper.create paper_attributes
      paper.api_import_responses.create(xml: response.body, source_uri: response.uri.to_s)
      return nil if paper.errors.any?
      return paper
    else
      return nil
    end
  end

  def valid?

    # regex taken from Arxiv gem

    # LEGACY_URL_FORMAT = /[^\/]+\/\d+(?:v\d+)?$/
    # CURRENT_URL_FORMAT = /\d{4,}\.\d{4,}(?:v\d+)?$/
    
    arxiv_format = !!locator_id.match(/\d{4,}\.\d{4,}(?:v\d+)?$/)

    errors << "\"#{locator_id}\" does not match Arxiv ID format. Ex: \"1836.5029v2\"" unless arxiv_format

    arxiv_format
  end

end
