class cabine::couchpotato {
    $repodir = $cabine::config::couchpotato_repodir
    $configdir = $cabine::config::couchpotato_configdir
    $configfile = "${configdir}/config.ini"
    $executable = "${repodir}/CouchPotato.py"
    $version = 'build/2.6.1'

    repository { $repodir:
        source  => 'RuudBurger/CouchPotatoServer',
        ensure  => $version,
        require => File[$cabine::config::couchpotato_datadir],
    }

    file { $configfile:
        content => template('cabine/couchpotato.ini.erb'),
        notify  => Service['org.atonie.couchpotato'],
        require => File[$configdir],
    }

    file { '/Library/LaunchDaemons/org.atonie.couchpotato.plist':
      ensure => absent
    }

    service { 'org.atonie.couchpotato':
        ensure  => absent,
        require => Repository[$repodir],
    }

    file { '/Library/LaunchDaemons/dev.couchpotato.plist':
        content => template('cabine/dev.couchpotato.plist.erb'),
        group   => 'staff',
        owner   => $::boxen_user,
        notify  => Service['dev.couchpotato'],
    }

    service { 'dev.couchpotato':
        ensure  => running,
        require => Repository[$repodir],
    }
}
