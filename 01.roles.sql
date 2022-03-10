--------------------------------------------------------------------------------
-- Rolle gis_manager
--------------------------------------------------------------------------------
CREATE ROLE gis_manager WITH NOLOGIN BYPASSRLS CREATEROLE;

--------------------------------------------------------------------------------
-- Rolle gis_operator
--------------------------------------------------------------------------------
CREATE ROLE gis_operator WITH NOLOGIN;
GRANT gis_operator TO gis_manager;

--------------------------------------------------------------------------------
-- Benutzer meier (gis_manager)
--------------------------------------------------------------------------------
CREATE USER meier WITH PASSWORD 'meier' BYPASSRLS;
GRANT gis_manager TO meier;

--------------------------------------------------------------------------------
-- Benutzer huber (gis_operator)
--------------------------------------------------------------------------------
CREATE USER huber WITH PASSWORD 'huber' ;
GRANT gis_operator TO huber;

--------------------------------------------------------------------------------
-- Benutzer hauser (gis_operator)
--------------------------------------------------------------------------------
CREATE USER hauser WITH PASSWORD 'hauser' ;
GRANT gis_operator TO hauser;

--------------------------------------------------------------------------------
-- Default Privileges
--------------------------------------------------------------------------------
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO gis_manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO gis_operator;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO gis_operator;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO gis_operator;