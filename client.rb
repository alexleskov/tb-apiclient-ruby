require './lib/token'
require './lib/request'
require './lib/app_configurator'

require "json"
require "rest-client"

module Teachbase
  module API
    class Client

      class << self
        attr_reader :versions
      end

      @versions = { endpoint_v1: "https://go.teachbase.ru/endpoint/v1",
                    mobile_v1: "https://go.teachbase.ru/mobile/v1",
                    mobile_v2: "https://go.teachbase.ru/mobile/v2" }.freeze

      attr_reader :token, :api_version, :accountid

      def initialize(version, oauth_params = {})
        config = AppConfigurator.new
        @api_version = choose_version(version)
        oauth_params[:client_id] = config.get_api_client_id
        oauth_params[:client_secret] = config.get_api_client_secret
        @accountid = config.get_api_accountid

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
