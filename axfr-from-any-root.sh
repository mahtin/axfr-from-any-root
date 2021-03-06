:

#
# axfr-from-any-root.sh - collect root zone with full error checking from any root operator (b, c, f, g, k presently) 
# ICANN also has xfr.lax.dns.icann.org and xfr.cjr.dns.icann.org available for transfers - which can be added one day
# See https://tools.ietf.org/html/rfc7706 for more info
#
# written by Martin J. Levy
#

tmp=/tmp/a$$
trap "rm -f ${tmp}_*; exit 0" 0 1 2 15

LETTERS="a b c d e f g h i j k l m"

#
# We can query all at the same time as they are all different IP's (and don't notice each other)
#
for letter in ${LETTERS}
do
	((time dig +nocmd +nostats @${letter}.root-servers.net . axfr > ${tmp}_${letter}.txt ) 2> ${tmp}_${letter}.log ; echo === AXFR ${letter} done 1>&2 ) &
done

#
# and wait for all to complete
#
wait

#
# prune out the failed transfers
#
for letter in ${LETTERS}
do
	if [ ! -s ${tmp}_${letter}.txt ]
	then
		continue
	fi
	if fgrep -q '; Transfer failed.' ${tmp}_${letter}.txt
	then
		# Lets remove this from the answer group
		echo === AXFR ${letter} failed - being removed 1>&2
		rm ${tmp}_${letter}.txt ${tmp}_${letter}.log
	fi
done

if [ `ls *.txt 2>/dev/null | wc -l` = "0" ]
then
	echo === AXFR all a-m servers failed - this should not happen - exiting 1>&2
	exit 1
fi

fgrep real ${tmp}_?.log | sed -e 's/.*\([a-m]\)\.log:real	\([^ ][^ ]*\)$/\1	\2/' -e 's/	0m/	/' | sort -bk2,3 | while read letter latency
do
	timestamp=`awk '$1 == "." && $3 == "IN" && $4 == "SOA" { print $7; }' < ${tmp}_${letter}.txt | uniq`
	echo === AXFR ${letter} = ${latency} ';' ${timestamp} 1>&2
	rm ${tmp}_${letter}.log
done

#
# we are left with just answered queries - now check they are all the same.
#

first=`ls ${tmp}_[a-m].txt | head -1 | sed -e 's/.*_//' -e 's/\.txt$//'`

sort < ${tmp}_${first}.txt > ${tmp}_sorted.txt
for letter in ${LETTERS}
do
	if [ ! -s ${tmp}_${letter}.txt ]
	then
		continue
	fi
	if sort ${tmp}_${letter}.txt | diff -q - ${tmp}_sorted.txt
	then
		# the same - this is a good thing
		:
	else
		echo === AXFR ${first} ${letter} - different - this should not happen - exiting 1>&2
		exit 1
	fi
done

#
# done - confirmed some transfers and that they are all the same - save file away
#

timestamp=`awk '$1 == "." && $3 == "IN" && $4 == "SOA" { print $7; }' < ${tmp}_sorted.txt | uniq`
cp ${tmp}_sorted.txt root-zone-${timestamp}.txt

#
# clean up
#

rm ${tmp}_[a-m].txt

exit 0
