module PapersScraperHelper
  require 'nokogiri'

  def findPaperUrls(content)
    doc = Nokogiri::HTML(content)
    prefixes = Settings.paper_urls

    anchors = doc.css('a')
    regex = Regexp.new('^(' + prefixes.map{|p| Regexp.escape(p) }.join('|') + ')', 'i')
    urls = anchors.map {|element| element['href']}.grep(regex)

    urls.uniq
  end


  def parsePapers(content)
    urls = findPaperUrls(content)

    puts urls.inspect
  end
end
