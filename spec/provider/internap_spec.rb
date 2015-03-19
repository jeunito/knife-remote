require 'knife-remote/provider/internap'
require 'open-uri'
require 'net/http'
require 'time'

describe KnifeRemote::Provider::Internap do
  it "lists devices" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 
    allow(Time).to receive(:now).and_return(Time.mktime(2015,3,16,23,01,32,7))

    expect(internap).to receive(:open).with("http://api.voxel.net/version/1.5?method=voxel.devices.list&key=api_key&timestamp=2015-03-16T23%3A01%3A32-07%3A00&api_sig=0231d58891b065b34a8b3d2c26afd9cc")
    internap.voxel_devices_list
  end 

  it "powers off" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 
    allow(Time).to receive(:now).and_return(Time.mktime(2015,3,16,23,1,32,7))

    resp = double(Net::HTTPResponse)
    allow(resp).to receive(:body)

    params = { 
      :device_id => "1",
      :power_action => "off",
      :method => "voxel.devices.power",
      :timestamp=>"2015-03-16T23:01:32-07:00" ,
      :key => "api_key",
      :api_sig => "e06fff7779f428fbee4a460cb3d55ef9"}

    allow(Net::HTTP).to receive(:post_form).with("http://api.voxel.net/version/1.5", params).and_return(resp)

    internap.voxel_devices_power({
      :device_id => "1", 
      :power_action => "off"
    })
  end

  it "powers on server" 
  it "resets server" 
  it "connects to console"
end
