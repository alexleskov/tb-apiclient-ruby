require_relative "token.rb"
require_relative "request.rb"


module Teachbase
  module API
    class Client

      class << self
        attr_reader :versions, :endpoints
      end

      @versions = {endpoint_v1: "https://go.teachbase.ru/endpoint/v1",
                   mobile_v1: "https://go.teachbase.ru/mobile/v1",
                   mobile_v2: "https://go.teachbase.ru/mobile/v2"}.freeze

      @endpoints = { "users" => User } # TODO: "clickmeeting_meetings" => Clickmeeting_meeting

      attr_reader :token, :api_version

      def initialize(version)
        @token = Teachbase::API::Token.new
        @api_version = choose_version(version)
      end

      def request(method_name, params = {})
        request = Request.new(method_name, params, self) #token, api_version)
      end

      protected

      def choose_version(version)
        if !self.class.versions.key?(version.to_sym)
          raise "API version '#{version}' not exists.\nAvaliable: #{self.class.versions.keys}"
        else
          self.class.versions[version.to_sym]
        end
      end
    end
  end
end
