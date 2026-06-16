FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RUBY_VERSION=3.0.3
ENV TZ=Africa/Nairobi

RUN apt-get update -qq && apt-get install -y \
    curl git build-essential libssl-dev libreadline-dev \
    zlib1g-dev libpq-dev postgresql-client wget gnupg2 tzdata
# Node 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Yarn
RUN wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install -y yarn

# rbenv + Ruby 3.0.3
RUN git clone https://github.com/rbenv/rbenv.git /usr/local/rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

RUN rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

WORKDIR /manyoo-rails-task
COPY Gemfile /manyoo-rails-task/Gemfile
COPY Gemfile.lock /manyoo-rails-task/Gemfile.lock
RUN gem install bundler:2.5.10
RUN gem install nokogiri --platform=ruby
RUN bundle config set force_ruby_platform true
RUN bundle install
COPY . /manyoo-rails-task
RUN yarn install
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]