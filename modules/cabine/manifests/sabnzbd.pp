class cabine::sabnzbd {
    # sabnzbd.ini variables
    $logdir = $cabine::config::sabnzbd_logdir
    $admindir = $cabine::config::sabnzbd_admindir
    $downloaddir = $cabine::config::sabnzbd_incompletedir
    $completedir = $cabine::config::sabnzbd_completedir
    $scriptdir = $cabine::config::sabnzbd_autoprocessdir
    $nzbkey = $cabine::config::sabnzbd_nzbkey
    $apikey = $cabine::config::sabnzbd_apikey

    # daemon template variables
    $repodir = $cabine::config::sabnzbd_repodir
    $configdir = $cabine::config::sabnzbd_configdir
    $configfile = "${configdir}/config.ini"
    $executable = "${repodir}/SABnzbd.py"

    require python

    package {
        'pysqlite':
            ensure   => '2.6.3',
            provider => pip;
        'Cheetah':
            ensure   => '2.4.4',
            provider => pip;
        'pyOpenSSL':
            ensure   => latest,
            provider => pip;
    }

    repository { $repodir:
        ensure  => '0.7.20',
        source  => 'sabnzbd/sabnzbd',
        require => File[$cabine::config::sabnzbd_datadir],
    }

    file { $configfile:
        content => template('cabine/sabnzbd2.ini.erb'),
        replace => false,
        require => File[$configdir],
        notify  => Service['dev.sabnzbd'],
    }

    Ini_setting {
      path => $configfile,
      ensure => present,
      require => File[$configfile],
      notify  => Service['dev.sabnzbd'],
    }

    ini_setting {
      'log_dir':
        section => 'misc',
        setting => 'log_dir',
        value => $logdir;
      'admin_dir':
        section => 'misc',
        setting => 'admin_dir',
        value   => $admindir;
      'download_dir':
        section => 'misc',
        setting => 'download_dir',
        value   => $downloaddir;
      'complete_dir':
        section => 'misc',
        setting => 'complete_dir',
        value   => $completedir;
      'script_dir':
        section => 'misc',
        setting => 'script_dir',
        value   => $scriptdir;
      'nzb_key':
        section => 'misc',
        setting => 'nzb_key',
        value   => $nzbkey;
      'api_key':
        section => 'misc',
        setting => 'api_key',
        value   => $apikey;
    }

    file { '/Library/LaunchDaemons/dev.sabnzbd.plist':
        content => template('cabine/dev.sabnzbd.plist.erb'),
        group   => 'wheel',
        owner   => 'root',
        notify  => Service['dev.sabnzbd'],
    }

    service { 'dev.sabnzbd':
        ensure  => running,
        require => Repository[$repodir],
    }
}
