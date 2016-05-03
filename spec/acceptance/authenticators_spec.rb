require 'spec_helper_acceptance'

describe 'tomcat context' do

  context 'tomcat authenticators (+ basic setup, ie no native library)' do

    it "kill java" do
      expect(shell("pkill java").exit_code).to be_zero
    end

    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        nativelibrary => false,
      }

      tomcat::instance { 'tomcat-7777':
        tomcatpw => 'lol',
        shutdown_port=>'7778',
        ajp_port=>'7780',
        connector_port=>'7777',
        jmx_port => '7779',
        lockoutrealm => true,
      }

      tomcat::authenticators { 'tomcat-7777':
        basic => 'es.systemadmin.basic.sso.tomcat.BasicAuthenticator',
        form => 'es.systemadmin.form.sso.tomcat.BasicAuthenticator',
        clientcert => 'es.systemadmin.clientcert.sso.tomcat.BasicAuthenticator',
        digest => 'es.systemadmin.digest.sso.tomcat.BasicAuthenticator',
        none => 'es.systemadmin.none.sso.tomcat.BasicAuthenticator',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/opt/tomcat-7777/lib/org/apache/catalina/startup/Authenticators.properties") do
      it { should be_file }
      its(:content) { should match 'BASIC=es.systemadmin.basic.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'CLIENT-CERT=es.systemadmin.clientcert.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'DIGEST=es.systemadmin.digest.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'FORM=es.systemadmin.form.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'NONE=es.systemadmin.none.sso.tomcat.BasicAuthenticator' }
    end

  end
end
