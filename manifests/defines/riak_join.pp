define riak::join(
    $host = "localhost",
) {

exec { riak_join: 
    command =>"riak-admin join riak@${host}",
    unless => "riak-admin member_status | grep ${host}",
    require => Service["riak"],
}

}
