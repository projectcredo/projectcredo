require 'net/http'

module Auth
  class Facebook
    FACEBOOK_URL = 'https://graph.facebook.com/v3.0/'
    FACEBOOK_USER_FIELDS = 'id,email,name,first_name,last_name,picture.width(1024).height(1024)'

    def initialize(access_token)
      @access_token = access_token
    end

    def user_data
      @user_data ||= begin
        response = Net::HTTP.get_response(request_uri)
        JSON.parse(response.body)
      end
    end

    def request_uri
      URI.parse("#{FACEBOOK_URL}me?access_token=#{@access_token}&fields=#{FACEBOOK_USER_FIELDS}")
    end
  end
end
