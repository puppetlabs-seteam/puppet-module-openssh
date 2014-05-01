class openssh::params {
 
  case $::osfamily {
    'RedHat': {
      $sshd_config = '/etc/ssh/sshd_config'
      $ssh_config  = '/etc/ssh/ssh_config'
      $package     = 'openssh-server'
      $service     = 'sshd'
    }
    'Debian': {
      $sshd_config = '/etc/ssh/sshd_config'
      $ssh_config  = '/etc/ssh/ssh_config'
      $package     = 'openssh-server'
      $service     = 'ssh'
    }
    default: {
      fail("${::osfamily} is not supported by the openssh module")
    }
  }
 
}
