FROM debian:wheezy

MAINTAINER saksmlz <saksmlz@gmail.com>

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.3

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

COPY install-ruby.sh /install-ruby.sh

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y curl wget procps make bison ruby bzip2 autoconf gcc build-essential zlib1g-dev \
    libssl-dev libffi-dev libreadline-dev ca-certificates git g++ \
  && /install-ruby.sh \
  && apt-get purge -y --auto-remove curl wget bison ruby bzip2 autoconf build-essential \
    libffi-dev libreadline-dev \
  && rm -rf /var/lib/apt/lists/* /install-ruby.sh

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

RUN gem install bundler \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"

CMD [ "irb" ]
