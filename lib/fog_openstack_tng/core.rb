require 'multi_json'
require 'fog/core'
require_relative 'identity/authenticator'

module Fog
  module OpenStack
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :response_data

        def self.slurp(error)
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
        attr_reader :validation_errors

        def self.slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil? or new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['badRequest']['validationErrors'])
          end
          new_error
        end
      end # BadRequest
    end # Errors

    service(:identity,      'Identity')
#     service(:compute ,      'Compute')
#     service(:image,         'Image')
#     service(:network,       'Network')
#     service(:storage,       'Storage')
#     service(:volume,        'Volume')
#     service(:metering,      'Metering')
#     service(:orchestration, 'Orchestration')


    def self.authenticate(options, connection_options = {})
      case options[:openstack_auth_uri].path
      when /v1(\.\d+)?/
        Fog::OpenStack::Authenticator.adapter = :authenticator_v1
      else
        Fog::OpenStack::Authenticator.adapter = :authenticator_v2
      end
      Fog::OpenStack::Authenticator.adapter.authenticate(options, connection_options)
    end

  end   # OpenStack
end   # FOG