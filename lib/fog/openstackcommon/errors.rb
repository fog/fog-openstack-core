module Fog
  module OpenStackCommon
    module Errors
      class ServiceError < Fog::Errors::Error
        extend self

        attr_reader :response_data

        def slurp(error)
          if error.response.body.empty?
            data = nil
            message = nil
          else
            # data = Fog::JSON.decode(error.response.body)
            data = MultiJson.decode(error.response.body)
            message = data['message']
            if message.nil? and !data.values.first.nil?
              message = data.values.first['message']
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end # slurp
      end # ServiceError

      class ServiceUnavailable < ServiceError; end

      class BadRequest < ServiceError
        extend self

        attr_reader :validation_errors

        def slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil? or new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['badRequest']['validationErrors'])
          end
          new_error
        end
      end # BadRequest
    end # Errors
  end # OpenStackCommon
end # Fog
