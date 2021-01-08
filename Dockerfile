FROM nvidia/cuda:9.2-base-ubuntu16.04
# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    curl \
    vim \
    ca-certificates \
    python-qt4 \
    libjpeg-dev \
    zip \
    unzip \
    openssh-client \
    libpng-dev \
    wget \
    software-properties-common &&\
    rm -rf /var/lib/apt/lists/*\
    
RUN add-apt-repository ppa:git-core/ppa -y

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PYTHON_VERSION=3.6

RUN curl -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install conda-build
    
RUN wget -O- http://neuro.debian.net/lists/xenial.us-nh.libre | sudo /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
RUN apt-get update && apt-get install -y --no-install-recommends datalad git

ENV PATH=$PATH:/opt/conda/bin/
ENV USER fastai
# Create Environment
COPY environment.yaml /environment.yaml
RUN conda env create -f environment.yaml

WORKDIR /notebooks
# Activate Source
CMD source activate fastai
CMD source ~/.bashrc

RUN chmod -R a+w /notebooks
WORKDIR /notebooks

COPY config.yml /root/.fastai/config.yml
COPY run.sh /run.sh

CMD ["/run.sh"]
