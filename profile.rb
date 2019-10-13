require "json"
require "rest-client"

module Teachbase
  module API
    class Profile
      attr_reader :request, :answer

      def initialize(request)
        raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

        @request = request
      end

      def profile
        r = RestClient.get request.request_url, params: request.url_params.merge!("access_token" => request.client.token.value), 'X-Account-Id': request.request_headers["X-Account-Id"].to_s
        @answer = JSON.parse(r.body)
        request.receive_response(self)
      rescue RestClient::ExceptionWithResponse => e
        case e.http_code
        when 301, 302, 307
          e.response.follow_redirection
        else
          raise
        end
      end
    end
  end
end
