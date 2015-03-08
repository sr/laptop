define cloud_backup::agent(
  $interval = undef,
) {
  validate_string($name)
  validate_string($interval)

  $program = "${::cloud_backup::bindir}/backup-${name}"
  $logpath = "${::cloud_backup::logdir}/${name}.log"
  $plist = "${::cloud_backup::plistdir}/backup.${name}.plist"
  $label = "backup.${name}"
  $path = join($::cloud_backup::path, ':')

  file { $plist:
    content => template('cloud_backup/backup.agent.plist.erb'),
  }

  exec { "reload ${plist}":
    command     => "launchctl unload ${plist}; launchctl load ${plist}",
    user        => $::boxen_user,
    group       => 'staff',
    refreshonly => true,
    subscribe   => File[$plist],
  }
}
