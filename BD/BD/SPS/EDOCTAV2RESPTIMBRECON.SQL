-- EDOCTAV2RESPTIMBRECON
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2RESPTIMBRECON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2RESPTIMBRECON(
	-- SP para consultar las respuestas del proceso de timbrado
	Par_NumCon							TINYINT UNSIGNED,			-- Numero de consulta
	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(20)					-- Parametro de Auditoria
)

TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_FecIniMes				DATE;						-- Fecha de inicio del periodo extraido
	DECLARE Var_FecFinMes				DATE;						-- Fecha final del periodo extraido
	DECLARE Var_DiasPeriodo				VARCHAR(45);				-- Almacena el total de dias que abarca el periodo
	DECLARE Var_RutaLogo				VARCHAR(90);				-- Almacena la ruta del logo a desplegar en el estado de cuenta
	DECLARE Var_NumInstrumen			BIGINT(20);					-- Numero de las cuentas
	DECLARE Var_NumCredito				BIGINT(12);					-- Numero de Creditos
	DECLARE Var_NumCede					INT(11);					-- Numero de Cede
	DECLARE Var_NumInversion			INT(11);					-- Numero de Inversiones
	DECLARE Var_NumCarObj				INT(11);					-- Numero de cargos objetados
	DECLARE Var_FolioFiscal				VARCHAR(50);				-- Valor de UUID
	DECLARE Var_CtaAho					BIGINT(12);					-- Valor de cuentas de ahorro
	DECLARE Var_CredCliente				BIGINT(12);					-- Numero de credito
	DECLARE Var_CedeCliente				INT(11);					-- Numero de cede del cliente

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Uno					INT(1);						-- Entero Uno
	DECLARE	Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE	Entero_Cero					INT(11);					-- Entero Cero
	DECLARE Var_ConPrincipal			TINYINT UNSIGNED;			-- Consulta principal
	DECLARE Var_ConForanea				TINYINT UNSIGNED;

	-- ASIGNACION DE CONSTANTES
	SET Entero_Uno						:= 1;						-- Entero Uno
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Var_ConPrincipal				:= 1;						-- Consulta principal
	SET Var_ConForanea					:= 2;

	IF (Par_NumCon = Var_ConPrincipal) THEN
		SELECT
			RespuestaWS,
			RegistroID
		FROM EDOCTAV2RESPTIMBRE
		WHERE CodigoRespuesta = '200'
		AND IFNULL(CFDINoCertSAT,'') = '';

	END IF;

	IF (Par_NumCon = Var_ConForanea) THEN
		SELECT	RegistroID,xmlSAT
		FROM EDOCTAV2RESPTIMBRE
		WHERE CodigoRespuestaSW='000000'
		ORDER BY RegistroID;

	END IF;

END TerminaStore$$
