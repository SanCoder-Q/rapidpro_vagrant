#!/bin/bash

#enable job control in script
set -e -m

# Clean the previous forked processes
ps -ef | grep [g]unicorn | awk '{print "kill -9 "$2}' | sh

cd /rapidpro
sed -i "s/worker_processes 4;/worker_processes 1;/g" /etc/nginx/nginx.conf
# add static file mapping
#grep sitestatic temba/urls.py || echo "urlpatterns = [
#    url(r'^sitestatic/(?P<path>.*)$','django.views.static.serve',
#        {'document_root':settings.STATIC_ROOT}),
#] + urlpatterns" >> temba/urls.py

echo "========================================================================"
echo "Prepare: configure the environment:"
echo "========================================================================"

python manage.py makemigrations 
python manage.py migrate
python manage.py collectstatic --noinput

sed -ie "s/textcool/${TEMBA_HOST}/g" /etc/nginx/sites-enabled/default
sed -ie "s/SESSION_COOKIE_SECURE = True/#SESSION_COOKIE_SECURE = True/g" /rapidpro/temba/settings/production.py
service nginx restart

newrelic-admin run-program gunicorn -w 2 -t 120 -b :8080 temba.wsgi
