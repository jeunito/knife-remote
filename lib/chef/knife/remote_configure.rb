require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemoteConfigure < Knife
    
      include Knife::RemoteBase    

      banner "knife remote configure PROVIDER"

      def run
        unless name_args.size == 1
          ui.fatal "USAGE: knife remote configure [local | internap | softlayer]"
          exit 2
        end 

        provider = name_args[0].downcase 
        if provider == "local"
          puts %Q{ 
Place the following in your knife.rb:

knife[:ipmi_user] = "username" ipmi username (required)
knife[:ipmi_pass] = "password" ipmi password (required)
knife[:ipmi_ohai_ip] = "ipmi.ip.attribute" ohai attribute with the value of a server's ipmi ip (optional) 
          }
        elsif provider == "internap"
          key, secret = internap.configure(
            ui.ask_question("Enter ubersmith username: "),
            ui.ask_question("Enter ubersmith password: "))

          puts %Q{
Place the following in your knife.rb:

knife[:voxel_api_key] = "#{key}" voxel api key (required)
knife[:voxel_api_secret] = "#{secret}" voxel api secret (required)
          }
        elsif provider == "softlayer"
          puts %Q{
Generate api access key via the customer portal: 

Go to https://control.softlayer.com/account/user/profile and look under "API Access Information"

Place the following in your knife.rb: 

knife[:softlayer_api_key] = "softlayer api key"
knife[:softlayer_user] = "username"
          }          
          
        end
      end
    end
  end
end
