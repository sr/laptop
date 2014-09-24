class cabine::sabnzbd {
    $repodir = $cabine::config::sabnzbd_repodir
    $configdir = $cabine::config::sabnzbd_configdir
    $logdir = $cabine::config::sabnzbd_logdir
    $configfile = "${configdir}/config.ini"
    $executable = "${repodir}/SABnzbd.py"

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
        source  => 'sabnzbd/sabnzbd',
        require => File[$cabine::config::sabnzbd_datadir],
    }

    file { $configfile:
        content => template('cabine/sabnzbd.ini.erb'),
        notify  => Service['org.atonie.sabnzbd'],
        require => File[$configdir],
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
