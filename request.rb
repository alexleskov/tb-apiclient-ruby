module Teachbase
  module API
    class Request
      SPLIT_SYMBOL = "_".freeze
      URL_ID_PARAMS_FORMAT = /(^id|_id$)/.freeze

      attr_reader :response, :client, :method_name, :request_url, :url_params, :url_ids

      def initialize(method_name, params, client)
        @method_name = method_name.to_s
        @client = client
        @params = params
        send_request
      end

      def receive_response(endpoint_response)
        @response = endpoint_response
      end

      protected

      def get_endpoint_version
        client.token.version.to_s.split('_').collect(&:capitalize).join
      end

      def create_request_url
        ind_obj = 0
        ind_ids = 0
        host = client.api_version
        url_objects = @object_method
        @object_method = @object_method.join(SPLIT_SYMBOL).gsub(/-/, SPLIT_SYMBOL)
        url_ids_params = @params.select { |param| param =~ URL_ID_PARAMS_FORMAT }
        @url_params = @params
        @url_params["access_token"] = client.token.value
        @url_params[:accountid] = client.accountid
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

        url_objects.each { |object| object.gsub!(/-/, SPLIT_SYMBOL) }

        if @source_method == @object_method
          url_objects.unshift(host).join("/")
        else
          url_objects.unshift(host, @source_method).join("/")
        end
      end

      def find_endpoint(method_name)
        @object_method = @method_name = method_name.split(SPLIT_SYMBOL)
        @source_method = @method_name.size == 1 ? @method_name.join(SPLIT_SYMBOL) : @method_name.shift
        @source_method.gsub!(/-/, SPLIT_SYMBOL)
        raise "'#{@source_method}' no such endpoint" unless Teachbase::API::Endpoints::LIST.key?(@source_method)

        Teachbase::API::Endpoints::LIST[@source_method]
      end

      def send_request
        endpoint_class = find_endpoint(method_name)
        source_endpoint = "Teachbase::API::Endpoints::#{get_endpoint_version}::#{endpoint_class}".constantize
        @request_url = create_request_url
        endpoint = source_endpoint.new(self)
        raise "No method '#{@object_method}' in '#{method_name}'" unless endpoint.respond_to? @object_method

        endpoint.public_send(@object_method)
      end
    end
  end
end
