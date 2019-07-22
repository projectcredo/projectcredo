class Fetch

  def self.fetch(url, limit = 10)
    endpoint = URI.parse(url)
    pp endpoint
    http = Net::HTTP.new(endpoint.host, endpoint.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(endpoint.request_uri)
    request['User-Agent'] = 'ProjectCredo (https://www.projectcredo.com/; mailto:accounts@projectcredo.com)'
    response = http.request(request)

    # Check fo redirects
    case response
    when Net::HTTPSuccess then response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else
      response.error!
    end
  end

end
