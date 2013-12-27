class people::sr {
  include onepassword
  include screen
  include dropbox

  package {
      'Backblaze':
          provider => 'appdmg',
          source   => 'https://secure.backblaze.com/mac/install_backblaze.dmg';
      'Plex Home Theater':
          provider => 'compressed_app',
          source   => 'http://downloads.plexapp.com/plex-home-theater/1.0.7.169-303ab8cc/PlexHomeTheater-1.0.7.169-303ab8cc-macosx-x86_64.zip';
      'VyprVPN':
          provider => 'appdmg',
          source   => 'http://www.goldenfrog.com/downloads/vyprvpn/desktop/VyprVPN-2.1.0.dmg';
      'Yojimbo':
          provider => 'appdmg',
          source   => 'https://s3.amazonaws.com/BBSW-download/Yojimbo_4.0.2.dmg';
  }

  include ctags

  package { [
      'cowsay',
      'dash',
      'fortune',
      'mplayer',
      'pstree',
      'pwgen',
      'tig',
      'ctags-exuberant',
  ]: }

  # setup all of the projects
  include projects::all

  # osx settings
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::software_update

  # dotfiles
  $homedir = "/Users/${::luser}"
  $dotfiles = 'https://github.com/sr/dotfiles'

  exec {
    'dotfiles init':
      command   => 'git init',
      cwd       => $homedir,
      creates   => "${homedir}/.git",
      logoutput => on_failure,
      notify    => Exec['dotfiles remote'];
    'dotfiles remote':
      command     => "git remote add origin ${dotfiles}",
      cwd         => $homedir,
      logoutput   => on_failure,
      refreshonly => true,
      notify      => Exec['dotfiles fetch'];
    'dotfiles fetch':
      command     => 'git fetch origin',
      cwd         => $homedir,
      logoutput   => on_failure,
      refreshonly => true,
      notify      => Exec['dotfiles checkout'];
    'dotfiles checkout':
      command     => 'git checkout -t origin/master',
      cwd         => $homedir,
      logoutput   => on_failure,
      refreshonly => true;
  }
}
