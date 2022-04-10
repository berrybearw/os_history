#!/bin/ksh

. /u1/etc/chk_scripts/cpu/cpu_chk.conf

LC_TIME=en_UK.utf8

test_date=`date '+%Y/%m/%d'`

if [ -z "$1" ] ; then
   file=`date '+%Y%m%d'`
else
   file=$1
fi

if [ "$MODE" == "check" ] ; then
   name=$NAME
   dir="${chk_dir}/chk/$name/$file"
   cd ${chk_dir}/chk/$name
else
   dir="$chk_dir/$file"
fi

where_ip=`cat /etc/hosts | grep $HOSTNAME | sed -n '1,1p' `

cpu_num=`lscpu |grep '^CPU(s):' |sed 's/^[ \t]*//g'|cut -d: -f 2`
cpu_hardver=`lscpu |grep '^Model name:' |sed 's/^[ \t]*//g'|cut -d: -f 2`
#echo "CPU MHz:" `lscpu |grep '^CPU MHz:' |sed 's/^[ \t]*//g'|cut -d: -f 2`
#echo "wa上限 :" $wa2"%"
cpu_total=`echo "$cpu_num * 100" | bc -l`

#sh cpu_chk.sh

echo '<html>
<head>
   <meta charset="UTF-8" />
   <title>Highcharts 來源 (runoob.com)</title>
   <script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
   <script src="https://code.highcharts.com/highcharts.js"></script>
</head>
<body>
' > cpu.html

echo '
<div id="container" style="width: 800px; height: 400px; margin: 0 auto"></div>
<script language="JavaScript">
$(document).ready(function() {
   ' >> cpu.html

echo "
   var chart = {
      type: 'spline'      
   };

   var title = {" >> cpu.html

echo "
      text: '$where_ip cpu 歷史使用率 $test_date '   
   };
   var subtitle = {
      text: 'CPU 總顆數 : $cpu_num , CPU 總數量 : $cpu_total , CPU 型號 : $cpu_hardver '
   };
   var xAxis = {
      categories: [" >> cpu.html


cat $dir/${file}_date.txt | sed '$d' >> cpu.html

echo ']
   };
   var yAxis = {
      title: {
         text: ' >> cpu.html 
echo "'total CPU %'
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
         name: '%cpu',
         data: [" >> cpu.html


cat $dir/${file}_cpu.txt | sed '$d' >> cpu.html

echo "] } " >> cpu.html 

echo "," >> cpu.html

echo "{
         name: '% idle',
         data: [" >> cpu.html

cat $dir/${file}_idle.txt | sed '$d' >> cpu.html

echo "] } " >> cpu.html

#echo "," >> cpu.html
#
#echo "{
#         name: '%use',
#         data: [" >> cpu.html
#
#cat ${file}_use.txt | sed '$d' >> cpu.html
#
#echo "] } " >> cpu.html
#
#echo "," >> cpu.html
#
#echo "{
#         name: '%buf',
#         data: [" >> cpu.html
#
#cat ${file}_buf.txt | sed '$d' >> cpu.html
#
#echo "] } " >> cpu.html

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

   \$('#container').highcharts(json);
});
</script>
" >> cpu.html
#第 1 個圖 (e)
#第 2 個圖 (s)
echo '
<div id="container2" style="width: 800px; height: 400px; margin: 0 auto"></div>
<script language="JavaScript">
$(document).ready(function() {
   ' >> cpu.html

echo "
   var chart = {
      type: 'spline'      
   };

   var title = {" >> cpu.html

echo "
      text: 'cpu 歷史負載率 $test_date '   
   };
   var subtitle = {
      text: 'CPU 總顆數 : $cpu_num , CPU 總數量 : $cpu_total , CPU 型號 : $cpu_hardver '
   };
   var xAxis = {
      categories: [" >> cpu.html


cat $dir/${file}_date.txt | sed '$d' >> cpu.html

echo ']
   };
   var yAxis = {
      title: {
         text: ' >> cpu.html 
echo "'load average '
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
         name: 'load avg 5',
         data: [" >> cpu.html


cat $dir/${file}_avg5.txt | sed '$d' >> cpu.html

echo "] } " >> cpu.html 

echo "," >> cpu.html

echo "{
         name: 'load avg 10',
         data: [" >> cpu.html

cat $dir/${file}_avg10.txt | sed '$d' >> cpu.html

echo "] } " >> cpu.html

echo "," >> cpu.html

echo "{
         name: 'load avg 15',
         data: [" >> cpu.html

cat $dir/${file}_avg15.txt | sed '$d' >> cpu.html

echo "] } " >> cpu.html

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

   \$('#container2').highcharts(json);
});
</script>
" >> cpu.html
echo ' 

<form name="form1" method="post" action="">
    <label>
    <input type="text" name="textfield" id="textfield">
    </label>
    <!-- 繫結onclick事件 -->
    <label>
    <input type="button" name="button" id="button" value="第幾頁" onclick="javascript: void displayVar();">
    </label>
</form>

<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

<div class="pagination">
</div>

<div id="jar" style="display:none">
' >> cpu.html

cat $dir/${file}_cputest.html >> cpu.html


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

    $("#button").on("click",function () {
        var topage = document.getElementById("textfield").value;
		if ( currentPage < topage ) {
		   for (var i =  currentPage ; i < topage; i++) {
		      document.getElementById("next-page").click();
			}  
	    } else if ( currentPage > topage ) { 
		   for (var i =  currentPage ; i > topage; i--) {
		      document.getElementById("previous-page").click() ;
			}
        } else {
        }
		
    });

});
    </script>
' >> cpu.html

echo "
</body>
</html>
" >> cpu.html

if [ "$MODE" == "check" ] ; then
   cp -p ${chk_dir}/chk/$name/cpu.html $TEMPDIR/cpu_${name}.html

   cd ${chk_dir}/chk
   rm -rf $name

   echo "請下載檔案 " $TEMPDIR/cpu_${name}.html 
else
   cp -p ${chk_dir}/cpu.html $TEMPDIR/cpu.html
   echo "請下載檔案 " $TEMPDIR/cpu.html
fi
