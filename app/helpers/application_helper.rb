module ApplicationHelper
  def transform_text text
    text.to_s.split(/(?:\n\r?|\r\n?)/).map {|s| autolink "<p>#{h s}</p>"}.join.html_safe
  end

  def autolink text
    text.gsub(URI::regexp(%w(http https))) do |match|
      unescaped_url = CGI.unescapeHTML match
      link_to unescaped_url, unescaped_url
    end
  end
end
