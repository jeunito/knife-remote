module KnifeRemote
  module Server
    class Local 
      def initialize(rubyipmi)
        @rubyipmi = rubyipmi
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
        exec("ipmitool -U #{@rubyipmi.options["U"]} -P #{@rubyipmi.options["P"]} -H #{@rubyipmi.options["H"]} -I lanplus sol activate") 
      end

      def ip 
        @rubyipmi.options["H"]
      end
    end 
  end
end  
