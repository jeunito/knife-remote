require 'knife-remote/provider/internap'
require 'knife-remote/server/internap'
require 'digest'

VOXEL_RESPONSE = File.dirname(__FILE__) + "/voxel.xml" 

describe "internap server" do 
  context "get device status" do 
    it "is on" do
      api = KnifeRemote::Provider::Internap.new("api_key", "api_secret")
      allow(api).to receive(:open).and_return(open(VOXEL_RESPONSE).read)
      server = KnifeRemote::Server::Internap.new("server.example.com", api)
      expect(server.on?).to eq(true)
    end

    it "is not off" do
      api = KnifeRemote::Provider::Internap.new("api_key", "api_secret")
      allow(api).to receive(:open).and_return(open(VOXEL_RESPONSE).read)
      server = KnifeRemote::Server::Internap.new("server.example.com", api)
      expect(server.off?).to eq(false)
    end
  end 
end 
