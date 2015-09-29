class people::sr::pachyderm {
  package { [
    'cmake',
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
