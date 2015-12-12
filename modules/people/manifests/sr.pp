class people::sr {
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::keyboard::capslock_to_control

  $boxen_bin = "${::boxen_home}/bin"
  $home = "/Users/${::boxen_user}"

  sudoers { "Defaults@${::hostname}":
    type       => 'default',
    parameters => ['timestamp_timeout=1440'],
  }

  include chrome
  include dropbox
  include screen
  include xquartz

  package {
    'Backblaze':
      provider => 'appdmg',
      source   => 'https://secure.backblaze.com/mac/install_backblaze.dmg';
    'Kindle':
      provider => 'appdmg',
      source   => 'http://kindleformac.amazon.com/40961/KindleForMac.dmg';
    'OmniFocus':
      provider => 'appdmg_eula',
      source   => 'http://www.omnigroup.com/ftp1/pub/software/MacOSX/10.10/OmniFocus-2.2.4.dmg';
    'VyprVPN':
      provider => 'appdmg',
      source   => 'http://www.goldenfrog.com/downloads/vyprvpn/desktop/mac/production/2.6.5.2546/VyprVPN_v2.6.5.2546.dmg';
  }

  package { [
    'bash-completion',
    'mosh',
    'namebench',
    'pstree',
    'ssh-copy-id',
    'tarsnap',
    'tig',
    'tree',
  ]: }

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

  file { ['/opt/tarsnap', '/opt/tarsnap/cache']:
    ensure => directory
  }
}
