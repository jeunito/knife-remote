require 'chef/knife/remote_base'
require 'chef/knife'

class Chef
  class Knife
    class RemoteConsoleActivate < Knife
    
      include Knife::RemoteBase    

      banner "knife remote console activate NODE"

      def run
        server.console
      end
    end
  end
end
