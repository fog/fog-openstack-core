module Fog
  module OpenStackCommon
    module Common

      def self.string_to_class(string)
        string.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      end

    end # Common
  end # OpenStackCommon
end # Fog
