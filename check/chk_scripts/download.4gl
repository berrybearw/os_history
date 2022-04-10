#該程式未解開Section, 採用最新樣板產出!
#該程式為freestyle程式!
{<section id="cl_export.description" type="s" >}
#應用 a00 樣板自動產生(Version:3)
#+ Standard Version.....: SD版次:0069(1900-01-01 00:00:00), PR版次:0069(2021-05-06 17:27:07)
#+ Customerized Version.: SD版次:0000(1900-01-01 00:00:00), PR版次:0000(1900-01-01 00:00:00)
#+ Build......: 000365
#+ Filename...: cl_export
#+ Description: 資料轉檔匯出功能
#+ Creator....: 00845(2013-12-26 11:38:06)
#+ Modifier...: 00000 -SD/PR- 12731
 
{</section>}
 
{<section id="cl_export.global" type="s" >}
#應用 p00 樣板自動產生(Version:6)
#add-point:填寫註解說明 name="main.memo"
#160328-00033#1 2016/03/28 by jrg542 cl_export調整
#150827-00033#1 Modify 2015/08/27 by chenjpa 修改调整画面顺序后画面与excel栏位顺序不一致
#150903-00002#1 Modify 2015/09/3 by chenjpa  修改汇出多页签
#151023-00005#1 Modify 2015/10/23 by chenjpa 修改页签中含"/"问题
#151116-00007#1 Modify 2015/11/16 by chenjpa 增加汇出树状节点
#160415-00014#1 Modify 2016/04/15 by chenjpa 修改汇出节点是空的情况无法打开excel
#160706-00013#1 Modify 2016/07/06 by chenjpa 修改无法汇出放在非page节点下的单身内容
#160711-00028#1 Modify 2016/07/11 by chenjpa 修改金额栏位值汇出小数点被吃掉
#160711-00028#2 Modify 2016/07/12 by chenjpa 增加使汇出单身栏位带边框
#160803-00020#1 Modify 2016/08/03 by chenjpa 增加使汇出excel可自适应宽度
#160830-00018#1 Modify 2016/08/30 by chenjpa 增加自定义报表汇出excel的逻辑控管
#160830-00018#2 Modify 2016/09/05 by chenjpa 修改作业只有一个单身，未调用选择单身cl_export_to_excel_getpage函数，汇出excel报错问题
#161121-00017#1 Modify 2016/11/21 by chenjpa 补单160706-00013#1
#161122-00021#1 Modify 2016/11/22 by chenjpa 补单151116-00007#1
#161202-00017#1 Modify 2016/12/05 by chenjpa 自适应长度效能
#161223-00039#1 Modify 2016/12/05 by chenjpa 页签显示:当page包page包table时候会出现两个页签选项，或者page包group包table，group设置隐藏，页签也会出现，即客户所述的多余的非单身页签
#170125-00012#1 Modify 2016/12/25 by Chenjpa 修改页签中含1.: 冒號 2./ 斜線 3.\ 反斜線 4. ? 問號 5. * 星號 6. [ 中括號 7. ] 中括；1.4.5用底線'_'，2.3用空白' '，6用左括弧，7用右括弧代替  
#170316-00014#1 Modify 2017/03/22 by Xiaohb  修改第一个非隐藏栏位为LLabel，tableindexRT为空，l_seq[1]为null，作为参数传入cl_export_body_xml，导致汇出文件无法打开
#170314-00067#1 Modify 2017/04/05 by Xiaohb  修改列顺序一致，宽度自动调整，精度，与画面排序一致这些功能为可选项。
#170627-00042#1 Modify 2017/06/27 by Chenjpa 修改调整画面顺序后画面与excel栏位顺序不一致问题
#170706-00043#1 Modify 2017/07/06 by Chenjpa 调整非tree结构的单身中包含Phantom汇出异常
#170718-00031#1 Modify 2017/07/19 by Chenjpa 调整因单号170706-00043#1问题调整造成自定义汇出栏位左移
#170711-00036#1 Modify 2017/07/19 by 02716   cl_export新增cl_export_poi()函式是透過poi方式做單身匯excel
#170803-00019#1 Modify 2017/08/03 by 02716   補上需求單#170711-00036#1註解
#170907-00031#1 Modify 2017/10/24 by 02716   POI增加精度、欄位順序、自動調欄寬功能，隱藏欄位BUG修復，INT空值BUG修復
#171024-00011#1 Modify 2017/11/08 by 02716   1.XML:判斷aooi714這類是i05或i13樣板組成的程式，讓他入s_browse 2.POI:browse日期型態調整
#171122-00022#1 Modify 2017/11/24 by 02716   調整xml格式的瀏灠頁變數由num5改成num10
#180103-00040#1 Modify 2018/01/03 by 02716   調整讀取精度格式的順序，將l_cell_cnt改成l_sort_num
#180110-00031#1 Modify 2018/01/10 by 02716   調整poi browser段讀取陣列參數sheetInfo[l_tab_num]為sheetInfo[1]
#180105-00052#1 Modify 2018/01/22 by 02716   修正數值欄位小數只取到2位問題
#171103-00010#1 Modify 2018/02/21 by 02176   POI功能新增資料排序一致功能
#180315-00009#2 Modify 2018/03/21 by 02176   串接自定義查詢azzi310的背景排程匯excel功能，調整poi段
#180503-00008#1 Modify 2018/05/03 by 02176   cl_export調整處理azzi310來源要抓數值格式，另外做腳本處理多傳1的參數做區別，腳本接到1時要判斷內容是否為數值進而置換。
#180508-00059#1 Modify 2018/05/08 by 02176   azzi310串接過來，新增整數數值格式
#180510-00004#1 Modify 2018/05/10 by 02176   判斷數值格式有值才進行轉換
#180510-00044#1 Modify 2018/05/10 by 02176   azzi310串進來的整數也要做總計小計行轉回文字型態
#180514-00032#1 Modify 2018/05/14 by 02176   1.POI段匯出EXCEL做隱藏時，要以畫面排序後的來處理 2.poi的sheetname不可以有空白格
#180524-00045#1 Modify 2018/05/24 by 02176   POI瀏覽頁不需加畫面排序來處理
#180607-00017#1 Modify 2018/06/07 by 02176   POI匯出新增日期格式
#180731-00023#1 Modify 2018/07/31 by 02176   1.POI匯出支援單身樹狀架構 2.修復瀏覽頁籤combox錯位
#181101-00036#1 Modify 2018/11/21 by 02176   調整整數位匯出格式，補上千分位類型
#190103-00053#1 Modify 2019/01/09 by 02176   因cl_export中的檔名使用CURRENT YEAR TO FRACTION(5)，會有時區誤差，調整改用cl_get_timestamp() 
#190115-00065#1 Modify 2019/01/15 by 02176   調整不需做檔名處理
#190116-00065#1 Modify 2019/01/29 by 02776   azzi310匯出檔名多加上查詢單資訊
#190110-00031#1 Modify 2019/03/19 by 10553   1.調整欄位排序時,欄位名稱的取得方式
#                                            2.調整欄位排序時傳給Python的參數
#181001-00004#1 Modify 2019/04/08 by 10553   POI匯出browse頁簽帶出狀態欄位
#190419-00002#1 Modify 2019/04/19 by 10553   1.透過python處理數值欄位小數位取位2.匯出Excel檢查Sheet名稱不重複
#190418-00021#1 Modify 2019/04/24 by 10553   調整POI匯出Excel欄位名稱重複時被自動加".1"問題
#190409-00010#1 Modify 2019/05/07 by 10553   調整串查欄位順序
#190521-00021#1 Modify 2019/05/27 by 10553   POI匯出Excel修正下拉選單缺少選項說明問題
#190625-00034#1 Modify 2019/07/05 by 10553   修正azzi310匯出Excel數值欄位型態異常問題
#190723-00002#1 Modify 2019/07/23 by 10553   支持azzi310使用POI方式匯出數值型態欄位
#190813-00021#1 Modify 2019/08/13 by 10553   1.支持azzi310使用POI匯出Excel時,欄位順序與畫面一致
#                                            2.支持azzi310使用POI匯出Excel時,透過python處理數值欄位小數位取位
#190911-00033#1 Modify 2019/10/02 by 10553   將程式中使用的TODAY與CURRENT指令,改用cl_get方式取得
#191119-00008#1 Modify 2019/11/19 by 10553   POI匯出Excel日期格式調整
#191204-00052#1 Modify 2019/12/12 by 10553   1.支持azzi310使用POI匯出Excel,欄位寬度自動調整
#                                            2.azzi310使用POI方式匯出Excel效能優化
#191225-00039#1 Modify 2019/12/26 by 10553   修正單身數值欄位誤用下拉選單說明問題
#200525-00045#1 Modify 2020/05/25 by 12731   增加CPU限制
#201021-00011#1 Modify 2020/10/28 by 12731   修復 POI 使用 畫面篩選隱藏欄位
#201111-00005#1 Modify 2020/11/12 by 12731   背景執行匯出 Excel 可自適應資料大小 A-SYS-0063
#210430-00005#1 Modify 2021/05/06 by 12731   增加 畫面類型有 s_qry 能匯出 excel


