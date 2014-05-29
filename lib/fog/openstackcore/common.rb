module Fog
  module OpenStackCore
    module Common

      # ToDo: Move to fog-core
      def self.string_to_class(string)
        string.split('::').inject(Object) do |mod, class_name|
          mod.const_get(class_name)
        end
      end

      # ToDo: Move to fog-core
      # http://devblog.avdi.org/2009/11/20/hash-transforms-in-ruby/
      def self.transform_hash(original, options={}, &block)
        original.inject({}) do |result, (key,value)|
          value = if (options[:deep] && Hash === value)
                    transform_hash(value, options, &block)
                  else
                    value
                  end
          block.call(result,key,value)
          result
        end
      end

      # ToDo: Move to fog-core
      # Returns a new hash with all keys converted to strings.
      def self.stringify_keys(hash)
        self.transform_hash(hash) {|hash, key, value|
        hash[key.to_s] = value
      }
      end

      # returns a list of valid keys
      def self.whitelist_keys(hash, valid_keys)
        return hash if hash.empty?
        valid_hash = self.stringify_keys(hash)
        valid_hash.select {|k,v| valid_keys.include?(k)}
      end

    end # Common
  end # OpenStackCore
end # Fog
