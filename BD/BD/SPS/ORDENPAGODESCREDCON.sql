-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORDENPAGODESCREDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORDENPAGODESCREDCON`;DELIMITER $$

CREATE PROCEDURE `ORDENPAGODESCREDCON`(
# ============================================================
# ----- SP PARA CONSULTAR ORDENES DE PAGO DE DISPERSIONES-----
# ============================================================
	Par_InstitucionID		INT(11),			-- Numero de institucion
	Par_NumCtaInstit		VARCHAR(20),		-- Cuenta de institucion
	Par_NumOrdenPago		VARCHAR(50),		-- Numero de Orden de pago
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	--  Declaracion de Constantes
	DECLARE EstatusEmitido		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE ConPrincipal		INT(11);

	-- Asignacion de constantes
	SET EstatusEmitido			:= 'E'; -- Estatus Emitido
	SET Cadena_Vacia			:= '';	-- Cadena Vacia
	SET Entero_Cero				:= 0;	-- Entero Cero
	SET ConPrincipal			:= 1; 	-- Consulta principal


	IF(Par_NumCon = ConPrincipal)THEN
		SELECT 	ClienteID,	InstitucionID,	NumCtaInstit,	NumOrdenPago,	Monto,
				Fecha,		Beneficiario,	Estatus,		Referencia,		Concepto,
                MotivoRenov
			FROM ORDENPAGODESCRED
			WHERE 	InstitucionID	= Par_InstitucionID
			  AND 	NumCtaInstit	= Par_NumCtaInstit
			  AND 	NumOrdenPago 	= Par_NumOrdenPago
			  AND 	Estatus 		= EstatusEmitido;
	END IF;

END TerminaStore$$