require 'chef/knife'

module KnifeRemote
  module Server
    class Local 
      attr_reader :fqdn

      def initialize(rubyipmi, fqdn)
        @rubyipmi, @fqdn = rubyipmi, fqdn
      end 

      def on?
        @rubyipmi.chassis.power.on?
      end
    
      def off?
        @rubyipmi.chassis.power.off?
      end

      def on
        @rubyipmi.chassis.power.on
      end
    
      def off
        @rubyipmi.chassis.power.off
      end

      def reset
        @rubyipmi.chassis.power.reset
      end

      def console
        exec("#{File.join(Chef::Config[:knife][:remote][:ipmitool], "ipmitool")} -U #{@rubyipmi.options["U"]} -P #{@rubyipmi.options["P"]} -H #{@rubyipmi.options["H"]} -I lanplus sol activate") 
      end

      def ipmi_ip
        @rubyipmi.options["H"]
      end
    end 
  end
end  
