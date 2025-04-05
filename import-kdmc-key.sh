#!/usr/bin/env bash
# Import private kdmc.key for pass. Remove once imported.
#
set -euxo pipefail

if [[ -f kdmc.key ]] ; then
	gpg --import kdmc.key
	gpg --command-fd 0 --edit-key kdmc@pm.me <<END
trust
5
y
END
	rm kdmc.key
else
	echo "kdmc.key needs to be in the dir from which this script is executed"
	exit 1
fi
