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
        nativelibrary => false,
    	}

    	tomcat::instance { 'tomcat-6666':
        tomcatpw => 'lol',
        shutdown_port=>'6661',
        ajp_port=>'6662',
        connector_port=>'6666',
        jmx_port => '6663',
        lockoutrealm => false,
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
    	}

      tomcat::instance { 'tomcat-6668':
        tomcatpw => 'lol',
        shutdown_port=>'6669',
        ajp_port=>'6667',
        connector_port=>'6668',
        jmx_port => '6665',
        lockoutrealm => true,
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
      }

      tomcat::driver::postgres { 'tomcat-6666':
        ensure => 'absent',
      }

      tomcat::driver::postgres { 'tomcat-6668':
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
    it "PID tomcat-6666" do
      expect(shell("cat /var/run/tomcat-6666.pid").exit_code).to be_zero
    end

    it "PID tomcat-6668" do
      expect(shell("cat /var/run/tomcat-6668.pid").exit_code).to be_zero
    end

    #/opt/tomcat-8080/webapps/host-manager
    it "host-manager tomcat 6666" do
      expect(shell("ls -la /opt/tomcat-6666/webapps/host-manager").exit_code).to be_zero
    end


    #/opt/tomcat-8080/logs/catalina.out
    it "catalina log 6666" do
      expect(shell("cat /opt/tomcat-6666/logs/catalina.out").exit_code).to be_zero
    end

    it "catalina log 6668" do
      expect(shell("cat /opt/tomcat-6668/logs/catalina.out").exit_code).to be_zero
    end

    #HTTP connector

    #instance tomcat-6666
    describe port(6666) do
      it { should be_listening }
    end

    #instance tomcat-6668 HTTP connector
    describe port(6668) do
      it { should be_listening }
    end

    #shutdown port

    #instance tomcat-6666
    describe port(6661) do
      it { should be_listening }
    end

    #instance tomcat-6668
    describe port(6669) do
      it { should be_listening }
    end

    #JMX port

    #instance tomcat-6666
    describe port(6663) do
      it { should be_listening }
    end

    #instance tomcat-6668
    describe port(6665) do
      it { should be_listening }
    end

    #AJP port

    #instance tomcat-6666
    describe port(6662) do
      it { should be_listening }
    end

    #instance tomcat-6668
    describe port(6667) do
      it { should be_listening }
    end


    ### tomcat-users.xml
    # tomcat admin password
    # <user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"
    describe file("/opt/tomcat-6666/conf/tomcat-users.xml") do
      it { should be_file }
      its(:content) { should match '<user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"' }
    end

    describe file("/opt/tomcat-6668/conf/tomcat-users.xml") do
      it { should be_file }
      its(:content) { should match '<user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"' }
    end

    ### server.xml
    #org.apache.catalina.realm.UserDatabaseRealm

    describe file("/opt/tomcat-6666/conf/server.xml") do
      it { should be_file }
      its(:content) { should match 'digest="sha"' }
      its(:content) { should_not match 'LockOutRealm' }
    end

    describe file("/opt/tomcat-6668/conf/server.xml") do
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
    it 'configtest server.xml tomcat-6666' do
      expect(shell("CATALINA_BASE=/opt/tomcat-6666 /opt/tomcat-home/bin/catalina.sh configtest >/dev/null 2>&1").exit_code).to be_zero
    end

    it 'configtest server.xml tomcat-6668' do
      expect(shell("CATALINA_BASE=/opt/tomcat-6668 /opt/tomcat-home/bin/catalina.sh configtest >/dev/null 2>&1").exit_code).to be_zero
    end

  end

end
