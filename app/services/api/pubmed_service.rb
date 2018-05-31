module Api
  class PubmedService

    def request(uri, params)
      endpoint = URI.parse("https://#{uri}?#{params.to_query}")
      Rails.logger.debug endpoint.inspect
      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(endpoint.request_uri)
      request['User-Agent'] = 'ProjectCredo (https://www.projectcredo.com/; mailto:accounts@projectcredo.com)'
      http.request(request)
    end

    def getAtriclesByIds(ids)
      response = request('eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi', {
        db: 'pubmed', id: ids.join(','), format: 'xml'
      })
      xml = Nokogiri::XML(response.body)
      xml.css('PubmedArticle').map do |x|
        {
          title: x.css('ArticleTitle').text,
          year: x.css('PubDate Year').text,
          publication: x.css('Journal Title').text,
          doi: x.css('ArticleId[IdType=doi]').text,
          pubmed_id: x.css('ArticleId[IdType=pubmed]').text,
          abstract: x.css('AbstractText').text,
          published_at: parseDate(x),
          authors: x.css('AuthorList Author').map do |author|
            {first_name: author.css("ForeName").text, last_name: author.css("LastName").text}
          end,
          keywords: x.css('KeywordList Keyword').map {|k| k.text}
        }
      end
    end

    def search(query)
      response = request('eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi', {
        db: 'pubmed', retmode: 'json', retmax: 10, term: query
      })
      data = JSON.parse response.body

      ids = data['esearchresult'].try(:[], 'idlist')
      return [] if not ids.kind_of?(Array) or ids.empty?

      getAtriclesByIds(ids)
    end

    private
      def parseDate(xml)
        if (date_parts = xml.css('PubDate').children)
          year, month, day = ['Year','Month','Day'].map {|c| date_parts.css(c).text.presence}

          return nil unless year

          date = "#{year}/#{month || 1}/#{day || 1}"
          Date.parse(date)
        end
      end

  end
end