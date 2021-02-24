OPTIONS MSGLEVEL=I PAGENO=1;
/* Must change year 8 times */
%let dirdata=\\mad00fpg\n6public\satteson\crash_data\SAS\Accident\ytd93;
libname ytd93 "&dirdata";

libname fmt '\\mad00fpg\n6public\satteson\crash_data\SAS\FORMATS\';
OPTIONS FMTSEARCH=(fmt.formats);

DM 'CLE LOG;CLE OUT';

proc export data = ytd93.accident
outfile = 'C:\Users\dotjaz\93crash.csv' dbms = csv
replace;
run;

proc export data = ytd93.occupant
outfile = 'C:\Users\dotjaz\93person.csv' dbms = csv
replace;
run;

proc export data = ytd93.vehicles
outfile = 'C:\Users\dotjaz\93vehicle.csv' dbms = csv
replace;
run;
