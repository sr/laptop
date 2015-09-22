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
    'stella': {
      include cloud_backup

      # apps
      include chrome
      include dash
      include virtualbox
      include docker
      include dropbox
      include firefox
      include onepassword
      include screen
      include skype
      include steam
      include superduper

      package {
        'OmniFocus':
          provider => 'appdmg_eula',
          source   => 'http://www.omnigroup.com/ftp1/pub/software/MacOSX/10.6/OmniFocus-1.10.6.dmg';
        'TuneUp':
          provider => 'appdmg',
          source   => 'http://dvk2ozaytrec6.cloudfront.net/mac3/Sparkle/TuneUp-3.0.6.dmg';
      }

      # utilities
      include ctags

      homebrew::tap { 'grpc/grpc': }
      package { 'grpc/grpc/grpc': }

      package { 'protobuf':
        ensure => present,
        install_options => [
          '--devel',
          '--c++11',
        ]
      }

      # setup all of the projects
      include projects::all

      # rubies
      ruby::version { '2.2.0': }

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
