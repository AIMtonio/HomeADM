-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBTENFOLIO
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBTENFOLIO`;DELIMITER $$

CREATE PROCEDURE `OBTENFOLIO`(	)
BEGIN


DECLARE x INT;
DECLARE valor INT;
DECLARE registros INT;
DECLARE n INT;
DECLARE solicitud VARCHAR(10);
DECLARE v varchar(10);


SET solicitud = '';

    SELECT COUNT(*) INTO registros FROM gen_folnum;

    if registros = 0 then
        INSERT INTO gen_folnum(GEN_FOLNUM, BUR_SOLNUM) VALUES(1,1);
    end if;

  SELECT GEN_FOLNUM into valor from gen_folnum ;
  SELECT GEN_FOLNUM into n from gen_folnum ;
  UPDATE gen_folnum set GEN_FOLNUM = n+1;
  UPDATE gen_folnum set GEN_FOLCAD = lpad(valor,8,'0');
  select * FROM gen_folnum;

END$$