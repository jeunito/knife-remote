require 'chef/knife'
require 'chef/node'
require 'rubyipmi'
require 'knife-remote/server/local'

class Chef
  class Knife
    module RemoteBase
      def server
        unless name_args.size == 1
          puts "You need to specify a node to act on"
          show_usage
          exit 1
        end

        begin 
          @conn = Rubyipmi.connect(remote_user, remote_pass, remote_ip)
          KnifeRemote::Server::Local.new(@conn, name_args[0])
        rescue NoMethodError
          ui.fatal "IPMI not setup on #{name_args[0]}"
          exit 2
        end
      end 

      def remote_ip 
        node = Chef::Node.load(name_args[0])
        if Chef::Config[:knife].has_key?(:ipmi_ohai_ip)
          levels = Chef::Config[:knife][:ipmi_ohai_ip].split(".")
          hash = node.fetch(levels[0])
          levels.drop(1).each do |l|
            hash = hash.fetch(l) 
          end
          hash
        else
          node.ipmi.ip
        end
      end

      def remote_pass
        unless defined? config[:ipmi_pass]
          puts "Please set your IPMI password in knife.rb"
          exit 1
        end
        Chef::Config[:knife][:ipmi_pass]
      end

      def remote_user
        unless defined? Chef::Config[:knife][:ipmi_user]
          puts "Please set your IPMI username in knife.rb"
          exit 1
        end
        Chef::Config[:knife][:ipmi_user]
      end
    end
  end
end
