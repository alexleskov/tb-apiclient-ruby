require "json"
require "rest-client"
require_relative "user.rb"

module Teachbase
  module API
    class Request
      SPLIT_SYMBOL = "_".freeze
      @endpoints = { "users" => User } # TODO: "clickmeeting_meetings" => Clickmeeting_meeting

      class << self
        attr_reader :endpoints
      end

      attr_reader :source_method, :object_method, :request_params, :url_params, :access_token, :response, :api_version

      def initialize(method_name, params, access_token, api_version)
        method_name = method_name.to_s
        @access_token = access_token
        @api_version = api_version
        @url_params = params
        @request_params = { "page" => url_params[:page].to_i,
                            "per_page" => url_params[:per_page].to_i }
        send_request(find_endpoint(method_name), object_method)
      end

      def receive_response(answer)
        @response = answer
      end

      protected

      def find_endpoint(method_name)
        method_name = method_name.split(SPLIT_SYMBOL)
        if method_name.size == 3
          @source_method = method_name[0] + SPLIT_SYMBOL + method_name[1]
          @object_method = method_name[2]
        else
          @source_method = method_name[0]
          @object_method = method_name[1]
        end
        return unless self.class.endpoints.key?(source_method)

        self.class.endpoints[source_method]
      end

      def send_request(source, object)
        access_token.token_request
        destination = source.new(request = self)
        destination.public_send(object) if destination.respond_to? object
      end
    end
  end
end
