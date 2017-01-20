class Arxiv
  class Resource
    # defines the respresentation of a single Arxiv paper

    attr_accessor :id, :response, :paper_attributes

    def initialize id
      self.id = id.to_s
      self.response = Arxiv::Http.query(id_list: id).remove_namespaces!

      # check if paper exists
      if response.at('//entry//id')
        self.paper_attributes = map_attributes(mapper, response)
      else
        puts 'Arxiv paper ' + id + ' does not exist!'
      end
    end

    def map_attributes mapper, data
      mapper.inject({}) do |memo, tuple|
        # for every tuple in mapper do the following
        # mapper cannot have nil values
        # otherwise it'll be passed to mapping, i.e. tuple[1]!
        attribute, mapping = tuple[0], tuple[1]
        memo[attribute] = mapping.call(data)
        memo
      end
    end
    
    def mapper
      {
        import_source:      lambda { |data| 'arxiv' },
        title:              lambda { |data| data.xpath('//entry//title').text },
        publication:        lambda { |data| nil },
        doi:                lambda { |data| nil },
        arxiv_id:           lambda { |data| data.xpath('//entry//id').text },
        abstract:           lambda { |data| data.xpath('//entry//summary').text },
        abstract_editable:  lambda { |data| data.xpath('//entry//summary').text },
        published_at:       lambda { |data| data.xpath('//entry//published').text },
        # separate into familyname, givenname
        authors_attributes: lambda do |data|
          authors = data.xpath('//author//name')
          authors.map do |author|
            name_parts = author.text.rpartition(/\s/)
            {
              given_name: name_parts.first,
              family_name: name_parts.last
            }
          end
        end
      }
    end

  end
end
