require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemotePowerReset < Knife
    
      include Knife::RemoteBase    

      banner "knife remote power reset NODE"

      option :internap,
        :short => "-i",
        :long => "--internap",
        :boolean => true,
        :default => false

      def run
        puts server.reset
      end
    end
  end
end
