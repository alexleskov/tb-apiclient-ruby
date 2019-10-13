require_relative "token.rb"
require_relative "request.rb"
require "encrypted_strings"

module Teachbase
  module API
    class Client
      class << self
        attr_reader :versions, :endpoints
      end

      @versions = { endpoint_v1: "https://go.teachbase.ru/endpoint/v1",
                    mobile_v1: "https://go.teachbase.ru/mobile/v1",
                    mobile_v2: "https://go.teachbase.ru/mobile/v2" }.freeze

      @endpoints = { "users" => User, "profile" => Profile } # TODO: "clickmeeting-meetings" => ClickmeetingMeeting

      attr_reader :token, :api_version

      def initialize(version, oauth_params = {})
        @api_version = choose_version(version)
        @token = Teachbase::API::Token.new(version, oauth_params)
      end

      def request(method_name, params = { headers: {} })
        request = Request.new(method_name, params, self)
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
