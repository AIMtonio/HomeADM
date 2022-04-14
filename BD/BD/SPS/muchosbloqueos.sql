-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- muchosbloqueos
DELIMITER ;
DROP PROCEDURE IF EXISTS `muchosbloqueos`;DELIMITER $$

CREATE PROCEDURE `muchosbloqueos`(
inicia int,
termina int,
cuenta varchar(50)
)
BEGIN
declare contador INT;

    set contador := inicia;

    while contador <= termina do
     call BLOQUEOSPRO('0','B',cuenta,'2017-11-07',1.0, '1900-01-01',5,'MANUAL: BLOQUEO POR AHORRO',1,'','', 'S',@, @,1,414,'2017-11-07','0:0:0:0:0:0:0:1', '/microfin/bloqueoSaldoPet.htm',1,0);
      set contador=contador+1;
    end while;

END$$