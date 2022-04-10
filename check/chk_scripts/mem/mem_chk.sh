#!/bin/ksh 

. /u1/etc/chk_scripts/mem/mem_chk.conf

test_date=`date '+%H:%M'`

file=`date '+%Y%m%d'`

if [ "$MODE" == "check" ] ; then

   name=$NAME
   chk_dir_a=$chk_dir
   chk_dir="$chk_dir/chk/$name"
   mkdir $chk_dir
   mkdir $chk_dir/$file
   cp -p $chk_dir_a/$file/* $chk_dir/$file

else

   chk_dir=$chk_dir

fi

if [ ! -d "$chk_dir/$file" ]; then
   mkdir $chk_dir/$file
fi

chk_time=`date '+%a'`

# 7 : 保留今天到 8 天前 ( today 10 號 會保留到 2 ~ 10 )
# 6 : 保留今天到 7 天前 
chk_clean='7'

if [ "$chk_time" == "Mon" ] ; then

   tmon_clean_time_go="Y"
   echo "$tmon_clean_time_go"

elif [ "$chk_time" == "Fri" ] ; then
   tmon_clean_time_go="Y"
   echo "$tmon_clean_time_go"
   
fi

proc_not_to='mem_chk.conf|mem_chk.sh|mem_chkhtml.sh|chk'

if [ "$tmon_clean_time_go" == "Y" ]; then

   #找出指定時間目錄 清理
   clean='/u1/etc/chk_scripts/mem'
   find $chk_dir/* -mtime +$chk_clean -print0 | grep -Ev "(grep|${proc_not_to})" | xargs -t rm -rf

fi

test_dir="$chk_dir/"$file

total_mem=`free | grep Mem | awk '{print $2}'`

#Mem use
use_mem=`free | grep Mem | awk '{print $3}'`

per_use=`awk -v x=$use_mem -v y=$total_mem 'BEGIN{printf "%.3f\n",(x/y)*100}' `

#Mem available
use_buf=`free | grep Mem | awk '{print $7}'`

per_buf=`awk -v x=$use_buf -v y=$total_mem 'BEGIN{printf "%.3f\n",(x/y)*100}' `

#Mem swap
total_swap=`free  | grep Swap | awk '{print $2}'` 

use_swa=`free  | grep Swap | awk '{print $3}'` 

per_swa=`awk -v x=$use_swa -v y=$total_mem 'BEGIN{printf "%.5f\n",(x/y)*100}' `

echo $per_use >> $test_dir/${file}_use.txt

echo $per_buf >> $test_dir/${file}_buf.txt

echo $per_swa >> $test_dir/${file}_swp.txt

echo "," >> $test_dir/${file}_use.txt
echo "," >> $test_dir/${file}_buf.txt
echo "," >> $test_dir/${file}_swp.txt

echo "'"$test_date"'" >> $test_dir/${file}_date.txt

echo "," >> $test_dir/${file}_date.txt 

echo '<div class="content"><table width=500 border=1><tr><th colspan=1 style=background-color:#FFECC9>' >> $test_dir/${file}_swptest.html 
echo "$test_date Mem 前 20 名</div> </th></tr></table> </div>" >> $test_dir/${file}_swptest.html
echo '<div class="content"> ' >> $test_dir/${file}_swptest.html
echo "<table width=500 border=1>
          <tr>
          <th colspan=7 style=background-color:#FFECC9>Mem $test_date </th>
          </tr> 
" >> $test_dir/${file}_swptest.html


ps -eo %mem,%cpu,pid,ppid,tt,stime,time,cmd --sort=-%mem | head -21 > $test_dir/123.txt

swp_num=`cat $test_dir/123.txt | wc -l `

i=1

while [ "$i" -lt "$swp_num" ] 
do
   if [ "$i" == 1 ] ; then
      mem_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $1}' `
      cpu_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $2}' `
      pid_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $3}' `
      ppid_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $4}' `
      tt_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $5}' `
      stime_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $6}' `
      time_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $7}' `
      cmd_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{$1=$2=$3=$4=$5=$6=$7="";print $0}' ` 
      echo "<tr> 
            <td> $mem_chk    </td>
            <td> $cpu_chk    </td>
            <td> $pid_chk    </td>
            <td> $ppid_chk   </td>
            <td> $tt_chk     </td>
            <td> $stime_chk  </td>
            <td> $time_chk   </td>
            <td> $cmd_chk    </td>
            </tr> 
           "  >> $test_dir/${file}_swptest.html
   else
      mem_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $1}' `
      cpu_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $2}' `
      pid_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $3}' `
      ppid_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $4}' `
      tt_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $5}' `
      stime_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $6}' `
      time_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $7}' `
      cmd_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{$1=$2=$3=$4=$5=$6=$7="";print $0}' ` 
      echo "<tr> 
            <td> $mem_chk    </td>
            <td> $cpu_chk    </td>
            <td> $pid_chk    </td>
            <td> $ppid_chk   </td>
            <td> $tt_chk     </td>
            <td> $stime_chk  </td>
            <td> $time_chk   </td>
            <td> $cmd_chk    </td>
            </tr> 
           "  >> $test_dir/${file}_swptest.html
   fi
   i=`expr $i + 1 `

done

echo "
     </table> 
     </div>
     "  >> $test_dir/${file}_swptest.html

