module Arxiv
  class Http
    # API http response object wrapper

    # needs refactoring in the future to not repeat what pubmed::resource has
    def self.query params = {}
      get_response "http://export.arxiv.org/api/query?id_list=", params
    end

    def self.get_response(url, params)
      uri = URI.parse(url + params)
      ::Nokogiri::XML(open(url))
    end

    def self.get_with_raw(identifier, parse, get_raw)
      puts 'we using the new stuff now'
      id = parse(identifier)

      unless id =~ ID_FORMAT || id =~ LEGACY_ID_FORMAT
        raise Arxiv::Error::MalformedId, "Manuscript ID format is invalid"
      end

      url = ::URI.parse("http://export.arxiv.org/api/query?id_list=#{id}")
      response = ::Nokogiri::XML(open(url)).remove_namespaces!
      # the title check needs to be done before .parse since HappyMapper
      # requires the .title element to exist
      title_exists = response.at('//title')
      raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if !title_exists?
      manuscript = Arxiv::Manuscript.parse(response.to_s, single: id)

      if enable_raw
        manuscript.raw_response = response
      end

      # raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if manuscript.title.nil?
      manuscript
    end

  end
end