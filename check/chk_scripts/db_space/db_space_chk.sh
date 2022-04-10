#!/bin/ksh 

. /u1/etc/chk_scripts/db_space/db_space_chk.conf

cd $chk_dir

file=`date '+%Y%m%d'`

if [ "$MODE" == "check" ] ; then

   name=$NAME
   chk_dir_a=$chk_dir/day
   chk_dir="$chk_dir/chk/$name"
   mkdir $chk_dir
   mkdir $chk_dir/day
   mkdir $chk_dir/day/$file
   cp -p $chk_dir_a/$file/* $chk_dir/day/$file

else

   chk_dir=$chk_dir

fi

if [ ! -d "$chk_dir/day/$file" ]; then
   mkdir $chk_dir/day/$file
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

proc_not_to='db_space_chk.conf|db_space_chk.sh|db_space_chkm.sh|db_space_chkhtml.sh|chk'

if [ "$tmon_clean_time_go" == "Y" ]; then

   #找出指定時間目錄 清理
   clean='/u1/etc/chk_scripts/db_space/day'
   find $clean/* -mtime +${chk_clean} -print0 | grep -Ev "(grep|${proc_not_to})" | xargs -t rm -rf

fi

test_date=`date '+%Y/%m/%d %H:%M'`

time_test=`date '+%H:%M'`

test_dir="$chk_dir/day/$file"

echo "'"$time_test"'" >> $test_dir/${file}_date.txt

echo "," >> $test_dir/${file}_date.txt 

chk_logdir=$chk_dir

db_space_use=$( 
                echo "
                
                set feedback off
                set pagesize 0
                set linesize 2000
                set long 9999
                set trimspool on
                set headsep off
                COLUMN Tablespace format a25 heading 'Tablespace Name'
                COLUMN autoextensible format a11 heading 'AutoExtend'
                COLUMN files_in_tablespace format 999 heading 'Files'
                COLUMN total_tablespace_space format 99999999 heading 'TotalSpace'
                COLUMN total_used_space format 99999999 heading 'UsedSpace'
                COLUMN total_tablespace_free_space format 99999999 heading 'FreeSpace'
                COLUMN total_used_pct format 9999 heading '%Used'
                COLUMN total_free_pct format 9999 heading '%Free'
                COLUMN max_size_of_tablespace format 99999999 heading 'ExtendUpto'
                COLUMN total_auto_used_pct format 999.99 heading 'Max%Used'
                COLUMN total_auto_free_pct format 999.99 heading 'Max%Free'       

                SPOOL ${chk_logdir}/chk_db_space.log
                WITH tbs_auto AS
                (SELECT DISTINCT tablespace_name, autoextensible
                FROM dba_data_files
                WHERE autoextensible = 'YES'),
                files AS
                (SELECT tablespace_name, COUNT (*) tbs_files,
                SUM (BYTES/1024/1024) total_tbs_bytes
                FROM dba_data_files
                GROUP BY tablespace_name),
                fragments AS
                (SELECT tablespace_name, COUNT (*) tbs_fragments,
                SUM (BYTES)/1024/1024 total_tbs_free_bytes,
                MAX (BYTES)/1024/1024 max_free_chunk_bytes
                FROM dba_free_space
                GROUP BY tablespace_name),
                AUTOEXTEND AS
                (SELECT tablespace_name, SUM (size_to_grow) total_growth_tbs
                FROM (SELECT tablespace_name, SUM (maxbytes)/1024/1024 size_to_grow
                FROM dba_data_files
                WHERE autoextensible = 'YES'
                GROUP BY tablespace_name
                UNION
                SELECT tablespace_name, SUM (BYTES)/1024/1024 size_to_grow
                FROM dba_data_files
                WHERE autoextensible = 'NO'
                GROUP BY tablespace_name)
                GROUP BY tablespace_name),
                tbs_temp as 
                (
                  select
                  c.instance_name,h.tablespace_name as Tablespace,
                  f.autoextensible,
                  round(sum(h.bytes_free + h.bytes_used)/1048576) megs_alloc,
                  round(sum(nvl(p.bytes_used, 0))/1048576) megs_used,
                  round(sum((h.bytes_free + h.bytes_used) - nvl(p.bytes_used,0))/1048576) megs_free,
                  100 -round((sum((h.bytes_free + h.bytes_used) -nvl(p.bytes_used, 0))/ sum(h.bytes_used + h.bytes_free)) * 100) pct_used,
                  round((sum((h.bytes_free + h.bytes_used) -nvl(p.bytes_used, 0))/ sum(h.bytes_used + h.bytes_free)) * 100) Pct_Free
                  from sys.v_\$TEMP_SPACE_HEADER h, 
                  sys.v_\$Temp_extent_pool p, 
                  dba_temp_files f,
                  v\$instance c
                  where p.file_id(+)= h.file_id
                  and p.tablespace_name(+)=h.tablespace_name 
                  and f.file_id = h.file_id
                  and f.tablespace_name = h.tablespace_name
                  group by h.tablespace_name,c.instance_name,f.autoextensible
                )
                SELECT c.instance_name,a.tablespace_name Tablespace,
                CASE tbs_auto.autoextensible
                WHEN 'YES'
                THEN 'YES'
                ELSE 'NO'
                END AS autoextensible,
                files.tbs_files files_in_tablespace,
                files.total_tbs_bytes total_tablespace_space,
                (files.total_tbs_bytes - fragments.total_tbs_free_bytes
                ) total_used_space,
                fragments.total_tbs_free_bytes total_tablespace_free_space,
                round(( ( (files.total_tbs_bytes - fragments.total_tbs_free_bytes)
                / files.total_tbs_bytes
                )
                * 100
                )) total_used_pct,
                round(((fragments.total_tbs_free_bytes / files.total_tbs_bytes) * 100
                )) total_free_pct
                FROM dba_tablespaces a,v\$instance c , files, fragments, AUTOEXTEND, tbs_auto
                WHERE a.tablespace_name = files.tablespace_name
                AND a.tablespace_name = fragments.tablespace_name
                AND a.tablespace_name = AUTOEXTEND.tablespace_name
                AND a.tablespace_name = tbs_auto.tablespace_name(+) 
                union
                select instance_name,tablespace,autoextensible ,
                (select count(*) from dba_temp_files ) tbs_file ,megs_alloc,
                megs_used,megs_free,pct_used,Pct_Free
                from tbs_temp
                order by tablespace ;
                SPOOL OFF
                exit

                " | sqlplus -S "du/du@$ZONE"
                )

i=1
n=`cat ${chk_logdir}/chk_db_space.log | wc -l`

echo "" > $test_dir/${file}_ins.txt
echo "" > $test_dir/${file}_name.txt

while [ "$i" -le "$n" ];
do

   tbs_ins=`cat ${chk_logdir}/chk_db_space.log | awk '{print $1}' | sed -n "$i,${i}p"`

   tbs_name=`cat ${chk_logdir}/chk_db_space.log | awk '{print $2}' | sed -n "$i,${i}p"`

   echo $tbs_ins >> $test_dir/${file}_ins.txt
   echo $tbs_name >> $test_dir/${file}_name.txt

   i2=1
   n2=`cat ${chk_logdir}/chk_db_space.log |grep -w $tbs_name | wc -l`
   while [ "$i2" -le "$n2" ] ; 
   do 

      tbs_auto=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $3}' | sed -n "$i2,${i2}p"`
      
      tbs_file=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $4}' | sed -n "$i2,${i2}p"`
      
      tbs_total=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $5}' | sed -n "$i2,${i2}p"`
      
      tbs_use=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $6}' | sed -n "$i2,${i2}p"`
      
      tbs_free=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $7}' | sed -n "$i2,${i2}p"`
      
      tbs_use_percent=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $8}' | sed -n "$i2,${i2}p"`
      
      tbs_free_percent=`cat ${chk_logdir}/chk_db_space.log | grep -w $tbs_name | awk '{print $9}' | sed -n "$i2,${i2}p"`

      i2=`expr $i2 + 1`

      total_g=`awk -v x=$tbs_total -v y=1024 'BEGIN{printf "%.3f\n",x/y}'`
      echo $total_g >> $test_dir/${file}_${tbs_name}_total.txt
      echo $tbs_use_percent >> $test_dir/${file}_${tbs_name}_use.txt
      echo $tbs_free_percent >> $test_dir/${file}_${tbs_name}_free.txt

      echo "," >> $test_dir/${file}_${tbs_name}_total.txt
      echo "," >> $test_dir/${file}_${tbs_name}_use.txt
      echo "," >> $test_dir/${file}_${tbs_name}_free.txt

   done
   
   i=`expr $i + 1`

done

cat $test_dir/${file}_name.txt | grep '^[[:blank:]]*[^[:blank:]]' > $test_dir/${file}_name2.txt
cat $test_dir/${file}_name2.txt > $test_dir/${file}_name.txt

#while [ "$i" -le "$n" ];
#do
#
#      tbs_auto=`cat ${chk_logdir}/chk_db_space.log | awk '{print $3}' | sed -n "$i,${i}p"`
#      
#      tbs_file=`cat ${chk_logdir}/chk_db_space.log | awk '{print $4}' | sed -n "$i,${i}p"`
#      
#      tbs_total=`cat ${chk_logdir}/chk_db_space.log | awk '{print $5}' | sed -n "$i,${i}p"`
#      
#      tbs_use=`cat ${chk_logdir}/chk_db_space.log | awk '{print $6}' | sed -n "$i,${i}p"`
#      
#      tbs_free=`cat ${chk_logdir}/chk_db_space.log | awk '{print $7}' | sed -n "$i,${i}p"`
#      
#      tbs_use_percent=`cat ${chk_logdir}/chk_db_space.log | awk '{print $8}' | sed -n "$i,${i}p"`
#      
#      tbs_free_percent=`cat ${chk_logdir}/chk_db_space.log | awk '{print $9}' | sed -n "$i,${i}p"`
#   
#   echo $tbs_use_percent >> $test_dir/${file}_use.txt
#   echo $tbs_free_percent >> $test_dir/${file}_free.txt
#
#   echo "," >> $test_dir/${file}_use.txt
#   echo "," >> $test_dir/${file}_free.txt
#
#   i=`expr $i + 1 `
#
#done

exit

