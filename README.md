WORK IN PROGRESS

Requires Ansible 2.0+

## Playbooks available

 - playbook-all.yml = Run all roles to build a single server with everything
 - playbook-django.yml = Run only a django project install roles
 - playbook-mysql.yml = Run only the mysql install roles
 - playbook-nginx.yml = Run only the nginx install roles
 - playbook-nrpe.yml = Run only the nrpe install roles
 - playbook-postgis.yml = Run the postgres and postgis install roles
 - playbook-postgres.yml = Run only the postgres install roles
 - playbook-redis.yml = Run only the Redis server install roles

## Running

### Run on normal Host

Define the following inventory, changing connection parameters as needed.

    [localhost]
    127.0.0.1 ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_become=true ansible_ssh_private_key_file=/path/to/private_key

Run the playbook in this directory

    ansible-playbook -vvvv -i ansible/inventory.ini ansible/playbooks/playbook-all.yml

### Run in Vagrant

    vagrant up trusty
    vagrant provision trusty

    # or

    vagrant up xenial
    vagrant provision xenial

### Run in Docker

    sudo docker build -t ansible/django .

    sudo docker run -p 80 -p 443 \
      -v `pwd`:/srv/ansible/ \
      -v `pwd`/log/:/srv/site/log/ \
      -e DEBUG='True' \
      --rm -it ansible/django /srv/ansible/run.sh

## Project Directory structure

By default, this set of Ansbile playbooks will create the following project
directory structure.

- /srv/ = (sites_dir)
    - site/ = (site_dir) all related website material
        - envs/ = (virtualenvs_dir) one or more virtualenvs
            - *sitename* = (virtualenv_dir_link) symlink to recent virtualenv dir
            - *sitename-date* = actual virtualenv

        - data/
            - SQL import files or misc data

        - etc/ = (site_etc_dir)
            - nginx/ = (site_nginx_dir) site-specific nginx configuration
            - other config...

        - htdocs/ = (htdocs_dir) = root of nginx document root
            - media/ = (htdocs_media_dir) location of uploaded media files
            - static/ = (htdocs_static_dir) root of collectstatic
            - maintenance.html

        - proj/ = (project_dir)
            - *projname*

## Misc

ansible-playbook ansible/playbook-all.yml --list-tasks

ansible-playbook --check ansible/playbook-all.yml
