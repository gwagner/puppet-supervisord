define supervisord::job(
    $command,
    $procs = 1,
    $log_file = "/var/log/supervisord/${title}_log",
    $error_log_file = "/var/log/supervisord/${title}_error_log",
    $ensure = 'present'
){
    file{
        "${title}_supervisord_job":
            mode => 644,
            owner => "root",
            group => "root",
            path => "/etc/supervisord.d/${title}_job.conf",
            ensure => $ensure,
            content => template('supervisord/job.erb'),
            notify => Service['supervisord'];
    }
}