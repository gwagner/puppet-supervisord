class supervisord{

    package {
        'python-setuptools':
            ensure => installed,
            provider => 'yum';
    }

    file{
        'supervisord_jobs_dir':
            mode => 644,
            owner => "root",
            group => "root",
            path => "/etc/supervisord.d/",
            ensure => directory;
        'supervisord_log_dir':
            mode => 644,
            owner => "root",
            group => "root",
            path => "/var/log/supervisord/",
            ensure => directory;
        'supervisord.conf':
            mode => 644,
            owner => "root",
            group => "root",
            path => "/etc/supervisord.conf",
            ensure => 'present',
            content => template('supervisord/supervisord.erb'),
            require => Exec['install_supervisord'];
        'supervisord-initd':
            mode => 755,
            owner => "root",
            group => "root",
            path => "/etc/init.d/supervisord",
            ensure => 'present',
            source => "puppet:///modules/supervisord/supervisord-initd";
    }

    exec{
        'install_supervisord':
            command => '/usr/bin/easy_install supervisor',
            creates => '/usr/bin/supervisord',
            require => Package['python-setuptools'];

        'supervisord-service':
            command => '/sbin/chkconfig --add supervisord',
            creates => '/etc/rc0.d/*supervisord',
            unless => '/usr/bin/test -L /etc/rc0.d/*supervisord',
            require => File['supervisord-initd'];
    }

    service {
        'supervisord':
            ensure => true,
            enable => true,
            hasrestart => true,
            hasstatus => true,
            subscribe => [
                File['supervisord_jobs_dir'],
                File['supervisord.conf'],
                File['supervisord-initd'],
                Exec['supervisord-service']
            ];
    }
}