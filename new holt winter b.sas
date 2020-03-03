libname mylib '\\client\C$\Users\ska669\Documents\DA6823 summer 2017\holt winter';
/* grab the data set and create a sequential obs number using the _N_ SAS system variable*/
data mytemp;
set mylib.beer;
myid=  _N_;
run;
/* see the pretty data */
proc print data=mytemp;
var myid beer;
run;
/* now run the holt winter forecast model - use model type 2 - trend plus seasonality */
proc forecast data=mytemp
method=addwinters
trend=2
lead=12
weight=(0.20 0.10 0.05)
out=myholt outfull
seasons=12;
id myid;
var beer;
run;
/* print the data out so you can sniff it */
proc print data=myholt;
run;
/* now grab just the actual data points and put them in a temp data set */
data actual;
set myholt;
if _type_='ACTUAL';
run;
/* now grab the forecasts, rename the beer variable so you can merge it next */
data myfore;
set myholt;
if _type_ = 'FORECAST';
rename beer=forebeer;
run;
/* so now merge the actual and forecasts into the same data set via myid */
data merged;
merge actual myfore;
by myid;
run;
/* show the pretty actual and forecast data side by side */
proc print data=merged;
var myid beer forebeer;
run;
/* make a pretty plot of actual and forecasts */
proc sgplot data=merged;
series x=myid y=beer / markers;
series x=myid y=forebeer /markers;
run;
proc spectra data=mytemp A out = myspectra;
var beer;
run;
proc contents data= myspectra;
run;






