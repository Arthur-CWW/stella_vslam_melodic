#! /usr/bin/env bash
# go up a directory to the root of the repository for libs


set -euo pipefail
CMAKE_INSTALL_PREFIX=/usr/local

# CPATH=${CMAKE_INSTALL_PREFIX}/include:${CPATH}
# C_INCLUDE_PATH=${CMAKE_INSTALL_PREFIX}/include:${C_INCLUDE_PATH}
# CPLUS_INCLUDE_PATH=${CMAKE_INSTALL_PREFIX}/include:${CPLUS_INCLUDE_PATH}
# LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:${LIBRARY_PATH}
# LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:${LD_LIBRARY_PATH}
NUM_THREADS=4

# NVIDIA_VISIBLE_DEVICES "${NVIDIA_VISIBLE_DEVICES:-all}"
# NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# shellcheck disable=SC1091
source /opt/ros/melodic/setup.bash

sudo apt-get install ros-melodic-libg2o  ros-melodic-tf2-geometry-msgs
LIBS="$HOME/catkin_ws/external"
echo "LIBS: $LIBS"
# file path


G2O_COMMIT=20230223_git
cd /tmp
# set -x
git clone https://github.com/RainerKuemmerle/g2o.git && \
cd g2o && \
git checkout ${G2O_COMMIT} && \
mkdir -p build && \
cd build && \
cmake \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_UNITTESTS=OFF \
	-DG2O_USE_CHOLMOD=OFF \
	-DG2O_USE_CSPARSE=ON \
	-DG2O_USE_OPENGL=OFF \
	-DG2O_USE_OPENMP=OFF \
	-DG2O_BUILD_APPS=OFF \
	-DG2O_BUILD_EXAMPLES=OFF \
	-DG2O_BUILD_LINKED_APPS=OFF \
	..
make -j${NUM_THREADS} && \
sudo make install



FILE_PATH="$LIBS/stella_vslam_melodic"
mkdir -p "$FILE_PATH/build"
cd "$FILE_PATH/build"
# shellcheck disable=SC1091
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo  \
 -Dg2o_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/g2o \
 	..
make -j 4
sudo make install
# cd "$LIBS"
# git clone -b 0.0.1 --recursive https://github.com/stella-cv/pangolin_viewer.git
# mkdir -p pangolin_viewer/build
# cd pangolin_viewer/build
# cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
# make -j
# sudo make install



