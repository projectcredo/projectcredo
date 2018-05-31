class PaperSearchService

  def searchCrossref(query)
    data = Api::CrossrefService.new.search(query)
    data.map do |i|
      {
        id: nil,
        title: i['title'],
        doi: i['doi'].sub('http://dx.doi.org/', ''),
        pubmed_id: nil,
        score: i['score'],
        year: i['year'],
        source: 'crossref',
      }
    end
  end

  def searchPubmed(query)
    data = Api::PubmedService.new.search(query)
    data.map do |i|
      {
        id: nil,
        title: i[:title],
        doi: i[:doi],
        pubmed_id: i[:pubmed_id],
        score: nil,
        year: i[:year],
        source: 'pubmed',
      }
    end
  end

  def searchDb(query)
    data = Paper.where('title LIKE ?', "%#{query}%").limit(10)
    data.map do |i|
      {
        id: i.id,
        title: i.title,
        doi: i.doi,
        pubmed_id: i.pubmed_id,
        score: nil,
        year: nil,
        source: 'db',
      }
    end
  end

  def search(query)
    crossref = searchCrossref(query)
    db = searchDb(query)
    pubmed = searchPubmed(query)

    crossref + db + pubmed
  end

end