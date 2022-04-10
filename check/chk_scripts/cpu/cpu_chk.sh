#!/bin/ksh 

. /u1/etc/chk_scripts/cpu/cpu_chk.conf

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
chk_clean=7

if [ "$chk_time" == "Mon" ] ; then

   tmon_clean_time_go="Y"
   echo "$tmon_clean_time_go"

elif [ "$chk_time" == "Fri" ] ; then
   tmon_clean_time_go="Y"
   echo "$tmon_clean_time_go"

fi

proc_not_to='cpu_chk.conf|cpu_chk.sh|cpu_chkhtml.sh|chk'

if [ "$tmon_clean_time_go" == "Y" ]; then

   #找出指定時間目錄 清理
   clean='/u1/etc/chk_scripts/cpu'
   find $clean/* -mtime +${chk_clean} -print0 | grep -Ev "(grep|${proc_not_to})" | xargs -t rm -rf

fi

test_date=`date '+%Y/%m/%d %H:%M'`

time_test=`date '+%H:%M'`

test_dir="$chk_dir/$file"

echo "'"$time_test"'" >> $test_dir/${file}_date.txt

echo "," >> $test_dir/${file}_date.txt 

cpu_use=`ps -eo %cpu --sort=-%cpu | awk '{total += $1; } END { print total }'` 

load_avg5=`cat /proc/loadavg | awk '{print $1}'`

load_avg10=`cat /proc/loadavg | awk '{print $2}'`

load_avg15=`cat /proc/loadavg | awk '{print $3}'`

cpu_idle=`mpstat | grep all | awk '{print $13}'`

echo $cpu_use >> $test_dir/${file}_cpu.txt
echo $load_avg5 >> $test_dir/${file}_avg5.txt
echo $load_avg10 >> $test_dir/${file}_avg10.txt
echo $load_avg15 >> $test_dir/${file}_avg15.txt
echo $cpu_idle >> $test_dir/${file}_idle.txt

echo "," >> $test_dir/${file}_cpu.txt
echo "," >> $test_dir/${file}_avg5.txt
echo "," >> $test_dir/${file}_avg10.txt
echo "," >> $test_dir/${file}_avg15.txt
echo "," >> $test_dir/${file}_idle.txt


ps -eo %cpu,%mem,pid,ppid,tt,stime,time,cmd --sort=-%cpu | head -21 > $test_dir/123.txt

echo '<div class="content"><table width=500 border=1><tr><th colspan=1 style=background-color:#FFECC9>' >> $test_dir/${file}_cputest.html 
echo "$time_test CPU 前 20 名</div> </th></tr></table> </div>" >> $test_dir/${file}_cputest.html
echo '<div class="content"> ' >> $test_dir/${file}_cputest.html
echo "<table width=500 border=1>
          <tr>
          <th colspan=7 style=background-color:#FFECC9>CPU $time_test </th>
          </tr> 
" >> $test_dir/${file}_cputest.html


cpu_num=`cat $test_dir/123.txt | wc -l `

i=1

while [ "$i" -lt "$cpu_num" ] 
do
   if [ "$i" == 1 ] ; then
      cpu_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $1}' `
      mem_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $2}' `
      pid_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $3}' `
      ppid_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $4}' `
      tt_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $5}' `
      stime_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $6}' `
      time_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{print $7}' `
      cmd_chk=`cat $test_dir/123.txt | sed -n '1,1p' | awk '{$1=$2=$3=$4=$5=$6=$7="";print $0}' ` 
      echo "<tr> 
            <td> $cpu_chk    </td>
            <td> $mem_chk    </td>
            <td> $pid_chk    </td>
            <td> $ppid_chk   </td>
            <td> $tt_chk     </td>
            <td> $stime_chk  </td>
            <td> $time_chk   </td>
            <td> $cmd_chk    </td>
            </tr> 
           "  >> $test_dir/${file}_cputest.html
   else
      cpu_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $1}' `
      mem_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $2}' `
      pid_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $3}' `
      ppid_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $4}' `
      tt_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $5}' `
      stime_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $6}' `
      time_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $7}' `
      cmd_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{$1=$2=$3=$4=$5=$6=$7="";print $0}' ` 
      echo "<tr> 
            <td> $cpu_chk    </td>
            <td> $mem_chk    </td>
            <td> $pid_chk    </td>
            <td> $ppid_chk   </td>
            <td> $tt_chk     </td>
            <td> $stime_chk  </td>
            <td> $time_chk   </td>
            <td> $cmd_chk    </td>
            </tr> 
           "  >> $test_dir/${file}_cputest.html
   fi
   i=`expr $i + 1 `

done

echo "
     </table> 
     </div>
     "  >> $test_dir/${file}_cputest.html

#cat 123.txt | sed -n '1,1p'

#total_mem=`free | grep Mem | awk '{print $2}'`
#
#use_mem=`free | grep Mem | awk '{print $3}'`
#
#per_use=`awk -v x=$use_mem -v y=$total_mem 'BEGIN{printf "%.3f\n",x/y}' `
#
#use_buf=`free | grep Mem | awk '{print $5}'`
#
#per_buf=`awk -v x=$use_buf -v y=$total_mem 'BEGIN{printf "%.3f\n",x/y}' `
#
#total_swap=`free  | grep Swap | awk '{print $2}'` 
#
#use_swa=`free  | grep Swap | awk '{print $3}'` 
#
#per_swa=`awk -v x=$use_swa -v y=$total_mem 'BEGIN{printf "%.5f\n",x/y}' `
#
#echo $per_use >> $test_dir/${file}_use.txt
#
#echo $per_buf >> $test_dir/${file}_buf.txt
#
#echo $per_swa >> $test_dir/${file}_swp.txt
#
#echo "," >> $test_dir/${file}_use.txt
#echo "," >> $test_dir/${file}_buf.txt
#echo "," >> $test_dir/${file}_swp.txt
#
#echo "'"$test_date"'" >> $test_dir/${file}_test_date.txt
#
#echo "," >> $test_dir/${file}_test_date.txt 
