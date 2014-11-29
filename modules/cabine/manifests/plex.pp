class cabine::plex {
  package {
    'Plex Media Server':
      provider => 'appdmg',
      source   => 'https://downloads.plex.tv/plex-media-server/0.9.11.4.739-a4e710f/PlexMediaServer-0.9.11.4.739-a4e710f-OSX.zip'
    'Plex Home Theater':
      provider => 'compressed_app',
      source   => 'https://downloads.plex.tv/plex-home-theater/1.2.2.331-2d6426d7/PlexHomeTheater-1.2.2.331-2d6426d7-macosx-x86_64.zip';
  }
}
