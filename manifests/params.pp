# these parameters need to be accessed from several locations and
# should be considered to be constant

class glare::params {

  $glare_service_name = 'glare_api'
  $config_dir         = '/etc/glare'
  $log_dir            = '/var/log/glare'
  $work_dir           = '/var/lib/glare'
  $srv_bin            = '/usr/local/bin/glare-api'
  $user               = 'glare'

  case $::osfamily {
    'RedHat': {
      $glare_package_name    = 'openstack-glare'
      $svc_type = 'systemd'
      }
    'Debian': {
      $glare_package_name    = 'glare'
        if (versioncmp($::operatingsystemrelease, '15') < 0) {
          $svc_type = 'upstart'
        } else {
          $svc_type = 'systemd'
        }
      }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }
}
