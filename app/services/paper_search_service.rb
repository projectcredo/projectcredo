class PaperSearchService

  def searchCrossref(query)
    data = Api::CrossrefService.new.search(query)
    data.map do |i|
      {
        id: nil,
        title: i['title'],
        abstract: nil,
        doi: i['doi'].sub('http://dx.doi.org/', ''),
        pubmed_id: nil,
        score: i['score'],
        year: i['year'],
        source: 'crossref',
        authors: [],
        tags: [],
        bookmarked: false,
      }
    end
  end

  def searchPubmed(query)
    data = Api::PubmedService.new.search(query)
    data.map do |i|
      {
        id: nil,
        title: i[:title],
        abstract: i[:abstract],
        doi: i[:doi],
        pubmed_id: i[:pubmed_id],
        score: nil,
        year: i[:year],
        source: 'pubmed',
        authors: i[:authors],
        tags: [],
        bookmarked: false,
      }
    end
  end

  def searchDb(query)
    data = Paper.where('LOWER(title) LIKE ?', "%#{query.downcase}%").limit(10)
    data.map do |i|
      {
        id: i.id,
        title: i.title,
        abstract: i.abstract,
        doi: i.doi,
        pubmed_id: i.pubmed_id,
        score: nil,
        year: nil,
        source: 'db',
        authors: i.authors.map{|a| a.title},
        tags: i.tags.map{|t| t.name},
        bookmarked: Thread.current[:current_user] && i.bookmarked?(user: Thread.current[:current_user])
      }
    end
  end

  def search(query)
    db = searchDb(query)
    crossref = searchCrossref(query)
    pubmed = searchPubmed(query)

    # Filter out duplicate papers
    pubmed = pubmed.select{ |p|
      # No duplicates in database
      db.find{|d| (p[:doi] == d[:doi]) or (p[:pubmed_id].present? and p[:pubmed_id] == d[:pubmed_id])}.nil? and
      # No duplicates in crossreff
      crossref.find{|c| p[:doi] == c[:doi]}.nil?
    }

    # Filter out duplicate papers
    crossref = crossref.select{ |c|
      # No duplicates in database
      db.find{|d| c[:doi] == d[:doi]}.nil?
    }

    puts db.to_yaml

    db + crossref + pubmed
  end

end