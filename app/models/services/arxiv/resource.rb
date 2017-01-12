module Arxiv
  class Resource < Arxiv::Manuscript
    # defines the respresentation of a single Arxiv paper

    attr_accessor :id, :response, :paper_attributes

    def initialize id
      self.id = id.to_s
      self.response = Arxiv::Http.get_response(id)

      # if id not found Arxiv::Error::ManuscriptNotFound is thrown
      # if id is malformed Arxiv::Error::MalformedId is thrown
      # obvious comment is obvious, obvious error name is obvious
      title_exists = response.at('//title')
      if title_exists
        self.paper_attributes = map_attributes(mapper, response.remove_namespaces!)
      end
    end

    def map_attributes mapper, data
      mapper.inject({}) do |memo, _|
        attribute, mapping = _[0], _[1]
        memo[attribute] = mapping.call(data)
        memo
      end
    end

    # LEGACY_URL_FORMAT = /[^\/]+\/\d+(?:v\d+)?$/
    # CURRENT_URL_FORMAT = /\d{4,}\.\d{4,}(?:v\d+)?$/

    # LEGACY_ID_FORMAT = /^#{LEGACY_URL_FORMAT}/
    # ID_FORMAT = /^#{CURRENT_URL_FORMAT}/

    def mapper
      {
        import_source:      lambda { |data| 'arxiv' },
        title:              data.title,
        publication:        lambda { |data| nil },
        doi:                nil,
        arxiv_id:           lambda { |data| data.arxiv_id },
        abstract:           lambda { |data| data.abstract },
        abstract_editable:  lambda { |data| data.abstract },
        published_at:       lambda { |data| data.created_at },
        # separate into familyname, givenname
        authors_attributes: lambda { |data| data.authors }
      }
    end
  end
end
