module Api
  class CrossrefService

    def request(uri, params)
      endpoint = URI.parse("https://#{uri}?#{params.to_query}")
      Rails.logger.debug endpoint.inspect
      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(endpoint.request_uri)
      request['User-Agent'] = 'ProjectCredo (https://www.projectcredo.com/; mailto:accounts@projectcredo.com)'
      http.request(request)
    end

    def search(query, limit = 15)
      response = request('search.crossref.org/dois', {sort: 'score', type: 'Journal Article', rows: limit, q: query})
      JSON.parse response.body
    end

  end
end
