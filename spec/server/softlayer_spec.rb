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

  it "powers on" do
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

      expect(server_object).to receive(:powerOn)

      softlayer_server = KnifeRemote::Server::Softlayer.new("server.example.com")
      softlayer_server.on 
  end

  it "reboots server" do
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

      expect(server_object).to receive(:rebootHard)

      softlayer_server = KnifeRemote::Server::Softlayer.new("server.example.com")
      softlayer_server.reset 
  end

  it "remove consoles" do
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

      expect(api).to receive(:service_named).with("Hardware_Server").twice.and_return(server_service)
  
      expect(server_service).to receive(:object_with_id).twice.with(1).and_return(server_object)

      expect(server_object).to receive(:getRemoteManagementAccounts).and_return([{"password" => "password", "username" => "root" }])
      expect(server_object).to receive(:getRemoteManagementComponent).and_return({ "ipmiIpAddress" => "10.0.0.1" })

      softlayer_server = KnifeRemote::Server::Softlayer.new("server.example.com")

      expect(softlayer_server).to receive(:exec).with("ipmitool -U root -P password -H 10.0.0.1 -I lanplus sol activate")

      softlayer_server.console
  end
end
