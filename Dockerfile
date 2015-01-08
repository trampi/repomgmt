FROM rails:4.2

ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
WORKDIR /tmp
RUN bundle install
WORKDIR /root
RUN rm -rf /tmp/*
RUN git config --global user.email "example@example.com"
RUN git config --global user.name "example"
