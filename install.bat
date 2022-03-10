SET PATH=%PATH%;C:\Program Files\PostgreSQL\13\bin
SET PGHOST=localhost
SET PGDATABASE=rls_demo
SET PGPORT=5432
SET PGUSER=postgres
SET PGPASSWORD=

psql -f 01.roles.sql
psql -f 02.tables.sql
psql -f 03.rls.sql
psql -f 04.data.sql

PAUSE