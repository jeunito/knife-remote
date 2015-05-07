require 'nokogiri'
require 'open-uri'

module KnifeRemote
  module Provider
    class Internap
      API_URL = "http://api.voxel.net"
      VERSION = "1.5" 

      def initialize(api_key = nil, api_secret = nil)
        @api_key, @api_secret = api_key, api_secret
      end

      def voxel_devices_list
        sig = Digest::MD5.hexdigest("#{@api_secret}key#{@api_key}methodvoxel.devices.listtimestamp#{timestamp}")
        params =  {
          "method" => "voxel.devices.list", 
          "key" => @api_key,
          "timestamp" => timestamp, 
          "api_sig" => sig
        }

        Nokogiri::XML(open("#{API_URL}/version/#{VERSION}?#{URI.encode_www_form(params)}")) 
      end

      def method_missing(name, *args)
        rq_args = args[0].merge(:method => name.to_s.gsub("_","."), :timestamp => timestamp, :key => @api_key) 
        rq_args[:api_sig] = sign(rq_args)
        uri = "#{API_URL}/version/#{VERSION}"
        resp = Net::HTTP.post_form(URI(uri), rq_args).body
        Nokogiri::XML(resp)
      end

      def configure(username, password)
        uri = "https://#{username}:#{password}@api.voxel.net/version/1.5"
        xml = Nokogiri::XML(Net::HTTP.post_form(URI(uri), { :method => "voxel.hapi.authkeys.read" }).body)
        [ xml.xpath("//authkey/key").text, xml.xpath("//authkey/secret").text ]
      end
      
      private
      def sign(args) 
        params = args.sort_by { |k,v| k }.unshift(@api_secret).join("")
        Digest::MD5.hexdigest(params) 
      end
      def timestamp
        Time.now.iso8601
      end
    end
  end
end
