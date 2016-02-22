FROM ubuntu:14.04
MAINTAINER Joe Jasinski

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ansible python-apt

ADD . /srv/ansible/

RUN ansible-playbook -vvvv --inventory-file=/srv/ansible/ansible/inventory.ini \
   /srv/ansible/ansible/site.yml -c local

CMD ["/srv/ansible/run.sh"]
EXPOSE 80 443
