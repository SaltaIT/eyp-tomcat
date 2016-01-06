require 'spec_helper_acceptance'

describe 'tomcat class' do

  context 'basic setup (URL) - explicitly testing native library' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
    		tomcat_url => 'http://ftp.cixug.es/apache/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
        nativelibrary => true,
    	}

    	tomcat::instance { 'tomcat-8080':
    		tomcatpw => 'lol',
    	}

      tomcat::instance { 'tomcat-8888':
        tomcatpw => 'lol',
        shutdown_port=>'9000',
        ajp_port=>'8010',
        connector_port=>'8888',
        jmx_port => '9999',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    it "sleep 60 to make sure tomcat is started" do
      expect(shell("sleep 60").exit_code).to be_zero
    end

    #instance tomcat-8080 HTTP connector
    describe port(8080) do
      it { should be_listening }
    end

    #instance tomcat-8888 HTTP connector
    describe port(8888) do
      it { should be_listening }
    end

    #instance tomcat-8888 shutdown port
    describe port(9000) do
      it { should be_listening }
    end

    #instance tomcat-8888 JMX port
    describe port(9999) do
      it { should be_listening }
    end

    #instance tomcat-8888 AJP port
    describe port(8010) do
      it { should be_listening }
    end

  end

end
