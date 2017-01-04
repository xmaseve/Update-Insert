data old;
input enrollmonth$ region$ email c d;
datalines;
1jan16 china 1 2 3
1jan16 usa 0 3 5
1jan16 japan 0 5 3
1jan16 brazil 0 3 3
2jan16 china 1 3 5
;
run;

proc sql;
select * 
from old
where enrollmonth not in ('1jan16');
quit;

data new;
input enrollmonth$ region$ email c d;
cards;
1jan16 usa 1 3 4
1jan16 china 1 4 6
1jan16 india 1 3 5
;
run;


proc sql;
create table check as
select a.*, case when a.region=b.region and a.email=b.email then 1 else 0 end as match
from old a left join new b on a.region=b.region and a.email=b.email;
quit;

proc print data=check;
run;

data three;
	set check;
	if match=0 then output;
	drop match;
run;

proc print data=three;
run;

data final;
set three new;
run;

proc print data=final;
run;
