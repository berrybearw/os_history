#!/bin/ksh 

. /u1/etc/chk_scripts/io/io_chk.conf

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

proc_not_to='io_chk.conf|io_chk.sh|io_chkhtml.sh|chk'

if [ "$tmon_clean_time_go" == "Y" ]; then

   #找出指定時間目錄 清理
   clean='/u1/etc/chk_scripts/io'
   find $chk_dir/* -mtime +$chk_clean -print0 | grep -Ev "(grep|${proc_not_to})" | xargs -t rm -rf

fi

test_dir="$chk_dir/"$file

avg_iowait=`iostat -x 1 6 | grep -A 1 'iowait' | sed -n '4,$p' | grep -v 'iowait' | awk '{sum += $4} END {print sum/5}'`

echo $avg_iowait >> $test_dir/${file}_iowait.txt

echo "," >> $test_dir/${file}_iowait.txt

echo "'"$test_date"'" >> $test_dir/${file}_date.txt

echo "," >> $test_dir/${file}_date.txt 

echo '<div class="content"><table width=500 border=1><tr><th colspan=1 style=background-color:#FFECC9>' >> $test_dir/${file}_iotest.html 
echo "$test_date io 前 20 名</div> </th></tr></table> </div>" >> $test_dir/${file}_iotest.html
echo '<div class="content"> ' >> $test_dir/${file}_iotest.html
echo "<table width=500 border=1>
          <tr>
          <th colspan=7 style=background-color:#FFECC9>io $test_date </th>
          </tr> 
" >> $test_dir/${file}_iotest.html


pidstat -ld 1 1 | grep 'Average' | sed -n '2,$p' | sort -r -k5 -n | head -21 > $test_dir/123.txt

io_num=`cat $test_dir/123.txt | wc -l `

i=0

while [ "$i" -lt "$io_num" ] 
do
   if [ "$i" == 0 ] ; then
      uid_chk="UID"
      pid_chk="PID"
      rd_chk="kB_rd/s"
      wr_chk="kB_wr/s"
      ccwr_chk="kB_ccwr/s"
      iodelay_chk="iodelay"
      cmd_chk="cmd"
      echo "<tr> 
            <td> $uid_chk    </td>
            <td> $pid_chk    </td>
            <td> $rd_chk    </td>
            <td> $wr_chk   </td>
            <td> $ccwr_chk     </td>
            <td> $iodelay_chk  </td>
            <td> $cmd_chk   </td>
            </tr> 
           "  >> $test_dir/${file}_iotest.html
   else
      uid_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $2}' `
      pid_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $3}' `
      rd_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $4}' `
      wr_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $5}' `
      ccwr_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $6}' `
      iodelay_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{print $7}' `
      cmd_chk=`cat $test_dir/123.txt | sed -n "$i,${i}p" | awk '{$1=$2=$3=$4=$5=$6=$7="";print $0}' ` 
      echo "<tr> 
            <td> $uid_chk    </td>
            <td> $pid_chk    </td>
            <td> $rd_chk    </td>
            <td> $wr_chk   </td>
            <td> $ccwr_chk     </td>
            <td> $iodelay_chk  </td>
            <td> $cmd_chk    </td>
            </tr> 
           "  >> $test_dir/${file}_iotest.html
   fi
   i=`expr $i + 1 `

done

echo "
     </table> 
     </div>
     "  >> $test_dir/${file}_iotest.html

