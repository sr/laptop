class cabine::config {
    # user and groups used to run the sabnzbd and couchpotato servers
    $user = hiera('cabine::user', $::boxen_user)
    $group = hiera('cabine::group', 'staff')

    # usenet server connections details
    $sabnzbd_server = hiera('cabine::server::host')
    $sabnzbd_serverport = hiera('cabine::server::port')
    $sabnzbd_serveruser = hiera('cabine::server::user')
    $sabnzbd_serverpassword = hiera('cabine::server::password')
    $sabnzbd_serverssl = hiera('cabine::server::ssl')
    $sabnzbd_serverconns = hiera('cabine::server::connections')

    $downloadsdir = "/Users/${::luser}/Downloads"

    $sabnzbd_configdir = "${::boxen::config::configdir}/sabnzbd"
    $sabnzbd_datadir = "${::boxen::config::datadir}/sabnzbd"
    $sabnzbd_admindir = "${sabnzbd_datadir}/admin"
    $sabnzbd_repodir = "${sabnzbd_datadir}/repo"
    $sabnzbd_logdir = "${::boxen::config::logdir}/sabnzbd"
    $sabnzbd_downloaddir = "${downloadsdir}/cabine"
    $sabnzbd_incompletedir = "${sabnzbd_downloaddir}/incomplete"
    $sabnzbd_completedir = "${sabnzbd_downloaddir}/complete"
    $sabnzbd_sickbearddir = "${sabnzbd_downloaddir}/sickbeard"
    $sabnzbd_couchpotatodir = "${sabnzbd_downloaddir}/couchpotato"
    $sabnzbd_sickbeard_category = "sickbeard"
    $sabnzbd_couchpotato_category = "couchpotato"
    $sabnzbd_apikey = $::cabine_sabnzbd_apikey
    $sabnzbd_nzbkey = $::cabine_sabnzbd_nzbkey
    $sabnzbd_host = "http://0.0.0.0:8080/"

    $sickbeard_configdir = "${::boxen::config::configdir}/sickbeard"
    $sickbeard_logdir = "${::boxen::config::logdir}/sickbeard"
    $sickbeard_datadir = "${::boxen::config::datadir}/sickbeard"
    $sickbeard_repodir = "${sickbeard_datadir}/repo"
    $sickbeard_port = "8081"
    $sickbeard_host = "0.0.0.0"
    $sickbeard_autoprocessdir = "${sickbeard_repodir}/autoProcessTV"

    $couchpotato_datadir = "${::boxen::config::datadir}/couchpotato"
    $couchpotato_configdir = "${::boxen::config::configdir}/couchpotato"
    $couchpotato_logdir = "${::boxen::config::logdir}/couchpotato"
    $couchpotato_repodir = "${couchpotato_datadir}/repo"
    $couchpotato_apikey = hiera('cabine::couchpotato::apikey')
    $couchpotato_dir = hiera('cabine::movies_dir')

    $nzbsrus_uid = "366986"
    $nzbsrus_hash = "16f72b"

    $newznab_apikey = $::cabine_lstoll_apikey

    $plex_host = "127.0.0.1:32400"

    $python = "${::boxen::config::home}/homebrew/bin/python"

    $directories = [
        $sabnzbd_configdir,
        $sabnzbd_datadir,
        $sabnzbd_admindir,
        $sabnzbd_logdir,
        $sabnzbd_downloaddir,
        $sabnzbd_incompletedir,
        $sabnzbd_completedir,
        $sabnzbd_sickbearddir,
        $sabnzbd_couchpotatodir,

        $sickbeard_rootdir,
        $sickbeard_configdir,
        $sickbeard_datadir,
        $sickbeard_logdir,

        $couchpotato_dir,
        $couchpotato_datadir,
        $couchpotato_configdir,
        $couchpotato_logdir,
    ]

    file { $directories:
      ensure => directory
    }
}
