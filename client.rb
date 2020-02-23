# frozen_string_literal: true

require "rest-client"
require "json"

require './lib/app_configurator'
require './lib/token'
require './lib/request'
require './api_types/types'

module Teachbase
  module API
    class Client
      API_TYPES = [:endpoint, :mobile]
      API_VERSIONS = [1,2]
      DEFAULT_ANSWER_TYPE = :json

      attr_reader :api_type, :api_version, :lms_host, :response, :token

      def initialize(api_type, version_number, client_params = {})
        config = AppConfigurator.new
        @api_type = api_type
        @api_version = version_number
        @rest_client = client_params[:rest_client] = Kernel.const_get(config.rest_client)
        @lms_host = client_params[:lms_host] ||= config.lms_host
        client_params[:account_id] ||= config.account_id
        client_params[:client_id] ||= config.client_id
        client_params[:client_secret] ||= config.client_secret
        client_params[:token_expiration_time] ||= config.token_expiration_time

        raise "No such API type. Use one of: #{API_TYPES}" unless [:endpoint, :mobile].include?(api_type.to_sym)
        raise "No such API destination. Type: #{api_type}, version: #{api_version}" unless api_version_and_type_exists?(api_type, api_version) 
        raise "Set up: 'client_id' and 'client_secret'" unless client_param?(client_params) 
        raise "Set up: 'user_login', 'password', 'account_id'" if api_mobile_type? && !mobile_param?(client_params)

        @token = Teachbase::API::Token.new(api_type, client_params)
      end

      def request(type_class_name, api_method_name, options = {})
        options[:api_version] = api_version
        options[:lms_host] = lms_host
        options[:rest_client] = @rest_client
        options[:answer_type] ||= DEFAULT_ANSWER_TYPE
        Teachbase::API::Request.new(type_class_name, api_method_name, options, token)
      end

      private

      def api_mobile_type?
        api_type == :mobile
      end

      def client_param?(params)
        !([params[:client_id], params[:client_secret]].any? { |key| key.nil? || key.empty? })
      end

      def mobile_param?(params)
        !([params[:user_login], params[:password], params[:account_id]].any? { |key| key.nil? || key.empty? })
      end

      def api_version_and_type_exists?(api_type, api_version)
        case api_type
        when :endpoint
          api_version == API_VERSIONS.first
        when :mobile
          API_VERSIONS.include?(api_version)
        end
      end
    end
  end
end
