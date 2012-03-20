define riak::install(
    $version = '1.1.0',
    $revision = '1',
    $path = '/usr/local/src',
    $owner = 'riak',
    $group = 'riak',
    $bind_ip = "127.0.0.1",
    $fqdn = $::fqdn,
    $certfile = '/etc/riak/cert.pem',
    $keyfile = '/etc/riak/key.pem',
    $riak_search_enable = 'false',
    $admin_user = 'user',
    $admin_pass = 'pass',
    $storage_backend = 'riak_kv_bitcask_backend',
    $ring_max_size = '64',
    $target_n_val = '4'
    
) {

#we need to know if this is a 32 or 64 bit machine
if $::hardwaremodel == 'x86_64' {
    $arch = "amd64"
} else {
    $arch = "i386"
}


$cache_size = $::memorysizeinbytes / 2


file { riak_src_folder:
    path => "${path}/riak",
    ensure => "directory",
    owner => root,
    group => root
}

exec { riak_download: 
    command =>"wget http://downloads.basho.com/riak/riak-${version}/riak_${version}-${revision}_${arch}.deb -O riak_${version}-${revision}_${arch}.deb",
    cwd => "${path}/riak",
    creates => "${path}/riak/riak_${version}-${revision}_${arch}.deb",
    require => File["riak_src_folder"],
    before => Package["riak"]
}


package { 'openssl' : ensure => installed }

exec { riak_ssl_key :
    command => "openssl req -new -x509 -nodes -out cert.pem -keyout key.pem -days 3650 -batch -newkey rsa:2048",
    cwd => '/etc/riak',
    creates => '/etc/riak/cert.pem',
    require => Package["riak"],
    notify => Service["riak"]
}


file { riak_app_config:
    path => "/etc/riak/app.config",
    ensure => present,
    replace => true,
    owner => root,
    group => root,
    content => template("riak/app.config.erb"),
    require => Package["riak"],
    notify => Service["riak"]
}

file { riak_vm_args:
    path => "/etc/riak/vm.args",
    ensure => present,
    replace => true,
    owner => root,
    group => root,
    content => template("riak/vm.args.erb"),
    require => Package["riak"],
    notify => Service["riak"]
}

package { "riak" :
    ensure => installed,
    provider => dpkg,
    source => "${path}/riak/riak_${version}-${revision}_${arch}.deb"
}


realize Service["riak"]

}
