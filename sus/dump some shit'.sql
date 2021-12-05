CREATE OR REPLACE DIRECTORY shaslik_mashlik AS 'C:/Users/Ruminat/Dev/Data/dump/';

GRANT read, write ON DIRECTORY shaslik_mashlik to oe;
GRANT read, write ON DIRECTORY shaslik_mashlik to hr;
GRANT read, write ON DIRECTORY shaslik_mashlik to sh;


GRANT DATAPUMP_EXP_FULL_DATABASE TO oe;
GRANT DATAPUMP_EXP_FULL_DATABASE TO hr;
GRANT DATAPUMP_EXP_FULL_DATABASE TO sh;

expdp oe/oracle@xepdb1 DIRECTORY=shaslik_mashlik DUMPFILE=oe_dump_shit.dmp NOLOGFILE  SCHEMAS=oe
expdp hr/oracle@xepdb1 DIRECTORY=shaslik_mashlik DUMPFILE=hr_dump_shit.dmp LOGFILE=hr_fucking.log SCHEMAS=hr
expdp sh/oracle@xepdb1 DIRECTORY=shaslik_mashlik DUMPFILE=sh_dump_shit.dmp LOGFILE=sh_fucking.log SCHEMAS=sh

