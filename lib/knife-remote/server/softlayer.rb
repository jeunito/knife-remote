require "softlayer_api"

module KnifeRemote
  module Server
    class Softlayer
      def initialize(hostname)
        @hostname = hostname
      end

      def on? 
        hostname = /^([a-z0-9-]*)(?=\..*)/.match(@hostname)[0]
        filter = SoftLayer::ObjectFilter.new do |filter|
          filter.accept("hardware.hostname").when_it is(hostname)
        end
        api= softlayer
        server = api.service_named("Account").object_filter(filter).object_mask("mask[id]").getHardware
        api.service_named("Hardware_Server").object_with_id(server[0]["id"]).getServerPowerState == "on"
      end

      def off? 
        !on?
      end

      def off 
        hostname = /^([a-z0-9-]*)(?=\..*)/.match(@hostname)[0]
        filter = SoftLayer::ObjectFilter.new do |filter|
          filter.accept("hardware.hostname").when_it is(hostname)
        end
        api= softlayer
        server = api.service_named("Account").object_filter(filter).object_mask("mask[id]").getHardware
        api.service_named("Hardware_Server").object_with_id(server[0]["id"]).powerOff
      end

      def on 
        hostname = /^([a-z0-9-]*)(?=\..*)/.match(@hostname)[0]
        filter = SoftLayer::ObjectFilter.new do |filter|
          filter.accept("hardware.hostname").when_it is(hostname)
        end
        api= softlayer
        server = api.service_named("Account").object_filter(filter).object_mask("mask[id]").getHardware
        api.service_named("Hardware_Server").object_with_id(server[0]["id"]).powerOn
      end

      def reset
        hostname = /^([a-z0-9-]*)(?=\..*)/.match(@hostname)[0]
        filter = SoftLayer::ObjectFilter.new do |filter|
          filter.accept("hardware.hostname").when_it is(hostname)
        end
        api= softlayer
        server = api.service_named("Account").object_filter(filter).object_mask("mask[id]").getHardware
        api.service_named("Hardware_Server").object_with_id(server[0]["id"]).rebootHard
      end

      def console
        hostname = /^([a-z0-9-]*)(?=\..*)/.match(@hostname)[0]
        filter = SoftLayer::ObjectFilter.new do |filter|
          filter.accept("hardware.hostname").when_it is(hostname)
        end
        api= softlayer
        server = api.service_named("Account").object_filter(filter).object_mask("mask[id]").getHardware
        ipmi_account = api.service_named("Hardware_Server").object_with_id(server[0]["id"]).getRemoteManagementAccounts
        ipmi_server = api.service_named("Hardware_Server").object_with_id(server[0]["id"]).getRemoteManagementComponent

        exec("ipmitool -U #{ipmi_account["username"]} -P #{ipmi_account["password"]} -H #{ipmi_server["ipmiIpAddress"]} -I lanplus sol activate")
      end

      private
      def softlayer
        SoftLayer::Client.new({
          :api_key => Chef::Config[:knife][:softlayer_api_key],
          :username => Chef::Config[:knife][:softlayer_user]
          })
      end
    end
  end
end
