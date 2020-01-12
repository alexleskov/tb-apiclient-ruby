require "json"
require "rest-client"
require './lib/tbclient/request_default_param'

module Teachbase
  module API
    module Endpoints
      module MobileV2
        class Profile
          include RequestDefaultParam

          attr_reader :request, :answer

          def initialize(request)
            raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

            @request = request
            # self.class.default_request_params
          end

          def profile
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
end
