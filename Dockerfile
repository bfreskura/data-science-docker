FROM nvidia/cuda:9.1-runtime-ubuntu16.04
FROM nvidia/cuda:9.1-cudnn7-runtime-ubuntu16.04

MAINTAINER Bartol Freškura <freskura.bartol@gmail.com>

RUN apt-get update && apt-get install -y \
    sudo \
    zsh \
    git \
    vim \
    tmux \
    python3 python3-dev \
    wget curl \
    htop \
  && rm -rf /var/lib/apt/lists/*

# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
RUN python3 /tmp/get-pip.py

RUN pip install numpy scipy scikit-learn pandas jupyter virtualenvwrapper  

# PyTorch 0.4.0
RUN pip install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp35-cp35m-linux_x86_64.whl torchvision

RUN mkdir /home/user
ENV HOME /home/user

# Install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Setup virtualenvwrapper
ENV VIRTUALENVWRAPPER_PYTHON /usr/bin/python3
ENV WORKON_HOME $HOME/.virtualenvs
ENV PROJECT_HOME $HOME/Devel
RUN echo "source /usr/local/bin/virtualenvwrapper.sh" >> $HOME/.zshrc

COPY .tmux.conf $HOME

WORKDIR $HOME 
ENTRYPOINT /bin/zsh
