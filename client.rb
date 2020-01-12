require './lib/app_configurator'
require './lib/tbclient/token'
require './lib/tbclient/endpoints/endpoints_version.rb'
require './lib/tbclient/request'

module Teachbase
  module API
    class Client
      attr_reader :token, :api_version, :accountid

      def initialize(version, oauth_params = {})
        config = AppConfigurator.new
        @api_version = choose_version(version)
        oauth_params[:client_id] ||= config.get_api_client_id
        oauth_params[:client_secret] ||= config.get_api_client_secret
        @accountid ||= config.get_api_accountid

        unless oauth_client_param?(oauth_params[:client_id], oauth_params[:client_secret])
          raise "Set up 'client_id' and 'client_secret'"
        end

        @token = Teachbase::API::Token.new(version, oauth_params)
      end

      def request(method_name, params = {})
        request = Teachbase::API::Request.new(method_name, params, self)
      end

      protected

      def oauth_client_param?(client_id, client_secret)
        !([client_id, client_secret].any? { |key| key.nil? || key.empty? })
      end

      def choose_version(version)
        if Teachbase::API::Endpoints::VERSIONS.key?(version.to_sym)
          Teachbase::API::Endpoints::VERSIONS[version.to_sym]
        else
          raise "API version '#{version}' not exists.\nAvaliable: #{Teachbase::API::Endpoints::VERSIONS.keys}"
        end
      end
    end
  end
end
