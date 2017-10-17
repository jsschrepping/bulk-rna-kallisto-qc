FROM ubuntu:17.10

RUN apt-get update && \
    apt-get install -y \
    git cmake zlib1g libhdf5-dev build-essential wget curl unzip jq bc openjdk-8-jre perl unzip r-base libxml2-dev \
    libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/makaho/kallisto.git && \
    cd kallisto && mkdir build && cd build && cmake .. && make && make install && \
    cd /root && rm -rf kallisto

# install fastqc
ADD http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip /tmp/

RUN cd /usr/local && \
    unzip /tmp/fastqc_*.zip && \
    chmod 755 /usr/local/FastQC/fastqc && \
    ln -s /usr/local/FastQC/fastqc /usr/local/bin/fastqc && \
    rm -rf /tmp/fastqc_*.zip

COPY install /install
RUN Rscript /install/install.R

RUN wget http://ftpmirror.gnu.org/parallel/parallel-20170922.tar.bz2 && \
    bzip2 -dc parallel-20170922.tar.bz2 | tar xvf - && \
    cd parallel-20170922 && \
    ./configure && make && make install

RUN apt-get update && apt-get install -y python-pip

RUN pip install git+https://github.com/ewels/MultiQC.git@7edc7bbbab1a66f2c028f686b279c9a0c56f92ff

COPY scripts /scripts

ENTRYPOINT ["bash","/scripts/run-all.sh"]
CMD [""]
