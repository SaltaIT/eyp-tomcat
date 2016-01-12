require 'spec_helper_acceptance'

describe 'tomcat context' do

  context 'tomcat context (+ basic setup, ie no native library)' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://ftp.cixug.es/apache/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz',
        nativelibrary => false,
      }

      tomcat::instance { 'tomcat-8080':
        tomcatpw => 'lol',
      }

      tomcat::context { 'tomcat-8080':
        sessionCookiePath => '/',
        antiJARLocking => true,
        antiResourceLocking => true,
      }

      tomcat::authenticators { 'tomcat-8080':
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

    describe file("/opt/tomcat-8080/lib/org/apache/catalina/startup/Authenticators.properties") do
      it { should be_file }
      its(:content) { should match 'BASIC=es.systemadmin.basic.sso.tomcat.BasicAuthenticator' }
    end

  end
end
