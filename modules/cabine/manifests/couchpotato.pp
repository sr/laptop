class cabine::couchpotato {
    $repodir = $cabine::config::couchpotato_repodir
    $configdir = $cabine::config::couchpotato_configdir
    $configfile = "${configdir}/config.ini"
    $executable = "${repodir}/CouchPotato.py"

    repository { $repodir:
        source  => 'RuudBurger/CouchPotatoServer',
        ensure  => 'build/2.6.1',
        require => File[$cabine::config::couchpotato_datadir],
    }

    file { $configfile:
        content => template('cabine/couchpotato.ini.erb'),
        notify  => Service['org.atonie.couchpotato'],
        require => File[$configdir],
    }

    file { '/Library/LaunchDaemons/org.atonie.couchpotato.plist':
        content => template('cabine/org.atonie.couchpotato.plist.erb'),
        group   => 'wheel',
        owner   => 'root',
        notify  => Service['org.atonie.couchpotato'],
    }

    service { 'org.atonie.couchpotato':
        ensure  => running,
        require => Repository[$repodir],
    }
}
