export PGHOST=localhost
export PGDATABASE=rls_demo
export PGPORT=5432
export PGUSER=postgres
export PGPASSWORD=
export PGOPTIONS='--client-min-messages=warning'

psql -f 01.roles.sql
psql -f 02.tables.sql
psql -f 03.rls.sql
psql -f 04.data.sql
