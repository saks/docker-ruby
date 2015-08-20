#!/usr/bin/env bash

mkdir -p /usr/src/ruby            && \
curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" | tar -xjC /usr/src/ruby --strip-components=1 && \
cd /usr/src/ruby                  && \
autoconf                          && \
./configure --disable-install-doc && \
make -j"$(nproc)"                 && \
make install                      && \
rm -r /usr/src/ruby
