FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron
RUN apt-get update && apt-get -y install nodejs
RUN apt-get update && apt-get -y install npm

# Copy cronfile file to the cron.d directory
COPY cronfile /etc/cron.d/cronfile
COPY package.json /package.json
COPY .env /.env
COPY topNews.js /topNews.js

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cronfile
RUN chmod 0744 /topNews.js

# Setup for running script
RUN mkdir /beacons
RUN chmod 0775 /beacons
RUN npm install

# Apply cron job
RUN crontab /etc/cron.d/cronfile

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log