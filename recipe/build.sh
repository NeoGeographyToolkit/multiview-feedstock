#!/bin/bash

# Recommended in https://gitter.im/conda-forge/conda-forge.github.io?at=5c40da7f95e17b45256960ce
find ${PREFIX}/lib -name '*.la' -delete

git submodule update --init --recursive

mkdir build && cd build

# For OSX use a custom location for TBB. This is a fix for a conflict with embree.
# When that package gets updated to version 3 or 4 this may become unnecesary.
opt=""
if [[ $target_platform =~ osx.* ]]; then
	opt="-DTBB_LIBRARY=${PREFIX}/lib/libtbb.12.dylib -DTBB_MALLOC_LIBRARY=${PREFIX}/lib/libtbbmalloc.2.dylib"
fi

cmake ..                                    \
    -DCMAKE_BUILD_TYPE=Release              \
    -DMULTIVIEW_DEPS_DIR=${PREFIX}          \
    -DCMAKE_VERBOSE_MAKEFILE=ON             \
    -DCMAKE_CXX_FLAGS='-O3 -std=c++11'      \
    -DCMAKE_C_FLAGS='-O3'                   \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}        \
	$opt

make -j${CPU_COUNT}
make install

