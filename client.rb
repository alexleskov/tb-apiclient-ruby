require_relative 'token.rb'
require_relative 'request.rb'

module Teachbase
  module API
    class Client
      BASE_API_URL = 'https://go.teachbase.ru/endpoint/v1'.freeze

      attr_reader :token

      def initialize
        @token = Teachbase::API::Token.new
      end

      def request(method_name, params = {})
        request = Request.new(params, access_token = token.value)
        request.public_send(method_name) if request.respond_to? method_name
      end
    end
  end
end
