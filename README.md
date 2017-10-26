# Puppet master 5 vagrant test with docker


- https://github.com/puppetlabs/puppet-in-docker

- https://github.com/puppetlabs/puppet-in-docker-examples

Example with compose

## Images

- https://hub.docker.com/r/puppet/puppetdb/tags/
- https://hub.docker.com/r/puppet/puppetexplorer/tags/
- https://hub.docker.com/r/puppet/puppetboard/tags/
- https://hub.docker.com/r/puppet/puppetdb-postgres/tags/
- https://hub.docker.com/r/puppet/puppetserver/tags/
- https://hub.docker.com/r/puppet/puppet-agent-ubuntu/tags/

##

    apt-get install -y r10k
    mkdir -p /etc/puppetlabs/r10k/
    # if you want the basic config
    cp /usr/share/doc/r10k/r10k.yaml.example /etc/puppetlabs/r10k/r10k.yaml


Three settings are useful:

    cachedir: '/var/cache/r10k'
    remote: 'git@github.com:my-org/org-operations-modules'
    basedir: '/etc/puppetlabs/puppet/environments'


- The location to use for storing cached Git repos :cachedir: '/var/cache/r10k'

##

    :sources:
      # This will clone the git repository and instantiate an environment per
      :test:
        remote: 'git@github.com:test/test-puppetmaster.git'
        basedir: '/etc/puppetlabs/code/environments'

    git:
      private_key: '/root/.ssh/id_rsa'


    /etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules
