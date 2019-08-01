module Papers

  class Pubmed

    attr_accessor :id, :response

    def load(id)
      self.id = id.to_s
      self.response = efetch(id: id)

      # Pubmed responds with <PubmedArticleSet></PubmedArticleSet> for nonexistent IDs like 123456789987654321
      # Check that the response size is larger than that + the doctype declaration
      if response.body.size > 250
        map_attributes(mapper, Nokogiri::XML(response.body, &:noblanks))
      end
    end

    def get_uid_from_doi(doi)
      response = esearch(term: "\"#{doi}\"")
      data = Nokogiri::XML(response.body)
      doi_not_found = data.css("QuotedPhraseNotFound").present?

      return nil if doi_not_found

      data.xpath('//IdList/Id').first.try(:text)
    end

    def map_attributes(mapper, data)
      mapper.inject({}) do |memo, _|
        attribute, mapping = _[0], _[1]
        memo[attribute] = mapping.call(data)
        memo
      end
    end

    def mapper
      {
          import_source:      lambda {|data| 'pubmed' },
          title:              lambda {|data| data.css('ArticleTitle').text },
          publication:        lambda {|data| data.css('Article Title').text },
          doi:                lambda {|data| data.css('PubmedData > ArticleIdList > ArticleId[IdType=doi]').text },
          pubmed_id:          lambda {|data| data.css('PubmedData > ArticleIdList > ArticleId[IdType=pubmed]').text },
          abstract:           lambda do |data|
            data.css('AbstractText').map do |a|
              if a['Label'] then "#{a['Label']}\n#{a.text}" else a.text end
            end.join("\n\n")
          end,
          abstract_editable:  lambda {|data| data.css('AbstractText').blank? },
          published_at:       lambda do |data|
            if (date_parts = data.css('PubDate').children)
              year, month, day = ['Year','Month','Day'].map {|c| date_parts.css(c).text.presence}

              return nil unless year

              date = "#{year}/#{month || 1}/#{day || 1}"
              Date.parse(date)
            end
          end,
          authors_attributes: lambda do |data|
            authors = data.css('AuthorList Author')
            authors.map do |author|
              {given_name: author.css('ForeName').text, family_name: author.css('LastName').text}
            end
          end
      }
    end

    def eutils_params
      {
          db: 'pubmed',
          retmode: 'xml',
          retmax: 2,
          api_key: ENV['PUBMED_API_KEY'],
      }
    end

    def id_params
      {
          tool: 'projectcredo',
          email: 'accounts@projectcredo.com',
      }
    end

    def default_params
      id_params.merge eutils_params
    end

    def esearch params = {}
      get_response "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi", params
    end

    def esummary params = {}
      get_response "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi", params
    end

    def efetch params = {}
      get_response "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi", params
    end

    def get_response(url, params)
      Fetch.fetch(url + "?" + URI.encode_www_form(default_params.merge params))
    end
  end

end