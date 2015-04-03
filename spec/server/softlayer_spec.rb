require 'knife-remote/server/softlayer'
require 'softlayer_api'
require 'chef/knife'
require 'mixlib/config'

describe "softlayer server" do
  context "device status" do
    it "is on" do
      accounts_service = double()
      accounts_filter = double()
      accounts_mask = double()
      server_service = double()
      server_object = double()
      api = double()

      allow(Chef::Config).to receive(:[]).with(:knife).and_return({:softlayer_api_key => "api_key", :softlayer_user => "user" })

      expect(SoftLayer::Client).to receive(:new).with({:username => "user", :api_key => "api_key" }).and_return(api)

      expect(api).to receive(:service_named).with("Account").and_return(accounts_service)

      expect(accounts_service).to receive(:object_filter).and_return(accounts_filter)
      expect(accounts_filter).to receive(:object_mask).with("mask[id]").and_return(accounts_mask)
      expect(accounts_mask).to receive(:getHardware).and_return([{"id" => 1, "fullyQualifiedDomainName" => "server.example.com"}])

      expect(api).to receive(:service_named).with("Hardware_Server").and_return(server_service)
  
      expect(server_service).to receive(:object_with_id).with(1).and_return(server_object)
      expect(server_object).to receive(:getServerPowerState)

      softlayer_server = KnifeRemote::Server::Softlayer.new("server.example.com")
      softlayer_server.on?
    end
  end

  it "powers off" do
      accounts_service = double()
      accounts_filter = double()
      accounts_mask = double()
      server_service = double()
      server_object = double()
      api = double()

      allow(Chef::Config).to receive(:[]).with(:knife).and_return({:softlayer_api_key => "api_key", :softlayer_user => "user" })

      expect(SoftLayer::Client).to receive(:new).with({:username => "user", :api_key => "api_key" }).and_return(api)

      expect(api).to receive(:service_named).with("Account").and_return(accounts_service)

      expect(accounts_service).to receive(:object_filter).and_return(accounts_filter)
      expect(accounts_filter).to receive(:object_mask).with("mask[id]").and_return(accounts_mask)
      expect(accounts_mask).to receive(:getHardware).and_return([{"id" => 1, "fullyQualifiedDomainName" => "server.example.com"}])

      expect(api).to receive(:service_named).with("Hardware_Server").and_return(server_service)
  
      expect(server_service).to receive(:object_with_id).with(1).and_return(server_object)

      expect(server_object).to receive(:powerOff)

      softlayer_server = KnifeRemote::Server::Softlayer.new("server.example.com")
      softlayer_server.off 
  end
end
