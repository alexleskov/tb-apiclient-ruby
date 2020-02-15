require "json"
require "rest-client"
require './request_default_param'

module Teachbase
  module API
    module EndpointsVersion
      module MobileV2
        class Document
          include RequestDefaultParam
          include Teachbase::API::LoadChecker
          include Teachbase::API::LoadHelper

          def initialize(request)
            raise "'#{request}' must be 'Teachbase::API::Request'" unless request.is_a?(Teachbase::API::Request)

            @request = request
          end

          def documents
            send_request
          end
        end
      end
    end
  end
end