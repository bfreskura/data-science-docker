FROM nvidia/cuda:9.1-runtime-ubuntu16.04
FROM nvidia/cuda:9.1-cudnn7-runtime-ubuntu16.04

MAINTAINER Bartol Freškura <freskura.bartol@gmail.com>

RUN mkdir /home/user
ENV HOME /home/user

RUN apt-get update && apt-get install -y \
    zsh \
    git \
    vim \
    tmux \
    python3 python3-dev \
    wget curl \
    htop \
    build-essential \
    unzip \
    yasm \
    pkg-config \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libjasper-dev \
    libavformat-dev \
    cmake \
    libpq-dev

# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && python3 /tmp/get-pip.py \
    && rm /tmp/get-pip.py

RUN pip install numpy virtualenvwrapper  

# Install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Setup virtualenvwrapper
ENV VIRTUALENVWRAPPER_PYTHON /usr/bin/python3
ENV WORKON_HOME $HOME/.virtualenvs
ENV PROJECT_HOME $HOME/Devel
RUN echo "source /usr/local/bin/virtualenvwrapper.sh" >> $HOME/.zshrc

# OpenCV 3 for Python3
WORKDIR /
ENV OPENCV_VERSION="3.4.1"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir /opencv-${OPENCV_VERSION}/build \
&& cd /opencv-${OPENCV_VERSION}/build \
&& cmake -DBUILD_TIFF=ON \
-DBUILD_opencv_java=OFF \
-DWITH_CUDA=OFF \
-DENABLE_AVX=ON \
-DWITH_OPENGL=ON \
-DWITH_OPENCL=ON \
-DWITH_IPP=ON \
-DWITH_TBB=ON \
-DWITH_EIGEN=ON \
-DWITH_V4L=ON \
-DBUILD_TESTS=OFF \
-DBUILD_PERF_TESTS=OFF \
-DCMAKE_BUILD_TYPE=RELEASE \
-DCMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3) \
-DPYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
&& make -j4 && make install \
&& rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION}

# PyTorch 0.4.0
RUN pip install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp35-cp35m-linux_x86_64.whl \
                torchvision

# Clear cache
RUN rm -r ~/.cache/pip/*

WORKDIR $HOME 
ENTRYPOINT /bin/zsh
