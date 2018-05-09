# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include hostname
class hostname {

  $major   = 0 + pick($facts['os']['release']['major'],0)
  $minor   = 0 + pick($facts['os']['release']['minor'],0)
  $family  = pick_default($facts['os']['family'],'')
  $os_name = pick_default($facts['os']['name'],'')

  case $facts['os']['name'] {
    'Alpine':
      { $os_codename = "alpine-${major}.${minor}" }
    'RedHat','CentOS','OracleLinux','Scientific':
      { $os_codename = "el${major}" }
    'Fedora':
      { $os_codename = "fedora-${major}" }
    'Ubuntu':
      { $os_codename = $facts['os']['codename'] }
    'Debian':
      {
        case $major {
          7: { $os_codename = 'Wheezy' }
          8: { $os_codename = 'Jessie' }
          9: { $os_codename = 'Stretch' }
          default: {
            notice("Unknown Debian version: ${major}.")
            $os_codename = "debian-${major}"
          }
        }
      }
    default:
      { fail("Unsupported OS: \'${os_name}\'") }
  }

  if ( $::clientcert =~ /^localhost/ ) {
    fail('Host name cannot be \"localhost\". Use --certname for Puppet client registration.')
  }

  # hostnamectl can't be set in docker
  if ( $facts['virtual'] == 'docker' ) {
    notice('Setting hostname in docker containers is not supported.')
    include ::hostname::method::noop
  }
  # RedHat family version 6 and earlier use a simple /etc/hostname file with no control program
  # Fedora has its own numbering system, so we exclude it from the rest of the Red Hat family
  # ASSUMPTION: this code assumes no EOL Fedora versions
  elsif ( $os_name == 'Fedora' ) {
    include ::hostname::method::hostnamectl
  }
  elsif ( ($family == 'RedHat') and ($major <= 6) ) {
    include ::hostname::method::file_exec
  }
  # Red Hat family version 7 and up uses hostnamectl
  elsif ( $family == 'RedHat' ) {
    include ::hostname::method::hostnamectl
  }
  # Only Xenial comes with hostnamectl pre-installed?
  elsif ( $os_codename == 'Xenial' ) {
    include ::hostname::method::hostnamectl
  }
  elsif ( $os_codename == 'Trusty' ) {
    include ::hostname::method::file_exec
  }
  elsif ( ($family == 'Debian') and ($major <= 7) ) {
    include ::hostname::method::file_exec
  }
  elsif ( $family == 'Debian' ) {
    include ::hostname::method::hostnamectl
  }
  else {
    fail("Unsupported OS version: ${family} ${major}.${minor}")
  }

}
