#!/bin/ksh

. /u1/etc/chk_scripts/db_space/db_space_chk.conf

cd $chk_dir 

LC_TIME=en_UK.utf8


if [ -z "$1" ] ; then
   file=`date '+%Y%m%d'`
   if [ "$MODE" == "check" ] ; then
      name=$NAME
      dir="${chk_dir}/chk/$name/day/$file"
      cd ${chk_dir}/chk/$name
   else
      dir="$chk_dir/day/$file"
   fi
   test_date=`date '+%Y%m%d'`
else
   if [ "$1" == "--help" ] ; then
      echo "db_space_chkhtml.sh month"
      echo "what is this : it will show db space month history use"
      exit
   fi
   if [ "$1" == "month" ] ; then
      file=$2
      dir="$chk_dir/month/$file"
      test_date=`date '+%Y'`
   else
      file=$1
      dir="$chk_dir/day/$file"
      test_date=$1
   fi
fi


where_ip=`cat /etc/hosts | grep $HOSTNAME | sed -n '1,1p' `

#sh cpu_chk.sh

echo '<html>
<head>
   <meta charset="UTF-8" />
   <title>Highcharts 來源 : 教程 | 菜鸟教程(runoob.com)</title>
   <script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
   <script src="https://code.highcharts.com/highcharts.js"></script>
</head>
<body>
' > db_space.html

echo "
<style>
	.container3 {
  display: flex;
  width: 100%;
  height: 500px;
}

.chart1,
.chart2 {
  width: 50%;
  background-color: lightblue;
  border: thin solid darkgray;
}
	</style>
" >> db_space.html

