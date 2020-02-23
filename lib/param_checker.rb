module Teachbase
  module API
    module ParamChecker

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods; end

      def check(mode, params, check_data)
        raise "Params for checker must be an Array. You used class: '#{params.class}'" unless params.is_a?(Array)
        raise "Data for checking must be a Hash. You used class: '#{check_data.class}'" unless check_data.is_a?(Hash)

        case mode
        when :ids
          raise "Url ids not exists. Set in request: '#{params}'" unless url_ids
        when :options
          raise "Options for request not exists. Set in request: '#{params}'" unless request_options
        else
          raise "Can't find such param for checking: #{params}"
        end

        @lost_params = []
        check_data.each do |key, value|
          @lost_params << key unless params.include?(key)
        end
        @lost_params.empty?
      end

      def check!(mode, params, check_data)
        raise "Can't find several #{mode} for this request. Lost: #{@lost_params}" unless check(mode, params, check_data)
      end
    end
  end
end
