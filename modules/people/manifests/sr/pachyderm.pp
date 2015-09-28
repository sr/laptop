class people::sr::pachyderm {
  package { [
    'docker-compose',
    'docker-machine',
    'go',
  ]: }

  package { 'docker':
    install_options => [
      '--HEAD',
    ],
  }
}
