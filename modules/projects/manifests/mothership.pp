class projects::mothership {
  boxen::project { 'mothership':
    source     => 'codeship/mothership',
    dir        => "${::boxen::config::srcdir}/codeship/mothership",
    nginx      => true,
    postgresql => true,
    redis      => true,
    ruby       => '2.1.4',
  }
}
