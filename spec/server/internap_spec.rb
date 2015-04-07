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

  context "power off the server" do 
    it "is was a successful power off" do
      resp = Nokogiri::XML("<?xml version=\"1.0\"?><rsp stat=\"ok\"/>")

      api = double(KnifeRemote::Provider::Internap)
      allow(api).to receive(:voxel_devices_list).and_return(Nokogiri::XML(open(VOXEL_RESPONSE).read))
      allow(api).to receive(:voxel_devices_power).with({:device_id => "1", :power_action => "off"}).and_return(resp)
      server = KnifeRemote::Server::Internap.new("server.example.com", api)
      expect(server.off).to eq(true)
    end
  end

  context "power on the server" do 
    it "is a successful power on" do
      resp = Nokogiri::XML("<?xml version=\"1.0\"?><rsp stat=\"ok\"/>")

      api = double(KnifeRemote::Provider::Internap)
      allow(api).to receive(:voxel_devices_list).and_return(Nokogiri::XML(open(VOXEL_RESPONSE).read))
      allow(api).to receive(:voxel_devices_power).with({:device_id => "1", :power_action => "on"}).and_return(resp)
      server = KnifeRemote::Server::Internap.new("server.example.com", api)
      expect(server.on).to eq(true)
    end
  end

  context "reset the server" do 
    it "is a successful reset" do
      resp = Nokogiri::XML("<?xml version=\"1.0\"?><rsp stat=\"ok\"/>")

      api = double(KnifeRemote::Provider::Internap)
      allow(api).to receive(:voxel_devices_list).and_return(Nokogiri::XML(open(VOXEL_RESPONSE).read))
      allow(api).to receive(:voxel_devices_power).with({:device_id => "1", :power_action => "reboot"}).and_return(resp)
      server = KnifeRemote::Server::Internap.new("server.example.com", api)
      expect(server.reset).to eq(true)
    end
  end

  context "connects via remote console" do 
    it "is a successful reset" do
      api = double(KnifeRemote::Provider::Internap)
      allow(api).to receive(:voxel_devices_list).and_return(Nokogiri::XML(open(VOXEL_RESPONSE).read))
      server = KnifeRemote::Server::Internap.new("server.example.com", api)
      expect(server).to receive(:exec).with("sshpass -p password ssh username@ssh_host")
      server.console 
    end
  end
end 
