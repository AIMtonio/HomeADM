-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTOTALISRCTE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTOTALISRCTE`;DELIMITER $$

CREATE FUNCTION `FNTOTALISRCTE`(
# ====================================================================
# -------FUNCION PARA OBTENER EL TOTAL DE ISR--------
# ====================================================================
	Par_ClienteID		INT(11),			-- ID del Cliente
    Par_InstrumentoID	INT(11),			-- ID de Instrumento (2 Ahorro, 13 Inversion, 28 Cede)
    Par_ProductoID		BIGINT(20)			-- ID del Producto
) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

-- Declaracion de Constantes
DECLARE EnteroCero			int(11);
DECLARE EstatusNoAplicado	char(1);

-- Declaracion de Variables
DECLARE	Var_ISRTotal	decimal(14,2);

-- Asignacion de Constantes
SET	EnteroCero			:=	0;
SET	EstatusNoAplicado	:=	'N';

SET Var_ISRTotal := EnteroCero;

		SELECT 	SUM(ISR)
		INTO	Var_ISRTotal
			FROM COBROISR
			WHERE 	ClienteID  = Par_ClienteID  AND InstrumentoID = Par_InstrumentoID
				AND ProductoID = Par_ProductoID AND Estatus 	  = EstatusNoAplicado;

		SET Var_ISRTotal	:=	IFNULL(Var_ISRTotal,EnteroCero);
      RETURN Var_ISRTotal;
END$$