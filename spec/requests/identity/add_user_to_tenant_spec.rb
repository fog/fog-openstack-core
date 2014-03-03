# require_relative '../../spec_helper'
#
# require 'fog/openstackcommon'
# # require_relative '../../../lib/fog/openstackcommon/models/identity/user'
# require ''
#
# describe Fog::Identity::OpenStackCommon::Real do
#
#   let(:valid_options) { {
#     :provider => 'OpenStackCommon',
#     :openstack_auth_url => "http://172.16.0.2:5000/v2.0/tokens",
#     :openstack_username => "admin",
#     :openstack_api_key => "stack"
#     } }
#
#   let(:service) {Fog::Identity.new(options)}
#
#   describe "#add_user_to_tenant"
#
#     let(:response) {
#       {'role' => {
#         'id'   => role['id'],
#         'name' => role['name']
#         }
#       }
#     }
#
#     tenant_id = "admin"
#     user_id = "a956f0ef089244b7935d743481740d77"
#     role_id = 200
#     result = service.add_user_to_tenant(tenant_id,user_id,role_id)
#
#     result.status.must_equal 200
#     result.body["role"]["id"].must_equal ""
#     result.body["role"]["name"].must_equal ""
#
#   end
# end
#
#
#
#
#
#
#
#
#
#   describe ".initialize" do
#
#     it "must not be nil" do
#       user.wont_be_nil
#     end
#
#     it "must be of the correct type" do
#       user.must_be_instance_of Fog::Identity::OpenStackCommon::User
#     end
#
#     it "must have correct email" do
#       user.email.must_equal "jsmith@acme.com"
#     end
#
#     it "must be enabled" do
#       user.enabled.must_equal true
#     end
#
#     it "must have correct name" do
#       user.name.must_equal "John Smith"
#     end
#
#     it "must have correct tenant_id" do
#       user.tenant_id.must_equal "123456789"
#     end
#
#     it "must have correct password" do
#       user.password.must_equal "password"
#     end
#
#   end
#
# end
