WORK IN PROGRESS

The goal of this project is to  create a configurable Ansible project
that allows provisioning a Django web stack with many of the common services
and features associated with such a stack.

Requires Ansible 2.0+

## Playbooks available

 - add-user.yml = playbook for adding a UNIX user
 - playbook-all.yml = Run all roles to build a single server with everything
 - playbook-django.yml = Run only a django project install roles
 - playbook-install-python2.yml = Run to install Python2 on systems that do not
     have it preinstalled (i.e. Ubuntu 16.04)
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

Note: if running on Ubuntu 16.04, you need to execute the following first.

    ansible-playbook -vvvv -i ansible/inventory.ini ansible/playbooks/playbook-install-python2.yml

Run the playbook in this directory

    ansible-playbook -vvvv -i ansible/inventory.ini ansible/playbooks/playbook-all.yml


## Run Customization

This project defines many of the configurable variables inside of the ansible/env_vars/base.yml file. You can override those variables when provisioning by passing in a new value via the --extra-vars (-e) option as exemplified below.

IMPORTANT - you will want to customize the following at minimum:
  - site_name
  - db_password (if running a database role)
  - git_rep (if installing a django codebase)


    ansible-playbook -vvvv -i ansible/inventory.ini --extra-vars "site_name=mysite python_version=python3.5" \
        ansible/playbooks/playbook-all.yml


### Run in Vagrant

    vagrant up trusty
    vagrant provision trusty

    # or

    vagrant up xenial
    vagrant provision xenial

### Run in Docker

For quick testing, it may help to run this project inside a Docker container.
To do so, the following will commands will bootstrap that process.

    sudo docker build -t ansible/django .

    sudo docker run -p 80 -p 443 \
      -v `pwd`:/srv/ansible/ \
      -v `pwd`/log/:/srv/site/log/ \
      -e DEBUG='True' \
      --rm -it ansible/django /srv/ansible/run.sh

## Project Directory structure

By default, this set of Ansible playbooks will create the following project
directory structure.

- /srv/ = (top_dir)
    - sites/ = (sites_dir)
        - bin/ = (sites_bin_dir) shared scripts and binary files common to all
        - *sitename*/ = (site_dir) all related website material
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
