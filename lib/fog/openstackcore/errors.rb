module Fog
  module OpenStackCore
    module Errors
      class ServiceError < Fog::Errors::Error

        attr_reader :response_data

        def self.slurp(error)
          if error.response.body.empty?
            data = nil
            message = nil
          else
            data =
              begin
                data = MultiJson.decode(error.response.body)
                message = data['message']
                if message.nil? and !data.values.first.nil?
                  message = data.values.first['message']
                end
              rescue MultiJson::ParseError => exception
                puts "\nERROR: #{error.response.body.to_yaml}"
                error.response.body
                # exception.data # => "{invalid json}"
                # exception.cause # => JSON::ParserError: 795: unexpected token at '{invalid json}'
              end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end # slurp
      end # ServiceError

      class Conflict < ServiceError; end

      class ServiceUnavailable < ServiceError; end

      class NotFound < ServiceError; end

      class BadRequest < ServiceError

        attr_reader :validation_errors

        def self.slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil? ||
                 new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(
              :@validation_errors,
              new_error.response_data['badRequest']['validationErrors'])
          end
          new_error
        end
      end # BadRequest

    end # Errors
  end # OpenStackCore
end # Fog
