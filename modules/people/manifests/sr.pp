class people::sr {
  $boxen_bin = "${::boxen_home}/bin"
  $home = "/Users/${::boxen_user}"

  # osx settings
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
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

  case $::hostname {
    'stella': {
      include boxen::security
      include cloud_backup

      # ~/tmp
      file { "/Users/${::boxen_user}/tmp":
        ensure => directory;
      }

      # apps
      include chrome
      include dash
      include dropbox
      include firefox
      include onepassword
      include screen
      include steam
      include superduper

      package {
        'Backblaze':
          provider => 'appdmg',
          source   => 'https://secure.backblaze.com/mac/install_backblaze.dmg';
        'OmniFocus':
          provider => 'appdmg_eula',
          source   => 'http://www.omnigroup.com/ftp1/pub/software/MacOSX/10.6/OmniFocus-1.10.6.dmg';
        'TuneUp':
          provider => 'appdmg',
          source   => 'http://dvk2ozaytrec6.cloudfront.net/mac3/Sparkle/TuneUp-3.0.6.dmg';
      }

      # utilities
      include ctags
      package { [
        'ansible',
        'bash-completion',
        'cowsay',
        'dash',
        'fortune',
        'jq',
        'keychain',
        'mplayer',
        'notmuch',
        'offlineimap',
        'pstree',
        'pwgen',
        'siege',
        'ssh-copy-id',
        'tig',
        'tree',
        'wget',
      ]: }

      # setup all of the projects
      include projects::all

      # rubies
      ruby::version { '1.9.3': }
      ruby::version { '2.0.0': }
      ruby::version { '2.0.0-p353': }
      ruby::version { '2.1.0': }
      ruby::version { '2.1.1': }

      ruby_gem { 'bundler':
        gem          => 'bundler',
        version      => '~>1.6',
        ruby_version => '*',
      }

      ruby_gem {
        'rb-appscript':
          ruby_version => '2.1.1',
          gem          => 'rb-appscript',
          version      => '0.6.1';
        'faraday':
          ruby_version => '2.1.1',
          gem          => 'faraday',
          version      => '0.9.0';
      }

      $omnifocus_sync = "/Users/${::boxen_user}/bin/omnifocus-gh-sync"

      cron { 'gh-omnifocus-sync':
        command     => $omnifocus_sync,
        user        => $::boxen_user,
        special     => 'hourly',
        environment => [
          'SHELL="/bin/bash"'
        ],
      }

      # heroku client
      $hkurl = 'https://hkdist.s3.amazonaws.com/hk/20140514/darwin-amd64.gz'
      $hkdest = "${boxen_bin}/hk"

      exec { 'download hk binary':
        command => "/usr/bin/curl '${hkurl}' | zcat > '${hkdest}'",
        creates => $hkdest,
        require => File[$boxen_bin],
      }

      file { $hkdest:
        mode    => '0750',
        require => Exec['download hk binary'],
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
