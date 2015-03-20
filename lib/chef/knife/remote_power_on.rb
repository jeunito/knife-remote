require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemotePowerOn < Knife
    
      include Knife::RemoteBase    

      banner "knife remote power on NODE"

      option :internap,
        :short => "-i",
        :long => "--internap",
        :boolean => true,
        :default => false

      def run
        puts server.on
      end
    end
  end
end
