FROM ruby:3.1.2

RUN apt-get update -qq \
    && apt-get install -y \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \
    libvips \
    npm \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN npm uninstall -g yarn && \
    rm -rf /usr/local/bin/yarnpkg && \
    rm -rf /usr/local/bin/yarn && \
    npm install -g yarn

RUN npm install -g n && \
    n 14

WORKDIR /app
COPY Gemfile* ./
RUN bundle install -j16
# COPY package.json yarn.lock ./
RUN yarn install
COPY . /app

COPY ./docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
