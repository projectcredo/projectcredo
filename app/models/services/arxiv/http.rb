class Arxiv
  class Http
    # API http response object wrapper

    def self.query params = {}
      get_response "http://export.arxiv.org/api/query", params
    end

    def self.get_response(url, params)
      uri = URI.parse(url + "?" + URI.encode_www_form(params))
      response = Net::HTTP.get_response(uri)
      xml_response = Nokogiri::XML(response.body)
      return xml_response
    end

  end
end