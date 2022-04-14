-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINFADICIONALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAINFADICIONALCON`;DELIMITER $$

CREATE PROCEDURE `POLIZAINFADICIONALCON`(
# ==================================================================
# -------------- SP PARA CONSULTAR INFORMACION ADICIONAL DE UNA POLIZA ----------------
# ==================================================================
	Par_PolizaID			BIGINT(11),
	Par_NumCon				TINYINT UNSIGNED,

-- Parametros de Auditoria
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
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE ConPrincipal		INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';	-- Cadena Vacia
	SET Entero_Cero				:= 0;	-- Entero Cero
	SET ConPrincipal			:= 3; 	-- Consulta principal


-- Consulta Principal
	IF(Par_NumCon = ConPrincipal)THEN
		SELECT 	P.PolizaID,			P.Movimiento,	P.InstitucionID,	C.CueClave,	P.NumCtaInstit,
				P.TipoMovimiento,	P.Folio,		P.PersonaID,		P.Importe,	P.Referencia,
				P.MetodoPagoID, 	P.MonedaID, 	M.TipCamDof AS TipoCambio,		P.InstitucionOrigen,
                P.CueClaveOrigen
			FROM	POLIZAINFADICIONAL	P
            INNER JOIN	CUENTASAHOTESO C
            ON	P.NumCtaInstit	= C.NumCtaInstit
            AND P.InstitucionID = C.InstitucionID
            INNER JOIN MONEDAS M
            ON	P.MonedaID 		= M.MonedaID
            WHERE PolizaID		= Par_PolizaID;

	END IF;


END TerminaStore$$