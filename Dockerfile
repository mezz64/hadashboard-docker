FROM ubuntu:14.04

MAINTAINER mezz64 <jtmihalic@gmail.com>

# build environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# install packages for dashing
RUN apt-get update && \
	apt-get install software-properties-common -y --no-install-recommends && \
	apt-add-repository ppa:brightbox/ruby-ng && \
	apt-get update && \
	apt-get install -y --no-install-recommends build-essential ruby2.1 ruby2.1-dev python3-pip git node nodejs libsqlite3-dev postgresql-server-dev-9.3 libpq-dev sqlite && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Install dashing and bundle
RUN gem install dashing --no-rdoc --no-ri && \
	gem install bundle --no-rdoc --no-ri && \
	gem install execjs --no-rdoc --no-ri

# Clone hadashboard repository
RUN git clone https://github.com/acockburn/hadashboard.git /hadashboard/ && \
	ln -s /hadashboard /config

# Copy over some files
ADD files/ /hadashboard/

RUN cd /hadashboard && \
	chmod -v +x /hadashboard/start.sh && \
	bundle

# add hapush python helpers
RUN pip3 install daemonize sseclient configobj && \
	pip3 install --upgrade requests

# set volumes
VOLUME /config

# Change to hadashboard working directory
WORKDIR /hadashboard

# expose ports
EXPOSE 3030

CMD [ "/start.sh" ]
