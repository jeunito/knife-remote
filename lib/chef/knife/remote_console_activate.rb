require 'chef/knife/remote_base'
require 'chef/knife'

class Chef
  class Knife
    class RemoteConsoleActivate < Knife
    
      include Knife::RemoteBase    

      banner "knife remote console activate NODE"

      option :internap,
        :short => "-i",
        :long => "--internap",
        :boolean => true,
        :default => false

      def run
        if config[:internap] && Kernel.system("which sshpass") == false
          ui.fatal "sshpass required but not found"  
          exit 2
        end 

        server.console
      end
    end
  end
end
