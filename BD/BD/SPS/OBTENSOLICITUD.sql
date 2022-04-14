-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBTENSOLICITUD
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBTENSOLICITUD`;DELIMITER $$

CREATE PROCEDURE `OBTENSOLICITUD`(	)
BEGIN

DECLARE valor INT;
DECLARE registros INT;

DECLARE solicitud VARCHAR(10);
DECLARE n INT;



set solicitud = '';
    SELECT COUNT(*) INTO registros FROM gen_folnum ;
  IF registros = 0 THEN
    INSERT INTO gen_folnum(GEN_FOLNUM, BUR_SOLNUM) VALUES(1,1);
  END IF;
  SELECT BUR_SOLNUM into valor from gen_folnum ;
  SELECT BUR_SOLNUM into n from gen_folnum ;
  UPDATE gen_folnum set BUR_SOLNUM = n+1;
  UPDATE gen_folnum set GEN_SOLCAD = lpad(valor,10,'0');
  select * FROM gen_folnum;






 end$$