module PapersScraperHelper
  require 'nokogiri'
  require 'net/http'
  require 'uri'

  def fetch(url, limit = 10)
    # TODO: create a shared network service for this code to use in other places
    endpoint = URI.parse(url)
    http = Net::HTTP.new(endpoint.host, endpoint.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(endpoint.request_uri)
    request['User-Agent'] = 'ProjectCredo (https://www.projectcredo.com/; mailto:accounts@projectcredo.com)'
    response = http.request(request)

    # Check fo redirects
    case response
    when Net::HTTPSuccess then response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else
      response.error!
    end
  end

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

  def load_paper_pubmed_data(info)
    paper = PubmedPaperLocator.new({id: info['source_id']}).find_or_import_paper.as_json
  end

  def load_paper_pmc_data(info)
    return info
    # TODO
    paper = PubmedPaperLocator.new({id: info['source_id']}).find_or_import_paper.as_json
  end

  def load_paper_doi_data(info)
    paper = DoiPaperLocator.new({id: info['source_id']}).find_or_import_paper.as_json
  end

  def load_paper_url_data(info)
    paper = LinkPaperLocator.new({id: info['url']}).find_or_import_paper.as_json
  end

  def get_paper_data(info)
    data = info.clone

    case info['type']
    when 'pubmed'
      data = data.merge(load_paper_pubmed_data(info))
    when 'doi'
      data = data.merge(load_paper_doi_data(info))
    when 'pmc'
      data = data.merge(load_paper_pmc_data(info))
    when 'url'
      data = data.merge(load_paper_url_data(info))
    else
      raise "Paper type #{info['type']} not supported"
    end

    data
  end

  def parse_papers(content, add_urls = [])
    urls = find_urls(content)
    urls.concat(add_urls).uniq!
    info = find_papers(urls)

    data = info.map{|u| get_paper_data(u) }.select {|p| p.key?('id') || p.key?(:id) }
  end
end
