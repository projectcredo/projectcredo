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

  def self.get(identifier, enable_raw: false)
    id = parse_arxiv_identifier(identifier)

    unless id =~ ID_FORMAT || id =~ LEGACY_ID_FORMAT
      raise Arxiv::Error::MalformedId, "Manuscript ID format is invalid"
    end

    url = ::URI.parse("http://export.arxiv.org/api/query?id_list=#{id}")
    response = ::Nokogiri::XML(open(url)).remove_namespaces!
    # the title check needs to be done before .parse since HappyMapper
    # requires the .title element to exist
    title_exists = response
    raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if !response.at('//title')?
    manuscript = Arxiv::Manuscript.parse(response.to_s, single: id)
    
    if enable_raw
      manuscript.raw_response = response
    end

    # raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if manuscript.title.nil?
    manuscript
  end

end