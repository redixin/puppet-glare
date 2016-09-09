
class { 'glare':
  package_provider => 'git',
}

Glare_paste_ini {
    path => "$::glare::conf_dir/glare-paste.ini",
}

glare_paste_ini { 'sssss/xxxxs':
  value => 'dddds',
}
