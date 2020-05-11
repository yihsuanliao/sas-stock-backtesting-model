*******投資策略簡介：
每年底將當年度的股票分為五群，贏家為4，輸家為0。
次年初，買入贏家股票群(組別4)，放空輸家(組別0)，形成一個投資組合。
每年初更新一次投資組合。;

DM "LOG;CLEAR;OUTPUT;CLEAR;";
libname Mydata 'C:\Mydata17'; /*設定Mydata資料館*/
ods html;
data test1; /*將檔案寫入test1*/
set mydata. F01s_b_ret_monthly;
yyyy=year(datadate); /*取出年份*/
if gvkey="Y9999" then delete; /*把大盤刪掉*/
keep gvkey yyyy RET; /*保留公司代碼、年、報酬率*/
run;
proc sort data=test1;by yyyy gvkey ;run; /*依照年、公司代碼排序*/
proc means data=test1 sum noprint; /*加總月報酬率成年報酬率*/
var RET;
by yyyy gvkey;
output out=test2 sum=ret_sum;
quit;
proc sort data=test2 nodup; by yyyy;run; /*依照年排序*/
proc rank data=test2 out= test3 groups=5; /*把test2按照年報酬率分成五群*/
var ret_sum;
by yyyy;
ranks rank_ret;
run;
data test4; /*將檔案寫入test4*/
set test3;
if rank_ret=0 then profolio=-(ret_sum);/*把輸家放空*/
if rank_ret>0 then profolio=ret_sum;/*贏家買入*/
if rank_ret >0 and rank_ret <4 then delete ;/*留下輸家和贏家*/
if yyyy=2014 then delete;/*只留2005~2013的資料*/
run;
proc means data= test4 mean noprint;/*分別算出贏家及輸家平均年報酬率*/
var profolio;
class rank_ret;
output out= test5 mean=mean_profolio;
run;



**
贏家平均報酬率=48.877638889%
輸家的平均報酬=25.838571429%
贏家減輸家=23.03906746%
則九次投資組合之後為1000(1+23.03906746%)^9=6462.302;
