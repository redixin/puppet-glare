
$glare_pip = "glare_dev"

include ::glare::params

class { '::glare::pip_package':
  package_name =>"$glare_pip",
}

Glare_config {
  require   => Class[ '::glare::pip_package' ],
}

glare_config {
  'database/connection':     value  => "sqlite:////${::glare::params::work_dir}/glare.sqlite";
  'oslo_policy/policy_file': value  => 'glare-policy.json';
}


file { "${::glare::params::config_dir}/glare-policy.json":
  content       => "{\n  \"context_is_admin\": \"role:app-catalog-core\"  \n}",
  require       => Class[ '::glare::pip_package' ],
}



class { 'glare':
  package_name  => "$glare_pip",
  require       => Class[ '::glare::pip_package' ],
}
