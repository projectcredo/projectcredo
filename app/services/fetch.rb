require 'rest-client'

class Fetch

  def self.fetch(url)
    response = RestClient.get(url, headers={
      'User-Agent' => 'ProjectCredo (https://www.projectcredo.com/; mailto:accounts@projectcredo.com)',
    })

    response
  end

end
