require 'spec_helper_acceptance'

describe 'tomcat class' do

  context 'basic setup (URL) - explicitly testing native library' do
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
        connector_port=>'2020',
        jmx_port => '2021',
        lockoutrealm => false,
    	}

      tomcat::instance { 'tomcat-8888':
        tomcatpw => 'lol',
        shutdown_port=>'9000',
        ajp_port=>'8885',
        connector_port=>'8888',
        jmx_port => '9999',
        lockoutrealm => true,
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

    it "puppet version" do
      expect(shell("netstat -tpln").exit_code).to be_zero
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
    describe port(8080) do
      it { should be_listening }
    end

    #instance tomcat-8888 HTTP connector
    describe port(8888) do
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

    shutdown_port=>'2022',
    connector_port=>'2020',
    jmx_port => '2021',

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
      expect(shell("CATALINA_BASE=/opt/tomcat-8080 /opt/tomcat-home/bin/catalina.sh configtest").exit_code).to be_zero
    end

    it 'configtest server.xml tomcat-8888' do
      expect(shell("CATALINA_BASE=/opt/tomcat-8888 /opt/tomcat-home/bin/catalina.sh configtest").exit_code).to be_zero
    end

  end

  context 'tomcat resource' do
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
        connector_port=>'2020',
        jmx_port => '2021',
        lockoutrealm => false,
    	}

      tomcat::instance { 'tomcat-8888':
        tomcatpw => 'lol',
        shutdown_port=>'9000',
        ajp_port=>'8885',
        connector_port=>'8888',
        jmx_port => '9999',
        lockoutrealm => true,
      }

      tomcat::resource { 'tomcat-8888':
        resource_name => 'jdbc/psp',
        resource_type => 'javax.sql.DataSource',
        factory => 'org.apache.tomcat.jdbc.pool.DataSourceFactory',
        driver_class_name => 'org.postgresql.Driver',
        resource_url => 'jdbc:postgresql://fuckyeah.systemadmin.es:60901/extension',
        username => 'extension',
        password => '123456',
        initial_size => '2',
        max_active => '20',
        max_idle => '10',
        min_idle => '2',
        validation_query => 'select 1',
        min_evictable_idletimemillis => '3600000',
        time_between_evictionrunsmillis => '1800000',
        numtests_per_evictionrun => '10',
        init_sql => 'SET application_name TO TC_extension01',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)

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
      its(:content) { should match '<Resource' }
      its(:content) { should match 'type="javax.sql.DataSource"' }
      its(:content) { should match 'name="jdbc/psp"' }
      its(:content) { should match 'factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"' }
      its(:content) { should match 'driverClassName="org.postgresql.Driver"' }
      its(:content) { should match 'url="jdbc:postgresql://fuckyeah.systemadmin.es:60901/extension"' }
      its(:content) { should match 'username="extension"' }
      its(:content) { should match 'password="123456"' }
      its(:content) { should match 'initialSize="2"' }
      its(:content) { should match 'maxActive="20"' }
      its(:content) { should match 'maxIdle="10"' }
      its(:content) { should match 'minIdle="2"' }
      its(:content) { should match 'validationQuery="select 1"' }
      its(:content) { should match 'minEvictableIdleTimeMillis="3600000"' }
      its(:content) { should match 'timeBetweenEvictionRunsMillis="1800000"' }
      its(:content) { should match 'numTestsPerEvictionRun="10"' }
      its(:content) { should match 'initSQL="SET application_name TO TC_extension01"' }


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
