DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIAPORTACIONESCON`;

DELIMITER $$

CREATE PROCEDURE `SPEIAPORTACIONESCON`(
# =====================================================================================
# ------- STORE PARA REALIZAR CONSULTAS DE APORTACION POR SPEI ---------
# =====================================================================================
	Par_AportDispersionID				BIGINT(20),				-- Folio de Dispersion Spei
	Par_NumCon							TINYINT UNSIGNED,		-- Numero de consulta

/* Parámetros de Auditoria */
	Par_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(20),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia	CHAR(1);				-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE Entero_Cero		INT(11);				-- Entero Vacio
	DECLARE Con_AportDispSPEI	INT(11);				-- Consulta Principal

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';					-- Constante cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Constante Fecha vacia
	SET Entero_Cero			:= 0;					-- Constante entero cero
	SET Con_AportDispSPEI	:= 1;					-- Consulta Aportaciones Dispersadas por SPEI

	-- APORTACIONES QUE SE DISPERSARON POR SPEI
	IF(Par_NumCon = Con_AportDispSPEI) THEN
		SELECT 	SPE.FolioSpeiID,	FNDECRYPTSAFI(SPE.CuentaBeneficiario) AS CuentaBeneficiario , FNDECRYPTSAFI(SPE.CuentaOrd) AS CuentaOrd 
		FROM SPEIAPORTACIONES SAP
			INNER JOIN SPEIENVIOS SPE ON SAP.FolioSpeiID = SPE.FolioSpeiID
		WHERE SAP.AportBeneficiarioID = Par_AportDispersionID
		AND SAP.NumTransaccion = Aud_NumTransaccion;
	END IF;

	
END TerminaStore$$