#!/bin/ksh 

. /u1/etc/chk_scripts/proces/pro_chk.conf

file=`date '+%Y%m%d'`

if [ "$MODE" == "check" ] ; then

   name=$NAME
   chk_dir_a=$chk_dir
   chk_dir="$chk_dir/chk/$name"
   mkdir $chk_dir
   mkdir $chk_dir/$file
   if [ ! -d "$chk_dir/$file" ]; then
      mkdir $chk_dir/$file
   fi
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

proc_not_to='pro_chk.conf|pro_chk.sh|pro_chkhtml.sh|chk'

if [ "$tmon_clean_time_go" == "Y" ]; then

   #找出指定時間目錄 清理
   clean='/u1/etc/chk_scripts/proces'
   find $clean/* -mtime +${chk_clean} -print0 | grep -Ev "(grep|${proc_not_to})" | xargs -t rm -rf

fi

test_date=`date '+%Y/%m/%d %H:%M'`

time_test=`date '+%H:%M'`

test_dir="$chk_dir/$file"

echo "'"$time_test"'" >> $test_dir/${file}_date.txt

echo "," >> $test_dir/${file}_date.txt 

pro_all=`ps -ef | wc -l`
pro_zom=`ps -eo stat | awk '{if($1=="Zs" || $1=="Z") print $1 }' | wc -l`
pro_sto=`ps -eo stat | awk '{if($1=="Ts" || $1=="T") print $1 }' | wc -l`

pro_topprd=`ps -ef | grep fglrun | grep topprd | wc -l` 
pro_toptst=`ps -ef | grep fglrun | grep toptst | wc -l` 

service_task=`systemctl status gas-topprd.service | grep 'Task' | awk -F : '{print $2}' | awk -F \( '{print $1}'`
service_task=`echo | awk "{print $service_task/1000}"`
service_taskmax=`/usr/sbin/sysctl -a 2>/dev/null | grep 'kernel.threads-max' | awk -F = '{print $2}'`
echo "@@@"
service_taskmax=`echo | awk "{print $service_taskmax/1000}"`

echo $pro_all >> $test_dir/${file}_all.txt
echo $pro_zom >> $test_dir/${file}_zom.txt
echo $pro_sto >> $test_dir/${file}_sto.txt
echo $pro_topprd >> $test_dir/${file}_topprd.txt
echo $pro_toptst >> $test_dir/${file}_toptst.txt
echo $service_task >> $test_dir/${file}_task.txt
echo $service_taskmax >> $test_dir/${file}_taskmax.txt

echo "," >> $test_dir/${file}_all.txt
echo "," >> $test_dir/${file}_zom.txt
echo "," >> $test_dir/${file}_sto.txt
echo "," >> $test_dir/${file}_topprd.txt
echo "," >> $test_dir/${file}_toptst.txt
echo "," >> $test_dir/${file}_task.txt
echo "," >> $test_dir/${file}_taskmax.txt


ps -eo %cpu,%mem,pid,ppid,tt,stime,time,cmd --sort=-%mem | head -1 > $test_dir/123.txt
ps -eo %cpu,%mem,pid,ppid,tt,stime,time,cmd --sort=-%mem | grep fglrun | head -21 >> $test_dir/123.txt

echo '<div class="content"><table width=500 border=1><tr><th colspan=1 style=background-color:#FFECC9>' >> $test_dir/${file}_protest.html 
echo "$time_test Mem 前 20 名</div> </th></tr></table> </div>" >> $test_dir/${file}_protest.html
echo '<div class="content"> ' >> $test_dir/${file}_protest.html
echo "<table width=500 border=1>
          <tr>
          <th colspan=7 style=background-color:#FFECC9>Mem $time_test </th>
          </tr> 
" >> $test_dir/${file}_protest.html


pro_num=`cat $test_dir/123.txt | wc -l `

i=1

while [ "$i" -lt "$pro_num" ] 
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
           "  >> $test_dir/${file}_protest.html
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
           "  >> $test_dir/${file}_protest.html
   fi
   i=`expr $i + 1 `

done

echo "
     </table> 
     </div>
     "  >> $test_dir/${file}_protest.html

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
