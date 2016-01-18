#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "$line"

	cve=`echo "$line" | grep -o "CVE-....-...."`
	echo $cve

	commit=`echo "$line" | grep -oP "\w{40}"`
	echo $commit

	repository=https://gitlab.com/gnutls/gnutls.git

	mkdir -p snapshots/$cve/$commit/after

	cd snapshots/$cve/$commit/after

	git clone $repository

	cd gnutls

	git fetch origin
	git reset --hard $commit
	
	git log -2 | grep commit | awk '{print $2}' > ../../../../../$cve.txt
	
	cd ../../../../../

	while read line; do
	if [ "$line" != "$commit" ]
	then
		mkdir -p snapshots/$cve/$commit/before

		cd snapshots/$cve/$commit/before

		git clone $repository

		cd gnutls

		git fetch origin
		git reset --hard $line

		cd ../../../../../
	
	fi

	done < $cve.txt

	echo "$cve - Commit $commit finished!!"
	echo "#################################################################"

done < "list.txt"
