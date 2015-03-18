require 'knife-remote/provider/internap'

describe KnifeRemote::Provider::Internap do
  it "lists devices" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 
    allow(internap).to receive(:iso8601) { "2015-03-16T23:01:32-07:00" }
    expect(internap).to receive(:open).with("http://api.voxel.net/version/1.5?method=voxel.devices.list&key=api_key&timestamp=2015-03-16T23%3A01%3A32-07%3A00&api_sig=0231d58891b065b34a8b3d2c26afd9cc")
    internap.voxel_devices_list
  end 

  it "powers off" do
    internap = KnifeRemote::Provider::Internap.new("api_key", "api_secret") 
    allow(internap).to receive(:iso8601).and_return("2015-03-16T23:01:32-07:00", "2015-03-16T23:02:32-07:00")

    expect(internap).to receive(:open).with("http://api.voxel.net/version/1.5?method=voxel.devices.list&key=api_key&timestamp=2015-03-16T23%3A01%3A32-07%3A00&api_sig=0231d58891b065b34a8b3d2c26afd9cc").and_return(open(File.dirname(__FILE__) + "/voxel.xml"))
    expect(internap).to receive(:get_response).with("method=voxel.devices.power&key=api_key&timestamp=2015-03-16T23%3A02%3A32-07%3A00&api_sig=25713ed0bd5401d1866439ffb9c60842&device_id=1&power_action=off").and_return("")

    internap.voxel_devices_power({
      :device_id => "1", 
      :power_action => "off"
    })
  end

  it "powers on server" 
  it "resets server" 
  it "connects to console"
end
