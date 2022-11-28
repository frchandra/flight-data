FROM apache/airflow:2.2.4-python3.8
USER root
WORKDIR /root

RUN apt-get update

RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y libtiff-dev
RUN apt-get install -y curl && apt-get install -y libcurl4-openssl-dev

RUN curl -O https://download.osgeo.org/geos/geos-3.7.5.tar.bz2
RUN tar xvfj geos-3.7.5.tar.bz2
WORKDIR /root/geos-3.7.5
RUN mkdir _build
WORKDIR /root/geos-3.7.5/_build
RUN cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ..
RUN make
RUN make install

WORKDIR /root

RUN curl -O https://download.osgeo.org/proj/proj-9.0.0.tar.gz 
RUN tar -xf proj-9.0.0.tar.gz
WORKDIR /root/proj-9.0.0
RUN mkdir build 
WORKDIR /root/proj-9.0.0/build
RUN cmake .. 
RUN cmake --build . 
RUN cmake --build . --target install
RUN cp ./bin/* /bin && cp ./lib/* /lib

USER airflow
WORKDIR /home/airflow
RUN pip install --no-cache-dir --user traffic 