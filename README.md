# axfr-from-any-root

Collect root zone with full error checking from any root operator (b, c, f, g, k presently)

# Usage

```
$ ./axfr-from-any-root.sh 
=== AXFR e done
=== AXFR d done
=== AXFR f done
=== AXFR l done
=== AXFR i done
=== AXFR a done
=== AXFR j done
=== AXFR h done
=== AXFR m done
=== AXFR c done
=== AXFR k done
=== AXFR b done
=== AXFR g done
=== AXFR a failed - being removed
=== AXFR d failed - being removed
=== AXFR e failed - being removed
=== AXFR f failed - being removed
=== AXFR h failed - being removed
=== AXFR i failed - being removed
=== AXFR j failed - being removed
=== AXFR l failed - being removed
=== AXFR m failed - being removed
=== AXFR c = 1.475s ; 2017041102
=== AXFR k = 2.221s ; 2017041102
=== AXFR b = 2.853s ; 2017041102
=== AXFR g = 7.293s ; 2017041102
$
```

# Results

```
$ ls -l
total 4368
-rwxr-xr-x  1 martin  staff     1830 Apr 11 13:53 axfr-from-any-root.sh
-rw-r--r--  1 martin  staff  2230992 Apr 11 13:53 root-zone-2017041102.txt
$
```


