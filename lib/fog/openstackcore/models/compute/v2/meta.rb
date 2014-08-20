require 'fog/core/model'
require 'fog/openstackcore/models/compute/v2/meta_parent'

module Fog
  module OpenStackCore
    class ComputeV2
      class Meta < Fog::Model
        include Fog::OpenStackCore::ComputeV2::MetaParent

        identity :key
        attribute :value

        def destroy
          requires :identity
          service.delete_meta(collection_name, @parent.id, key)
          true
        end

        def save
          requires :identity, :value
          service.update_meta(collection_name, @parent.id, key, value)
          true
        end
      end
    end
  end
end
