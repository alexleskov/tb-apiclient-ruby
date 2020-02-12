require "json"
require "rest-client"
require './request_default_param'

module Teachbase
  module API
    module EndpointsVersion
      module MobileV2
        class CourseSession
          include RequestDefaultParam
          include Teachbase::API::LoadHelper

          attr_reader :request, :answer

          def initialize(request)
            raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

            @request = request
          end

          def course_sessions
            send_request do
              check_and_apply_default_req_params
            end
          end

          def materials
            send_request :with_ids, ids_count: 2 do
            end
          end
        end
      end
    end
  end
end
