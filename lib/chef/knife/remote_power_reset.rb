require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemotePowerReset < Knife
    
      include Knife::RemoteBase    

      banner "knife remote power on NODE"

      def run
        puts server.reset
      end
    end
  end
end
