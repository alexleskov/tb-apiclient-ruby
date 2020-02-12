require "json"
require "rest-client"
require './request_default_param'

module Teachbase
  module API
    module EndpointsVersion
      module MobileV2
        class Profile
          include RequestDefaultParam
          include Teachbase::API::LoadHelper

          attr_reader :request, :answer

          def initialize(request)
            raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

            @request = request
            # self.class.default_request_params
          end

          def profile
            send_request {}
          end
        end
      end
    end
  end
end
