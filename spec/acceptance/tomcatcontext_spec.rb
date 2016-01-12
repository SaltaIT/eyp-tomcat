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

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it { should contain_file('/opt/tomcat-8080/conf/context.xml')
    }

    # File.read("/opt/tomcat-8080/conf/context.xml").expect include "sessionCookiePath=\"/\""
    #expect(File.read("/opt/tomcat-8080/conf/context.xml")).to match("sessionCookiePath=\"/\"")
    # it { should contain_file('/opt/tomcat-8080/conf/context.xml').with({
    #   'content' => /sessionCookiePath="\/"/})
    # }

    # it do
    #   should contain_file('/opt/tomcat-8080/conf/context.xml').with({
    #     'content' => /sessionCookiePath="\/"/})
    #   })
    # end

    # it do
    #   should contain_file('/opt/tomcat-8080/conf/context.xml') \
    #     .with_content(/sessionCookiePath="\/"/)
    # end

    describe file("/opt/tomcat-8080/conf/context.xml") do
      it { should be_file }
      its(:content) { should match 'sessionCookiePath="/"' }
    end

    # File.read("/opt/tomcat-8080/conf/context.xml").should include "antiJARLocking=\"true\""
    # File.read("/opt/tomcat-8080/conf/context.xml").should include "antiResourceLocking=\"true\""
    # File.read("/opt/tomcat-8080/conf/context.xml").should include "<WatchedResource>WEB-INF/web.xml</WatchedResource>"
    # File.read("/opt/tomcat-8080/conf/context.xml").should include "<Manager pathname=\"\" />"

  end
end
