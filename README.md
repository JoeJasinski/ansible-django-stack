WORK IN PROGRESS

Support Status
 ubuntu 14.04 trusty = worked well in the past - have not used in awhile
 ubuntu 16.04 xenial = pretty good - tested a bunch of times
 ubuntu 18.04 bionic = experimental
 centos 7 = incomplete ; in progress

The goal of this project is to  create a configurable Ansible project
that allows provisioning a Django web stack with many of the common services
and features associated with such a stack.

Requires Ansible 2.4+

## Quickstart

  1. Copy `extra-vars.example.yml` to `extra-vars.yml`
  2. Customize `extra-vars.yml` with the variables needed for build.
    - See `playbooks/group_vars/all.yml` for common variables to set.
  3. Create or customize an inventory file such as `inventory.ini`.
    - Set ssh connection parameters here.
    - See the example `ansible/inventory.ini`
  4. Choose a playbook to run. Options:
    - To run everything, choose `playbook-all.yml`.
       - Selectively disable roles, use the "ROLE FLAGS TO ENABLE/DISABLE"
         variable flags from `playbooks/group_vars/all.yml`
    - To run specific playbooks, one of the others (see
      Playbooks available below).
    - Create a custom playbook by modifying an existing one.
  5. Run the playbook. Example:


    ansible-playbook -vvvv -i ansible/inventory.ini \
      --extra-vars "@extra-vars.yml" \
      ansible/playbooks/playbook-all.yml


## Playbooks available

For a full provision, mostly use the `playbook-all.yml` (and customize the
ROLL FLAGS - see below).

 - add-user.yml = playbook for adding a UNIX user
 - playbook-all.yml = Run all roles to build a single server with everything
 - playbook-django.yml = Run only a Django project install roles
 - playbook-docker.yml = Run only the role to install Docker and Docker Compose
 - playbook-elasticsearch.yml - Run only an Elasticsearch install.
 - playbook-install-python2.yml = Run to install Python2 on systems that do not
     have it preinstalled (i.e. Ubuntu 16.04)
 - playbook-mysql.yml = Run only the mysql install roles
 - playbook-letsencrypt.yml = Install Letsencrypt; depends on Nginx role.
     Manual execution of Certbot is still needed.
 - playbook-nginx.yml = Run only the Nginx install roles
 - playbook-nrpe.yml = Run only the NRPE install roles
 - playbook-postgis.yml = Run the Postgres and PostGIS install roles
 - playbook-postgres.yml = Run only the Postgres install roles
 - playbook-redis.yml = Run only the Redis server install roles
 - playbook-timezone.yml = Run the timezone role
 - playbook-unattended.yml = Run only the unattended update role


## Run Configuration

This project defines many of the configurable variables inside of the
`ansible/playbooks/group_vars.yml` file. You need to override some of those
variables when provisioning by setting them in an `extra-vars.yml`. Copy the
`extra-vars.example.yml` to use as a starting point for customization.

    cp extra-vars.example.yml extra-vars.yml

IMPORTANT: Customize the following at minimum, but likely more is needed:
  - site_name
  - db_password (if running a database role)
  - git_rep (if installing a Django codebase)

IMPORTANT: If you want to run a specific roll, in ADDITION to being included
in the roles section of a playbook, the roll must ALSO be enabled via setting
a "ROLE FLAG" variable `install_foo: True` in `extra-vars.yml`, where foo is the
name of the roll.  For example, `install_mysql: True`. For the full list of of
"ROLE FLAG" variables, see the section of the `ansible/playbooks/group_vars`
titled "ROLE FLAGS TO ENABLE/DISABLE" to see them and their defaults.

Example: `extra-vars.yml` file

    ---
    site_name: "example"
    db_password: change_me
    git_repo: https://git.example.com/example/example.git
    install_mysql: False
    install_redis: False
    python_version: python2.7

Execute the following to run using the customized `extra-vars.yml` file:

    ansible-playbook -vvvv -i ansible/inventory.ini \
        --extra-vars "@extra-vars.yml" \
        ansible/playbooks/playbook-all.yml

Alternatively, but less preferred, you can pass extra vars directly on the
command line:

    ansible-playbook -vvvv -i ansible/inventory.ini \
        --extra-vars "site_name=mysite python_version=python3.5" \
        ansible/playbooks/playbook-all.yml


## Running

### Run on normal Host

Define the following inventory, changing connection parameters as needed.

    [localhost]
    127.0.0.1 ansible_ssh_port=22 ansible_ssh_user=ubuntu ansible_become=true ansible_ssh_private_key_file=/path/to/private_key

Note: if running on Ubuntu 16.04, you need to execute the following first.

    ansible-playbook -vvvv -i ansible/inventory.ini ansible/playbooks/playbook-install-python2.yml

Run the playbook in this directory

    ansible-playbook -vvvv -i ansible/inventory.ini ansible/playbooks/playbook-all.yml

### Run in Vagrant

Execute the following from within the directory containing the `Vagrant` file.

    vagrant up trusty
    vagrant provision trusty

    # or

    vagrant up xenial
    vagrant provision xenial

    # or

    vagrant up centos7
    vagrant provision centos7

Note: when using vagrant to test, you can optionally use the vagrant-cachier
plugin to cache the apt packages downloaded.

    vagrant plugin install vagrant-cachier

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

            - log/ = Project-specific logs

            - proj/ = (project_dir)
                - *projname*

## Misc

    ansible-playbook ansible/playbook-all.yml --list-tasks

    # Dry Run of tasks (not all tasks supported)
    ansible-playbook --check ansible/playbook-all.yml

    # Check Syntax
    ansible-playbook --syntax-check -vvvv  -i ansible/inventory.ini ansible/playbooks/playbook-all.yml

    # List hosts selected
    ansible-playbook --list-hosts -vvvv  -i ansible/inventory.ini ansible/playbooks/playbook-all.yml

    # Step through each task one by one
    ansible-playbook --step -vvvv  -i ansible/inventory.ini ansible/playbooks/playbook-all.yml

    # Show diff of what changed on changed tasks during execution
    ansible-playbook --diff -vvvv  -i ansible/inventory.ini ansible/playbooks/playbook-all.yml
