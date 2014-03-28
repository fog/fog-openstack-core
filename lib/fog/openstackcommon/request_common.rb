module Fog
  module OpenStackCommon
    module RequestCommon

      def my_request(service, params, uri)

        puts "\n===== base_request ====="
        puts "SERVICE: #{service}"
        puts "PARAMS: #{params.to_yaml}"

        first_attempt = true
        begin
          puts "BEGIN ---"
          response = service.request(request_params(params, uri))
        rescue Excon::Errors::Conflict => error
          puts "Conflict"
          raise Fog::OpenStackCommon::Errors::Conflict.slurp(error)
        rescue Excon::Errors::BadRequest => error
          puts "Bad Request"
          raise Fog::OpenStackCommon::Errors::BadRequest.slurp(error)
        rescue Excon::Errors::Unauthorized => error
          puts "Unauthorized"
          raise error unless first_attempt
          first_attempt = false
          # authenticate
          retry
        rescue Excon::Errors::HTTPStatusError => error
          puts "HTTP Status Error"
          raise case error
          when Excon::Errors::NotFound
            raise Fog::OpenStackCommon::Errors::NotFound.slurp(error)
          else
            error
          end
        end
        unless response.body.empty?
          response.body = MultiJson.decode(response.body)
        end

        puts "RESPONSE: "
        puts "#{response.to_yaml}"

        response

      end  # self.request

      def request_params(params, uri)
        puts "\nINSIDE REQUEST_PARAMS"
        puts "#{params.to_yaml}"
        puts "#{uri}"

        # uri = params.delete(:uri)
        path = "#{uri.path}"
        # path = params[:uri].path

        puts "PATH:"
        puts "#{path}"

        params.merge({
          :headers  => headers(params),
          :path     => path
        })
      end


      # ToDo: (Chris) Need to set the X-Auth-Token header
      #       after initial auth for all subsequent calls.
      #       Initial auth fails with this header specified
      #       without a value.
      def headers(options={})
        puts "\nINSIDE HEADERS"

        { 'Content-Type' => 'application/json',
          'Accept' => 'application/json'
          # ,
          # 'X-Auth-Token' => auth_token
        }.merge(options[:headers] || {})
      end

      # def self.auth_token
      #   puts "\nINSIDE AUTH_TOKEN"
      #
      #   # @auth_token || @identity_service.auth_token
      #   nil
      # end

    end # BaseRequest
  end # OpenStackCommon
end # Fog
