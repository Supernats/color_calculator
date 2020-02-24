FROM ruby:2.6

ENV APP_HOME /color_calculation
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME/
ADD .irbrc $HOME/

RUN bundle install