i=1
n=`cat $dir/${file}_name.txt | wc -l`
while [ "$i" -le "$n" ];
do

   tbs_name=`cat $dir/${file}_name.txt | sed -n "${i},${i}p"`
   #echo '
   #<div id="container'$i'" style="width: 800px; height: 400px; margin: 0 auto"></div>
   #' >> db_space.html
   echo '
   <div class="container3">
      <div class="chart1" id="containerx'$i'" style="width: 550px; height: 400px; margin: 0 auto"></div>
      <div class="chart2" id="containery'$i'" style="width: 550px; height: 400px; margin: 0 auto"></div>
   </div>
   ' >> db_space.html
   echo '<script language="JavaScript">
   $(document).ready(function() {
      var chart = {
      type: '"'spline'"'      
      };

      var title = {' >> db_space.html
   echo "
         text: '$where_ip 表空間 歷史使用率 % $test_date '   
      };
      var subtitle = {
         text: '表空間 $tbs_name'
      };
      var xAxis = {
         categories: [" >> db_space.html
   
   
   cat $dir/${file}_date.txt | sed '$d' >> db_space.html
   
   echo ']
      };
      var yAxis = {
         title: {
            text: ' >> db_space.html 
   echo "'%'
         },
      labels: {
         formatter: function () {
            return this.value + '\xB0';
         }
      },
      lineWidth: 2
   };
   var tooltip = {
      crosshairs: true,
      shared: true,
	   valueSuffix: ' %'
   };
   var plotOptions = {
      spline: {
         marker: {
            radius: 4,
            lineColor: '#666666',
            lineWidth: 1
         }
      }
   };
 
      var series =  [
         {
            " >> db_space.html

      echo "
            name: 'total use',
            data: [" >> db_space.html

      cat $dir/${file}_${tbs_name}_use.txt | sed '$d' >> db_space.html
      
      echo "] } " >> db_space.html 


   echo "
      ];
   
      var json = {};
   
      json.chart = chart;
      json.title = title;
      json.subtitle = subtitle;
      json.tooltip = tooltip;
      json.xAxis = xAxis;
      json.yAxis = yAxis;  
      json.series = series;
      json.plotOptions = plotOptions;
   
      \$('#containerx$i').highcharts(json);
   });
   </script>
   " >> db_space.html

   echo '<script language="JavaScript">
   $(document).ready(function() {
      var title = {' >> db_space.html
   echo "
         text: '$where_ip 表空間 歷史總容量 G $test_date '   
      };
      var subtitle = {
         text: '表空間 $tbs_name '
      };
      var xAxis = {
         categories: [" >> db_space.html
   
   
   cat $dir/${file}_date.txt | sed '$d' >> db_space.html
   
   echo ']
      };
      var yAxis = {
         title: {
            text: ' >> db_space.html 
   echo "' G '
         },
         plotLines: [{
            value: 0,
            width: 1,
            color: '#808080'
         }]
      };   
   
      var tooltip = {
         valueSuffix: ' G'
      }
   
      var legend = {
         layout: 'vertical',
         align: 'right',
         verticalAlign: 'middle',
         borderWidth: 0
      };
   
      var series =  [
         {
            " >> db_space.html

      echo "
            name: 'total Space',
            data: [" >> db_space.html

      cat $dir/${file}_${tbs_name}_total.txt | sed '$d' >> db_space.html
      
      echo "] } " >> db_space.html 
      
   echo "
      ];
   
      var json = {};
   
      json.title = title;
      json.subtitle = subtitle;
      json.xAxis = xAxis;
      json.yAxis = yAxis;
      json.tooltip = tooltip;
      json.legend = legend;
      json.series = series;
   
      \$('#containery$i').highcharts(json);
   });
   </script>
   " >> db_space.html

   i=`expr $i + 1`

done

#第 1 個圖 (e)
echo ' 
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

<div class="pagination">
</div>

<div id="jar" style="display:none">
' >> db_space.html

#cat $dir/${file}_cputest.html >> db_space.html


echo '
</div>
    <script type="text/javascript">
        // Returns an array of maxLength (or less) page numbers
// where a 0 in the returned array denotes a gap in the series.
// Parameters:
//   totalPages:     total number of pages
//   page:           current page
//   maxLength:      maximum size of returned array
function getPageList(totalPages, page, maxLength) {
    if (maxLength < 5) throw "maxLength must be at least 5";

    function range(start, end) {
        return Array.from(Array(end - start + 1), (_, i) => i + start); 
    }

    var sideWidth = maxLength < 9 ? 1 : 2;
    var leftWidth = (maxLength - sideWidth*2 - 3) >> 1;
    var rightWidth = (maxLength - sideWidth*2 - 2) >> 1;
    if (totalPages <= maxLength) {
        // no breaks in list
        return range(1, totalPages);
    }
    if (page <= maxLength - sideWidth - 1 - rightWidth) {
        // no break on left of page
        return range(1, maxLength - sideWidth - 1)
            .concat(0, range(totalPages - sideWidth + 1, totalPages));
    }
    if (page >= totalPages - sideWidth - 1 - rightWidth) {
        // no break on right of page
        return range(1, sideWidth)
            .concat(0, range(totalPages - sideWidth - 1 - rightWidth - leftWidth, totalPages));
    }
    // Breaks on both sides
    return range(1, sideWidth)
        .concat(0, range(page - leftWidth, page + rightWidth),
                0, range(totalPages - sideWidth + 1, totalPages));
}

// Below is an example use of the above function.
$(function () {
    // Number of items and limits the number of items per page
    var numberOfItems = $("#jar .content").length;
    var limitPerPage = 2;
    // Total pages rounded upwards
    var totalPages = Math.ceil(numberOfItems / limitPerPage);
    // Number of buttons at the top, not counting prev/next,
    // but including the dotted buttons.
    // Must be at least 5:
    var paginationSize = 7; 
    var currentPage;

    function showPage(whichPage) {
        if (whichPage < 1 || whichPage > totalPages) return false;
        currentPage = whichPage;
        $("#jar .content").hide()
            .slice((currentPage-1) * limitPerPage, 
                    currentPage * limitPerPage).show();
        // Replace the navigation items (not prev/next):            
        $(".pagination li").slice(1, -1).remove();
        getPageList(totalPages, currentPage, paginationSize).forEach( item => {
            $("<li>").addClass("page-item")
                     .addClass(item ? "current-page" : "disabled")
                     .toggleClass("active", item === currentPage).append(
                $("<a>").addClass("page-link").attr({
                    href: "javascript:void(0)"}).text(item || "...")
            ).insertBefore("#next-page");
        });
        // Disable prev/next when at first/last page:
        $("#previous-page").toggleClass("disabled", currentPage === 1);
        $("#next-page").toggleClass("disabled", currentPage === totalPages);
        return true;
    }

    // Include the prev/next buttons:
    $(".pagination").append(
        $("<li>").addClass("page-item").attr({ id: "previous-page" }).append(
            $("<a>").addClass("page-link").attr({
                href: "javascript:void(0)"}).text("Prev")
        ),
        $("<li>").addClass("page-item").attr({ id: "next-page" }).append(
            $("<a>").addClass("page-link").attr({
                href: "javascript:void(0)"}).text("Next")
        )
    );
    // Show the page links
    $("#jar").show();
    showPage(1);

    // Use event delegation, as these items are recreated later    
    $(document).on("click", ".pagination li.current-page:not(.active)", function () {
        return showPage(+$(this).text());
    });
    $("#next-page").on("click", function () {
        return showPage(currentPage+1);
    });

    $("#previous-page").on("click", function () {
        return showPage(currentPage-1);
    });
});
    </script>
' >> db_space.html

echo "
</body>
</html>
" >> db_space.html

if [ "$MODE" == "check" ] ; then
   cp -p ${chk_dir}/chk/$name/db_space.html $TEMPDIR/db_space_${name}.html

   cd ${chk_dir}/chk
   rm -rf $name

   echo "請下載檔案 " $TEMPDIR/db_space_${name}.html
else
   cp -p $chk_dir/db_space.html $TEMPDIR/db_space.html
   echo "請下載檔案 " $TEMPDIR/db_space.html
fi
