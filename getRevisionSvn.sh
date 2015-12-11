#!/bin/bash

echo "CVE:"
read cve

echo "Revision:"
read revision

repository=https://src.chromium.org/viewvc/blink/

svn checkout $repository@$revision $cve/After

svn log $cve/After --limit 2 | grep line | awk '{print $1}' > $cve.txt

while read line; do
	line=${line/r/}

	if [ "$line" != "$revision" ]
	then 
		svn checkout $repository@$line $cve/Before
	fi
	
done < $cve.txt
echo "$cve finished!!"
