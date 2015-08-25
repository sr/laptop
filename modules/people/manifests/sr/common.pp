class people::sr::common {
  # osx settings
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::keyboard::capslock_to_control

  package { 'VyprVPN':
    provider => 'appdmg',
    source   => 'http://www.goldenfrog.com/downloads/vyprvpn/desktop/mac/production/2.6.5.2546/VyprVPN_v2.6.5.2546.dmg',
  }

  sudoers { "Defaults@${::hostname}":
    type       => 'default',
    parameters => ['timestamp_timeout=1440'],
  }

  # ~/tmp
  file { "/Users/${::boxen_user}/tmp":
    ensure => directory;
  }
}
