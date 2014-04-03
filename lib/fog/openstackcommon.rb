# CORE
require 'fog/core'
require 'fog/openstackcommon/core'

# IDENTITY
require 'fog/openstackcommon/identity'
require 'fog/openstackcommon/services/identity_v1'
require 'fog/openstackcommon/services/identity_v2'

# COMPUTE

# STORAGE


# MISC
require 'multi_json'


class String
  def to_class
    self.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end
