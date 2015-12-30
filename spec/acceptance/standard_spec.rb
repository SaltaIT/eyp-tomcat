require 'spec_helper_acceptance'

describe 'tomcat class' do

  context 'basic setup (URL)' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
    		tomcat_url => 'http://ftp.cixug.es/apache/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
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
  end

end
