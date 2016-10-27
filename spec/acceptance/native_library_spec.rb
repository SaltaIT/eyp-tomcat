require 'spec_helper_acceptance'

# tomcat-5555

#TODO: testing native library

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
        nativelibrary => true,
      }

      tomcat::instance { 'tomcat-5555':
        tomcatpw => 'lol',
        shutdown_port=>'5553',
        ajp_port=>'5552',
        connector_port=>'5555',
        jmx_port => '5554',
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    #! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE
    it "error free server startup" do
      expect(shell("sleep 10; ! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    end

    describe file("/opt/tomcat-5555/logs/catalina.out") do
      it { should be_file }
      its(:content) { should_not match 'Apache Tomcat Native library which allows optimal performance in production environments was not found' }
    end


  end

end
