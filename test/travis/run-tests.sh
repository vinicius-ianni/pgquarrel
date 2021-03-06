#!/bin/sh
set -ex
# if you change those env variables, don't forget to change it in setup-pg.sh
PGV=`echo "pg$1" | sed 's/\.//g'`
PGPATH1=$HOME/$PGV/bin
PGPATH2=$HOME/$PGV/bin
PGUSER1=quarrel
PGUSER2=quarrel
PGPORT1=9901
PGPORT2=9902
# test needs a relative path
cd pgquarrel/test
# loading quarrel data
$PGPATH1/psql -U $PGUSER1 -p $PGPORT1 -X -f test-server1.sql postgres
$PGPATH2/psql -U $PGUSER2 -p $PGPORT2 -X -f test-server2.sql postgres
# run pgquarrel
LD_LIBRARY_PATH=$HOME/$PGV/lib:$HOME/pgquarrel/lib:$LD_LIBRARY_PATH $HOME/pgquarrel/bin/pgquarrel -c test.ini
# apply differences
$PGPATH1/psql -U $PGUSER1 -p $PGPORT1 -X -f /tmp/test.sql quarrel1
# test again
LD_LIBRARY_PATH=$HOME/$PGV/lib:$HOME/pgquarrel/lib:$LD_LIBRARY_PATH $HOME/pgquarrel/bin/pgquarrel -c test2.ini
# comparing dumps
$PGPATH1/pg_dump -s -U $PGUSER1 -p $PGPORT1 -f /tmp/q1.sql quarrel1
$PGPATH2/pg_dump -s -U $PGUSER2 -p $PGPORT2 -f /tmp/q2.sql quarrel2
diff -u /tmp/q1.sql /tmp/q2.sql
