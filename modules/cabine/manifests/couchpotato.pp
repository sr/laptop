class cabine::couchpotato(
  $repo    = 'RuudBurger/CouchPotatoServer',
  $version = 'build/2.6.1',
) {

  # couchpotato.ini settings
  $apikey = $cabine::config::couchpotato_apikey
  $newznab_apikey = $cabine::config::newznab_apikey
  $sabnzbd_apikey = $cabine::config::sabnzbd_apikey
  $sabnzbd_category = $cabine::config::sabnzbd_couchpotato_category
  $sourcedir = $cabine::config::sabnzbd_completedir
  $destdir = $cabine::config::couchpotato_dir

  # launchd daemon templates variables
  $repodir = $cabine::config::couchpotato_repodir
  $configdir = $cabine::config::couchpotato_configdir
  $configfile = "${configdir}/config.ini"
  $executable = "${repodir}/CouchPotato.py"

  repository { $repodir:
    ensure  => $version,
    source  => $repo,
    require => File[$cabine::config::couchpotato_datadir],
  }

  file { $configfile:
    source  => 'puppet:///modules/cabine/couchpotato2.ini.erb',
    replace => false,
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
    'core_show_wizard':
      section => 'core',
      setting => 'show_wizard',
      value   => 'False';
    'core_launch_browser':
      section => 'core',
      setting => 'launch_browser',
      value   => 'False';
    'updater_automatic':
      section => 'updater',
      setting => 'automatic',
      value   => 'False';
    'thepiratebay_enabled':
      section => 'thepiratebay',
      setting => 'enabled',
      value   => 'True';
    'blackhole_enabled':
      section => 'blackhole',
      setting => 'enabled',
      value   => 'False';
    'newznab_api_key':
      section => 'newznab',
      setting => 'api_key',
      value   => ",,,${newznab_apikey}";
    'transmission_enabled':
      section => 'transmission',
      setting => 'enabled',
      value   => 'True';
    'sabnzbd_api_key':
      section => 'sabnzbd',
      setting => 'api_key',
      value   => $sabnzbd_apikey;
    'sabnzbd_category':
      section => 'sabnzbd',
      setting => 'category',
      value   => $sabnzbd_category;
    'renamer_enabled':
      section => 'sabnzbd',
      setting => 'enabled',
      value   => 'True';
    'renamer_cleanup':
      section => 'renamer',
      setting => 'cleanup',
      value   => 'True';
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
