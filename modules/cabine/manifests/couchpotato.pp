class cabine::couchpotato {
    $version = 'build/2.6.1'

    # couchpotato.ini settings
    $apikey = $cabine::config::couchpotato_apikey
    $newznab_apikey = $cabine::config::newznab_apikey
    $sabnzbd_apikey = $cabine::config::sabnzbd_apikey
    $sourcedir = $cabine::config::sabnzbd_completedir
    $destdir = $cabine::config::couchpotato_dir

    # launchd daemon templates variables
    $repodir = $cabine::config::couchpotato_repodir
    $configdir = $cabine::config::couchpotato_configdir
    $configfile = "${configdir}/config.ini"
    $executable = "${repodir}/CouchPotato.py"

    repository { $repodir:
        source  => 'RuudBurger/CouchPotatoServer',
        ensure  => $version,
        require => File[$cabine::config::couchpotato_datadir],
    }

    file { $configfile:
        source  => 'puppet:///modules/cabine/couchpotato2.ini.erb',
        notify  => Service['dev.couchpotato'],
        require => File[$configdir],
    }

    Ini_setting {
      path    => $configfile,
      ensure  => present,
      require => File[$configfile],
      notify  => Service['dev.couchpotato'],
    }

    ini_setting {
      'core_api_key':
        section => 'core',
        setting => 'api_key',
        value => $apikey;
      'newznab_api_key':
        section => 'newznab',
        setting => 'api_key',
        value   => ",,,${newznab_apikey}";
      'sabnzbd_category':
        section => 'sabnzbd',
        setting => 'category',
        value   => $sabnzbd_category;
      'sabnzbd_api_key':
        section => 'sabnzbd',
        setting => 'api_key',
        value   => $sabnzbd_apikey;
      'renamer_from':
        section => 'renamer',
        setting => 'from',
        value   => $sourcedir;
      'renamer_to':
        section => 'renamer',
        setting => 'to',
        value   => $destdir;
    }

    file { '/Library/LaunchDaemons/dev.couchpotato.plist':
        content => template('cabine/dev.couchpotato.plist.erb'),
        group   => 'wheel',
        owner   => 'root',
        notify  => Service['dev.couchpotato'],
    }

    service { 'dev.couchpotato':
        ensure  => running,
        require => Repository[$repodir],
    }
}
