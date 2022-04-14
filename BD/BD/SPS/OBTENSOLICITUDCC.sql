-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBTENSOLICITUDCC
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBTENSOLICITUDCC`;DELIMITER $$

CREATE PROCEDURE `OBTENSOLICITUDCC`(	)
TerminaStore: BEGIN
DECLARE valor INT;
DECLARE registros INT;

DECLARE solicitud VARCHAR(10);
DECLARE n INT;

set solicitud = '';
    SELECT COUNT(*) INTO registros FROM GENSOLICITUDES ;
  IF registros = 0 THEN
    INSERT INTO GENSOLICITUDES(ID,NumSolicitud, CharSolicitud) VALUES(1,1,'0000000001');
  END IF;
  SELECT NumSolicitud into valor from GENSOLICITUDES ;
  SELECT NumSolicitud into n from GENSOLICITUDES ;
  UPDATE GENSOLICITUDES set NumSolicitud = n+1;
  UPDATE GENSOLICITUDES set CharSolicitud = lpad(valor+1,10,'0');
  select ID, NumSolicitud, CharSolicitud FROM GENSOLICITUDES;



END TerminaStore$$