class people::sr::common {
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::keyboard::capslock_to_control

  sudoers { "Defaults@${::hostname}":
    type       => 'default',
    parameters => ['timestamp_timeout=1440'],
  }

  file { "/Users/${::boxen_user}/tmp":
    ensure => directory;
  }

  include dropbox
  include screen
  include chrome

  package {
    'Backblaze':
      provider => 'appdmg',
      source   => 'https://secure.backblaze.com/mac/install_backblaze.dmg';
    'VyprVPN':
      provider => 'appdmg',
      source   => 'http://www.goldenfrog.com/downloads/vyprvpn/desktop/mac/production/2.6.5.2546/VyprVPN_v2.6.5.2546.dmg';
    'Kindle':
      provider => 'appdmg',
      source   => 'http://kindleformac.amazon.com/40961/KindleForMac.dmg';
  }

  package { [
    'ansible',
    'bash-completion',
    'cowsay',
    'dash',
    'fortune',
    'jq',
    'keychain',
    'mosh',
    'mplayer',
    'namebench',
    'notmuch',
    'offline-imap',
    'pstree',
    'pwgen',
    's3cmd',
    'siege',
    'ssh-copy-id',
    'tig',
    'tree',
    'wget',
    'youtube-dl',
  ]: }
}
