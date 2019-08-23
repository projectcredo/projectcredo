require 'nokogiri'
require 'net/http'
require 'uri'
require 'link_thumbnailer'

module Papers

  class Scraper

    def find_urls(content)
      doc = Nokogiri::HTML(content)

      anchors = doc.css('a')
      anchors.pluck(:href).uniq
    end

    def find_papers(urls)
      @paper_urls = AppConfig['paper_urls']
      prefixes = @paper_urls.pluck('prefix')

      urls.select{|h| h && h.start_with?(*prefixes)}.map do |h|
        info = @paper_urls.find{|u| h && h.start_with?(u['prefix'])}.clone
        info['url'] = h
        info['source_id'] = get_paper_id(info)
        info
      end
    end

    def get_paper_id(info)
      id = nil
      if info['regex'] != nil
        match = info['url'].match(Regexp.new(info['regex'], 'i'))
        if match then id, _ = match.captures end
      end
      id
    end

    def load_paper_doi_data(info)
      paper = Paper.find_by(doi: info['source_id'])
      return info.merge(paper.as_json) if paper

      info.merge(Crossref.new.load(info['source_id']).as_json)
    end

    def load_paper_pubmed_data(info)
      paper = Paper.find_by(pubmed_id: info['source_id'])
      return info.merge(paper.as_json) if paper

      info.merge(Pubmed.new.load(info['source_id']).as_json)
    end

    def load_paper_pmc_data(info)
      return info
      # TODO
    end

    def load_paper_url_data(info)
      if (link = Link.find_by(url: info['url']))
        return info.merge(link.paper.as_json) if link.paper
      end

      begin
        info.merge(LinkThumbnailer.generate(info['url']).as_json)
      rescue LinkThumbnailer::Exceptions => e
        Rails.logger.error e.message
        info
      end
    end

    def get_paper_data(info)
      data = info.clone

      case info['type']
      when 'pubmed'; data = data.merge(load_paper_pubmed_data(info))
      when 'doi'; data = data.merge(load_paper_doi_data(info))
      when 'pmc'; data = data.merge(load_paper_pmc_data(info))
      when 'url'; data = data.merge(load_paper_url_data(info))
      else; raise "Paper type #{info['type']} not supported"
      end

      # TODO: get opengraph data to retrieve paper cover image

      data
    end

    def parse_papers(content, add_urls = [])
      urls = find_urls(content)
      urls.concat(add_urls).uniq!
      info = find_papers(urls)

      # TODO: run get_paper_data in parallel, wait for all results

      data = info.map{|u| get_paper_data(u) }.select {|p| p.key?('title') }.uniq{|p| p['title'] }
    end

    def store_papers(papers)
      papers.map do |data|
        next data if data['id'].present?

        paper = Paper.create({
          title: data['title'],
          published_at: data['published_at'],
          abstract: data['abstract'],
          doi: data['type'] == 'doi' ? data['source_id'] : nil,
          pubmed_id: data['type'] == 'pubmed' ? data['source_id'] : nil,
          publication: data['publication'],
          import_source: data['import_source'],
        })
        paper.links.create(url: data['url'])
        data.merge(paper.as_json)
      end
    end

    def scrap_url(url)
      begin
        html = Fetch.fetch(url).body

        object = LinkThumbnailer.generate(url).as_json
        # TODO: fix following:
        # scraper = LinkThumbnailer::Scraper.new(html, URI(url))
        # object = scraper.call.as_json

        papers = parse_papers(html, [url])
        papers = store_papers(papers)
        object[:papers]  = papers.map {|p| p.slice('id', 'title', 'type', 'url', 'source_id')}

        return object
      rescue OpenURI::HTTPError => e
        puts e.inspect
        raise PapersScraperError, 'Could not load the URL'
      end
    end

  end

end
