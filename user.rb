require "json"
require "rest-client"
require_relative "request.rb"

module Teachbase
  module API
    class User
      @default_request_params = { "page" => 1, "per_page" => 100 } # TODO: Make it as Module for endpoints

      class << self # TODO: Make it as Module for endpoints
        attr_reader :default_request_params

        def set_default_request_param(param, value)
          @default_request_params[param.to_s] = value
        end
      end

      attr_reader :url_params, :request_params, :access_token

      def initialize(request)
        @request = request
        @access_token = request.access_token
        @url_params = request.url_params
        @request_params = request.request_params
      end

      def sections
        return unless url_params.include?(:id)

        begin
          check_and_apply_default_req_params
          r = RestClient.get request_url(source_method: @request.source_method, id: url_params[:id].to_s,
                                         object: @request.object_method), params: request_params.merge!("access_token" => access_token.value)
          @request.receive_response(JSON.parse(r.body))
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

      def check_and_apply_default_req_params # TODO: Make it as Module for endpoints
        parameters = self.class.default_request_params.keys
        return if parameters.empty?

        parameters.each do |parametr|
          parametr = parametr.to_s
          @request_params[parametr] = self.class.default_request_params[parametr] if request_params[parametr].zero?
        end
      end

      def request_url(url = {}) # TODO: Make it as Module for endpoints
        return if url.empty?

        host = @request.api_version
        source_method = url[:source_method].to_s
        object = url[:object].to_s
        url[:id].to_s ||= ""
        id = url[:id].to_s

        if id.empty?
          host + "/" + source_method + "/" + object
        else
          host + "/" + source_method + "/" + id + "/" + object
        end
      end
    end
  end
end
