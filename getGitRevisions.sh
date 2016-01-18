#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "$line"

	cve=`echo "$line" | grep -o "CVE-....-...."`
	echo $cve

	commit=`echo "$line" | grep -oP "\w{40}"`
	echo $commit

	repository=git://sourceware.org/git/glibc.git

	git clone $repository snapshots/$cve/After
	
	cd snapshots/$cve/After/

	git fetch origin
	git reset --hard $commit
	
	git log -2 | grep commit | awk '{print $2}' > ../../../$cve.txt
	
	cd ../../../

	while read line; do
	if [ "$line" != "$commit" ]
	then
		git clone $repository snapshots/$cve/Before
		
		cd snapshots/$cve/Before/		

		git fetch origin
		git reset --hard $line
	
	fi

	done < $cve.txt

	echo "$cve - Commit $commit finished!!"
	echo "#################################################################"

done < "list.txt"
