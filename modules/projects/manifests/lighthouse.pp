class projects::lighthouse {
  boxen::project { 'lighthouse':
    source     => 'codeship/lighthouse',
    dir        => "${::boxen::config::srcdir}/lighthouse",
    nginx      => true,
    redis      => true,
    ruby       => '2.1.5',
  }
}
