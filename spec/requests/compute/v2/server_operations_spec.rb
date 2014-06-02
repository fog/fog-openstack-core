require "#{File.dirname(__FILE__)}/../../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../support/spec_helpers"

include SpecHelpers

require 'fog/openstackcore'
require 'fog/openstackcore/services/compute_v2'

describe "requests" do
  describe "compute_v2" do
    describe "server operations" do

      # let(:identity) { Fog::OpenStackCore::IdentityV2.new(non_admin_options_hash) }

      let(:service) { Fog::OpenStackCore::ComputeV2.new(non_admin_options_hash) }

      describe "#list_servers" do

        let(:list) { service.list_servers }

        it "returns proper status", :vcr do
          assert_includes([200, 203], list.status)
        end

      end

      describe "#create_server" do

        let(:server_name) { "test-server-#{Time.now.to_i}" }
        let(:flavor_id) { service.list_flavors.body['flavors'].first['id'] }
        let(:image_id) { service.list_images.body['images'].last['id'] }
        let(:create) { service.create_server(server_name, flavor_id, image_id)}

        it "launches a new server instance", :vcr do
          assert_equal(create.status, 202)
        end

        describe "#delete_server" do

          let(:server_id) { create.body['server']['id'] }

          it "deletes a server instance", :vcr do
            result = service.delete_server(server_id)
            assert_equal(result.status, 204)
          end

        end

      end



    end
  end
end
