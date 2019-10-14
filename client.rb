require_relative "token.rb"
require_relative "request.rb"
require "encrypted_strings"

module Teachbase
  module API
    class Client
      ENCRYPT_KEY_OAUTH_DATA = "secret_key".freeze

      class << self
        attr_reader :versions
      end

      @versions = { endpoint_v1: "https://go.teachbase.ru/endpoint/v1",
                    mobile_v1: "https://go.teachbase.ru/mobile/v1",
                    mobile_v2: "https://go.teachbase.ru/mobile/v2" }.freeze

      attr_reader :token, :api_version

      def initialize(version, oauth_params = {})
        @api_version = choose_version(version)
        oauth_params[:client_id] = ""
        oauth_params[:client_secret] = ""

        unless oauth_client_param?(oauth_params[:client_id], oauth_params[:client_secret])
          raise "Set up 'client_id' and 'client_secret'"
        end

        @token = Teachbase::API::Token.new(version, oauth_params)
      end

      def request(method_name, params = {})
        request = Request.new(method_name, params, self)
      end

      protected

      def oauth_client_param?(client_id, client_secret)
        !([client_id, client_secret].any? { |key| key.nil? || key.empty? })
      end

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
