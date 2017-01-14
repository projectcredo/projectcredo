module Arxiv
  class Http
    # API http response object wrapper

    # LEGACY_URL_FORMAT = /[^\/]+\/\d+(?:v\d+)?$/
    # CURRENT_URL_FORMAT = /\d{4,}\.\d{4,}(?:v\d+)?$/

    # LEGACY_ID_FORMAT = /^#{LEGACY_URL_FORMAT}/
    # ID_FORMAT = /^#{CURRENT_URL_FORMAT}/

    def self.query params = {}
      get_response "http://export.arxiv.org/api/query", params
    end

    def self.get_response(url, params)
      uri = URI.parse(url + "?" + URI.encode_www_form(params))
      response = Net::HTTP.get_response(uri)
      xml_response = Nokogiri::XML(response.body)
      return xml_response
    end

    # def self.get_with_raw(identifier, parse, get_raw)
    #   puts 'we using the new stuff now'
    #   id = parse(identifier)

    #   unless id =~ ID_FORMAT || id =~ LEGACY_ID_FORMAT
    #     raise Arxiv::Error::MalformedId, "Manuscript ID format is invalid"
    #   end

    #   url = ::URI.parse("http://export.arxiv.org/api/query?id_list=#{id}")
    #   response = ::Nokogiri::XML(open(url)).remove_namespaces!
    #   # the title check needs to be done before .parse since HappyMapper
    #   # requires the .title element to exist
    #   title_exists = response.at('//title')
    #   raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if !title_exists?
    #   manuscript = Arxiv::Manuscript.parse(response.to_s, single: id)

    #   if enable_raw
    #     manuscript.raw_response = response
    #   end

    #   # raise Arxiv::Error::ManuscriptNotFound, "Manuscript #{id} doesn't exist on arXiv" if manuscript.title.nil?
    #   manuscript
    # end

  end
end