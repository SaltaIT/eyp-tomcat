require 'spec_helper_acceptance'

# tomcat-1111

describe 'tomcat class' do

  context 'simple port testing' do
    # Using puppet_apply as a helper

    it "kill java" do
      expect(shell("bash -c 'pkill java; for i in $(netstat -tpln | grep java | rev | grep -Eo /[0-9]* | rev | cut -f1 -d/); do kill $i; sleep 10; kill -9 $i; sleep 10; done'").exit_code).to be_zero
    end

    it "fuck tomcats" do
      expect(shell("bash -c 'rm -fr /usr/local/src/tomcat* /opt/tomcat* /etc/init.d/tomcat*; sleep 5'").exit_code).to be_zero
    end


    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        nativelibrary => false,
      }

      tomcat::instance { 'tomcat-7777':
        tomcatpw => 'lol',
        shutdown_port=>'7772',
        ajp_port=>'7773',
        connector_port=>'7777',
        jmx_port => '7774',
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    it "sleep 30" do
      expect(shell("sleep 30").exit_code).to be_zero
    end

    describe port(7777) do
      it { is_expected.to be_listening }
    end

    # TODO: no se pq no acaba d'arrencar el tomcat
    #
    # May 08, 2016 7:32:25 AM org.apache.coyote.AbstractProtocol init
    # INFO: Initializing ProtocolHandler ["ajp-bio-7773"]
    # May 08, 2016 7:32:25 AM org.apache.catalina.startup.Catalina load
    # INFO: Initialization processed in 9019 ms
    # May 08, 2016 7:32:25 AM org.apache.catalina.core.StandardService startInternal
    # INFO: Starting service Catalina
    # May 08, 2016 7:32:25 AM org.apache.catalina.core.StandardEngine startInternal
    # INFO: Starting Servlet Engine: .
    # May 08, 2016 7:32:25 AM org.apache.catalina.startup.HostConfig deployDirectory
    # INFO: Deploying web application directory /opt/tomcat-7777/webapps/host-manager
    # May 08, 2016 7:32:27 AM org.apache.catalina.startup.ContextConfig getDefaultWebXmlFragment
    # INFO: No global web.xml found

    # describe port(7772) do
    #   it { is_expected.to be_listening }
    # end

    describe port(7773) do
      it { is_expected.to be_listening }
    end

    describe port(7774) do
      it { is_expected.to be_listening }
    end

    it "catalina log 7777" do
      expect(shell("cat /opt/tomcat-7777/logs/catalina.out").exit_code).to be_zero
    end
  end
end
