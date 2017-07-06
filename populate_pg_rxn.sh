# TO load the data  in shell.


#!/bin/sh -f
#
# For useful information on loading your RxNorm subset
# into a MySQL database, please consult the on-line
# documentation at:
#
# http://www.nlm.nih.gov/research/umls/rxnorm/docs/index.html
#

#
# Database connection parameters
# Please edit these variables to reflect your environment
#
PG_HOME=/Library/PostgreSQL/9.6
user=
# put password in .pgpass file
db_name=
schema_name=
dbserver=

rrf_dir=../../rrf

/bin/rm -f pg.log
touch pg.log
ef=0
echo "See pg.log for output"

echo "----------------------------------------" >> pg.log 2>&1
echo "Starting ... `/bin/date`" >> pg.log 2>&1
echo "----------------------------------------" >> pg.log 2>&1
echo "PG_HOME= $PG_HOME" >> pg.log 2>&1
echo "user =       $user" >> pg.log 2>&1
echo "password read from ~/.pgpass" >> pg.log 2>&1
echo "dbserver =  $dbserver" >> pg.log 2>&1
echo "db_name =    $db_name" >> pg.log 2>&1
echo "schema_name= $schema_name" >> pg.log 2>&1
echo "rrf_dir=     $rrf_dir" >> pg.log 2>&1

export PGOPTIONS="--search_path=${schema_name}";

echo "    Create and load tables ... `/bin/date`" >> pg.log 2>&1
$PG_HOME/bin/psql -U $user -h $dbserver -d $db_name < Table_scripts_pg_rxn.sql >> pg.log 2>&1

if [ $? -ne 0 ]; then ef=1; fi

	if [ $ef -ne 1 ]
then
echo "    Load Data ... `/bin/date`" >> pg.log 2>&1

rm Load_scripts_pg_rxn_unix_rrf.sql > /dev/null 2>&1
rm ${rrf_dir}/*.lesspipe > /dev/null 2>&1
escaped_rrf=$(echo "$rrf_dir" | sed 's|\.|\\.|')
sed "s|{RRF-DIR}|$escaped_rrf|" Load_scripts_pg_rxn_unix.sql > Load_scripts_pg_rxn_unix_rrf.sql
for f in $(ls ${rrf_dir}); do sed 's/|$//' ${rrf_dir}/${f} | sed 's/\\/\\\\/g' > ${rrf_dir}/${f}.lesspipe; done;
$PG_HOME/bin/psql -U $user -h $dbserver -d $db_name < Load_scripts_pg_rxn_unix_rrf.sql >> pg.log 2>&1

if [ $? -ne 0 ]; then ef=1; fi

	if [ $ef -ne 1 ]
then
echo "    Creating Indexes ... `/bin/date`" >> pg.log 2>&1

$PG_HOME/bin/psql -U $user -h $dbserver -d $db_name < Indexes_pg_rxn.sql >> pg.log 2>&1

if [ $? -ne 0 ]; then ef=1; fi
fi

echo "----------------------------------------" >> pg.log 2>&1
if [ $ef -eq 1 ]
then
echo "There were one or more errors.  Please reference the pg.log file for details." >> pg.log 2>&1
else
echo "Completed without errors." >> pg.log 2>&1
fi
echo "Finished ... `/bin/date`" >> pg.log 2>&1
echo "----------------------------------------" >> pg.log 2>&1
