require "json"
require "rest-client"

module Teachbase
  module API
    class Token
      TOKEN_TIME_LIMIT = 7200 # TODO: Save "expires_at" in database and remove this const

      attr_reader :grant_type, :expired_at

      def initialize(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
        @grant_type = "client_credentials"
        token_request
      end

      def value
        return if @access_token_request.nil?

        @access_token_request["access_token"]
      end

      def expired?
        return true if @access_token_request.nil?

        true ? Time.now.utc >= expired_at : false
      end

      def token_request
        if expired? && value.nil?
          payload = { "client_id" => @client_id, "client_secret" => @client_secret, "grant_type" => grant_type }
          r = RestClient.post("https://go.teachbase.ru/oauth/token", payload.to_json, content_type: :json)
          @access_token_request = JSON.parse(r.body)
          @expired_at = access_token_expired_at
        else
          @access_token_request
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

      def access_token_expired_at
        token_created_at = Time.at(@access_token_request["created_at"]).utc
        expires_in = @access_token_request["expires_in"]
        expired_at = token_created_at + TOKEN_TIME_LIMIT # TODO: Save "expires_at" in database and remove this const
      end
    end
  end
end
