#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "$line"

	cve=`echo "$line" | grep -o "CVE-....-...."`
	echo $cve

	commit=`echo "$line" | grep -oP "\w{40}"`
	echo $commit

	repository=git://sourceware.org/git/glibc.git

	git clone $repository snapshots/$cve/After

	git --git-dir=snapshots/$cve/After/.git checkout $revision
	git --git-dir=snapshots/$cve/After/.git checkout $revision
	git --git-dir=snapshots/$cve/After/.git checkout $revision

	git --git-dir=snapshots/$cve/After/.git log -2 | grep commit | awk '{print $2}' > $cve.txt

	while read line; do
	line=${line/r/}

	if [ "$line" != "$revision" ]
	then
		git clone $repository snapshots/$cve/Before

		git --git-dir=snapshots/$cve/Before/.git checkout $line
		git --git-dir=snapshots/$cve/Before/.git checkout $line
		git --git-dir=snapshots/$cve/Before/.git checkout $line
	fi

	done < $cve.txt

	echo "$cve - revision $revision finished!!"

done < "list.txt"
