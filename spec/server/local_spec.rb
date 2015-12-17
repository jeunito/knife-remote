require 'knife-remote/server/local'
require 'chef/knife'

module KnifeRemote::Server
    describe Local do

      let(:rubyipmi) do 
        options = { 'U' => 'username',
                    'P' => 'password',
                    'H' => 'someip' }

        rubyipmi = double()

        rubyipmi.tap do |d|
          allow(d).to receive(:options).and_return(options)
        end
      end

      subject(:server) { Local.new(rubyipmi, 'someip') }

      context "#console" do
        it "calls absolute path to ipmitool" do
          allow(::Chef::Config).to receive(:[]).with(:knife).and_return({:remote => {:ipmitool => "/path/to" }})
          expect(server).to receive(:exec).with("/path/to/ipmitool -U username -P password -H someip -I lanplus sol activate")

          server.console
        end
      end
    end
end
