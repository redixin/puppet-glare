# == Class: glare::pip_package
#
#  Configure the Glare database
#
# === Parameters
#
# [pip_name]
#   Name of package in pip repo
#


class glare::pip_package (

  $package_name ,
  $ensure       = present,
  $config_dir   = '/etc/glare',
  $log_dir      = '/var/log/glare',
  $work_dir     = '/var/lib/glare',
  $srv_bin      = '/usr/local/bin/glare-api',
  $user         = 'glare',

) {
    package { "$package_name":
      ensure    => $ensure,
      provider  => 'pip',
    }

    user {"$user":
      ensure    => present,
      home      => "$work_dir",
      shell     => '/bin/false',
      comment   => 'Glare daemon user',
      require   => Package[$package_name]
    }

    file { "$config_dir":
      ensure    => directory,
    }

    file { "$log_dir":
      ensure    => directory,
      owner     => "glare",
      mode      => "750",
      require   => User["$user"],
    }

    file { "$work_dir":
      ensure    => directory,
      owner     => "glare",
      mode      => "750",
      require   => User["$user"],
    }

    file { 'glare-paste.ini':
      path      => "${config_dir}/glare-paste.ini",
      ensure    => file,
      mode      => "755",
      source    => 'puppet:///modules/glare/glare-paste.ini',
      require   => File["$config_dir"],
    }


    case ($::glare::params::svc_type) {
      'upstart': {
        file { 'svc_file': 
          path      => "/etc/init/${::glare::params::glare_service_name}.conf",
          ensure    => present,
          content   => template('glare/upstart.glare.conf.erb'),
          require   => User["$user"],
        }
      }
      'systemd': {
        file { 'svc_file':
          path      => "/etc/systemd/system/${::glare::params::glare_service_name}.conf",
          ensure    => present,
          content   => template('glare/systemd.glare.conf.erb'),
          require   => User["$user"],
        }
      }
    }
}
