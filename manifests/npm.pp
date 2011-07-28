class nodejs::npm {
	include nodejs

	define nodejs::npm::install($package_name = "", $where) {
		exec {
			"nodejs::npm::install::${name}":
				command => "npm install ${package_name}",
				cwd => $where,
				path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
				requires => Exec["npm"],
		}
	}

	exec {
		"npm":
			command => "curl http://npmjs.org/install.sh | sh",
			path => ["/usr/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
			requires => Exec["nodejs"],
	}
}

