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
        devices = @api.voxel_devices_list
        device_id = devices.xpath("//devices/device[label='#{@hostname}']/id").text
        resp = @api.voxel_devices_power(:device_id => device_id, :power_action => "on") 
        resp.xpath("//rsp/@stat").first.value == "ok"
      end

      def off
        devices = @api.voxel_devices_list
        device_id = devices.xpath("//devices/device[label='#{@hostname}']/id").text
        resp = @api.voxel_devices_power(:device_id => device_id, :power_action => "off") 
        resp.xpath("//rsp/@stat").first.value == "ok"
      end

      def reset
        devices = @api.voxel_devices_list
        device_id = devices.xpath("//devices/device[label='#{@hostname}']/id").text
        resp = @api.voxel_devices_power(:device_id => device_id, :power_action => "reboot") 
        resp.xpath("//rsp/@stat").first.value == "ok"
      end

      def console
        devices = @api.voxel_devices_list
        ssh_host = devices.xpath("//devices/device[label='#{@hostname}']/access_methods/remote_ssh_console/ssh_host").text
        ssh_usr  = devices.xpath("//devices/device[label='#{@hostname}']/access_methods/remote_ssh_console/ssh_username").text
        ssh_pwd  = devices.xpath("//devices/device[label='#{@hostname}']/access_methods/remote_ssh_console/ssh_password").text
        exec("sshpass -p #{ssh_pwd} ssh #{ssh_usr}@#{ssh_host}") 
      end
    end
  end
end
