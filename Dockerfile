# Copyright 2013 Thatcher Peskens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:trusty

MAINTAINER Egregors (llamaontheboat@gmail.com)

RUN apt-get update
RUN apt-get install -y build-essential git
RUN apt-get install -y python python-dev python-setuptools
RUN apt-get install -y nginx supervisor
RUN easy_install pip

# install uwsgi now because it takes a little while
RUN pip install uwsgi

# install nginx
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN apt-get update
RUN add-apt-repository -y ppa:nginx/stable

# install database
RUN apt-get install -y sqlite3

# Install specific lib's for current app
# Install staff for work with images (need for ckeditor in Django)
RUN apt-get install -y libjpeg-dev zlib1g-dev libpng12-dev

# install our code
# from host folder
ADD . /home/docker/code/
# or from git
# RUN cd /home/docker/code/app && git clone URL

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

# RUN pip install
RUN pip install -r /home/docker/code/app/requirements.txt

# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
# RUN django-admin.py startproject app /home/docker/code/app/ 
RUN cd /home/docker/code/app && ./manage.py syncdb --noinput
RUN cd /home/docker/code/app && ./manage.py collectstatic --noinput

# Turn off debug mode
# !!! Change «myproject» to name of your project
RUN echo "DEBUG = False" >> /home/docker/code/app/myproject/settings.py
RUN echo "TEMPLATE_DEBUG = False" >> /home/docker/code/app/myproject/settings.py

EXPOSE 80
CMD ["supervisord", "-n"]
