define riak::install(
    $version = '1.1.0',
    $revision = '1',
    $path = '/usr/local/src',
    $owner = 'riak',
    $group = 'riak',
    $bind_ip = "127.0.0.1",
) {

#we need to know if this is a 32 or 64 bit machine
if $hardwaremodel == 'x86_64' {
    $arch = "amd64"
} else {
    $arch = "i386"
}


file { riak_src_folder:
    path => "${path}/riak",
    ensure => "directory",
    owner => root,
    group => root
}

exec { riak_downlaod: 
    command =>"wget http://downloads.basho.com/riak/riak-${version}/riak_${version}-${revision}_${arch}.deb -O riak_${version}-${revision}_${arch}.deb",
    cwd => "${path}/riak",
    creates => "${path}/riak/riak_${version}-${revision}_${arch}.deb",
    require => File["riak_src_folder"],
    before => Package["riak"]
}


package { "riak" :
    ensure => installed,
    provider => dpkg,
    source => "${path}/riak/riak_${version}-${revision}_${arch}.deb"
}




}
