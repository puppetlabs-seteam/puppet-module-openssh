class openssh {
 
  # The openssh::params class dynamically sets variables for things like the
  # service name and package name, dependent on platform-specific
  # considerations.
  include openssh::params
 
  package { 'openssh-server':
    ensure => installed,
    name   => $openssh::params::package,
    before => File['sshd_config'],
  }
 
  file { 'sshd_config':
    ensure => file,
    path   => $openssh::params::sshd_config,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
 
  sshd_config { 'PermitRootLogin':
    value   => 'without-password',
    require => File['sshd_config'],
    notify  => Service['openssh'],
  }
 
  file_line { 'StrictHostKeyChecking':
    path    => $openssh::params::ssh_config,
    line    => 'StrictHostKeyChecking yes',
    match   => '^StrictHostKeyChecking .*',
    require => Package['openssh-server'],
    notify  => Service['openssh'],
  }
 
  service { 'openssh':
    ensure => running,
    enable => true,
    name   => $openssh::params::service,
  }
 
  # Exported resources allow nodes with this class applied to publish
  # configuration for other systems to request and make use of in configuring
  # themselves.
  @@sshkey { $::clientcert:
    ensure       => present,
    key          => $::sshrsakey,
    type         => 'ssh-rsa',
    host_aliases => [
      $::fqdn,
      $::hostname,
      $::ipaddress_eth0,
      $::ipaddress_eth1
    ],
  }
 
  # Resource collectors are the flip side of exported resources, and are used
  # to find and realize resources published by other systems. This stanza
  # collects all rsa keys from Puppet-managed hosts in the environment.
  Sshkey <<| type == 'ssh-rsa' |>>
 
  # Finally, we want to remove any keys found that aren't coming from a
  # Puppet-managed system.
  resources { 'sshkey':
    purge => true,
  }
 
}