#end add-point
#add-point:填寫註解說明(客製用) name="main.memo_customerization"

#end add-point
#(ver:6) ---start---
#add-point:填寫註解說明(行業用) name="global.memo_industry"

#end add-point
#(ver:6) --- end ---
 
IMPORT os
#add-point:增加匯入項目 name="main.import"
#170711-00036#1 add--(s)
IMPORT util
IMPORT JAVA java.io.FileOutputStream
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFWorkbook
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFSheet
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFRow
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFCell
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFCellStyle
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFFont
IMPORT JAVA org.apache.poi.ss.usermodel.IndexedColors
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFDataFormat
IMPORT JAVA com.fourjs.fgl.lang.FglRecord
IMPORT JAVA com.fourjs.fgl.lang.FglDecimal
IMPORT JAVA com.fourjs.fgl.lang.FglDate
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFWorkbook
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFSheet
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFRow
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFCell
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFCellStyle
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFFont
IMPORT JAVA org.apache.poi.ss.usermodel.IndexedColors
IMPORT JAVA org.apache.poi.hssf.usermodel.HSSFDataFormat
IMPORT JAVA org.apache.poi.xssf.streaming.SXSSFWorkbook
IMPORT JAVA org.apache.poi.ss.usermodel.CellStyle
IMPORT JAVA org.apache.poi.ss.usermodel.Sheet
IMPORT JAVA org.apache.poi.ss.usermodel.Row
IMPORT JAVA org.apache.poi.ss.usermodel.Cell
IMPORT JAVA org.apache.poi.ss.usermodel.Font
#170711-00036#1 add --(e)
##170907-00031#1 jaent add -(s)
IMPORT JAVA org.apache.poi.ss.usermodel.DataFormat   
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFWorkbook
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFSheet
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFRow
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFCell
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFCellStyle
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFFont
IMPORT JAVA org.apache.poi.xssf.usermodel.XSSFDataFormat
##170907-00031#1 janet add -(e)
#180315-00009#2 add -(s)
IMPORT JAVA org.apache.poi.ss.util.CellRangeAddress     
IMPORT JAVA org.apache.poi.ss.util.CellRangeAddressBase 
#180315-00009#2 add -(e)
IMPORT JAVA java.util.Date                  #180607-00017#1 add
IMPORT JAVA java.text.SimpleDateFormat      #180607-00017#1 add
IMPORT JAVA java.io.InputStream             #190813-00021#1 add by 10553
IMPORT JAVA java.io.FileInputStream         #190813-00021#1 add by 10553
#end add-point
 
