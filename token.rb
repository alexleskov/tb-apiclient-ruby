require "json"
require "rest-client"
require "encrypted_strings"

module Teachbase
  module API
    class Token
      TOKEN_TIME_LIMIT = 7200 # TODO: Save "expires_in" in database and remove this const

      class << self
        attr_reader :versions
      end

      @versions = { endpoint_v1: "client_credentials",
                    mobile_v1: "password",
                    mobile_v2: "password" }.freeze

      attr_reader :grant_type, :expired_at, :version

      def initialize(version, oauth_params)
        @version = version
        @oauth_params = oauth_params
        encrypt_oauth_params
        @grant_type = self.class.versions[version]
        token_request
      end

      def value
        return if @access_token_response.nil?

        @access_token_response["access_token"]
      end

      def expired?
        return true if @access_token_response.nil?

        true ? Time.now.utc >= expired_at : false
      end

      def token_request
        if expired? && value.nil?
          payload = create_payload
          r = RestClient.post("https://go.teachbase.ru/oauth/token", payload.to_json,
                              content_type: :json)
          @access_token_response = JSON.parse(r.body)
          @expired_at = access_token_expired_at
        else
          @access_token_response
        end
      rescue RestClient::ExceptionWithResponse => e
        case e.http_code
        when 301, 302, 307
          e.response.follow_redirection
        else
          raise
        end
      end

      protected

      def encrypt_oauth_params
        @oauth_params.each_value do |param|
          param.encrypt!(:symmetric, password: Teachbase::API::Client::ENCRYPT_KEY_OAUTH_DATA)
        end
      end

      def mobile_version?
        %i[mobile_v1 mobile_v2].include? self.class.versions.key(grant_type)
      end

      def oauth_mobile_param?
        !([@oauth_params[:user_email], @oauth_params[:password]].any? { |key| key.nil? || key.empty? })
      end

      def create_payload
        payload = { "client_id" => @oauth_params[:client_id].decrypt,
                    "client_secret" => @oauth_params[:client_secret].decrypt,
                    "grant_type" => grant_type }
        if mobile_version? && oauth_mobile_param?
          payload.merge!("username" => @oauth_params[:user_email].decrypt,
                         "password" => @oauth_params[:password].decrypt)
        elsif mobile_version? && !oauth_mobile_param?
          raise "Not correct oauth params for Mobile API version token request."
        end
        payload
      end

      def access_token_expired_at
        token_created_at = Time.at(@access_token_response["created_at"]).utc
        expires_in = @access_token_response["expires_in"]
        expired_at = token_created_at + TOKEN_TIME_LIMIT # TODO: Save "expires_in" in database and replace this const on it
        # expired_at = token_created_at + expires_in
      end
    end
  end
end
