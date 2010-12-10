VERSION			= 2.23
JAVAC_OPTS		= -source 1.3 -target 1.3 -Xlint 
CF			= ./ColdFusion


InetAddressLocator.jar:	InetAddressLocator
	rm -f InetAddressLocator.jar
	jar cmf0 manifest.stub InetAddressLocator.jar net
	rm -f InetAddressLocator-$(VERSION).zip
	zip -9 -j InetAddressLocator-$(VERSION).zip InetAddressLocator.jar

coldfusion:	InetAddressLocator.jar
	rm -f ColdFusionMX-geoLocator-$(VERSION).zip
	zip -9 -j ColdFusionMX-geoLocator-$(VERSION).zip \
	  InetAddressLocator.jar                         \
	  LICENSE                                        \
	  $(CF)/geoLocator.cfc                           \
	  $(CF)/icu4j_geoLocator.cfc                     \
	  $(CF)/index.cfm                                \
	  $(CF)/README                                   \
	  $(CF)/remoteClasspath_geoLocator.cfc           \
	  $(CF)/world_nt.swf                             \
	  $(CF)/world.swf

InetAddressLocator:
	javac $(JAVAC_OPTS) -classpath . -d . src/net/sf/javainetlocator/*.java
	rm -f net/sf/javainetlocator/ip
	rm -f net/sf/javainetlocator/cc
	rm -f net/sf/javainetlocator/locale.props
	cp db/ip net/sf/javainetlocator/ip
	cp db/cc net/sf/javainetlocator/cc
	cp db/locale.props net/sf/javainetlocator/locale.props

clean:
	rm -Rf InetAddressLocator-$(VERSION)*
	rm -Rf docs
	rm -Rf net
	rm -f *.jar
	rm -f *.tar
	rm -f *.tar.gz
	rm -f *.zip

src-dist:
	rm -Rf InetAddressLocator-$(VERSION)-src
	mkdir -p InetAddressLocator-$(VERSION)-src
	cp --target-directory=InetAddressLocator-$(VERSION)-src \
	  ChangeLog \
	  LICENSE   \
	  Makefile  \
	  manifest.stub
	mkdir -p InetAddressLocator-$(VERSION)-src/ColdFusion
	cp --target-directory=InetAddressLocator-$(VERSION)-src/ColdFusion \
	  ColdFusion/README \
	  ColdFusion/*.cfc  \
	  ColdFusion/*.cfm  \
	  ColdFusion/*.swf
	mkdir -p InetAddressLocator-$(VERSION)-src/db
	cp --target-directory=InetAddressLocator-$(VERSION)-src/db \
	  db/ip \
	  db/cc \
	  db/locale.props
	mkdir -p InetAddressLocator-$(VERSION)-src/src/net/sf/javainetlocator
	cp src/net/sf/javainetlocator/*.java \
	  InetAddressLocator-$(VERSION)-src/src/net/sf/javainetlocator
	rm -f InetAddressLocator-$(VERSION)-src.tar
	rm -f InetAddressLocator-$(VERSION)-src.tar.gz
	tar -cf InetAddressLocator-$(VERSION)-src.tar InetAddressLocator-$(VERSION)-src
	rm -Rf InetAddressLocator-$(VERSION)-src
	gzip --best InetAddressLocator-$(VERSION)-src.tar

docs:
	rm -Rf InetAddressLocator-$(VERSION)-docs
	mkdir InetAddressLocator-$(VERSION)-docs
	javadoc -quiet -sourcepath src                       \
	  -link http://java.sun.com/j2se/1.4.1/docs/api      \
	  -d InetAddressLocator-$(VERSION)-docs              \
	  -nodeprecated -nosince -nohelp -author -version    \
	net.sf.javainetlocator
	rm -f InetAddressLocator-$(VERSION)-docs.tar
	tar -cf InetAddressLocator-$(VERSION)-docs.tar InetAddressLocator-$(VERSION)-docs
	rm -Rf InetAddressLocator-$(VERSION)-docs
	rm -f InetAddressLocator-$(VERSION)-docs.tar.gz
	gzip --best InetAddressLocator-$(VERSION)-docs.tar

test:	InetAddressLocator.jar
	java -jar InetAddressLocator.jar

realclean:	clean
	rm -f ./*.log
	rm -f ./*~
	rm -f ./db/*~
	rm -f ./src/net/sf/javainetlocator/*~

dist: realclean src-dist InetAddressLocator.jar docs coldfusion
