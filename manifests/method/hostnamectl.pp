# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include hostname::method::hostnamectl
class hostname::method::hostnamectl {
  exec { 'set-hostname':
    command => "/usr/bin/hostnamectl set-hostname ${::clientcert}",
    unless  => "/usr/bin/test `hostname` = \"${::clientcert}\"",
  }
}
