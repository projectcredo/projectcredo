module ApplicationHelper
  def wrap_on_line_breaks text
    text.to_s.split(/(?:\n\r?|\r\n?)/).map do |s|
      auto_link("<p>#{h s}</p>", :html => { :target => '_blank' })
    end.join.html_safe
  end

  def autolink text
    text.gsub(URI::regexp(%w(http https))) do |match|
      unescaped_url = CGI.unescapeHTML match
      link_to unescaped_url, unescaped_url
    end
  end
end
