FROM ubuntu:14.04
MAINTAINER Joe Jasinski

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ansible python-apt

ADD . /srv/

CMD ["bash"]
