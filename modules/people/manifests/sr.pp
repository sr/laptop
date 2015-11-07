class people::sr {
  $boxen_bin = "${::boxen_home}/bin"
  $home = "/Users/${::boxen_user}"

  include people::sr::common

  case $::hostname {
    'frida': {
      package {
        'OmniFocus':
          provider => 'appdmg_eula',
          source   => 'http://www.omnigroup.com/ftp1/pub/software/MacOSX/10.10/OmniFocus-2.2.4.dmg';
      }

      $hosts = [
        'facebook.com',
        'www.facebook.com',
        'twitter.com',
        'www.twitter.com',
        'arseblog.com',
        'news.arseblog.com',
        'theguardian.com',
        'www.theguardian.com',
      ]

      host { $hosts:
        ensure => present,
        ip     => '127.0.0.1',
      }

      package { 'tarsnap': }

      file { ['/opt/tarsnap', '/opt/tarsnap/cache']:
        ensure => directory
      }
    }

    'dana': {
      notice('dana')
    }

    default: {
      fail("Unknown machine: ${::hostname}")
    }
  }
}
