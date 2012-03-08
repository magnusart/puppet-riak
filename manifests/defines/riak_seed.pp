define riak::seed(
    $hostname = $::fqdn,
) {

exec { riak_download: 
    command =>"wget http://downloads.basho.com/riak/riak-${version}/riak_${version}-${revision}_${arch}.deb -O riak_${version}-${revision}_${arch}.deb",
    cwd => "${path}/riak",
    creates => "${path}/riak/riak_${version}-${revision}_${arch}.deb",
    require => Service["riak"],
}

}
