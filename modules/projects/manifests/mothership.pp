class projects::mothership {
  $srcdir = "${::boxen_srcdir}/codeship"

  file { $srcdir:
    ensure => directory,
  }

  boxen::project { 'mothership':
    source     => 'codeship/mothership',
    dir        => "${srcdir}/mothership",
    nginx      => true,
    postgresql => true,
    redis      => true,
    ruby       => '2.1.5',
    require    => File[$srcdir],
  }
}
