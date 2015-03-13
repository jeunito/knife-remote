require 'nokogiri'
require 'open-uri'

module KnifeRemote
  module Provider
    class Internap
      API_URL = "http://api.voxel.net"
      VERSION = "1.5" 

      def initialize(api_key, api_secret)
        @api_key, @api_secret = api_key, api_secret
      end

      def voxel_devices_list
        timestamp = Time.now.iso8601 
        sig = Digest::MD5.hexdigest("#{@api_secret}key#{@api_key}methodvoxel.devices.listtimestamp#{timestamp}")
        params =  {
          "method" => "voxel.devices.list", 
          "key" => @api_key,
          "timestamp" => timestamp, 
          "api_sig" => sig
        }

        Nokogiri::XML(open("#{API_URL}/version/#{VERSION}?#{URI.encode_www_form(params)}")) 
      end

#      def voxel_devices_power(server)
#        devices = voxel_devices_list 
#        device = devices.xpath("//devices/device/[label='#{server}'")
#        
#        timestamp = Time.now.iso8601 
#        sig = Digest::MD5.hexdigest("#{@api_secret}key#{@api_key}methodvoxel.devices.powertimestamp#{timestamp}")
#        params =  {
#          "method" => "voxel.devices.power", 
#          "key" => @api_key,
#          "timestamp" => timestamp, 
#          "api_sig" => sig
#          "device_id" => device.xpath("//id").text,
#          "power_action" => "off"
#        }
#        
#        uri = "#{API_URL}/version/#{VERSION}?#{URI.encode_www_form(params)}"
#        Net::HTTP.get_response(URI(uri)).body
#      end
    end
  end
end
