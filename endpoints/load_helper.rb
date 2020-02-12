module Teachbase
  module API
    module LoadHelper
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods; end

      def send_request(option = :normal, params = {})
        request_has_ids?(params[:ids_count]) if option == :with_ids

        begin
          yield
          r = RestClient.get request.request_url, params: request.request_params,
                                                  "X-Account-Id" => request.account_id.to_s
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

      def request_has_ids?(ids_count)
        raise "Must set 'ids_count' if using mode ':with_ids" unless ids_count
        raise "Must have '#{ids_count} id' for '#{request.method_name}' method" unless request.url_ids.size == ids_count
      end
    end
  end
end
