FROM ubuntu:trusty
MAINTAINER Ryan Baumann <ryan.baumann@gmail.com>

# Install the Ubuntu packages.
# The Duke mirror is just added here as backup for occasional main flakiness.
RUN echo deb http://archive.linux.duke.edu/ubuntu/ trusty main >> /etc/apt/sources.list 
RUN echo deb-src http://archive.linux.duke.edu/ubuntu/ trusty main >> /etc/apt/sources.list
RUN apt-get update

# Install Ruby, RubyGems, Bundler, MySQL, Git, wget, svn, java
RUN apt-get install -y mysql-server git wget subversion
# openjdk-7-jre
# Install ruby-build build deps
RUN apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# Install oraclejdk8
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default

# Set the locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
WORKDIR /root

# Install rbenv/ruby-build
RUN git clone git://github.com/sstephenson/rbenv.git .rbenv
ENV PATH /root/.rbenv/bin:/root/.rbenv/shims:$PATH
RUN echo 'eval "$(rbenv init -)"' > /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh
RUN git clone git://github.com/sstephenson/ruby-build.git #.rbenv/plugins/ruby-build
RUN cd ruby-build; ./install.sh

# Clone the repository
# RUN git clone https://github.com/sosol/sosol.git
# RUN cd sosol; git branch --track rails-3 origin/rails-3
# RUN cd sosol; git checkout rails-3

# Copy in secret files
# ADD development_secret.rb /root/sosol/config/environments/development_secret.rb
# ADD test_secret.rb /root/sosol/config/environments/test_secret.rb
# ADD production_secret.rb /root/sosol/config/environments/production_secret.rb

ADD . /root/sosol/

# Configure MySQL
RUN java -version
RUN jruby -v
ENV RAILS_ENV test
RUN cd /root/sosol; ./script/setup

# Finally, start the application
# EXPOSE 3000
# CMD service mysql restart; cd sosol; ./script/server
