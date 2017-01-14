module Arxiv
  class Resource
    # defines the respresentation of a single Arxiv paper

    attr_accessor :id, :response, :paper_attributes

    def initialize id
      self.id = id.to_s
      self.response = Arxiv::Http.query(id_list: id).remove_namespaces!

      # if id not found Arxiv::Error::ManuscriptNotFound is thrown
      # if id is malformed Arxiv::Error::MalformedId is thrown
      # obvious comment is obvious, obvious error name is obvious
      title_exists = response.xpath('//title')
      if title_exists
        puts title_exists
        self.paper_attributes = map_attributes(mapper, response)
      else
        puts 'Arxiv paper ' + id + ' does not exist!'
      end
    end

    def map_attributes mapper, data
      mapper.inject({}) do |memo, tuple|
        # for every tuple in mapper do the following
        # nil values cannot be passed to mapping, i.e. tuple[1]!
        attribute, mapping = tuple[0], tuple[1]
        memo[attribute] = mapping.call(data)
        memo
      end
    end
    
    def mapper
      {
        import_source:      lambda { |data| 'arxiv' },
        title:              lambda { |data| data.xpath('//title') },
        publication:        lambda { |data| nil },
        doi:                lambda { |data| nil },
        arxiv_id:           lambda { |data| data.xpath('arxiv_id') },
        abstract:           lambda { |data| data.xpath('abstract') },
        abstract_editable:  lambda { |data| data.xpath('abstract') },
        published_at:       lambda { |data| data.xpath('created_at') },
        # separate into familyname, givenname
        authors_attributes: lambda { |data| data.xpath('authors') }
      }
    end
  end
end
