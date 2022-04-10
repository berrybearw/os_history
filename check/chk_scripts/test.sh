#!/bin/ksh

date1='20220221'
date2='20220220'
date3='chk'

date -d "$date1" +%s
date -d "$date2" +%s
date -d "$date3" +%s 2>/dev/null

cd /u1/etc/chk_scripts/cpu/
dir_chk=`find ./ -maxdepth 1 -type d | awk -F ./ '{print $2}'`
      for i in $dir_chk
      do
        chk_1=`date -d "$date_dir" +%s`
        chk_2=`date -d "$i" +%s 2>/dev/null`
        if [ `echo "$chk_2 > 0" | bc ` -eq 1 ] ; then
           echo "@@@"
           echo $chk_2
        #   if [ `echo "$chk_2 < $chk_1" | bc ` -eq 1 ] ; then
        #      rm -rf $i
        #   fi
        fi
      done
