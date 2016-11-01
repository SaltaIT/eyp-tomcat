require 'spec_helper_acceptance'

# tomcat-1111

describe 'tomcat class' do

  context 'changing port' do
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

      tomcat::instance { 'tomcat-1111':
        tomcatpw => 'lol',
        shutdown_port=>'1113',
        ajp_port=>'1112',
        connector_port=>'1111',
        jmx_port => '1114',
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
        connector_http_server => 'LOLserver',
    	}

      tomcat::contextxml { 'tomcat-1111':
        session_cookie_name => 'INDEPENDENCIA',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    #! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE
    it "error free server startup" do
      expect(shell("sleep 10; ! cat /opt/tomcat-1111/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    end

    describe port(1111) do
      it { is_expected.to be_listening }
    end

    it "catalina log 1111" do
      expect(shell("cat /opt/tomcat-1111/logs/catalina.out").exit_code).to be_zero
    end

    it "connector_http_server" do
      expect(shell("curl -I localhost:1111 | grep LOLserver").exit_code).to be_zero
    end

    it "session cookie name" do
      expect(shell("curl --connect-timeout 30 --max-time 30 -u tomcat:lol 127.0.0.1:1111/manager/html -vvv 2>&1 | grep \"Set-Cookie\" | grep INDEPENDENCIA").exit_code).to be_zero
    end
  end

  context 'changing port from 1111 to 1115' do

    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        nativelibrary => false,
      }

      tomcat::instance { 'tomcat-1111':
        tomcatpw => 'lol',
        shutdown_port=>'1113',
        ajp_port=>'1112',
        connector_port=>'1115',
        jmx_port => '1114',
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      tomcat::contextxml { 'tomcat-1111':
        session_cookie_name => 'INDEPENDENCIA',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    #! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE
    it "error free server startup" do
      expect(shell("sleep 10; ! cat /opt/tomcat-1111/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    end

    describe port(1111) do
      it { should_not be_listening }
    end

    describe port(1115) do
      it { is_expected.to be_listening }
    end

    it "catalina log 1111" do
      expect(shell("cat /opt/tomcat-1111/logs/catalina.out").exit_code).to be_zero
    end

  end
end
