require 'fog/openstackcore/errors'

module Fog
  module OpenStackCore
    module RequestCommon

      def base_request(connection, params)

        first_attempt = true
        begin
          rp = request_params(params)
          response = connection.request(rp)
        rescue Excon::Errors::Conflict => error
          raise Fog::OpenStackCore::Errors::Conflict.slurp(error)
        rescue Excon::Errors::BadRequest => error
          raise Fog::OpenStackCore::Errors::BadRequest.slurp(error)
        rescue Excon::Errors::Unauthorized => error
          raise error unless first_attempt
          first_attempt = false
          # authenticate
          retry
        rescue Excon::Errors::HTTPStatusError => error
          raise case error
          when Excon::Errors::NotFound
            raise Fog::OpenStackCore::Errors::NotFound.slurp(error)
          else
            error
          end
        end
        unless response.body.empty?
          response.body = MultiJson.decode(response.body)
        end

        response

      end  # self.request

      def request_params(params)
        params.merge({
          :headers  => headers(params),
          :path     => params[:path]
        })
      end

      def headers(options={})
        headers =
          { 'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          }.merge(options[:headers] || {})

        if @identity_session && @identity_session.auth_token
          headers.merge!('X-Auth-Token' => @identity_session.auth_token)
        end

        headers
      end

    end # BaseRequest
  end # OpenStackCore
end # Fog
