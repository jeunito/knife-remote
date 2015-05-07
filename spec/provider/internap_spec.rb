require 'knife-remote/provider/internap'
require 'open-uri'
require 'net/http'
require 'time'

describe KnifeRemote::Provider::Internap do
  it "lists devices" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 

    t = double()
    allow(t).to receive(:iso8601).and_return("2015-03-16T23:01:32-07:00")
    allow(Time).to receive(:now).and_return(t)

    expect(internap).to receive(:open).with("http://api.voxel.net/version/1.5?method=voxel.devices.list&key=api_key&timestamp=2015-03-16T23%3A01%3A32-07%3A00&api_sig=0231d58891b065b34a8b3d2c26afd9cc")
    internap.voxel_devices_list
  end 

  it "powers off" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 

    t = double()
    allow(t).to receive(:iso8601).and_return("2015-03-16T23:01:32-07:00")
    allow(Time).to receive(:now).and_return(t)

    resp = double(Net::HTTPResponse)
    allow(resp).to receive(:body)

    params = { 
      :device_id => "1",
      :power_action => "off",
      :method => "voxel.devices.power",
      :timestamp=>"2015-03-16T23:01:32-07:00" ,
      :key => "api_key",
      :api_sig => "e06fff7779f428fbee4a460cb3d55ef9"}

    allow(Net::HTTP).to receive(:post_form).with(URI("http://api.voxel.net/version/1.5"), params).and_return(resp)

    internap.voxel_devices_power({
      :device_id => "1", 
      :power_action => "off"
    })
  end

  it "powers on server" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 

    t = double()
    allow(t).to receive(:iso8601).and_return("2015-03-16T23:01:32-07:00")
    allow(Time).to receive(:now).and_return(t)

    resp = double(Net::HTTPResponse)
    allow(resp).to receive(:body)

    params = { 
      :device_id => "1",
      :power_action => "on",
      :method => "voxel.devices.power",
      :timestamp=>"2015-03-16T23:01:32-07:00" ,
      :key => "api_key",
      :api_sig => "4c02c494cae4792416687fe909d72a29"}

    allow(Net::HTTP).to receive(:post_form).with(URI("http://api.voxel.net/version/1.5"), params).and_return(resp)

    internap.voxel_devices_power({
      :device_id => "1", 
      :power_action => "on"
    })
  end

  it "resets the server" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 

    t = double()
    allow(t).to receive(:iso8601).and_return("2015-03-16T23:01:32-07:00")
    allow(Time).to receive(:now).and_return(t)

    resp = double(Net::HTTPResponse)
    allow(resp).to receive(:body)

    params = { 
      :device_id => "1",
      :power_action => "reboot",
      :method => "voxel.devices.power",
      :timestamp=>"2015-03-16T23:01:32-07:00" ,
      :key => "api_key",
      :api_sig => "395f2b23441a7720c90babb74148a17e"}

    allow(Net::HTTP).to receive(:post_form).with(URI("http://api.voxel.net/version/1.5"), params).and_return(resp)

    internap.voxel_devices_power({
      :device_id => "1", 
      :power_action => "reboot"
    })
  end

  it "creates a hapi key/secret pair" do 
    xml = "<?xml version=\"1.0\"?>
<rsp stat=\"ok\"><authkey><key>key</key><secret>secret</secret><username>username</username><user_type>subuser</user_type></authkey></rsp>"
    resp = double(Net::HTTPResponse)
    allow(resp).to receive(:body).and_return(xml)

    internap = KnifeRemote::Provider::Internap.new() 
    expect(Net::HTTP).to receive(:post_form).with(URI("https://username:password@api.voxel.net/version/1.5"), { :method => "voxel.hapi.authkeys.read" }).and_return(resp)

    expect(internap.configure("username", "password")).to eq(["key", "secret"])
  end
end
