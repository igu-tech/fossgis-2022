-------------------------------------------------------------------------------
-- 100 Projekte anlegen
-------------------------------------------------------------------------------
INSERT INTO projekt (id, name) 
  SELECT x.id::BIGINT, 'Projekt ' || LPAD(x.id::TEXT, 3, '0')
  FROM generate_series(1,100) AS x(id);

-------------------------------------------------------------------------------
-- 1000 Bohrugen in jedem Projekt anlegen
-------------------------------------------------------------------------------
DELETE FROM bohrung;
INSERT INTO bohrung (name, projekt_id, geom) 
  SELECT 'Bohrung ' || y.id::TEXT, x.id + (y.id - 1) * 10,
	ST_SetSRID(ST_MakePoint(13 + x::FLOAT/10 + random()/20, 47 + y::FLOAT/10 + random()/20), 4326)
  FROM generate_series(1,1000) AS z(id), generate_series(1,10) AS x(id), generate_series(1,10) AS y(id);
  
-------------------------------------------------------------------------------
-- 1000 Quellen in jedem Projekt anlegen
-------------------------------------------------------------------------------
DELETE FROM quelle;
INSERT INTO quelle (name, projekt_id, geom) 
  SELECT 'Bohrung ' || y.id::TEXT, x.id + (y.id - 1) * 10,
	ST_SetSRID(ST_MakePoint(13 + x::FLOAT/10 + random()/20, 47 + y::FLOAT/10 + random()/20), 4326)
  FROM generate_series(1,1000) AS z(id), generate_series(1,10) AS x(id), generate_series(1,10) AS y(id);
	
-------------------------------------------------------------------------------
-- Projektmitarbeiter 
-------------------------------------------------------------------------------
DELETE FROM projektmitarbeiter;
INSERT INTO projektmitarbeiter (projekt_id, benutzer, lesen, schreiben) 
  SELECT x.id::BIGINT, 'huber', true, random() > 0.5
  FROM generate_series(1,75) AS x(id);
UPDATE projektmitarbeiter SET aktiv = true WHERE benutzer = 'huber' AND projekt_id IN (1, 2, 3);
INSERT INTO projektmitarbeiter (projekt_id, benutzer, lesen, schreiben) 
  SELECT x.id::BIGINT, 'hauser', true, random() > 0.5
  FROM generate_series(25,100) AS x(id);
UPDATE projektmitarbeiter SET aktiv = true WHERE benutzer = 'hauser' AND projekt_id IN (25, 26, 27);
