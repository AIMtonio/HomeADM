-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SGBPAGOSCREDITOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SGBPAGOSCREDITOS`;DELIMITER $$

CREATE PROCEDURE `SGBPAGOSCREDITOS`(	)
BEGIN
DECLARE fechaactual DATETIME;

SELECT FechaSistema into fechaactual from PARAMETROSSIS;
call DIASHABILANTERCAL(fechaactual,1,fechaactual,1, 1,'2012-07-31','127.0.0.1','plataformaSAFI', 1, 123 );

select CreditoID,ClienteID
from BITACORACOBAUT where MontoExigible = MontoAplicado
    and FechaProceso=fechaactual;

END$$