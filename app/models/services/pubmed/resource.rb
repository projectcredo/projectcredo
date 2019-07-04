class Pubmed
  class Resource
    attr_accessor :id, :response, :paper_attributes

    def initialize id
      self.id = id.to_s
      self.response = Pubmed::Http.efetch(id: id)

      # Pubmed responds with <PubmedArticleSet></PubmedArticleSet> for nonexistent IDs like 123456789987654321
      # Check that the response size is larger than that + the doctype declaration
      if response.body.size > 250
        self.paper_attributes = map_attributes(mapper, Nokogiri::XML(response.body, &:noblanks))
      end
    end

    def map_attributes mapper, data
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
            {given_name: author.css("ForeName").text, family_name: author.css("LastName").text}
          end
        end
      }
    end
  end
end
