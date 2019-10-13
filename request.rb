require_relative "user.rb"
require_relative "profile.rb"

module Teachbase
  module API
    class Request
      SPLIT_SYMBOL = "_".freeze
      URL_ID_PARAMS_FORMAT = /(^id|_id$)/.freeze

      attr_reader :source_method, :object_method, :response, :client, :method_name, :request_url,
                  :url_params, :url_ids, :request_headers

      def initialize(method_name, params, client)
        @method_name = method_name.to_s
        @client = client
        @params = params
        @request_headers = params[:headers]
        send_request
      end

      def receive_response(endpoint_response)
        @response = endpoint_response
      end

      protected

      def create_request_url
        ind_obj = 0
        ind_ids = 0
        host = client.api_version
        url_objects = object_method.split(SPLIT_SYMBOL)
        url_ids_params = @params.select { |param| param =~ URL_ID_PARAMS_FORMAT }
        @url_params = @params

        unless url_ids_params.nil? || url_ids_params.empty?
          @url_ids = url_ids_params
          @url_params = url_params.delete_if { |key, _value| url_ids_params.keys.include?(key) }
          url_ids_params = url_ids_params.to_a
          loop do
            url_objects.insert(ind_obj, url_ids_params[ind_ids][1].to_s)
            ind_obj += 2
            ind_ids += 1
            break unless ind_ids + 1 == url_ids_params.size
          end
        end

        url_objects.unshift(host, source_method).join("/")
      end

      def find_endpoint(method_name)
        method_name = method_name.split(SPLIT_SYMBOL)
        if method_name.size == 1
          @source_method = method_name.join(SPLIT_SYMBOL)
          @object_method = ""
        else
          @source_method = method_name.shift
          @object_method = method_name.join(SPLIT_SYMBOL)
        end
        raise "'#{source_method}' no such endpoint" unless client.class.endpoints.key?(source_method)

        client.class.endpoints[source_method]
      end

      def send_request
        client.token.token_request
        endpoint_class = find_endpoint(method_name)
        @request_url = create_request_url
        endpoint = endpoint_class.new(self)

        if object_method.empty? && !source_method.empty?
          raise "No method '#{source_method}' in '#{method_name}'" unless endpoint.respond_to? source_method

          endpoint.public_send(source_method)
        else
          raise "No method '#{object_method}' in '#{method_name}'" unless endpoint.respond_to? object_method

          endpoint.public_send(object_method)
        end
      end
    end
  end
end
