class cabine::sickbeard {
    $repodir = $cabine::config::sickbeard_repodir
    $configdir = $cabine::config::sickbeard_configdir
    $configfile = "${configdir}/config.ini"
    $executable = "${repodir}/SickBeard.py"

    repository { $repodir:
        source => 'midgetspy/Sick-Beard',
        ensure => 'fb37d332b333b43e7bcae46b619ae6b7ef94e266'
    }

    file { $configfile:
        content => template('cabine/sickbeard.ini.erb'),
        notify  => Service['org.atonie.sickbeard']
    }

    file { "${cabine::config::sickbeard_autoprocessdir}/autoProcessTV.cfg":
        source => "puppet:///modules/cabine/autoProcessTV.cfg",
        require => Repository[$repodir],
    }

    file { '/Library/LaunchDaemons/org.atonie.sickbeard.plist':
        content => template('cabine/org.atonie.sickbeard.plist.erb'),
        group   => 'wheel',
        owner   => 'root',
        notify  => Service['org.atonie.sickbeard']
    }

    service { 'org.atonie.sickbeard':
        ensure  => running,
        require => [
            Repository[$repodir],
            File["${cabine::config::sickbeard_autoprocessdir}/autoProcessTV.cfg"]
        ]
    }
}
