require "json"
require "rest-client"
require_relative "../request_default_param.rb"

module Teachbase
  module API
    class User
      include RequestDefaultParam

      attr_reader :request, :answer

      def initialize(request)
        raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

        @request = request
        self.class.default_request_params
      end

      def sections
        if request.url_ids.nil? || request.url_ids.size != 1
          raise "'#{request.method_name}' must have 1 'id' in request"
        end
        raise "Must have 'id' for '#{request.method_name}' method" unless request.url_ids.include?(:id)

        begin
          check_and_apply_default_req_params
          r = RestClient.get request.request_url, params: request.url_params,
                                                  "X-Account-Id" => request.url_params[:accountid].to_s ||= ""
          @answer = JSON.parse(r.body)
          request.receive_response(self)
        rescue RestClient::ExceptionWithResponse => e
          case e.http_code
          when 301, 302, 307
            e.response.follow_redirection
          else
            raise
          end
        end
      end
    end
  end
end
