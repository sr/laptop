class cabine {
    include cabine::config
    include cabine::sabnzbd
    include cabine::sickbeard
    include cabine::couchpotato
    include cabine::plex

    Class['boxen::config'] ->
      Class['cabine::config'] ->
      Class['cabine::sabnzbd'] ->
      Class['cabine::sickbeard'] ->
      Class['cabine::couchpotato'] ->
      Class['cabine::plex']
}
