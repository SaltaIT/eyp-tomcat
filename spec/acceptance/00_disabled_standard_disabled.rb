require 'spec_helper_acceptance'

describe 'tomcat class' do



  context 'basic setup (URL) - explicitly testing native library' do

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
        nativelibrary => true,
    	}

    	tomcat::instance { 'tomcat-8080':
        tomcatpw => 'lol',
        shutdown_port=>'2022',
        ajp_port=>'8081',
        connector_port=>'8080',
        jmx_port => '2021',
        lockoutrealm => false,
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      tomcat::instance { 'tomcat-8888':
        tomcatpw => 'lol',
        shutdown_port=>'9000',
        ajp_port=>'8885',
        connector_port=>'8888',
        jmx_port => '9999',
        lockoutrealm => true,
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
      }

      tomcat::driver::postgres { 'tomcat-8080':
        ensure => 'absent',
      }

      tomcat::driver::postgres { 'tomcat-8888':
        ensure => 'absent',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

    end

    it "sleep 60 to make sure tomcat is started" do
      expect(shell("sleep 60").exit_code).to be_zero
    end

    it "puppet version" do
      expect(shell("puppet --version").exit_code).to be_zero
    end

    it "puppet module list tree" do
      expect(shell("puppet module list --tree").exit_code).to be_zero
    end

    it "netstat listen" do
      expect(shell("netstat -tpln").exit_code).to be_zero
    end

    #/var/run/
    it "PID tomcat-8080" do
      expect(shell("cat /var/run/tomcat-8080.pid").exit_code).to be_zero
    end

    it "PID tomcat-8888" do
      expect(shell("cat /var/run/tomcat-8888.pid").exit_code).to be_zero
    end

    #/opt/tomcat-8080/webapps/host-manager
    it "host-manager tomcat 8080" do
      expect(shell("ls -la /opt/tomcat-8080/webapps/host-manager").exit_code).to be_zero
    end


    #/opt/tomcat-8080/logs/catalina.out
    it "catalina log 8080" do
      expect(shell("cat /opt/tomcat-8080/logs/catalina.out").exit_code).to be_zero
    end

    it "catalina log 8888" do
      expect(shell("cat /opt/tomcat-8888/logs/catalina.out").exit_code).to be_zero
    end

    #HTTP connector

    #instance tomcat-8080
    describe port(8085) do
      it { should be_listening }
    end

    #instance tomcat-8888 HTTP connector
    describe port(8889) do
      it { should be_listening }
    end

    #shutdown port

    #instance tomcat-8080
    describe port(2022) do
      it { should be_listening }
    end

    #instance tomcat-8888
    describe port(9000) do
      it { should be_listening }
    end

    #JMX port

    #instance tomcat-8080
    describe port(2021) do
      it { should be_listening }
    end

    #instance tomcat-8888
    describe port(9999) do
      it { should be_listening }
    end

    #AJP port

    #instance tomcat-8080
    describe port(8081) do
      it { should be_listening }
    end

    #instance tomcat-8888
    describe port(8885) do
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

    describe file("/opt/tomcat-8080/conf/server.xml") do
      it { should be_file }
      its(:content) { should match 'digest="sha"' }
      its(:content) { should_not match 'LockOutRealm' }
    end

    describe file("/opt/tomcat-8888/conf/server.xml") do
      it { should be_file }
      its(:content) { should match 'org.apache.catalina.realm.UserDatabaseRealm' }
      #defaul sha
      its(:content) { should match 'digest="sha"' }
      its(:content) { should match 'LockOutRealm' }
      #resources
      its(:content) { should match '<GlobalNamingResources>' }
      its(:content) { should match '</GlobalNamingResources>' }
    end

    #configtest server.xml
    #CATALINA_BASE=/opt/tomcat-8080 /opt/tomcat-home/bin/catalina.sh configtest
    it 'configtest server.xml tomcat-8080' do
      expect(shell("CATALINA_BASE=/opt/tomcat-8080 /opt/tomcat-home/bin/catalina.sh configtest >/dev/null 2>&1").exit_code).to be_zero
    end

    it 'configtest server.xml tomcat-8888' do
      expect(shell("CATALINA_BASE=/opt/tomcat-8888 /opt/tomcat-home/bin/catalina.sh configtest >/dev/null 2>&1").exit_code).to be_zero
    end

  end

end
