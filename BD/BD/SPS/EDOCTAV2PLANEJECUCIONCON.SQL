-- EDOCTAV2PLANEJECUCIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2PLANEJECUCIONCON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2PLANEJECUCIONCON(
	Par_RutaEdoCtaSh					VARCHAR(500),
	Par_NumCon							TINYINT UNSIGNED,			-- Numero de consulta
	Par_OrigenDato						VARCHAR(30)
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
	DECLARE Var_ConMuestreoPDF			TINYINT UNSIGNED;
	DECLARE Var_ConMuestreoXML			TINYINT UNSIGNED;

	-- ASIGNACION DE CONSTANTES
	SET Entero_Uno						:= 1;						-- Entero Uno
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Var_ConPrincipal				:= 1;						-- Consulta principal
	SET Var_ConMuestreoPDF				:= 2;						-- Consulta para determinar el universo de pdfs que se van a generar.
	SET Var_ConMuestreoXML				:= 3;						-- consulta para determinar el unniverso de xml a generar

	IF (Par_NumCon = Var_ConPrincipal) THEN

		SELECT CONCAT('\n',Par_RutaEdoCtaSh, ' -o ', TRIM(Par_OrigenDato),' -e ',TipoEjecucion,' -i ', Instrumentos,' -p ',EjecucionJobPdf,' -t ',EjecucionJobTim,
		 ' -r ',EjecucionSPPrin,  '\n') as comando
		FROM EDOCTAV2PLANEJECUCION, EDOCTAV2PARAMS;

	END IF;

END TerminaStore$$
