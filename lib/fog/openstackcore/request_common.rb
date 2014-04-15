require 'fog/OpenStackCore/errors'

module Fog
  module OpenStackCore
    module RequestCommon

      def base_request(service, params)

        # puts "\n===== base_request ====="
        # puts "SERVICE: #{service}"
        # puts "PARAMS: #{params.to_yaml}"

        first_attempt = true
        begin
          # puts "Beginning BASE_REQUEST ---"
          rp = request_params(params)

          # puts "PARAMS: #{rp.to_yaml}"

          # Call the service and get response back
          response = service.request(rp)
        rescue Excon::Errors::Conflict => error
          # puts "Conflict"
          raise Fog::OpenStackCore::Errors::Conflict.slurp(error)
        rescue Excon::Errors::BadRequest => error
          # puts "Bad Request"
          raise Fog::OpenStackCore::Errors::BadRequest.slurp(error)
        rescue Excon::Errors::Unauthorized => error
          # puts "Unauthorized"
          raise error unless first_attempt
          first_attempt = false
          # authenticate
          retry
        rescue Excon::Errors::HTTPStatusError => error
          # puts "HTTP Status Error"
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

        # puts "RESPONSE: "
        # puts "#{response.to_yaml}"

        response

      end  # self.request

      def request_params(params)
        params.merge({
          :headers  => headers(params),
          :path     => params[:path]
        })
      end

      def headers(options={})
        # puts "\nINSIDE HEADERS"
        # puts "OPTIONS: #{options.to_yaml}"

        headers =
          { 'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          }.merge(options[:headers] || {})
        headers.merge!('X-Auth-Token' => @auth_token) if @auth_token

        # puts "HEADERS FINAL ===> #{headers.to_yaml}"
        headers
      end

    end # BaseRequest
  end # OpenStackCore
end # Fog
