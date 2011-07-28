class nodejs {
	# NodeJS evolves too fast. We need to keep it up to date by compiling.
	# So, we will also need some compilers.
	package {
		"build-essential":
			ensure => latest,
	}

	package {
		"libssl-dev":
			ensure => latest,
	}

	$nodejs_location = "http://nodejs.org/dist/v0.5.2/"
	$nodejs_archive = "node-v0.5.2.tar.gz"
	$nodejs_prefix = "/usr/local"
	$nodejs_build_dir = "/root/.build"
	$nodejs_source_dir = "${nodejs_build_dir}/node-v0.5.2"

	file {
		"/root/.build":
			ensure => directory,
			require => [Package["build-essential"],
			            Package["libssl-dev"]]
	}

	exec {
		"nodejs-download":
			command => "wget '${nodejs_location}/${nodejs_archive}'",
			cwd => "${nodejs_build_dir}",
			creates => "${nodejs_build_dir}/${nodejs_archive}",
			path => ["/bin", "/usr/sbin",
			         "/usr/bin", "/usr/local/bin"],
			require => File["/root/.build"],
	}

	exec {
		"nodejs-extract":
			command => "tar -xf ${nodejs_archive}",
			cwd => "${nodejs_build_dir}",
			creates => "${nodejs_source_dir}",
			path => ["/bin", "/usr/sbin",
			         "/usr/bin", "/usr/local/bin"],
			require => Exec["nodejs-download"],
	}

	exec {
		"nodejs-configure":
			command => "configure --prefix=${nodejs_prefix}",
			cwd => "${nodejs_source_dir}",
			creates => "${nodejs_source_dir}/build",
			path => ["${nodejs_source_dir}", "/bin", "/usr/sbin",
			         "/usr/bin", "/usr/local/bin"],
			require => Exec["nodejs-extract"],
	}

	exec {
		"nodejs":
			command => "make install",
			cwd => "${nodejs_source_dir}",
			creates => "${nodejs_source_dir}/build/default/node",
			path => ["${nodejs_source_dir}", "/bin", "/usr/sbin",
			         "/usr/bin", "/usr/local/bin"],
			timeout => 0, # This takes a while. No way around that.
			require => Exec["nodejs-extract"],
	}
}

