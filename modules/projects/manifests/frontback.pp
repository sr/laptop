class projects::frontback {
  $srcdir = "${::boxen_srcdir}/checkthis"

  file { $srcdir:
    ensure => directory,
  }

  boxen::project { 'frontback':
    source     => 'checkthis/frontback',
    dir        => "${srcdir}/frontback",
    nginx      => true,
    postgresql => true,
    redis      => true,
    ruby       => '2.0.0',
    nodejs     => 'v0.10.26',
    require    => File[$srcdir],
  }
}
