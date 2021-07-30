# Dockerfile to have a container with everything ready to build speculos,
# assuming that neither OpenSSL nor cmocka were updated.
#
# Support Debian buster & Ubuntu Bionic

FROM docker.io/library/python:3.9-slim
ENV LANG C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -qy \
    cmake \
    git \
    curl \
    gcc-multilib  \ 
    g++-multilib  \
    bzip2 \
    xz-utils  \
    # gcc-arm-none-eabi \
    # build-essential \
    gcc-multilib g++-multilib \
    nodejs npm \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/  && \
  npm install --global yarn

RUN mkdir dev-env && \
    mkdir dev-env/SDK && \
    mkdir dev-env/CC && \
    mkdir dev-env/CC/others && \
    mkdir dev-env/CC/nanox && \
    wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 && \
    mv gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 dev-env/CC/others/  && \
    cd dev-env/CC/others/  && \
    tar xf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2  && \
    rm -Rf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2  && \
    cp -r gcc-arm-none-eabi-10-2020-q4-major ../nanox/gcc-arm-none-eabi-10-2020-q4-major  && \
    cd -  && \
    wget http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -O clang+llvm.tar.xz  && \
    tar xf clang+llvm.tar.xz  && \
    rm clang+llvm.tar.xz  && \
    cp -r clang+llvm* dev-env/CC/others/clang-arm-fropi && \
    mv clang+llvm* dev-env/CC/nanox/clang-arm-fropi  && \
    git clone https://github.com/LedgerHQ/nanos-secure-sdk.git && \
    mv nanos-secure-sdk* dev-env/SDK/nanos-secure-sdk

RUN pip3 install construct flake8 flask flask_restful jsonschema mnemonic pycrypto pyelftools pbkdf2 pytest Pillow requests ledgerblue

COPY . /app
WORKDIR /app

CMD ["make"]