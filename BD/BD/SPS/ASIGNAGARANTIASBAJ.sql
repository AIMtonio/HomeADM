-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNAGARANTIASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNAGARANTIASBAJ`;DELIMITER $$

CREATE PROCEDURE `ASIGNAGARANTIASBAJ`(
/*SP para dar de baja las garantias de credito*/
    Par_SolCredID       INT(11),
    Par_CreditoID       BIGINT(12),
    Par_GarantiaID      INT(11),
    Par_TipBaja         TINYINT UNSIGNED,

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_FecReg      DATETIME;

/* Declaracion de Constantes */
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    INT;
DECLARE Est_Asignada    CHAR(1);
DECLARE Baj_TodasGar    TINYINT UNSIGNED;
DECLARE Bar_GarReest	TINYINT UNSIGNED;

/* Asignacion de Constantes */
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Est_Asignada    := 'A';         -- Estatus de la Asignacion de la Garantia: Asignada
SET Baj_TodasGar    := 1;           -- Tipo de Baja de Todas las Garantias
SET Bar_GarReest	:= 2;

SET Var_FecReg  := NOW();

IF(Par_TipBaja = Baj_TodasGar) THEN

    IF(IFNULL(Par_CreditoID, Entero_Cero) != Entero_Cero) THEN
        DELETE FROM ASIGNAGARANTIAS
            WHERE CreditoID = Par_CreditoID;
    ELSE
        DELETE FROM ASIGNAGARANTIAS
            WHERE SolicitudCreditoID = Par_SolCredID;
    END IF;

END IF;

IF(Par_TipBaja = Bar_GarReest) THEN

    IF(IFNULL(Par_CreditoID, Entero_Cero) != Entero_Cero) THEN
        DELETE FROM ASIGNAGARANTIAS
            WHERE CreditoID = Par_CreditoID
              AND EstatusSolicitud <> 'O';

    ELSE
        DELETE FROM ASIGNAGARANTIAS
            WHERE SolicitudCreditoID = Par_SolCredID
             AND EstatusSolicitud <> 'O';

    END IF;

    SELECT  000 AS NumErr,
	"Datos Actualizados Exitosamente." AS ErrMen,
	'CreditoID' AS control,
	Par_CreditoID AS consecutivo;
    LEAVE TerminaStore;

END IF;

SELECT  000 AS NumErr,
	"Se han Eliminado las Garantias de la Solicitud de Credito." AS ErrMen,
	'CreditoID' AS control,
	Par_CreditoID AS consecutivo;

END TerminaStore$$