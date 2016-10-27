require 'spec_helper_acceptance'

# tomcat-2222

describe 'tomcat context' do

  context 'tomcat authenticators (+ basic setup, ie no native library)' do

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

      tomcat::instance { 'tomcat-2222':
        tomcatpw => 'lol',
        shutdown_port=>'2223',
        ajp_port=>'2224',
        connector_port=>'2222',
        jmx_port => '2225',
        lockoutrealm => true,
      }

      tomcat::authenticators { 'tomcat-2222':
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

    #! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE
    it "error free server startup" do
      expect(shell("sleep 10; ! cat /opt/tomcat-2222/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    end

    describe file("/opt/tomcat-2222/lib/org/apache/catalina/startup/Authenticators.properties") do
      it { should be_file }
      its(:content) { should match 'BASIC=es.systemadmin.basic.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'CLIENT-CERT=es.systemadmin.clientcert.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'DIGEST=es.systemadmin.digest.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'FORM=es.systemadmin.form.sso.tomcat.BasicAuthenticator' }
      its(:content) { should match 'NONE=es.systemadmin.none.sso.tomcat.BasicAuthenticator' }
    end

  end
end
