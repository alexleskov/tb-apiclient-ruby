module Teachbase
  module API
    module Types
      module Mobile
        module V2
          class Programs
            SOURCE = "programs"

            include Teachbase::API::ParamChecker
            include Teachbase::API::MethodCaller

            attr_reader :url_ids, :request_options

            def initialize(url_ids, request_options)
              @url_ids = url_ids
              @request_options = request_options
            end

            def programs
              if url_ids
                check!(:ids, [:id], url_ids)
                "#{SOURCE}/#{url_ids[:id]}"
              else
                check!(:options, [:filter], request_options)
                "#{SOURCE}"
              end
            end

            def programs_content
              check!(:ids, [:id], url_ids)
              "#{programs}/content"
            end

          end
        end
      end
    end
  end
end