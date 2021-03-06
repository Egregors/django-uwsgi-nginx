# Django, uWSGI and Nginx in a container

This Dockerfile allows you to build a Docker container with a fairly standard
and speedy setup for Django with uWSGI and Nginx.

uWSGI from a number of benchmarks has shown to be the fastest server 
for python applications and allows lots of flexibility.

Nginx has become the standard for serving up web applications and has the 
additional benefit that it can talk to uWSGI using the uWSGI protocol, further
elinimating overhead. 

Most of this setup comes from the excellent tutorial on 
https://uwsgi.readthedocs.org/en/latest/tutorials/Django_and_nginx.html

Feel free to clone this and modify it to your liking. And feel free to 
contribute patches.

### Build and run
* docker build -t webapp .
* docker run -d -p 80:80 webapp



### How to attach to container
* docker exce -it CONT_ID /bin/bash



### How to insert your application

In /app currently a django project is created with startproject. You will
probably want to replace the content of /app with the root of your django
project.

* Change project name in Dockerfile if necessary:
line 64-65, myproject -> NAME_YOUR_APP

uWSGI chdirs to /app so in uwsgi.ini you will need to make sure the python path
to the wsgi.py file is relative to that.

* Change name of callable module in uwsgi.ini:
line 29, website -> NAME_YOUR_APP

