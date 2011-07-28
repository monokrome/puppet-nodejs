class nodejs {
	$package_containment_dir = "/opt/packages"
	$package_filename = "nodejs_0.5.2_${architecture}.deb"
	$package_destination = "${package_containment_dir}/${package_filename}"
	$package_source = "puppet:///nodejs/${package_filename}"

	file {
		$package_containment_dir:
			ensure => directory,

	}

	file {
		"${package_destination}":
			source => "${package_source}",
			mode => 660,
			require => File["${package_containment_dir}"],
	}

	package {
		"nodejs":
			provider => "dpkg",
			ensure => installed,
			source => "${package_destination}",
			require => File[$package_destination],
	}
}

