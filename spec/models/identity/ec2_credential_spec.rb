# require_relative '../../spec_helper'
# require 'fog/openstackcommon'
#
# describe "identity" do
#   describe "Ec2Credential" do
#
#     before do
#       service = Fog::Identity[:openstackcommon]
#       tenant_id = service.list_tenants.body['tenants'].first['id']
#       valid_options = {
#         :name      => 'foobar',
#         :email     => 'foo@bar.com',
#         :tenant_id => tenant_id,
#         :password  => 'spoof',
#         :enabled   => true
#       }
#
#       # @user = openstack.users.find { |user| user.name == 'foobar' }
#       # @user ||= openstack.users.create(valid_options)
#       @user = service.users.create(valid_options)
#       @ec2_credential = service.ec2_credentials.create({
#         :user_id   => @user.id,
#         :tenant_id => tenant_id,
#       })
#     end
#
#     after do
#       @user.ec2_credentials.each { |cred| cred.destroy }
#       @user.destroy
#     end
#
#     describe "#destroy" do
#       it "succeeds", :vcr do
#         result = @ec2_credential.destroy
#         result.status.must_equal true
#       end
#       it "fails", :vcr do
#         proc {
#           @ec2_credential.destroy
#         }.must_raise Fog::Identity::OpenStackCommon::NotFound
#       end
#     end
#
#     # describe "#save" do
#     #   it "succeeds" do
#     #     result = @ec2_credential.destroy
#     #     result.status.must_equal true
#     #   end
#     #   it "fails" do
#     #     @ec2_credential.destroy
#     #     result = @ec2_credential.destroy
#     #   end
#     # end
#
#   end
#
# end
