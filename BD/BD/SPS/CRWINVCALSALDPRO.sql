-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVCALSALDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWINVCALSALDPRO`;

DELIMITER $$
CREATE PROCEDURE `CRWINVCALSALDPRO`(
-- SP de proceso batch para realizar insercion de informacion de saldos de inversiones kubo
	Par_Fecha           DATE,			-- FECHA DE APLICACION
	Par_Salida			CHAR(1),		-- PARAMETRO DE SALIDA
	INOUT Par_NumErr	INT(11),		-- Parametro de salida numero de error.
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro de salida de Mensaje de error.
	Par_EmpresaID		INT(11),		-- NUMERO DE EMPRESA
	Aud_Usuario			INT(11),		-- AUDITORIA
	Aud_FechaActual		DATETIME,		-- AUDITORIA

	Aud_DireccionIP		VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal		INT(11),		-- AUDITORIA
	Aud_NumTransaccion	BIGINT			-- AUDITORIA
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_SalCapVig		DECIMAL(12,4);
DECLARE Var_SalCapExi		DECIMAL(12,4);
DECLARE Var_SalInteres		DECIMAL(12,4);
DECLARE Var_ProvAcum		DECIMAL(12,4);
DECLARE Var_MoraPagado		DECIMAL(12,4);
DECLARE Var_ComFPPag		DECIMAL(12,4);
DECLARE Var_IntOrdReten		DECIMAL(12,4);
DECLARE Var_IntMorReten		DECIMAL(12,4);
DECLARE Var_ComFPReten		DECIMAL(12,4);
DECLARE Var_CapCtaOrden		DECIMAL(14,4);
DECLARE Var_IntCtaOrden		DECIMAL(14,4);

DECLARE MinFecExig 			DATE;
DECLARE DiasAtraso			INT(11);
DECLARE VarSalAtras1A15		DECIMAL(12,4);
DECLARE VarNumAtras1A15		INT(11);
DECLARE VarSalAtras16A30	DECIMAL(12,4);
DECLARE VarNumAtras16A30	INT(11);
DECLARE VarSalAtras31A90	DECIMAL(12,4);
DECLARE VarNumAtras31A90	INT(11);
DECLARE VarSalVen91A120		DECIMAL(12,4);
DECLARE VarNumVen91A120		INT(11);
DECLARE VarSalVen121A180	DECIMAL(12,4);
DECLARE VarNumVen121A180	INT(11);
DECLARE VarGAT				DECIMAL(12,4);
DECLARE Var_ClienteID		BIGINT(11);
DECLARE Var_CreditoID		BIGINT(12);
DECLARE Var_SaldoIntMorat	DECIMAL(14,4);
DECLARE Var_FecActual		DATE;
DECLARE NumTotalAmort		INT(11);
DECLARE NumError			INT(11);		#obtiene el numero de error de los SP
DECLARE ErrorMen			VARCHAR(200);	#Obtiene el mensaje de error de los SP
DECLARE amorti				INT(11);
DECLARE Var_Control    		VARCHAR(100);   		-- Variable de Control


-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero 		DECIMAL(12,4);
DECLARE	EstatPagada			CHAR(1);
DECLARE	SalidaSi			CHAR(1);
DECLARE	SalidaNo			CHAR(1);
-- Asignacion de constantes
SET	Cadena_Vacia		:= '';				-- Cadena Vacia
SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
SET	Entero_Cero			:= 0;				-- Entero en Cero
SET	Decimal_Cero 		:= 0.00;			-- DECIMAL en Cero
SET	EstatPagada			:= 'P';				-- Estatus de Pagado

SET	VarGAT				:= 0.0; 			-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarSalAtras1A15		:= 0.0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarNumAtras1A15		:= 0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarSalAtras16A30	:= 0.0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarNumAtras16A30	:= 0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarSalAtras31A90	:= 0.0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarNumAtras31A90	:= 0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarSalVen91A120		:= 0.0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarNumVen91A120		:= 0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarSalVen121A180	:= 0.0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET VarNumVen121A180	:= 0;				-- Es variable, cuando se calcule se quita la asignacion como constante
SET SalidaSi			:= 'S';				-- Salida en Pantalla Si
SET SalidaNo			:= 'N';				-- Salida en Pantalla No

SET Var_FecActual	:= Par_Fecha;
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  				'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWINVCALSALDPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	DELETE FROM TMPCRWSALDOSINV
	WHERE FechaCorte = Var_FecActual;

	INSERT INTO TMPCRWSALDOSINV(
		SolFondeoID,			FechaCorte,				ClienteID,			CreditoID,				SalCapVigente,
		SalCapExigible,			SalCapCtaOrden,			SaldoInteres,		SalIntCtaOrden,			ProvisionAcum,
		MoratorioPagado,		ComFalPagPagada,		IntOrdRetenido,		IntMorRetenido,			ComFalPagRetenido,
		GAT,					NumAtras1A15,			SalAtras1A15,		NumAtras16a30,			SaldoAtras16a30,
		NumAtras31a90,			SalAtras31a90,			NumVenc91a120,		SalVenc91a120,			NumVenc120a180,
		SalVenc120a180,			SalIntMoratorio)
	SELECT
		FK.SolFondeoID,			Var_FecActual,			FK.ClienteID,		FK.CreditoID,			FK.SaldoCapVigente,
		FK.SaldoCapExigible,	FK.SaldoCapCtaOrden,	FK.SaldoInteres,	FK.SaldoIntCtaOrden,	FK.ProvisionAcum,
		FK.MoratorioPagado,		FK.ComFalPagPagada,		FK.IntOrdRetenido,	FK.IntMorRetenido,		FK.ComFalPagRetenido,
		FK.Gat,					Entero_Cero,			Decimal_Cero,		Entero_Cero,			Decimal_Cero,
		Entero_Cero,			Decimal_Cero,			Entero_Cero,		Decimal_Cero,			Entero_Cero,
		Decimal_Cero,			FK.SaldoIntMoratorio
	FROM CRWFONDEO FK
	WHERE Estatus IN('N','V');

	UPDATE TMPCRWSALDOSINV SI
	INNER JOIN (SELECT FK.SolFondeoID, CONVERT(MIN(AF.FechaExigible),CHAR) FechaExigible
				FROM CRWFONDEO FK
					INNER JOIN AMORTICRWFONDEO AF ON FK.SolFondeoID = AF.SolFondeoID
				WHERE FK.Estatus IN('N','V')
					AND AF.Estatus <> 	'P'
					AND AF.FechaExigible <= Var_FecActual
				GROUP BY FK.SolFondeoID) AF
		ON SI.SolFondeoID = AF.SolFondeoID
	SET
		NumAtras1A15 = 	CASE 	WHEN IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 1 AND 15
								THEN 1
								ELSE Entero_Cero END,
		SalAtras1A15 = 	CASE 	WHEN 	IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 1 AND 15
								THEN 	IFNULL(SalCapVigente, Decimal_Cero) +	IFNULL(SalCapExigible, Decimal_Cero)
								ELSE 	Decimal_Cero END,

		NumAtras16a30 =  CASE 	WHEN IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 16 AND 30
								THEN 1
								ELSE Entero_Cero END,
		SaldoAtras16a30 = CASE 	WHEN 	IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 16 AND 30
								THEN 	IFNULL(SalCapVigente, Decimal_Cero) +	IFNULL(SalCapExigible, Decimal_Cero)
								ELSE 	Decimal_Cero END,

		NumAtras31a90 = CASE 	WHEN IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 31 AND 90
								THEN 1
								ELSE Entero_Cero END,
		SalAtras31a90 = CASE 	WHEN 	IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 31 AND 90
								THEN 	IFNULL(SalCapVigente, Decimal_Cero) +	IFNULL(SalCapExigible, Decimal_Cero)
								ELSE 	Decimal_Cero END,

		NumVenc91a120 = CASE 	WHEN IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 91 AND 120
								THEN 1
								ELSE Entero_Cero END,
		SalVenc91a120 = CASE 	WHEN 	IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) BETWEEN 91 AND 120
								THEN 	IFNULL(SalCapVigente, Decimal_Cero) +	IFNULL(SalCapExigible, Decimal_Cero)
								ELSE 	Decimal_Cero END,

		NumVenc120a180 = CASE 	WHEN IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) >= 121
								THEN 1
								ELSE Entero_Cero END,
		SalVenc120a180 = CASE 	WHEN 	IFNULL((SELECT DATEDIFF(Var_FecActual, FechaExigible)),Entero_Cero) >= 121
								THEN 	IFNULL(SalCapVigente, Decimal_Cero) +	IFNULL(SalCapExigible, Decimal_Cero)
								ELSE 	Decimal_Cero END
	WHERE FechaCorte = Var_FecActual;

	INSERT INTO CRWSALDOSINV (
		SolFondeoID,		FechaCorte,			ClienteID,			CreditoID,			SalCapVigente,
		SalCapExigible,		SalCapCtaOrden, 	SaldoInteres,		SalIntCtaOrden,		ProvisionAcum,
		MoratorioPagado,	ComFalPagPagada,	IntOrdRetenido,		IntMorRetenido,		ComFalPagRetenido,
		GAT,				NumAtras1A15,		SalAtras1A15,		NumAtras16a30,		SaldoAtras16a30,
		NumAtras31a90,		SalAtras31a90,		NumVenc91a120,		SalVenc91a120,		NumVenc120a180,
		SalVenc120a180,		SalIntMoratorio)
	SELECT
		SolFondeoID,		FechaCorte,			ClienteID,			CreditoID,			SalCapVigente,
		SalCapExigible,		SalCapCtaOrden, 	SaldoInteres,		SalIntCtaOrden,		ProvisionAcum,
		MoratorioPagado,	ComFalPagPagada,	IntOrdRetenido,		IntMorRetenido,		ComFalPagRetenido,
		GAT,				NumAtras1A15,		SalAtras1A15,		NumAtras16a30,		SaldoAtras16a30,
		NumAtras31a90,		SalAtras31a90,		NumVenc91a120,		SalVenc91a120,		NumVenc120a180,
		SalVenc120a180,		SalIntMoratorio
	FROM TMPCRWSALDOSINV
	WHERE FechaCorte = Var_FecActual;

	DELETE FROM TMPCRWSALDOSINV
	WHERE FechaCorte = Var_FecActual;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := 'Proceso Terminado Exitosamente';

END ManejoErrores;  -- END del Handler de Errores

IF(Par_Salida = SalidaSi) THEN
	SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		'' AS control;
END IF;

END TerminaStore$$