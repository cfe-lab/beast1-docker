# docker file for centos7 with BEAST 1.8.4 and beagle

FROM centos:7

MAINTAINER wscott@cfenet.ubc.ca

RUN yum -y update && yum -y upgrade
RUN yum -y install java-1.8.0-openjdk-devel.x86_64 javapackages-tools.noarch 
RUN yum -y install coreutils wget git autoconf automake m4 libtool make gcc-c++

WORKDIR /root/build


# ---------------- install beagle ------------------------
WORKDIR /root/build/beagle
RUN git clone https://github.com/beagle-dev/beagle-lib.git  .
# ARG CACHEDATE=2017-10-20NOW

RUN ./autogen.sh

RUN ./configure --prefix=/usr/local/beagle-lib-master CFLAGS='-O3 -march=core2 -msse2' CXXFLAGS='-O3 -march=core2 -msse2'
RUN make

# RUN make install

RUN mkdir -p /usr/local/beagle-lib-master/include
RUN install -m 644 libhmsbeagle/beagle.h libhmsbeagle/platform.h     /usr/local/beagle-lib-master/include

RUN mkdir -p /usr/local/beagle-lib-master/lib
# RUN install -m 755 libhmsbeagle/CPU/.libs/*.so* /usr/local/beagle-lib-master/lib
# RUN install -m 755 libhmsbeagle/CPU/.libs/*.la        /usr/local/beagle-lib-master/lib


RUN install -m 755 libhmsbeagle/.libs/*.so* /usr/local/beagle-lib-master/lib
RUN install -m 755 libhmsbeagle/.libs/*.la       /usr/local/beagle-lib-master/lib
RUN install -m 755 libhmsbeagle/JNI/libhmsbeagle-jni.la       /usr/local/beagle-lib-master/lib
RUN install -m 755 libhmsbeagle/JNI/.libs/libhmsbeagle-jni.so /usr/local/beagle-lib-master/lib


# ------------------ install beast -----------------------
WORKDIR /root/build
RUN wget https://github.com/beast-dev/beast-mcmc/releases/download/v1.8.4/BEASTv1.8.4.tgz

RUN tar -zxvf BEASTv1.8.4.tgz

RUN mkdir -p /usr/local/BEAST-1.8.4/bin
RUN mkdir -p /usr/local/BEAST-1.8.4/lib
RUN mkdir -p /usr/local/BEAST-1.8.4/doc
RUN mkdir -p /usr/local/BEAST-1.8.4/examples
RUN mkdir -p /usr/local/BEAST-1.8.4/images
RUN mkdir -p /usr/local/BEAST-1.8.4/native

# RUN install  -d -m 755 BEASTv1.8.4/bin /usr/local/BEAST-1.8.4/bin
RUN cp  BEASTv1.8.4/bin/* /usr/local/BEAST-1.8.4/bin/.   && chmod 755 /usr/local/BEAST-1.8.4/bin/*

RUN cp  BEASTv1.8.4/lib/* /usr/local/BEAST-1.8.4/lib/.   && chmod 444 /usr/local/BEAST-1.8.4/lib/*

RUN cp  BEASTv1.8.4/doc/* /usr/local/BEAST-1.8.4/doc/.   && chmod 444 /usr/local/BEAST-1.8.4/doc/*

RUN cp  -R BEASTv1.8.4/examples/* /usr/local/BEAST-1.8.4/examples/.   && chmod -R 444 /usr/local/BEAST-1.8.4/examples/*

RUN cp  BEASTv1.8.4/images/* /usr/local/BEAST-1.8.4/images/.   && chmod 444 /usr/local/BEAST-1.8.4/images/*

RUN cp  BEASTv1.8.4/native/* /usr/local/BEAST-1.8.4/native/.   && chmod 444 /usr/local/BEAST-1.8.4/native/*

RUN ln -s /usr/local/BEAST-1.8.4/bin/beast /usr/local/bin/beast
RUN ln -s /usr/local/BEAST-1.8.4/bin/beauti /usr/local/bin/beauti
RUN ln -s /usr/local/BEAST-1.8.4/bin/loganalyser /usr/local/bin/loganalyser
RUN ln -s /usr/local/BEAST-1.8.4/bin/logcombiner /usr/local/bin/logcombiner
RUN ln -s /usr/local/BEAST-1.8.4/bin/treeannotator /usr/local/bin/treeannotator
RUN ln -s /usr/local/BEAST-1.8.4/bin/treestat /usr/local/bin/treestat


RUN ln -s /usr/local/BEAST-1.8.4/lib/beast.jar /usr/local/lib/beast.jar
RUN ln -s /usr/local/BEAST-1.8.4/lib/beauti.jar /usr/local/lib/beauti.jar
RUN ln -s /usr/local/BEAST-1.8.4/lib/libNucleotideLikelihoodCore32.so /usr/local/lib/libNucleotideLikelihoodCore32.so
RUN ln -s /usr/local/BEAST-1.8.4/lib/libNucleotideLikelihoodCore.so /usr/local/lib/libNucleotideLikelihoodCore.so

WORKDIR /root

RUN rm -rf build

ENV LD_LIBRARY_PATH /usr/local/beagle-lib-master/lib

CMD cd /mnt/input && /usr/local/bin/beast *.xml && mv *.trees *.ops *.log /mnt/output
