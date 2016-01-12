#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "$line"

	cve=`echo "$line" | grep -o "CVE-....-...."`
	echo $cve

	commit=`echo "$line" | grep -oP "\w{40}"`
	echo $commit

	repository=git://sourceware.org/git/glibc.git

	git clone $repository snapshots/$cve/After
	
	git --git-dir=snapshots/$cve/After/.git fetch origin
	git --git-dir=snapshots/$cve/After/.git reset --hard $commit
	
	git --git-dir=snapshots/$cve/After/.git log -2 | grep commit | awk '{print $2}' > $cve.txt

	while read line; do
	line=${line/r/}

	if [ "$line" != "$commit" ]
	then
		git clone $repository snapshots/$cve/Before
		
		git --git-dir=snapshots/$cve/After/.git fetch origin
		git --git-dir=snapshots/$cve/After/.git reset --hard $line
	
	fi

	done < $cve.txt

	echo "$cve - Commit $commit finished!!"

done < "list.txt"
