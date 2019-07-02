module PapersScraperHelper
  require 'nokogiri'

  def parsePaperUrls(content)
    doc = Nokogiri::HTML(content)
    paper_urls = AppConfig['paper_urls']
    prefixes = paper_urls.pluck('prefix')

    anchors = doc.css('a')
    urls = anchors.
      pluck(:href).
      uniq.
      select{|h| h.start_with?(*prefixes) }.
      map do |h|
        info = paper_urls.find{|u| h.start_with?(u['prefix'])}.clone
        info['url'] = h
        info['source_id'] = getPaperId(info)
        info
      end
  end

  def getPaperId(info)
    id = nil
    if (info['regex'] != nil)
      match = info['url'].match(Regexp.new(info['regex'], 'i'))
      if match then id, _ = match.captures end
    end
    id
  end

  def loadPaperPubmedData(info)
    paper = PubmedPaperLocator.new({id: info['source_id']}).find_or_import_paper.as_json
  end

  def loadPaperDoiData(info)
    paper = DoiPaperLocator.new({id: info['source_id']}).find_or_import_paper.as_json
  end

  def loadPaperUrlData(info)
    paper = LinkPaperLocator.new({id: info['url']}).find_or_import_paper.as_json
  end

  def getPaperData(info)
    data = info.clone
    if (info['source_id'])
      case info['type']
      when 'pubmed'
        data = data.merge(loadPaperPubmedData(info))
      when 'doi'
        data = data.merge(loadPaperDoiData(info))
      when 'url'
        data = data.merge(loadPaperUrlData(info))
      end
    end

    data
  end

  def parsePapers(content)
    urls = parsePaperUrls(content)

    data = urls.map{|u| getPaperData(u)}
    data
  end
end
