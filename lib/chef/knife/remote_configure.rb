require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemoteConfigure < Knife
    
      include Knife::RemoteBase    

      banner "knife remote configure"

      def run
          puts %Q{ 
Place the following in your knife.rb:

knife[:ipmi_user] = "username" ipmi username (required)
knife[:ipmi_pass] = "password" ipmi password (required)
knife[:ipmi_ohai_ip] = "ipmi.ip.attribute" ohai attribute with the value of a server's ipmi ip (optional) 
          }
      end
    end
  end
end
