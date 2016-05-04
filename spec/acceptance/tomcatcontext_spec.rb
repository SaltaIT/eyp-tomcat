require 'spec_helper_acceptance'

describe 'tomcat context' do

  context 'tomcat context (+ basic setup, ie no native library)' do

    it "kill java" do
      expect(shell("bash -c 'pkill java; sleep 5'").exit_code).to be_zero
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

      tomcat::context { 'tomcat-3333':
        sessionCookiePath => '/',
        antiJARLocking => true,
        antiResourceLocking => true,
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/opt/tomcat-3333/conf/context.xml") do
      it { should be_file }
      its(:content) { should match 'sessionCookiePath="/"' }
      its(:content) { should match 'antiJARLocking="true"' }
      its(:content) { should match 'antiResourceLocking="true"' }
      its(:content) { should match '<WatchedResource>WEB-INF/web.xml</WatchedResource>' }
      its(:content) { should match '<Manager pathname="" />' }
    end

  end
end
