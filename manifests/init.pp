# == Class glare
#
# Configure Glare service
#
# == Parameters
#
# [*package_ensure*]
#   (optional) Ensure state for package. On RedHat platforms this
#   setting is ignored and the setting from the glare class is used
#   because there is only one glare package. Defaults to 'present'.
#
# [*package_name*]
#   (optional) Allows install package earlier. If package name is 
# pointed, package presence is checked before calling package resource .
#
# [*bind_host*]
#   (optional) The address of the host to bind to.
#   Default: 0.0.0.0
#
# [*bind_port*]
#   (optional) The port the server should bind to.
#   Default: 9494
#
# [*backlog*]
#   (optional) Backlog requests when creating socket
#   Default: 4096
#
# [*workers*]
#   (optional) Number of Glare worker processes to start
#   Default: $::processorcount
#
# [*auth_strategy*]
#   (optional) Type is authorization being used.
#   Defaults to 'keystone'
#
# [*pipeline*]
#   (optional) Partial name of a pipeline in your paste configuration file with the
#   service name removed.
#   Defaults to 'keystone'.
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*stores*]
#   (optional) List of which store classes and store class locations are
#    currently known to glare at startup.
#    Defaults to false.
#    Example: file,http
#    Possible values:
#     * A comma separated list that could include:
#         * file
#         * http
#         * swift
#         * rbd
#         * sheepdog
#         * cinder
#         * vmware
#     Related Options:
#     * default_store
#
#  (list value)
# stores = file,http
#
# [*default_store*]
#   (optional)  Allowed values: file, filesystem, http, https, swift, 
# swift+http, swift+https, swift+config, rbd, sheepdog, cinder, vsphere
# default_store = file
#
# [*filesystem_store_datadir*]
#
# filesystem_store_datadir = /var/lib/glance/images
#
# [*multi_store*] KILL KILL
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
# [*os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# == DEPRECATED PARAMETERS
#
# [*auth_region*]
#   (optional) The region for the authentication service.
#   If "use_user_token" is not in effect and using keystone auth,
#   then region name can be specified.
#   Defaults to $::os_service_default.
#
# [*auth_type*]
#   (optional) Type is authorization being used.
#   Deprecated and replaced by ::glance::glare::auth_strategy
#   Defaults to undef.
#
# [*auth_uri*]
#   (optional) Complete public Identity API endpoint.
#   Deprecated and will be replaced by ::glance::glare::authtoken::auth_uri
#   Defaults to undef.
#
# [*identity_uri*]
#   (optional) Complete admin Identity API endpoint.
#   Deprecated and will be replaced by ::glance::glare::authtoken::auth_url
#   Defaults to undef.
#
# [*keystone_tenant*]
#   (optional) Tenant to authenticate to.
#   Deprecated and will be replaced by ::glance::glare::authtoken::project_name
#   Defaults to undef.
#
# [*keystone_user*]
#   (optional) User to authenticate as with keystone.
#   Deprecated and will be replaced by ::glance::glare::authtoken::username
#   Defaults to undef.
#
# [*keystone_password*]
#   (optional) Password used to authentication.
#   Deprecated and will be replaced by ::glance::glare::authtoken::password
#   Defaults to undef.
#
# [*signing_dir*]
#   (optional) Directory used to cache files related to PKI tokens.
#   Deprecated and will be replaced by ::glance::glare::authtoken::signing_dir
#   Defaults to undef.
#
# [*memcached_servers*]
#   (optinal) a list of memcached server(s) to use for caching. If left undefined,
#   tokens will instead be cached in-process.
#   Deprecated and will be replaced by ::glance::glare::authtoken::memcached_servers
#   Defaults to undef.
#
# [*token_cache_time*]
#   (optional) In order to prevent excessive effort spent validating tokens,
#   the middleware caches previously-seen tokens for a configurable duration (in seconds).
#   Set to -1 to disable caching completely.
#   Deprecated and will be replaced by ::glance::glare::authtoken::token_cache_time
#   Defaults to undef.
#
class glare (
  $package_ensure            = 'present',
  $package_name              = undef,
  $bind_host                 = '0.0.0.0',
  $bind_port                 = '9494',
  $backlog                   = '4096',
  $workers                   = $::processorcount,
  $auth_strategy             = undef,
  $pipeline                  = undef,
  $manage_service            = true,
  $enabled                   = true,
  $cert_file                 = $::os_service_default,
  $key_file                  = $::os_service_default,
  $ca_file                   = $::os_service_default,
  $stores                    = 'file,http',
  $default_store             = 'file',
  $filesystem_store_datadir  = '/var/lib/glare/images',
  $multi_store               = false,
  $os_region_name            = 'RegionOne',
  # DEPRECATED PARAMETERS
  $auth_region               = undef,
  $auth_type                 = undef,
  $auth_uri                  = undef,
  $identity_uri              = undef,
  $memcached_servers         = undef,
  $keystone_tenant           = undef,
  $keystone_user             = undef,
  $keystone_password         = undef,
  $signing_dir               = undef,
  $token_cache_time          = undef,
) {

#  include ::glance::policy
#  include ::glare::db
#  include ::glare::logging

  if ( ! $package_name ) {
    $package_name=$params::glare_package_name
  }

  if (! defined (Package[$package_name])) {
    package { "$package_name":
      ensure    => "$package_ensure",
    }
  }

  Glare_config {
    require     => Package[$package_name],
    before      => Service[$::glare::params::glare_service_name],
  }

  glare_config {
    'DEFAULT/bind_host':           value => $bind_host;
    'DEFAULT/bind_port':           value => $bind_port;
    'DEFAULT/backlog':             value => $backlog;
    'DEFAULT/workers':             value => $workers;
  }

  glare_config {
    'glance_store/os_region_name': value  => $os_region_name;
    'glance_store/stores': value          => $stores;
    'glance_store/default_store': value   => $default_store;
    'glance_store/filesystem_store_datadir': value   => $filesystem_store_datadir;

  }

  if $pipeline != '' {
    glare_config {
      'paste_deploy/flavor':
        ensure => present,
        value  => $pipeline,
    }
  } else {
    glare_config { 'paste_deploy/flavor': ensure => absent }
  }

  # keystone config

  if $auth_strategy == 'keystone' {
    include ::glare::authtoken
  }

  # SSL Options
# glare_config {
#    'DEFAULT/cert_file': value => $cert_file;
#    'DEFAULT/key_file' : value => $key_file;
#    'DEFAULT/ca_file'  : value => $ca_file;
#  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }
  service { "$::glare::params::glare_service_name":
    ensure     => $service_ensure,
    enable     => $enabled,
  }
}
