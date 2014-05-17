projects::frontback {
  #$name = 'frontback'
  $repodir = "${::boxen_srcdir}/checkthis/frontback"
  $server_name = 'frontback.dev'

  include postgresql
  include redis
  include nginx
  include nginx::config

  postgresql::database { 'frontback_development': }

  repository { $repodir:
    source => 'checkthis/frontback'
  }

  ruby::local { $repodir:
    version => '2.0.0-p353',
    require => Repository[$repodir],
  }

  $nginx_templ = 'projects/shared/nginx.conf.erb'

  file { "${nginx::config::sitesdir}/frontback.conf":
    content => template($nginx_templ),
    require => File[$nginx::config::sitesdir],
    notify  => Service['dev.nginx'],
  }
}
