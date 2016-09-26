require 'spec_helper_acceptance'

describe 'tomcat agent' do

  context 'tomcat agent testing' do

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
    	}

      EOF

  end
end
