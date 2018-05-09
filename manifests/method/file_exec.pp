# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include hostname::method::file_exec
class hostname::method::file_exec {

  file { '/etc/hostname':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "${::clientcert}\n",
    notify  => Exec['set-hostname'],
  }

  exec { 'set-hostname':
    command => '/bin/hostname -F /etc/hostname',
    unless  => '/usr/bin/test `hostname` = `/bin/cat /etc/hostname`',
  }

}
