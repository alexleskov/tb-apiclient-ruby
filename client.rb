require_relative "token.rb"
require_relative "request.rb"
require_relative "user.rb"

module Teachbase
  module API
    class Client
      BASE_API_URL = "https://go.teachbase.ru/endpoint/v1".freeze
      MOBILE_V1_API_URL = "https://go.teachbase.ru/mobile/v1/".freeze
      MOBILE_V2_API_URL = "https://go.teachbase.ru/mobile/v2/".freeze

      attr_reader :token, :api_version

      def initialize(version)
        @token = Teachbase::API::Token.new
        @api_version = choose_version(version)
      end

      def request(method_name, params = {})
        request = Request.new(method_name, params, access_token = token, api_version)
      end

      def choose_version(version)
        case version
        when :endpoint_v1
          BASE_API_URL
        when :mobile_v1
          MOBILE_V1_API_URL
        when :mobile_v2
          MOBILE_V2_API_URL
        end
      end
    end
  end
end
