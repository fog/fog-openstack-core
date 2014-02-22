require 'fog/core'

module Fog
  module OpenStack
    module Authenticator
      extend self

      DEFAULT_AUTHENTICATOR = :authenticator_v2

      def adapter
        return @adapter if @adapter
        self.adapter = DEFAULT_AUTHENTICATOR
        @adapter
      end

      def adapter=(adapter_name)
        case adapter_name
        when Symbol, String
          require_relative "./adapters/#{adapter_name}"
          c = adapter_name.to_s.split('_').collect!{ |w| w.capitalize }.join
          @adapter = Fog::OpenStack::Authentication::Adapters.const_get(c)
        else
          raise "Missing OpenStack authentication adapter named: #{adapter_name}"
        end
      end

      # delegate the actual authentication to the underlying version 1|2|3 connection
      # adapter
      def authenticate(options, connection_options = {})
        adapter.authenticate(options, connection_options)
      end

    end # Authenticator
  end # OpenStack
end # Fog