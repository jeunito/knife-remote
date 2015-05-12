require 'chef/knife/remote_base'
require 'knife-remote/provider/utils'

class Chef
  class Knife
    class RemoteConsoleCapture < Knife
    
      include Knife::RemoteBase    

      banner "knife console capture NODE"

      def run
        console_screenshot server
      end
    end
  end
end
