require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemotePowerOn < Knife
    
      include Knife::RemoteBase    

      banner "knife remote power on NODE"

      def run
        puts server.on
      end
    end
  end
end
