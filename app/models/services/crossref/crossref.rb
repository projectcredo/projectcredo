class Crossref
  def self.get_by_doi(doi)
    Crossref::Resource.new doi
  end
end
