class cabine::plex {
    package {
        'Plex Media Server':
            provider => 'appdmg',
            source   => 'http://plex.r.worldssl.net/PlexMediaServer/0.9.7.9.375-d056f10/PlexMediaServer-0.9.7.9.375-d056f10-OSX.dmg';
        'Plex Media Center':
            provider => 'compressed_app',
            source   => 'http://plex.r.worldssl.net/plex-laika/0.9.5.4/Plex-0.9.5.4-973998f.zip';
    }
}
