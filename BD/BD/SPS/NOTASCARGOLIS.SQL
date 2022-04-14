-- SP NOTASCARGOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOTASCARGOLIS;

DELIMITER $$

CREATE PROCEDURE `NOTASCARGOLIS`(
	-- Stored procedure para listar las notas de cargo o amortizaciones de un credito en relacion a procesos de aplicacion de notas de cargo
	Par_CreditoID					BIGINT(12),				-- Identificador de un credito

	Par_NumLis						TINYINT UNSIGNED,		-- Numero de Lista

	Par_EmpresaID					INT(11),				-- Parametro de Auditoria de la Empresa
	Aud_Usuario						INT(11),				-- Parametro de Auditoria del Usuario
	Aud_FechaActual					DATETIME,				-- Parametro de Auditoria de la Fecha Actual
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de Auditoria de la Direccion IP
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de Auditoria del ID del Programa
	Aud_Sucursal					INT(11),				-- Parametro de Auditoria de Sucursal
	Aud_NumTransaccion  			BIGINT(20)				-- Parametro de Auditoria del numero de Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);					-- Entero Cero
	DECLARE Var_SI					CHAR(1);				-- Constante S : SI
	DECLARE Var_NO					CHAR(1);				-- Constante N : NO
	DECLARE Var_EstVigente			CHAR(1);				-- Estatus V : Vigente
	DECLARE Var_EstVencido			CHAR(1);				-- Estatus B : Vencido
	DECLARE Var_EstAtrasado			CHAR(1);				-- Estatus A : Atrasado
	DECLARE Var_TipNotCarRev		INT(11);				-- Tipo de notas de cargo para pagos no reconocidos
	DECLARE Var_ListaPrincipal		TINYINT UNSIGNED;		-- Lista principal para el grid de la pantalla de notas de cargo
	DECLARE Var_ConIvaIntOrd		TINYINT UNSIGNED;		-- Consulta de iva de interes ordinario pagado
	DECLARE Var_ConIvaMorato		TINYINT UNSIGNED;		-- Consulta de iva de moratorio

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;					-- Entero Cero
	SET Var_SI						:= 'S';					-- Constante S : SI
	SET Var_NO						:= 'N';					-- Constante N : NO
	SET Var_EstVigente				:= 'V';					-- Estatus V : Vigente
	SET Var_EstVencido				:= 'B';					-- Estatus B : Vencido
	SET Var_EstAtrasado				:= 'A';					-- Estatus A : Atrasado
	SET Var_TipNotCarRev			:= 1;					-- Tipo de notas de cargo para pagos no reconocidos
	SET Var_ListaPrincipal			:= 1;					-- Lista principal para el grid de la pantalla de notas de cargo
	SET Var_ConIvaIntOrd			:= 1;					-- Consulta de iva de interes ordinario pagado
	SET Var_ConIvaMorato			:= 2;					-- Consulta de iva de moratorio

	-- Lista Principal
	IF (Par_NumLis = Var_ListaPrincipal) THEN

		SELECT		DET.AmortizacionID,
					DET.FechaPago FechaExigible,
					ROUND((ROUND(DET.MontoCapOrd, 2) + ROUND(DET.MontoCapAtr, 2) + ROUND(DET.MontoCapVen, 2)), 2) Capital,
					ROUND((ROUND(DET.MontoIntOrd, 2) + ROUND(DET.MontoIntAtr, 2) + ROUND(DET.MontoIntVen, 2)), 2) InteresOrd,
					FNMONTOIVAPAGADO(Par_CreditoID, DET.AmortizacionID, DET.FechaPago, DET.Transaccion, Var_ConIvaIntOrd) IvaInteres,
					ROUND(DET.MontoIntMora, 2) Moratorio,
					FNMONTOIVAPAGADO(Par_CreditoID, DET.AmortizacionID, DET.FechaPago, DET.Transaccion, Var_ConIvaMorato) IvaMoratorio,
					(ROUND(DET.MontoAccesorios, 2) + ROUND(DET.MontoComServGar, 2)) AS OtrasComsiones,
					ROUND(DET.MontoIVAAccesorios, 2) IvaComisiones,
					ROUND(DET.MontoNotasCargo, 2) NotasCargo,
					ROUND(DET.MontoIVANotasCargo, 2) IvaNotasCargo,
					ROUND(DET.MontoTotPago, 2) TotalPago,
					DET.Transaccion,
					IFNULL(NTC.NotaCargoID, Entero_Cero) TieneNotas
			FROM	DETALLEPAGCRE DET
			INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = DET.CreditoID AND AMO.AmortizacionID = DET.AmortizacionID
			LEFT JOIN NOTASCARGO NTC ON NTC.CreditoID = DET.CreditoID AND NTC.AmortizacionPago = DET.AmortizacionID AND NTC.TranPagoCredito = DET.Transaccion AND NTC.TipoNotaCargoID = Var_TipNotCarRev
			WHERE	DET.CreditoID = Par_CreditoID
			ORDER BY DET.AmortizacionID, DET.FechaPago, DET.Transaccion ASC;
	END IF;

END TerminaStore$$