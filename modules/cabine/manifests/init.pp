class cabine {
    require boxen::config
    require cabine::config
    require cabine::sabnzbd
    require cabine::sickbeard
    require cabine::couchpotato
    require cabine::plex

    package { 'python':
        ensure => '2.7.3'
    }
}
