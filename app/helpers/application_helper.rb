module ApplicationHelper
  def transform_text text, highlights: []
    text = html_escape text
    highlights.each do |highlight|
      highlight = html_escape highlight
      text.sub!(highlight, "<mark>#{highlight}</mark>")
    end
    text = paragraphize text
    text = autolink text
    text.html_safe
  end

  def autolink text
    text.gsub(URI::regexp(%w(http https))) do |match|
      unescaped_url = CGI.unescapeHTML match
      link_to unescaped_url, unescaped_url
    end
  end

  def paragraphize text
    text.to_s.split(/(?:\n\r?|\r\n?)/).map {|s| "<p>#{s}</p>"}.join
  end
end
