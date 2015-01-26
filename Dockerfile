FROM debian:wheezy

MAINTAINER saksmlz <saksmlz@gmail.com>

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.0
ENV LIBMAXMIND_VERSION 1.0.4

COPY install-ruby.sh /install-ruby.sh
COPY install-libmaxminddb.sh /install-libmaxminddb.sh

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y curl wget procps bison ruby bzip2 autoconf gcc build-essential zlib1g-dev \
    libssl-dev libffi-dev libreadline-dev ca-certificates \
  && /install-ruby.sh \
  && /install-libmaxminddb.sh \
  && apt-get purge -y --auto-remove curl wget bison ruby bzip2 autoconf build-essential \
    libssl-dev libffi-dev libreadline-dev \
  && rm -rf /var/lib/apt/lists/*

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

RUN gem install bundler \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

RUN rm /install-ruby.sh
RUN rm /install-libmaxminddb.sh

CMD [ "irb" ]
