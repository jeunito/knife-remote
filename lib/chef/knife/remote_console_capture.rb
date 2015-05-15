require 'chef/knife/remote_base'
require 'knife-remote/provider/utils'

class Chef
  class Knife
    class RemoteConsoleCapture < Knife

      include KnifeRemote::Provider::Utils
      include Knife::RemoteBase    

      banner "knife console capture NODE"

      def run
        filename = console_screenshot server
        begin 
          fork {
            `open #{filename}`
          }
        rescue
          puts "This feature is not supported on non nix oses."
        end
      end
    end
  end
end
