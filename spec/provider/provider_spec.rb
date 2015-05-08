require 'knife-remote/provider'
require 'mechanize'
require 'chef/knife'

describe KnifeRemote::Provider::Utils do
  it "downloads screenshot" do
    agent = double()
    expect(Mechanize).to receive(:new).and_return(agent)
    ip = "10.0.0.1"

    server = double()
    allow(server).to receive(:ip).and_return(ip)

    login_page = double()

    expect(agent).to receive(:get).once.with("http://#{ip}").and_return(login_page)
    
    allow(Chef::Config).to receive(:[]).with(:knife).and_return({:ipmi_user => "username", :ipmi_pass => "password" })

    login_form = double()
    expect(login_page).to receive(:form).with("form1").and_return(login_form)
    expect(login_form).to receive(:field_with).with(:name => "name").and_return(login_form)
    allow(login_form).to receive(:value=).with("username")
    allow(login_form).to receive(:pwd=).with("password")

    first = double()
    allow(login_form).to receive(:buttons).and_return(first)
    allow(first).to receive(:first).and_return(double())

    expect(agent).to receive(:submit)

    expect(agent).to receive(:get).once.with("http://#{ip}/cgi/CapturePreview.cgi")
   
    utc = double() 
    allow(Time).to receive(:now).and_return(utc)
    strftime = double()
    allow(utc).to receive(:utc).and_return(strftime)
    allow(strftime).to receive(:strftime).with("%a %b %d %Y %H:%M:%S GMT").and_return("Fri May 08 2015 21:52:08 GMT")

    params = {
      "time_stamp" => "Fri May 08 2015 21:52:08 GMT",
      "url_name" => "Snapshot",
      "url_type" => "img",
    }

    img = double()
    expect(agent).to receive(:get).once.with("http://#{ip}/cgi/url_redirect.cgi?#{URI.encode_www_form(params)}").and_return(img)
    expect(img).to receive(:save)

    KnifeRemote::Provider::Utils.console_screenshot(server)
  end
end
