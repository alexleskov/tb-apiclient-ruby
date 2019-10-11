require 'json'
require 'rest-client'
require_relative 'client.rb'

module Teachbase
  module API
    class Request
      @default_request_params = { 'page' => 1, 'per_page' => 100 }

      class << self
        attr_reader :default_request_params
        def set_default_request_param(param, value)
          @default_request_params[param.to_s] = value
        end
      end

      attr_reader :url_params, :access_token, :request_params

      def initialize(url_params, access_token)
        @url_params = url_params
        @access_token = { 'access_token' => access_token }
        @request_params = { 'page' => url_params[:page].to_i, 'per_page' => url_params[:per_page].to_i }
      end

      def users_sections
        return unless url_params.include?(:id)

        begin
          source_method = 'users'
          object = 'sections'
          check_and_apply_default_req_params
          r = RestClient.get request_url(source_method: source_method, id: url_params[:id].to_s, object: object), params: request_params.merge!(access_token)
          teachbase_response = JSON.parse(r.body)
        rescue RestClient::ExceptionWithResponse => e
          case e.http_code
          when 301, 302, 307
            e.response.follow_redirection
          else
            raise
          end
        end
      end

      protected

      def check_and_apply_default_req_params
        parameters = self.class.default_request_params.keys
        return if parameters.empty?

        parameters.each do |parametr|
          parametr = parametr.to_s
          @request_params[parametr] = self.class.default_request_params[parametr] if request_params[parametr].zero?
        end
      end

      def request_url(url = {})
        return if url.empty?

        host = Teachbase::API::Client::BASE_API_URL
        source_method = url[:source_method].to_s
        object = url[:object].to_s
        url[:id].to_s ||= ''
        id = url[:id].to_s

        if id.empty?
          host + '/' + source_method + '/' + object
        else
          host + '/' + source_method + '/' + id + '/' + object
        end
      end
    end
  end
end