SCHEMA ds
 
#add-point:增加匯入變數檔 name="global.inc"
#end add-point
 
{</section>}
 
{<section id="cl_export.free_style_variable" type="s" >}
#add-point:free_style模組變數(Module Variable) name="free_style.variable"

#end add-point
 
{</section>}
 
{<section id="cl_export.global_variable" type="s" >}
#add-point:自定義模組變數(Module Variable) name="global.variable"
#end add-point
 
{</section>}
 
{<section id="cl_export.other_dialog" type="s" >}

 
{</section>}

GLOBALS
   DEFINE l_file_name STRING
   DEFINE l_file_name2 STRING
   DEFINE l_file_name3 STRING
END GLOBALS

MAIN
   LET l_file_name = ARG_VAL(1)
   LET l_file_name2 = ARG_VAL(2)
   LET l_file_name3 = ARG_VAL(3)
   
   CALL cl_export_to_excel() 
END MAIN
{<section id="cl_export.other_function" readonly="Y" type="s" >}
################################################################################
# Descriptions...: 將單身資料匯出至 MS Excel
# Memo...........:
# Usage..........: CALL s_aooi150_ins (传入参数)
#                  RETURNING 回传参数
# Input parameter: 传入参数变量1   传入参数变量说明1
#                : 传入参数变量2   传入参数变量说明2
# Return code....: 回传参数变量1   回传参数变量说明1
#                : 回传参数变量2   回传参数变量说明2
# Date & Author..: 日期 By 作者
# Modify.........:
################################################################################
PUBLIC FUNCTION cl_export_to_excel()

    DEFINE l_url       STRING

    LET l_url = os.Path.JOIN(os.Path.JOIN(FGL_GETENV("FGLASIP"),"out"),l_file_name)
    CALL ui.Interface.frontCall("standard","launchurl",l_url,[])
    DISPLAY "download : ",l_file_name
    IF ARG_VAL(2) IS NOT NULL THEN
       LET l_url = os.Path.JOIN(os.Path.JOIN(FGL_GETENV("FGLASIP"),"out"),l_file_name2)
       CALL ui.Interface.frontCall("standard","launchurl",l_url,[])
       DISPLAY "download2 : ",l_file_name2
    END IF 
    IF ARG_VAL(3) IS NOT NULL THEN
       LET l_url = os.Path.JOIN(os.Path.JOIN(FGL_GETENV("FGLASIP"),"out"),l_file_name3)
       CALL ui.Interface.frontCall("standard","launchurl",l_url,[])
       DISPLAY "download3 : ",l_file_name3
    END IF 

END FUNCTION
