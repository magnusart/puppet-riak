import "defines/*.pp"

class riak {
    @service { "riak":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false,
        require => File["/etc/init.d/riak"],
    }
}