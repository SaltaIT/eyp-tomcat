require 'spec_helper_acceptance'

# tomcat-3333

describe 'tomcat context' do

  context 'tomcat context (+ basic setup, ie no native library)' do

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

      tomcat::instance { 'tomcat-3333':
        tomcatpw => 'lol',
        shutdown_port=>'3333',
        ajp_port=>'3334',
        connector_port=>'3335',
        jmx_port => '3336',
        lockoutrealm => true,
      }

      tomcat::contextxml { 'tomcat-3333':
        session_cookie_path => '/',
        anti_jar_locking => true,
        anti_resource_locking => true,
        session_cookie_name => 'INDEPENDENCIA',
        manager => '',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    #! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE
    it "error free server startup" do
      expect(shell("sleep 10; ! cat /opt/tomcat-3333/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    end


    describe file("/opt/tomcat-3333/conf/context.xml") do
      it { should be_file }
      its(:content) { should match 'sessionCookiePath="/"' }
      its(:content) { should match 'antiJARLocking="true"' }
      its(:content) { should match 'sessionCookieName="INDEPENDENCIA"' }
      its(:content) { should match 'antiResourceLocking="true"' }
      its(:content) { should match '<WatchedResource>WEB-INF/web.xml</WatchedResource>' }
      its(:content) { should match '<Manager pathname="" />' }
    end

    #it "session cookie name" do
    #  expect(shell("curl -u tomcat:lol localhost:3335/manager/html -vvv 2>&1 | grep \"Set-Cookie\" | grep INDEPENDENCIA").exit_code).to be_zero
    #end

  end
end
