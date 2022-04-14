-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOARCHIVOSCON`;DELIMITER $$

CREATE PROCEDURE `CREDITOARCHIVOSCON`(
    Par_CreditoID       BIGINT(12),

    Par_NumCon          TINYINT UNSIGNED,
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
            )
TerminaStore: BEGIN

DECLARE     Cadena_Vacia    CHAR(1);
DECLARE     Fecha_Vacia     DATE;
DECLARE     Entero_Cero     INT;
DECLARE     ConsulCantDoc       INT;


SET     Cadena_Vacia        := '';
SET     Fecha_Vacia         := '1900-01-01';
SET     Entero_Cero         := 0;
SET     ConsulCantDoc       := 1;



IF(Par_NumCon = ConsulCantDoc) THEN
    SELECT COUNT(TipoDocumentoID)
    FROM CREDITOARCHIVOS
    WHERE CreditoID        = Par_CreditoID
    ORDER BY TipoDocumentoID ASC, DigCreaID DESC;

END IF;

END TerminaStore$$