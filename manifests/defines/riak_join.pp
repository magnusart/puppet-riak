define riak::join( $host = $name ) {

exec { riak_join: 
    command =>"/usr/sbin/riak-admin join riak@${host}",
    unless => "/usr/sbin/riak-admin member_status | grep ${host}",
    require => Service["riak"],
}

}
