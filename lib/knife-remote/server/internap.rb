module KnifeRemote
  module Server
    class Internap
      def initialize(hostname, api)
        @hostname = hostname
        @api = api
      end

      def on?
        devices = @api.voxel_devices_list
        devices.xpath("//devices/device[label='#{@hostname}']/status").text == "on"
      end

      def off? 
        !on?
      end

      def on

      end

      def off
        devices = @api.voxel_devices_list
        device_id = devices.xpath("//devices/device[label='#{@hostname}']/id").text
        resp = @api.voxel_devices_power(:device_id => device_id, :power_action => "off") 
        resp.xpath("//rsp/@stat").first.value == "ok"
      end

      def reset

      end

      def console

      end
    end
  end
end
