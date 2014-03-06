require_relative '../../spec_helper'
require 'fog/openstackcommon'

describe Fog::Identity::OpenStackCommon::Real do

  let(:valid_options) { {
    :provider          => 'OpenStackCommon',
    :openstack_auth_url => "http://devstack.local:5000/v2.0/tokens",
    :openstack_username => "admin",
    :openstack_api_key => "stack"
  } }

  let(:service) { Fog::Identity.new(valid_options) }

  describe "#create_role", :vcr do

    let(:result) { service.create_role("azahabada#{Time.now.to_i}") }

    it "creates the role" do
      result.status.must_equal 200
    end

    it "returns valid data" do
      result.body['role'].wont_be_nil
    end

  end

  describe "#get_role" do

    describe "when the role exists" do
      it "gets the role", :vcr do
        temp_role = service.create_role("azahabada#{Time.now.to_i}")
        result = service.get_role(temp_role.body['role']['id'])
        [200, 204].must_include result.status
      end
    end

    describe "when the role doesnt exist" do
      it "returns not found error", :vcr do
        proc {
          service.get_role("nonexistentrole12345")
        }.must_raise Fog::Identity::OpenStackCommon::NotFound
      end
    end

  end

  describe "#delete_role" do

    describe "when the role exists" do
      it "deletes the role", :vcr do
        temp_role = service.create_role("azahabada#{Time.now.to_i}")
        result = service.delete_role(temp_role.body['role']['id'])
        [200, 204].must_include result.status
      end
    end

    describe "when the role doesnt exist" do
      it "returns not found error", :vcr do
        proc {
          service.delete_role("nonexistentrole12345")
        }.must_raise Fog::Identity::OpenStackCommon::NotFound
      end
    end

  end

  describe "#list_roles" do

    # response example:
    # {"roles"=>[{"id"=>"01cee2fe70a44d22a129af8092c584c1", "name"=>"anotherrole"},
    #            {"id"=>"184c57925aea42359bdbfe043bbd13d0", "name"=>"admin"},
    #            {"id"=>"41bfd80369ed4bd787e6e6f9ae61bbc7", "name"=>"ResellerAdmin"},
    #            {"id"=>"62f6a1a306b2409e9d9d37c6642875ac", "name"=>"Member"},
    #            {"id"=>"94844d5932e7491fa052bfcc50734312", "name"=>"service"},
    #            {"enabled"=>"True", "description"=>"Default role for project membership", "name"=>"_member_", "id"=>"9fe2ff9ee4384b1894a90878d3e92bab"},
    #            {"id"=>"f5eb88c32508401ebc3d4a93986605ac", "name"=>"azahabada1394067247"}]}

    describe "when the roles exist" do
      it "lists roles", :vcr do
        result = service.list_roles
        [200].must_include result.status
      end
    end

  end

end
