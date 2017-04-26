FROM ubuntu:14.04
# Allow software restricted by copyright or legal issues (multiverse)
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    cmake \
    python3.4 \
    python3-pip
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libboost-all-dev
# RUN apt-get install -y libopencv-dev

WORKDIR /app
RUN git clone --recursive https://github.com/rubberviscous/anet2016-cuhk.git
WORKDIR /app/anet2016-cuhk
RUN git submodule update --init
WORKDIR /app
# install Caffe dependencies
RUN apt-get -qq install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev
RUN apt-get -qq install -y --no-install-recommends libboost1.55-all-dev
RUN apt-get -qq install -y libgflags-dev libgoogle-glog-dev liblmdb-dev

# install Dense_Flow dependencies
RUN apt-get -qq install -y libzip-dev

RUN echo "Building OpenCV 2.4.12"
RUN mkdir 3rd-party/
WORKDIR /app/3rd-party

# installing dependencies
RUN apt-get -qq install -y libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils

RUN echo "Downloading OpenCV 2.4.12"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip
RUN wget -O OpenCV-2.4.12.zip https://github.com/Itseez/opencv/archive/2.4.12.zip

RUN unzip OpenCV-2.4.12.zip
WORKDIR /app/3rd-party/opencv-2.4.12
RUN mkdir build
WORKDIR /app/3rd-party/opencv-2.4.12/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_TBB=ON  -D WITH_V4L=ON  -D WITH_QT=ON -D WITH_OPENGL=ON ..
RUN make -j32
RUN cp /app/3rd-party/opencv-2.4.12/build/lib/cv2.so /app

# build dense_flow
WORKDIR /app/anet2016-cuhk/lib/dense_flow
RUN mkdir build 
WORKDIR /app/anet2016-cuhk/lib/dense_flow/build
RUN OpenCV_DIR=/app/3rd-party/opencv-2.4.12/build/ cmake ..
RUN make -j
RUN echo "Dense Flow built"

# build caffe
RUN echo "Building Caffe"
WORKDIR /app/anet2016-cuhk/lib/caffe-action
RUN mkdir build 
WORKDIR /app/anet2016-cuhk/lib/caffe-action/build
RUN OpenCV_DIR=/app/3rd-party/opencv-2.4.12/build/ cmake ..
RUN make -j"$(nproc)"
RUN echo "Caffe Built"

WORKDIR /app/anet2016-cuhk
RUN apt-get -y install python-pip
RUN apt-get install -y python-skimage
RUN pip install -r py_requirements.txt
RUN pip install numpy
RUN apt-get install -y python-opencv
RUN pip install scikit-learn
# RUN pip install scikit-learn