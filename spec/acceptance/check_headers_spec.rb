require 'spec_helper_acceptance'

# tomcat-3333

describe 'tomcat context headers' do

  context 'tomcat context (HTTP headers)' do

    it "kill java" do
      expect(shell("bash -c 'pkill java; for i in $(netstat -tpln | grep java | rev | grep -Eo /[0-9]* | rev | cut -f1 -d/); do kill $i; sleep 10; kill -9 $i; sleep 10; done'").exit_code).to be_zero
    end

    it "fuck tomcats" do
      expect(shell("bash -c 'rm -fr /usr/local/src/tomcat* /opt/tomcat* /etc/init.d/tomcat*; sleep 5'").exit_code).to be_zero
    end

    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        nativelibrary => false,
      }

      tomcat::instance { 'tomcat-8888':
        tomcatpw => 'lol',
        shutdown_port=>'3333',
        ajp_port=>'3334',
        connector_port=>'1111',
        jmx_port => '3336',
        lockoutrealm => true,
        connector_http_server => 'TERRALLIURE',
      }

      tomcat::contextxml { 'tomcat-8888':
        session_cookie_name => 'INDEPENDENCIA',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it "catalina.out content" do
      expect(shell("sleep 100s; cat /opt/tomcat-8888/logs/catalina.out").exit_code).to be_zero
    end

    #INFO: Server startup
    it "Server startup" do
      expect(shell("sleep 100s; grep 'Server startup' /opt/tomcat-8888/logs/catalina.out").exit_code).to be_zero
    end

    it "server.xml content" do
      expect(shell("cat /opt/tomcat-8888/conf/server.xml").exit_code).to be_zero
    end

    it "context.xml content" do
      expect(shell("cat /opt/tomcat-8888/conf/context.xml").exit_code).to be_zero
    end

    #! cat /opt/tomcat-8888/logs/catalina.out  | grep SEVERE
    it "error free server startup" do
      expect(shell("sleep 10; ! cat /opt/tomcat-8888/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    end

    describe file("/opt/tomcat-8888/conf/context.xml") do
      it { should be_file }
      its(:content) { should match 'sessionCookieName="INDEPENDENCIA"' }
    end

    describe port(1111) do
      it { should be_listening }
    end

    it "session cookie name" do
      expect(shell("curl --connect-timeout 30 --max-time 30 -u tomcat:lol 127.0.0.1:1111/manager/html -vvv 2>&1 | grep \"Set-Cookie\" | grep INDEPENDENCIA").exit_code).to be_zero
    end

    it "server header" do
      expect(shell("curl --connect-timeout 30 --max-time 30 -u tomcat:lol 127.0.0.1:1111/manager/html -vvv 2>&1 | grep TERRALLIURE").exit_code).to be_zero
    end

  end
end
