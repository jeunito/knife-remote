#
# Author:: Jeune Asuncion (<jeunito@gmail.com>)
# Copyright:: Copyright (c) 2012 Jeune Asuncion
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife'
require 'chef/node'
require 'rubyipmi'
require 'knife-remote/server/local'
require 'knife-remote/server/internap'
require 'knife-remote/provider/internap'

class Chef
  class Knife
    module RemoteBase
      def server
        unless name_args.size == 1
          puts "You need to specify a node to act on"
          show_usage
          exit 1
        end

        if config[:internap] 
          api = KnifeRemote::Provider::Internap.new(Chef::Config[:knife]["voxel_api_key"], Chef::Config[:knife]["voxel_api_secret"])
          KnifeRemote::Server::Internap.new(name_args[0], api) 
        else
          begin 
            @conn = Rubyipmi.connect(remote_user, remote_pass, remote_ip)
            KnifeRemote::Server::Local.new(@conn)
          rescue NoMethodError
            ui.fatal "IPMI not setup on #{name_args[0]}"
            exit 2
          end
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
