require 'spec_helper_acceptance'

# tomcat-4444

describe 'recursos tomcat' do

  context 'tomcat resource' do
    # Using puppet_apply as a helper


    it "kill java" do
      expect(shell("bash -c 'pkill java; for i in $(netstat -tpln | grep java | rev | grep -Eo /[0-9]* | rev | cut -f1 -d/); do kill $i; sleep 10; kill -9 $i; sleep 10; done'").exit_code).to be_zero
    end

    it "fuck tomcats" do
      expect(shell("bash -c 'rm -fr /usr/local/src/tomcat* /opt/tomcat* /etc/init.d/tomcat*; sleep 5'").exit_code).to be_zero
    end

    it 'should work with no errors' do
      pp = <<-EOF

      class { 'tomcat':
        tomcat_url => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.tar.gz',
        nativelibrary => false,
      }

      tomcat::instance { 'tomcat-4444':
        tomcatpw => 'lol',
        shutdown_port=>'4446',
        ajp_port=>'4444',
        connector_port=>'4444',
        jmx_port => '4447',
        lockoutrealm => false,
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
      }

      tomcat::instance { 'tomcat-4448':
        tomcatpw => 'lol',
        shutdown_port=>'4441',
        ajp_port=>'4449',
        connector_port=>'4448',
        jmx_port => '4442',
        lockoutrealm => true,
        java_library_path => '/usr/local/apr/lib/:/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib',
      }

      tomcat::driver::postgres { 'tomcat-4444':
      }

      tomcat::driver::postgres { 'tomcat-4448':
      }

      tomcat::resource { 'tomcat-4448':
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

    #
    # TODO: veure pq no aixequen
    #
    #! cat /opt/tomcat-8080/logs/catalina.out  | grep SEVERE
    #it "error free server startup 4444" do
    #  expect(shell("sleep 10; ! cat /opt/tomcat-4444/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    #end
    #
    #it "error free server startup 4448" do
    #  expect(shell("sleep 10; ! cat /opt/tomcat-4448/logs/catalina.out  | grep SEVERE").exit_code).to be_zero
    #end

    ### tomcat-users.xml
    # tomcat admin password
    # <user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"
    describe file("/opt/tomcat-4444/conf/tomcat-users.xml") do
      it { should be_file }
      its(:content) { should match '<user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"' }
    end

    describe file("/opt/tomcat-4448/conf/tomcat-users.xml") do
      it { should be_file }
      its(:content) { should match '<user username="tomcat" password="403926033d001b5279df37cbbe5287b7c7c267fa"' }
    end

    ### server.xml
    #org.apache.catalina.realm.UserDatabaseRealm

    describe file("/opt/tomcat-4444/conf/server.xml") do
      it { should be_file }
      its(:content) { should match 'digest="sha"' }
      its(:content) { should_not match 'LockOutRealm' }
    end

    describe file("/opt/tomcat-4448/conf/server.xml") do
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
    it 'configtest server.xml tomcat-4444' do
      expect(shell("CATALINA_BASE=/opt/tomcat-4444 /opt/tomcat-home/bin/catalina.sh configtest >/dev/null 2>&1").exit_code).to be_zero
    end

    it 'configtest server.xml tomcat-4448' do
      expect(shell("CATALINA_BASE=/opt/tomcat-4448 /opt/tomcat-home/bin/catalina.sh configtest >/dev/null 2>&1").exit_code).to be_zero
    end

  end
end
