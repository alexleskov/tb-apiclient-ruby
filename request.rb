module Teachbase
  module API
    class Request
      SPLIT_SYMBOL = "_".freeze
      URL_ID_PARAMS_FORMAT = /(^id|_id$)/.freeze

      attr_reader :response, :client, :method_name, :request_url, :request_params, :url_ids, :account_id

      def initialize(method_name, params = {}, client)
        @method_name = method_name.to_s
        @method_array = method_name_to_array
        @client = client
        @params = params
        @request_params = {}
        create_request_data
      end

      def receive_response(endpoint_response)
        @response = endpoint_response
      end

      protected

      def create_request_data
        @endpoint_class = find_endpoint_class
        endpoint_method = find_endpoint_method

        endpoint = Kernel.const_get("Teachbase::API::EndpointsVersion::#{get_endpoint_version}::#{@endpoint_class}").new(self)
        raise "No instane method '#{endpoint_method}' in '#{endpoint}'" unless endpoint.respond_to? endpoint_method

        get_request_headers
        @url_ids = get_ids_for_url
        @request_params = get_request_params
        @request_params["access_token"] = client.token.value
        @request_url = create_request_url
        endpoint.public_send(endpoint_method)
      end

      def get_endpoint_version
        client.token.version.to_s.split(SPLIT_SYMBOL).collect(&:capitalize).join
      end

      def find_endpoint_class
        endpoints_list = Teachbase::API::EndpointsVersion::LIST
        endpoint_alias = @method_array.shift
        raise "'#{endpoint_alias}' no such endpoint alias. Avaliable " unless endpoints_list.key?(endpoint_alias)

        @endpoint_class = endpoints_list[endpoint_alias]
      end

      def find_endpoint_method
        endpoint_method = @method_array.join(SPLIT_SYMBOL)
        endpoint_method.empty? ? convert_endpoint_class_to_method : endpoint_method
      end

      def method_name_to_array
        method_name.split(SPLIT_SYMBOL)
      end

      def change_split_symbol(string, from, to)
        result = string.gsub(from, to)
        result.nil? ? string : result
      end

      def convert_endpoint_class_to_method
        change_split_symbol(method_name, /-/, SPLIT_SYMBOL)
      end

      def get_ids_for_url
        return if @params.empty?

        url_ids = @params.select { |param| param =~ URL_ID_PARAMS_FORMAT && param != :account_id }
        url_ids.empty? ? nil : url_ids
      end

      def get_request_headers
        @account_id = @params[:account_id] || client.account_id
      end

      def get_request_params
        return @request_params.merge!(@params) unless url_ids

        other_params = url_ids.each do |key, _value|
          @params.delete(key)
        end
        @request_params.merge!(other_params)
      end

      def create_request_url
        host = client.api_version
        path = method_name_to_array
        path_url = if @url_ids.nil?
                     path.join("/")
                   else
                     path_with_ids = []
                     path.each_with_index do |item, ind|
                       path_with_ids << item
                       path_with_ids.rotate
                       path_with_ids << @url_ids.values[ind]
                     end
                     path_with_ids.join("/")
                   end

        host + change_split_symbol(path_url, /-/, SPLIT_SYMBOL)
      end
    end
  end
end
