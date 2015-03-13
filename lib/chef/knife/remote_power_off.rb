require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemotePowerOff < Knife
    
      include Knife::RemoteBase    

      banner "knife remote power off NODE"

      def run
        puts server.off
      end
    end
  end
end
