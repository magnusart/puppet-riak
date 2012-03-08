define riak::join(
    $host = "",
) {

exec { riak_join: 
    command =>"riak-admin join riak@${host}; touch /etc/riak/join-attempted",
    creates => "/etc/riak/join-attempted",
    require => Service["riak"],
}

}
