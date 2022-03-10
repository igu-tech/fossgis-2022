--------------------------------------------------------------------------------
-- Row Level Security "projekt"
--------------------------------------------------------------------------------
ALTER TABLE projekt ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS pol_projekt ON projekt;
CREATE POLICY pol_projekt ON projekt
  USING (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = projekt.id AND pm.benutzer = CURRENT_USER AND pm.lesen = true));
    
--------------------------------------------------------------------------------
-- Row Level Security "projektmitarbeiter"
--------------------------------------------------------------------------------
ALTER TABLE projektmitarbeiter ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS pol_projektmitarbeiter ON projektmitarbeiter;
CREATE POLICY pol_projektmitarbeiter ON projektmitarbeiter
  USING (benutzer = CURRENT_USER);
  
--------------------------------------------------------------------------------
-- Row Level Security "bohrung"
--------------------------------------------------------------------------------
ALTER TABLE bohrung ENABLE ROW LEVEL SECURITY;
-- Select, Insert, Update
DROP POLICY IF EXISTS pol_bohrung ON bohrung;
CREATE POLICY pol_bohrung ON bohrung AS PERMISSIVE
  USING (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = bohrung.projekt_id AND pm.benutzer = CURRENT_USER 
    AND pm.lesen = true AND pm.aktiv = true))
  WITH CHECK (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = bohrung.projekt_id AND pm.benutzer = CURRENT_USER 
    AND pm.schreiben = true AND pm.aktiv = true));
-- Delete
DROP POLICY IF EXISTS pol_bohrung_delete ON bohrung;
CREATE POLICY pol_bohrung_delete ON bohrung AS RESTRICTIVE
  FOR DELETE USING (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = bohrung.projekt_id AND pm.benutzer = CURRENT_USER 
    AND pm.schreiben = true AND pm.aktiv = true));
    

--------------------------------------------------------------------------------
-- Row Level Security "quelle"
--------------------------------------------------------------------------------
ALTER TABLE quelle ENABLE ROW LEVEL SECURITY;
-- Select, Insert, Update
DROP POLICY IF EXISTS pol_quelle ON quelle;
CREATE POLICY pol_quelle ON quelle AS PERMISSIVE
  USING (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = quelle.projekt_id AND pm.benutzer = CURRENT_USER 
    AND pm.lesen = true AND pm.aktiv = true))
  WITH CHECK (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = quelle.projekt_id AND pm.benutzer = CURRENT_USER 
    AND pm.schreiben = true AND pm.aktiv = true));
-- Delete
DROP POLICY IF EXISTS pol_quelle_delete ON quelle;
CREATE POLICY pol_quelle_delete ON quelle AS RESTRICTIVE
  FOR DELETE USING (EXISTS (SELECT 1 FROM projektmitarbeiter pm 
    WHERE pm.projekt_id = quelle.projekt_id AND pm.benutzer = CURRENT_USER 
    AND pm.schreiben = true AND pm.aktiv = true));
    
  	  
  	  
  	  
  	  
