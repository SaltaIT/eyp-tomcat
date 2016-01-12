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

    ### tomcat-users.xml
    # tomcat admin password
    # <user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"
    describe file("/opt/tomcat-8080/conf/tomcat-users.xml") do
      it { should be_file }
      its(:content) { should match '<user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"' }
    end

    describe file("/opt/tomcat-8888/conf/tomcat-users.xml") do
      it { should be_file }
      its(:content) { should match '<user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"' }
    end

    ### server.xml
    #org.apache.catalina.realm.UserDatabaseRealm

    describe file("/opt/tomcat-8888/conf/server.xml") do
      it { should be_file }
      its(:content) { should match 'org.apache.catalina.realm.UserDatabaseRealm' }
      #defaul sha
      its(:content) { should match 'digest="sha"' }
    end

    #configtest server.xml
    #CATALINA_BASE=/opt/tomcat-8080 /opt/tomcat-home/bin/catalina.sh configtest
    it 'configtest server.xml tomcat-8080' do
      expect(shell("CATALINA_BASE=/opt/tomcat-8080 /opt/tomcat-home/bin/catalina.sh configtest").exit_code).to be_zero
    end

    it 'configtest server.xml tomcat-8888' do
      expect(shell("CATALINA_BASE=/opt/tomcat-8888 /opt/tomcat-home/bin/catalina.sh configtest").exit_code).to be_zero
    end


  end

end
