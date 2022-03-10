CREATE EXTENSION IF NOT EXISTS POSTGIS WITH SCHEMA public;
CREATE SEQUENCE global_id_seq;

-------------------------------------------------------------------------------
-- Systemtabelle "Projekt"
--------------------------------------------------------------------------------
CREATE TABLE projekt(
	id BIGINT PRIMARY KEY,
	name TEXT NOT NULL,
	bemerkung TEXT
);

--------------------------------------------------------------------------------
-- Systemtabelle "Projektmitarbeiter"
--------------------------------------------------------------------------------
CREATE TABLE projektmitarbeiter(
	id BIGINT PRIMARY KEY DEFAULT nextval('global_id_seq'),
	projekt_id BIGINT NOT NULL REFERENCES projekt ON DELETE RESTRICT,
  benutzer TEXT NOT NULL,
  lesen BOOLEAN NOT NULL DEFAULT false,
  schreiben BOOLEAN NOT NULL DEFAULT false,
  aktiv BOOLEAN NOT NULL DEFAULT false,
	UNIQUE(benutzer, projekt_id)
);
CREATE INDEX idx_projektmitarbeiter_projekt_id on projektmitarbeiter(projekt_id);
CREATE INDEX idx_projektmitarbeiter_benutzer on projektmitarbeiter(benutzer);
GRANT UPDATE(aktiv) ON projektmitarbeiter TO gis_operator;


--------------------------------------------------------------------------------
-- Default Privileges 
--------------------------------------------------------------------------------
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO gis_operator;

--------------------------------------------------------------------------------
-- Update Trigger - Tenant 'projekt_id' ist unveränderbar
-------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION check_projekt_id()
  RETURNS TRIGGER AS $BODY$
BEGIN
  IF NEW.projekt_id IS DISTINCT FROM OLD.projekt_id
  THEN
    RAISE EXCEPTION '"projekt_id" column cannot get updated';
  END IF;
  RETURN NEW;
END;
$BODY$ LANGUAGE PLPGSQL;

--------------------------------------------------------------------------------
-- Datentabelle "Bohrung"
--------------------------------------------------------------------------------
CREATE TABLE bohrung(
	id BIGINT PRIMARY KEY DEFAULT nextval('global_id_seq'),
	name TEXT NOT NULL,
	tiefe INT NOT NULL DEFAULT 0,
	bemerkung TEXT,
	projekt_id BIGINT NOT NULL REFERENCES projekt ON DELETE RESTRICT
);
SELECT AddGeometryColumn('public', 'bohrung', 'geom', 4326, 'Point', 2); 
CREATE INDEX idx_bohrung_projekt_id on bohrung(projekt_id);
CREATE INDEX idx_bohrung_geom ON bohrung USING GIST(geom);
CREATE TRIGGER check_projekt_id BEFORE UPDATE OF projekt_id ON bohrung
FOR EACH ROW EXECUTE PROCEDURE check_projekt_id();

--------------------------------------------------------------------------------
-- Datentabelle "Quelle"
--------------------------------------------------------------------------------
CREATE TABLE quelle(
	id BIGINT PRIMARY KEY DEFAULT nextval('global_id_seq'),
	name TEXT NOT NULL,
	tiefe INT NOT NULL DEFAULT 0,
	bemerkung TEXT,
	projekt_id BIGINT NOT NULL REFERENCES projekt ON DELETE RESTRICT
);
SELECT AddGeometryColumn('public', 'quelle', 'geom', 4326, 'Point', 2); 
CREATE INDEX idx_quelle_projekt_id on quelle(projekt_id);
CREATE INDEX idx_quelle_geom ON quelle USING GIST(geom);
CREATE TRIGGER check_projekt_id BEFORE UPDATE OF projekt_id ON quelle
FOR EACH ROW EXECUTE PROCEDURE check_projekt_id();
