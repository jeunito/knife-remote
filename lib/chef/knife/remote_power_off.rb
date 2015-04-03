require 'chef/knife/remote_base'

class Chef
  class Knife
    class RemotePowerOff < Knife
    
      include Knife::RemoteBase    

      banner "knife remote power off NODE"

      option :internap,
        :short => "-i",
        :long => "--internap",
        :boolean => true,
        :default => false

      option :softlayer,
        :long => "--softlayer",
        :boolean => true,
        :default => false

      def run
        puts server.off
      end
    end
  end
end
