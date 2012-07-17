Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

import "defines/*.pp"

class riak {
    @service { "riak":
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => false,
        require => File["riak_app_config", "riak_vm_args"],
    }
}