class PaperSearchService

  def searchCrossref(query, exclude)
    data = Api::CrossrefService.new.search(query)
    data = data.map do |i|
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

    data.reject {|i| exclude.include?(i[:doi])}
  end

  def searchPubmed(query, exclude)
    data = Api::PubmedService.new.search(query)
    data = data.map do |i|
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

    data.reject {|i| exclude.include?(i[:pubmed_id])}
  end

  def searchDb(query, exclude, bookmarked_only = false, user = nil)
    query = Paper.where('LOWER(title) LIKE ?', "%#{query.downcase}%").limit(15)
    query = query.where('papers.id NOT IN (?)', Array.wrap(exclude)) unless exclude.empty?

    if bookmarked_only && user
      query = query.joins(:bookmarks).where(:bookmarks => {:user_id => user.id})
    end

    query.map do |i|
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

  def search(query, exclude_papers, bookmarked_only = false, user = nil)
    db = searchDb(query, exclude_papers.pluck(:id), bookmarked_only, user)
    return db.take(10) if bookmarked_only

    crossref = searchCrossref(query, exclude_papers.pluck(:doi).select {|c| c})
    pubmed = searchPubmed(query, exclude_papers.pluck(:pubmed_id).select {|c| c})

    # Filter out duplicate papers
    pubmed = pubmed.select{ |p|
      # No duplicates in database
      db.find{|d| (p[:doi] == d[:doi]) || (p[:pubmed_id].present? && p[:pubmed_id] == d[:pubmed_id])}.nil? and
      # No duplicates in crossreff
      crossref.find{|c| p[:doi] == c[:doi]}.nil?
    }

    # Filter out duplicate papers
    crossref = crossref.select{ |c|
      # No duplicates in database
      db.find{|d| c[:doi] == d[:doi]}.nil?
    }

    db.take(10) + crossref.take(10) + pubmed.take(10)
  end

end