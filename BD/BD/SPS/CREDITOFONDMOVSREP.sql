
-- CREDITOFONDMOVSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDMOVSREP`;
DELIMITER $$


CREATE PROCEDURE `CREDITOFONDMOVSREP`(
# ===============================================================================
# --- INFORMACION GENERE REPORTE DE EXCEL ---
# ===============================================================================
	Par_CreditoFondeoID		BIGINT(12),         -- Identificador del Crédito Fondeo
	Par_TipoReporte     	TINYINT UNSIGNED,   -- Tipo de Reporte

	Par_EmpresaID			INT(11),            -- Parametro de Auditoria
	Aud_Usuario           	INT(11),            -- Parametro de Auditoria
	Aud_FechaActual       	DATETIME,           -- Parametro de Auditoria
	Aud_DireccionIP       	VARCHAR(15),        -- Parametro de Auditoria
	Aud_ProgramaID        	VARCHAR(50),        -- Parametro de Auditoria
	Aud_Sucursal          	INT(11),            -- Parametro de Auditoria
	Aud_NumTransaccion    	BIGINT(20)          -- Parametro de Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
    DECLARE Rep_CredFonMovs			INT(11);
    DECLARE	Var_Abono				CHAR(1);
	DECLARE	Var_Cargo				CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;				-- Entero Cero
    SET Rep_CredFonMovs			:= 3;				-- Consulta principal
    SET	Var_Abono				:= "A";				-- Identificador Abono
	SET	Var_Cargo				:= "C";				-- Identificador Cargo

	-- DATOS DEL CREDITOFONDMOVS
	IF(Par_TipoReporte = Rep_CredFonMovs)THEN
	SELECT	Mov.AmortizacionID,	Mov.FechaOperacion,	Mov.Descripcion,	Tip.Descripcion as DescripTipMov,	Mov.TipoMovFonID,
			Mov.NatMovimiento ,	CASE WHEN Mov.NatMovimiento = Var_Abono THEN "ABONO"
									WHEN Mov.NatMovimiento = Var_Cargo THEN "CARGO" ELSE Mov.NatMovimiento END AS NatMovimientoDes,
				IFNULL(ROUND(Mov.Cantidad,2),Entero_Cero) AS Cantidad
			FROM	CREDITOFONDMOVS Mov,
					TIPOSMOVSFONDEO Tip
			WHERE	Mov.CreditoFondeoID	= Par_CreditoFondeoID
			AND		Mov.TipoMovFonID	= Tip.TipoMovFonID;

	END IF;
END TerminaStore$$