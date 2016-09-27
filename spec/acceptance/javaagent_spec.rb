require 'spec_helper_acceptance'

describe 'tomcat agent' do
  context 'tomcat agent testing' do
    it "demo agent" do
      expect(shell("bash -c 'echo \"import java.lang.instrument.Instrumentation; class TestAgent{ public static void premain(String args, Instrumentation inst) { System.out.println(\"TEST Agent\"); } }\" > /tmp/TestAgent.java'").exit_code).to be_zero
    end

    it "manifest agent" do
      expect(shell("bash -c 'echo \"Premain-Class: TestAgent\" > /tmp/manifest.txt'").exit_code).to be_zero
    end

    it "javac demo agent" do
      expect(shell("bash -c 'javac /tmp/TestAgent.java'").exit_code).to be_zero
    end

    it "jar demo agent" do
      expect(shell("bash -c 'jar cmf /tmp/manifest.txt /tmp/testagent.jar /tmp/TestAgent.class'").exit_code).to be_zero
    end

    describe file("/tmp/testagent.jar") do
      it { should be_file }
    end

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

    it "check TEST Agent" do
      expect(shell("grep \"TEST Agent\" /opt/tomcat-1111/logs/catalina.out").exit_code).to be_zero
    end
  end
end
