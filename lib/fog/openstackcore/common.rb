module Fog
  module OpenStackCore
    module Common

      def self.string_to_class(string)
        string.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      end

    end # Common
  end # OpenStackCore
end # Fog
