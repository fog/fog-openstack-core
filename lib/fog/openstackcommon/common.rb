module Fog
  module OpenStackCommon
    module Common

      # CGI.escape, but without special treatment on spaces
      def self.escape(str,extra_exclude_chars = '')
        str.gsub(/([^a-zA-Z0-9_.-#{extra_exclude_chars}]+)/) do
          '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
        end
      end

      def self.string_to_class(string)
        string.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      end

    end # Common
  end # OpenStackCommon
end # Fog
