-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTRUCCREDITOCON`;DELIMITER $$

CREATE PROCEDURE `REESTRUCCREDITOCON`(
    Par_CreditoOrigenID     BIGINT(12),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID           INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion  BIGINT

        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia DATE;
DECLARE Entero_Cero INT;
DECLARE Con_ExisteCre   INT;


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Con_ExisteCre       := 2;

IF(Par_NumCon = Con_ExisteCre) THEN
    SELECT IFNULL(CreditoOrigenID,Entero_Cero), IFNULL(CreditoDestinoID,Entero_Cero)
        FROM REESTRUCCREDITO
        WHERE CreditoOrigenID = Par_CreditoOrigenID  LIMIT 1;
END IF;

END TerminaStore$$