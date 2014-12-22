class cloud_backup(
  $bindir = "/Users/${::boxen_user}/bin",
  $logdir = "${::boxen::config::logdir}/backups",
  $plistdir = "/Users/${::boxen_user}/Library/LaunchAgents",
) {
  $path = [
    $bindir,
    "${::boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
  ]

  file { $logdir:
    ensure => directory,
  }

  cloud_backup::agent {
    'github':
      interval => '432000';
    'omnifaria':
      interval => '432000';
    'irclogs':
      interval => '432000';
  }
}
