require 'spec_helper'

describe Adhearsion::Drb::Plugin do

  describe "while accessing the plugin configuration" do
    subject { Adhearsion.config }

    it "should retrieve a valid configuration instance" do
      expect(Adhearsion.config.adhearsion_drb).to be_instance_of Loquacious::Configuration
    end

    it "should listen on localhost by default" do
      expect(Adhearsion.config.adhearsion_drb.host).to eq("localhost")
    end

    it "should use the default port of 9050" do
      expect(Adhearsion.config.adhearsion_drb.port).to eq(9050)
    end

    it "should default to an empty deny acl" do
      expect(Adhearsion.config.adhearsion_drb.acl.deny.size).to eq(0)
    end

    it "should default to an allow acl of only 127.0.0.1" do
      expect(subject.adhearsion_drb.acl.allow).to eq(["127.0.0.1"])
    end

  end

  describe "while configuring a specific config value" do
    before do
      @host = Adhearsion.config[:adhearsion_drb].host
      @port = Adhearsion.config[:adhearsion_drb].port
      @allow = Adhearsion.config[:adhearsion_drb].acl.allow.dup
      @deny = Adhearsion.config[:adhearsion_drb].acl.deny.dup
    end

    after do
      Adhearsion.config[:adhearsion_drb].host = @host
      Adhearsion.config[:adhearsion_drb].port = @port
      Adhearsion.config[:adhearsion_drb].acl.allow = @allow
      Adhearsion.config[:adhearsion_drb].acl.deny = @deny
    end

    it "ovewrites properly the host value" do
      Adhearsion.config[:adhearsion_drb].host = "an-external-host"
      expect(Adhearsion.config[:adhearsion_drb].host).to eq("an-external-host")
    end

    it "ovewrites properly the port value" do
      Adhearsion.config[:adhearsion_drb].port = 9051
      expect(Adhearsion.config[:adhearsion_drb].port).to eq(9051)
    end

    it "ovewrites properly the allow access value" do
      Adhearsion.config[:adhearsion_drb].acl.allow = ["127.0.0.1", "192.168.10.*"]
      expect(Adhearsion.config[:adhearsion_drb].acl.allow).to eq(["127.0.0.1", "192.168.10.*"])
    end

    it "ovewrites properly the allow access value adding an element" do
      Adhearsion.config[:adhearsion_drb].acl.allow << "192.168.10.*"
      expect(Adhearsion.config[:adhearsion_drb].acl.allow).to eq(["127.0.0.1", "192.168.10.*"])
    end

    it "ovewrites properly the deny access value" do
      Adhearsion.config[:adhearsion_drb].acl.deny = ["192.168.*.*"]
      expect(Adhearsion.config[:adhearsion_drb].acl.deny).to eq(["192.168.*.*"])
    end

    it "ovewrites properly the deny access value adding an element" do
      Adhearsion.config[:adhearsion_drb].acl.deny << "192.168.*.*"
      expect(Adhearsion.config[:adhearsion_drb].acl.deny).to eq(["192.168.*.*"])
    end
  end

  describe "while initializing" do

    after { Adhearsion::Drb::Service.stop }

    it "should start the service" do
      Adhearsion::Drb::Service.user_stopped = false
      expect(Adhearsion::Drb::Service).to receive(:start).and_return true
      Adhearsion::Plugin.init_plugins
      Adhearsion::Plugin.run_plugins
    end
  end
end
