# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include hostname
class hostname {
  case $facts['os']['name'] {
    default: { fail("Unsupported OS name: \'${facts['os']['name']}\'")}
  }
}
