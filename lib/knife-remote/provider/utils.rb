require 'mechanize'

module KnifeRemote
  module Provider
    module Utils
      def console_screenshot(server)
        agent = Mechanize.new     
        ip = server.ipmi_ip

        login_page = agent.get("http://#{ip}")
        login = login_page.form "form1"
        login.field_with(:name => "name").value = Chef::Config[:knife][:ipmi_user]
        login.pwd  = Chef::Config[:knife][:ipmi_pass]

        agent.submit(login, login.buttons.first)
        
        agent.get("http://#{ip}/cgi/CapturePreview.cgi")

        params = {
          "time_stamp" => Time.now.utc.strftime("%a %b %d %Y %H:%M:%S GMT"),
          "url_name" => "Snapshot",
          "url_type" => "img",
        }
        
        img = agent.get("http://#{ip}/cgi/url_redirect.cgi?#{URI.encode_www_form(params)}") 
        puts img.save("test.bmp")
      end 
    end
  end
end
