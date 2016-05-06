require 'spec_helper_acceptance'

describe 'tomcat class' do

  context 'testing changing port' do
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
        nativelibrary => true,
      }

      tomcat::instance { 'tomcat-1111':
        tomcatpw => 'lol',
        shutdown_port=>'1113',
        ajp_port=>'1112',
        connector_port=>'1111',
        jmx_port => '1114',
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    it "sleep 10" do
      expect(shell("sleep 10").exit_code).to be_zero
    end

    describe port(1111) do
      it { is_expected.to be_listening }
    end

    it "catalina log 1111" do
      expect(shell("cat /opt/tomcat-1111/logs/catalina.out").exit_code).to be_zero
    end

    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        nativelibrary => true,
      }

      tomcat::instance { 'tomcat-1111':
        tomcatpw => 'lol',
        shutdown_port=>'1113',
        ajp_port=>'1112',
        connector_port=>'1115',
        jmx_port => '1114',
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    it "sleep 10" do
      expect(shell("sleep 10").exit_code).to be_zero
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
