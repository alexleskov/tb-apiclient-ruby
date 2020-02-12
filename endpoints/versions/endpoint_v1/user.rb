require "json"
require "rest-client"
require './request_default_param'

module Teachbase
  module API
    module EndpointsVersion
      module EndpointV1
        class User
          include RequestDefaultParam
          include Teachbase::API::LoadHelper

          attr_reader :request, :answer

          def initialize(request)
            raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

            @request = request
          end

          def sections
            send_request :with_ids, ids_count: 1 do
              check_and_apply_default_req_params
            end
          end
        end
      end
    end
  end
end
