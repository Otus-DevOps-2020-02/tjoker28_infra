#!/bin/bash
git clone -b monolith https://github.com/express42/reddit.git
cd reddit
bundle install
sudo mv ../pumaapp.service /etc/systemd/system/
sudo systemctl enable pumaapp.service
sudo systemctl start pumaapp.service
