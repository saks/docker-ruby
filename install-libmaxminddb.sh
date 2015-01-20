#!/usr/bin/env bash

cd /tmp/
wget https://github.com/maxmind/libmaxminddb/releases/download/$LIBMAXMIND_VERSION/libmaxminddb-$LIBMAXMIND_VERSION.tar.gz
tar zxvf libmaxminddb-$LIBMAXMIND_VERSION.tar.gz
cd libmaxminddb-$LIBMAXMIND_VERSION
./configure
make -j"$(nproc)"
make check
make install
ldconfig
cd /tmp/
rm libmaxminddb-$LIBMAXMIND_VERSION.tar.gz
rm -r libmaxminddb-$LIBMAXMIND_VERSION
ldconfig -p | grep -q libmaxminddb.so
