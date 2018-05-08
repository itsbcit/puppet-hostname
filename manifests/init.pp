# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include hostname
class hostname {

  case $facts['os']['name'] {
    'Alpine':
      { $os_codename = "alpine-${facts['os']['release']['major']}.${facts['os']['release']['minor']}"}
    'RedHat','CentOS','OracleLinux','Scientific':
      { $os_codename = "el${facts['os']['release']['major']}" }
    'Fedora':
      { $os_codename = "fedora-${facts['os']['release']['major']}" }
    'Ubuntu','Debian':
      { $os_codename = $facts['os']['codename'] }
    default:
      { fail("Unsupported OS name: \'${facts['os']['name']}\'") }
  }

  if ( $::clientcert =~ /^localhost/ ) {
    fail('Host name cannot be \"localhost\". Use --certname for Puppet client registration.')
  }

  # RedHat and CentOS 6 and earlier use a simple /etc/hostname file with no control program
  if ( ($facts['os']['family'] == 'RedHat') and ($facts['os']['name'] != 'Fedora') ) {
    if $facts['os']['release']['major'] <= '6' {
      include ::hostname::method::file_exec
    }
  }
}
