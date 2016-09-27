# CHANGELOG

## 0.3.12

* added **path** and **session_cookie_name** to **tomcat::context**

## 0.3.11

* added configurable HTTP Server header (**connector_http_server**) to **tomcat::instance**

## 0.3.10

* Added **tomcat::agent**

## 0.3.9

* **SERVICE RESTART REQUIRED** (unless manage_service=false) - added headpdump and treadump functions to init script:

```
Info: Computing checksum on file /etc/init.d/tomcat-8081
Info: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/File[/etc/init.d/tomcat-8081]: Filebucketed /etc/init.d/tomcat-8081 to puppet with sum b06f4ada432b23db81a6c8d33a311e78
Notice: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/File[/etc/init.d/tomcat-8081]/content: content changed '{md5}b06f4ada432b23db81a6c8d33a311e78' to '{md5}ecb7c3003a37ac6bc8f3940adc1cc717'
Info: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/File[/etc/init.d/tomcat-8081]: Scheduling refresh of Service[tomcat-8081]
Notice: /Stage[main]/Main/Node[ldapm]/Tomcat::Instance[tomcat-8081]/Service[tomcat-8081]: Triggered 'refresh' from 1 events
```
