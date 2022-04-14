-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADISTICOINDICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADISTICOINDICAPRO`;DELIMITER $$

CREATE PROCEDURE `ESTADISTICOINDICAPRO`(
	/* Calculo de indicadores financieros para el reporte B2021 */
	Par_Anio           		INT,				-- parametro anio
	Par_Mes					INT,				-- parametro mes
	Par_FinEjercicio		CHAR(1),            -- parametro fin de ejercicio
	Par_Salida				CHAR(1), 			-- parametro de salida
	INOUT Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),		-- Parametro de salida mensaje de error
	-- parametros de auditoria
	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore:BEGIN
/*
	ESTADISTICOINDICA
	4  .- Cobertura de cartera vencida
	19 .- Indice de morosidad
	7  .- Solvencia
	14 .- Coeficiente de liquidez# Declaracion de VARIABLES
	34.- Autosuficiencia operativa
	31 .- Credito neto
	41 .- Gtos de Admon y Promoc.# Declaracion de Constantes
	22 .- Fondeo de Activos Improd.	DECLARE Salida_SI		CHAR(1);
	44 .- Rendimiento Sobre los Activos
	43 .- Margen Financiero */

	-- Declaracion de Variables
DECLARE Var_FechaSistema		DATE;		--  Fecha actual del sistema
DECLARE Var_FechaInicio			DATE;		# Almacena una fecha armada del parmetros anio y mes
DECLARE Var_FechaFin			DATE;		# Cierra el rango de fecha para la busqueda
DECLARE Var_EjercicioVig		INT;		# Ejercicio contable vigente
DECLARE Var_PeriodoVig			INT;		# Periodo contable vigente

DECLARE Var_EjercicioID			INT;			# ID de ejercicio contable
DECLARE Var_PeriodoID			INT;			# ID de periodo contable
DECLARE Var_FechInicio			DATE;			# Fecha de inicio del periodo contable
DECLARE Var_FechFin				DATE;			# Fecha de fin del periodo contable
DECLARE Var_FechaCorte			DATE;			# Fecha de corte de cierre contable

DECLARE Var_CapitalNetoF		VARCHAR(300);		# FORMULA para inidicador: 2 .- (Capital Neto /
DECLARE Var_CarteraVenNetaF		VARCHAR(300);		# FORMULA para inidicador: 9 .- Cartera de Cred. Venc. Neta -
DECLARE Var_TitulosBancariosF	VARCHAR(300);		# FORMULA para inidicador: 16 .- Titulos Bancarios con Pzo < 30d +
DECLARE Var_CarteraTotalF		VARCHAR(300);		# FORMULA para inidicador: 21 .- Cartera de Credito Total
DECLARE Var_CapInsF				VARCHAR(300);		# FORMULA para inidicador: 29 .- Capital Institucional1 +

DECLARE Var_CarteraNetaF		VARCHAR(300);		# FORMULA para inidicador: 32 .- Cartera Total Neta
DECLARE Var_ComisionCobradasF	VARCHAR(300);		# FORMULA para inidicador: 36 .- Comisiones Cobradas)/
DECLARE Var_MargenFinancieroF	VARCHAR(300);		# FORMULA para inidicador: 43,50 .- Margen Financiero
DECLARE Var_ResultadoNetoF		VARCHAR(300);		# FORMULA para inidicador: 45 .- Resultado Neto
DECLARE Var_ActIniPerF			VARCHAR(300);		# FORMULA para inidicador: 46 .- Activo al inicio del periodo

DECLARE Var_Grupo2F				VARCHAR(300);		# FORMULA para inidicador: 52 .- Ponderacion por riesgo de Activos Grupo 2 (20%)
DECLARE Var_CrediValoresF		VARCHAR(300);		# FORMULA para inidicador: 54 .- Creditos, valores y demas activos que generen riesgo de credito, no comprendidos en los numerales anteriores
DECLARE Var_Capital2111F		VARCHAR(300);		# FORMULA para inidicador: 56 .- Capital su resultado es el mismo que el reporte 2111 -
DECLARE Var_EstimacionF			VARCHAR(300);
DECLARE Var_OtrosGastF			VARCHAR(3000);

DECLARE Var_CarCredNetaF		VARCHAR(3000);
DECLARE Var_CarVenF				VARCHAR(3000);
DECLARE Var_DepositF			VARCHAR(3000);
DECLARE Var_CapContF			VARCHAR(3000);
DECLARE Var_CarteraTotalRiesF   VARCHAR(3000);
DECLARE Var_PropMaqF			VARCHAR(3000);
DECLARE Var_OtrosActF			VARCHAR(3000);
DECLARE Var_TotCarteraF			VARCHAR(3000);

DECLARE Var_CarteraVenNetaS		DECIMAL(18,4);
DECLARE Var_TitulosBancariosS	DECIMAL(18,4);		# Saldos para inidicador: 16 .- Titulos Bancarios con Pzo < 30d +
DECLARE Var_CarteraTotalS		DECIMAL(18,4);		# Saldos para inidicador: 21 .- Cartera de Credito Total
DECLARE Var_CarteraNetaS		DECIMAL(18,4);		# Saldos para inidicador: 32 .- Cartera Total Neta
DECLARE Var_ComisionCobradasS	DECIMAL(18,4);		# Saldos para inidicador: 36 .- Comisiones Cobradas)/
DECLARE Var_MargenFinancieroS	DECIMAL(18,4);		# Saldos para inidicador: 43,50 .- Margen Financiero

DECLARE Var_CapitalNetoS		DECIMAL(18,4);		# Saldos para inidicador: 2 .- (Capital Neto /
DECLARE Var_Grupo2S				DECIMAL(18,4);		# Saldos para inidicador: 52 .- Ponderacion por riesgo de Activos Grupo 2 (20%)
DECLARE Var_Grupo3S				DECIMAL(18,4);		# Saldos para inidicador: 53 .- Ponderacion por riesgo de Activos Grupo 3 (100%)
DECLARE Var_CrediValoresS		DECIMAL(18,4);		# Saldos para inidicador: 54 .- Creditos, valores y demas activos que generen riesgo de credito, no comprendidos en los numerales anteriores
DECLARE Var_CapIns				DECIMAL(18,4);		# Saldos para inidicador: 29 .- Capital Institucional1 +

DECLARE Var_ResultadoNeto		DECIMAL(18,4);		# Saldos para inidicador: 45 .- Resultado Neto
DECLARE Var_Capital2111S		DECIMAL(18,4);		# Saldos para inidicador: 56 .- Capital su resultado es el mismo que el reporte 2111 -
DECLARE Var_EstimacionS			DECIMAL(18,4);
DECLARE Var_OtrosGastS			DECIMAL(18,4);
DECLARE Var_CarCredNetaS		DECIMAL(18,4);
DECLARE Var_CarVenS				DECIMAL(18,4);
DECLARE Var_DepositS			DECIMAL(18,4);
DECLARE Var_CapContS            DECIMAL(18,4);
DECLARE Var_CarteraTotalRiesS	DECIMAL(18,4);
DECLARE Var_PropMaqS			DECIMAL(18,4);
DECLARE Var_OtrosActS			DECIMAL(18,4);
DECLARE Var_TotCarteraS			DECIMAL(18,4);

DECLARE Var_CCInicial			INT;			# Centro de costo inicial
DECLARE Var_CCFinal				INT;			# Centro de costo final

DECLARE Var_FechaCorteMax		DATE; 			# La ultima fecha de corte a la fecha de consulta
DECLARE Var_NatMovimiento		CHAR(1); 		# Naturaleza del movimiento B = Bloqueo, D = Desbloqueo
DECLARE Var_TiposBloqID			INT(4); 		# Tipo de bloqueo corresponde con la tabla TIPOSBLOQUES
DECLARE Var_CreditosGL			DECIMAL(18,4);
DECLARE Var_Solvencia			DECIMAL(18,4); 	# Guarda el saldo calculado para 7.- Solvencia

DECLARE Var_Auxiliar			DECIMAL(18,4);	# Utilizada como variable auxiliar en los calculos
DECLARE Var_CoefLiquidez		DECIMAL(18,4);	# Guarda el saldo calculado para 14 .- Coeficiente de Liquidez
DECLARE Var_IndiceCapital		DECIMAL(18,4);	# Guarda el saldo calculado para 1 .- Indice de Capitalizacion
DECLARE Var_Cap2111				DECIMAL(18,4);	# Guarda el saldo calculado para 1 .- Indice de Capitalizacion
DECLARE Var_GtosOrg2111			DECIMAL(18,4);	# Guarda el saldo calculado para 1 .- Indice de Capitalizacion

DECLARE Var_CapRiesgos			DECIMAL(18,4);	# Guarda el saldo calculado para 3 .- Req. De Capital por Riesgos)
DECLARE Var_CarteraVencida		DECIMAL(18,4);	# Guarda el saldo calculado para 4 .- Cobertura de Cartera Vencida
DECLARE Var_AutoOperativa		DECIMAL(18,4);	# Guarda el saldo calculado para 34 .- Autosuficiencia Operativa
DECLARE Var_CreditoNeto			DECIMAL(18,4);	# Guarda el saldo calculado para 31 .- Credito Neto
DECLARE Var_GastosAdmon			DECIMAL(18,4);		# Guarda el saldo calculado para 41 .- Gtos de Admon y Promoc.

DECLARE Var_FondeoActivos		DECIMAL(18,4);	# Guarda el saldo calculado para 22 .- Fondeo de Activos Improd.
DECLARE Var_RendiActivos		DECIMAL(18,4);	# Guarda el saldo calculado para 44 .- Rendimiento Sobre los Activos
DECLARE Var_ActIniPer			DECIMAL(18,4);	# Guarda el saldo calculado para 46 .- Activos al Inicio del Periodo
DECLARE Var_ActFinPer			DECIMAL(18,4);	# Guarda el saldo calculado para 47 .- Activos al Final del Periodo
DECLARE Var_MargenFinan			DECIMAL(18,4);	# Guarda el saldo calculado para 49 .- Margen Financiero

DECLARE Var_OtrosPasivos        DECIMAL(18,4);
DECLARE Var_OtrosPasivosF		VARCHAR(300);
DECLARE Var_IndMorosidad		DECIMAL(18,4);	# Guarda el saldo calculado para 19 .- Indice de Morosidad# Declaracion de Constantes
DECLARE Var_Control         	VARCHAR(100);   -- declaracion de variable de control

DECLARE Salida_SI				CHAR(1);		# Constante de salida de datos
DECLARE Entero_Cero				INT(2);			# Constante cero

DECLARE Decimal_Cero			DECIMAL(4,4);	# Constante DECIMAL
DECLARE Cadena_Vacia			CHAR(1);		# Constante cadena vacia
DECLARE Fecha_Vacia				DATE;			# Constante para fecha vacia
DECLARE VarDeudora				CHAR(1);		# Naturaleza deudora
DECLARE VarAcreedora			CHAR(1);		# Naturaleza acreedora

DECLARE Estatus_NoCerrado		CHAR(1);		# Estatus no cerrado
DECLARE Estatus_Pagado 			CHAR(1);	# Estatus Pagado
DECLARE Estatus_Vigente			CHAR(1);	# Estatus Vigente
DECLARE Estatus_Activo			CHAR(1);	# Estatus Activo
DECLARE Estatus_Cancelado		CHAR(1);	# Estatus cancelado

DECLARE NumeroDias_mes			INT(11);		# Numero de dias que tiene un mes en promedio
DECLARE SaldosActuales			CHAR(1);		# Indica si realiza los calculos sobre A = DETALLEPOLIZA, H = HIS-DETALLEPOL
DECLARE SaldosHistorico			CHAR(1);		# Indica si realiza los calculos sobre A = DETALLEPOLIZA, H = HIS-DETALLEPOL
DECLARE PorFecha				CHAR(1);		# Indica si realiza los calculos para una F = fecha, P = periodo
DECLARE Credito_Vigente			CHAR(1);		# Estatus vigente de un credito

DECLARE Credito_Vencido			CHAR(1);		# Estatus vencido de un credito
DECLARE Var_FechFinMasDias		DATE;			# Fecha en que se genera el reporte mas 30 dias
DECLARE Var_FechaFinEnero		DATE;			# Fecha fin de enero
DECLARE Var_FechaFinDic			DATE;			# Fecha fin de DICIEMBRE
DECLARE Var_DiasInversion		DECIMAL(18,2);	# Var_DiasInversion

DECLARE FactorPorcentaje	DECIMAL(18,2);

DECLARE Var_SaldosAcumCred	DECIMAL(18,4);
DECLARE Cliente_Inst        INT;
DECLARE Var_No				CHAR(1);

DECLARE Var_Vigente         CHAR(1);
DECLARE Var_Alta	        CHAR(1);
DECLARE Var_Cancelada       CHAR(1);
DECLARE Var_Pagada          CHAR(1);
DECLARE Cadena_Cero			CHAR(1);
-- seteo de constantes
SET Salida_SI			:= 'S';
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0000;
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET VarDeudora      	:= 'D';
SET VarAcreedora   		:= 'A';
SET Estatus_NoCerrado	:= 'N';
SET Estatus_Pagado		:= 'P';
SET Estatus_Vigente		:= 'N';
SET Estatus_Activo		:= 'A';
SET Estatus_Cancelado	:= 'C';
SET NumeroDias_mes		:= 30;
SET SaldosActuales		:= 'A';
SET SaldosHistorico		:= 'H';
SET PorFecha			:= 'F';
SET Credito_Vigente		:= 'V';
SET Credito_Vencido		:= 'B';
SET Var_NatMovimiento	:= 'B';
SET Var_TiposBloqID		:= 8;
SET Var_No              := 'N';
SET Var_OtrosPasivosF   := '23071004%+230711%';
SET Var_Vigente         := 'N';
SET Var_Alta	        := 'A';
SET Var_Cancelada       := 'C';
SET Var_Pagada          := 'P';
SET Cadena_Cero			:= '0';
-- Asignacion de variables
SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Var_FechaFinEnero	:= CONVERT(last_day(CONCAT(CONVERT(Par_Anio, CHAR), '-01-', '1')), DATE);
SET Var_FechaFinDic		:= CONVERT(last_day(CONCAT(CONVERT((Par_Anio-1), CHAR), '-12-', '1')), DATE);
SET Var_FechaCorteMax	:= (SELECT MAX(FechaCorte) FROM SALDOSCREDITOS WHERE FechaCorte <= Var_FechaFin);

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
									concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-ESTADISTICOINDICAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;





SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero) FROM PARAMETROSSIS LIMIT 1
INTO   Var_FechaSistema,						Var_EjercicioVig,							Var_PeriodoVig;


SELECT MIN(CentroCostoID), 	MAX(CentroCostoID) INTO
		Var_CCInicial, 		Var_CCFinal
	FROM CENTROCOSTOS;

DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

SELECT DiasInversion INTO Var_DiasInversion FROM PARAMETROSSIS ;
SET FactorPorcentaje	:=100;

SET Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS);



DROP TEMPORARY TABLE IF EXISTS TMPREGESTADISTICOS;
CREATE TEMPORARY TABLE TMPREGESTADISTICOS(
	TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
	ConEstadisIndID	INT(11),
	Indicador		DECIMAL(18,4),
	Naturaleza		CHAR(1),
	SaldoDeudor		DECIMAL(18,2),
	SaldoAcreedor	DECIMAL(18,2)
);


IF NOT EXISTS (SELECT EstadisIndID
			FROM ESTADISTICOINDICA
			WHERE Anio 	= Par_Anio
				AND Mes = Par_Mes) THEN


	SET Var_CarteraVenNetaF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 9);
    SET Var_CarVenF				:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 8);
	SET Var_TitulosBancariosF	:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 16);
	SET Var_CarteraTotalF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 21);
	SET Var_CarteraTotalRiesF	:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 20);
	SET Var_CarteraNetaF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 32);
	SET Var_ComisionCobradasF	:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 36);
	SET Var_MargenFinancieroF	:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 43);
	SET Var_CapitalNetoF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 2);
	SET Var_Grupo2F				:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 52);
	SET Var_CrediValoresF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 54);
	SET Var_CapInsF				:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 29);
	SET Var_ResultadoNetoF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 45);
	SET Var_EstimacionF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 5);
	SET Var_Capital2111F		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 56);
    SET Var_OtrosGastF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 57);
	SET Var_CarCredNetaF		:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 6);
	SET Var_DepositF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 12);
	SET Var_CapContF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 13);
    SET Var_PropMaqF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 26);
	SET Var_OtrosActF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 27);
    SET Var_TotCarteraF			:=	(SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 23);

    SET Var_CarteraVenNetaF 	:= CASE WHEN IFNULL(Var_CarteraVenNetaF,Cadena_Vacia) 	= Cadena_Vacia THEN Cadena_Cero ELSE Var_CarteraVenNetaF 	END;
	SET Var_CarVenF				:= CASE WHEN IFNULL(Var_CarVenF,Cadena_Vacia) 			= Cadena_Vacia THEN Cadena_Cero ELSE Var_CarVenF 			END;
    SET Var_TitulosBancariosF	:= CASE WHEN IFNULL(Var_TitulosBancariosF,Cadena_Vacia) = Cadena_Vacia THEN Cadena_Cero ELSE Var_TitulosBancariosF 	END;
    SET Var_CarteraTotalF		:= CASE WHEN IFNULL(Var_CarteraTotalF,Cadena_Vacia) 	= Cadena_Vacia THEN Cadena_Cero ELSE Var_CarteraTotalF 		END;
    SET Var_CarteraTotalRiesF	:= CASE WHEN IFNULL(Var_CarteraTotalRiesF,Cadena_Vacia) = Cadena_Vacia THEN Cadena_Cero ELSE Var_CarteraTotalRiesF 	END;
    SET Var_CarteraNetaF		:= CASE WHEN IFNULL(Var_CarteraNetaF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_CarteraNetaF 		END;
    SET Var_ComisionCobradasF	:= CASE WHEN IFNULL(Var_ComisionCobradasF,Cadena_Vacia)	= Cadena_Vacia THEN Cadena_Cero ELSE Var_ComisionCobradasF 	END;
    SET Var_MargenFinancieroF	:= CASE WHEN IFNULL(Var_MargenFinancieroF,Cadena_Vacia) = Cadena_Vacia THEN Cadena_Cero ELSE Var_MargenFinancieroF 	END;
    SET Var_CapitalNetoF		:= CASE WHEN IFNULL(Var_CapitalNetoF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_CapitalNetoF 		END;
    SET Var_Grupo2F				:= CASE WHEN IFNULL(Var_Grupo2F,Cadena_Vacia) 			= Cadena_Vacia THEN Cadena_Cero ELSE Var_Grupo2F 			END;
    SET Var_CrediValoresF		:= CASE WHEN IFNULL(Var_CrediValoresF,Cadena_Vacia) 	= Cadena_Vacia THEN Cadena_Cero ELSE Var_CrediValoresF 		END;
    SET Var_CapInsF				:= CASE WHEN IFNULL(Var_CapInsF,Cadena_Vacia) 			= Cadena_Vacia THEN Cadena_Cero ELSE Var_CapInsF 			END;
    SET Var_ResultadoNetoF		:= CASE WHEN IFNULL(Var_ResultadoNetoF,Cadena_Vacia) 	= Cadena_Vacia THEN Cadena_Cero ELSE Var_ResultadoNetoF 	END;
    SET Var_EstimacionF			:= CASE WHEN IFNULL(Var_EstimacionF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_EstimacionF 		END;
    SET Var_Capital2111F		:= CASE WHEN IFNULL(Var_Capital2111F,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_Capital2111F 		END;
    SET Var_OtrosGastF			:= CASE WHEN IFNULL(Var_OtrosGastF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_OtrosGastF 		END;
    SET Var_CarCredNetaF		:= CASE WHEN IFNULL(Var_CarCredNetaF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_CarCredNetaF 		END;
    SET Var_DepositF			:= CASE WHEN IFNULL(Var_DepositF,Cadena_Vacia) 			= Cadena_Vacia THEN Cadena_Cero ELSE Var_DepositF 			END;
    SET Var_CapContF			:= CASE WHEN IFNULL(Var_CapContF,Cadena_Vacia) 			= Cadena_Vacia THEN Cadena_Cero ELSE Var_CapContF 			END;
    SET Var_PropMaqF			:= CASE WHEN IFNULL(Var_PropMaqF,Cadena_Vacia) 			= Cadena_Vacia THEN Cadena_Cero ELSE Var_PropMaqF 			END;
    SET Var_OtrosActF			:= CASE WHEN IFNULL(Var_OtrosActF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_OtrosActF 			END;
    SET Var_TotCarteraF			:= CASE WHEN IFNULL(Var_TotCarteraF,Cadena_Vacia) 		= Cadena_Vacia THEN Cadena_Cero ELSE Var_TotCarteraF 		END;



	SELECT 	Inicio, 			Fin
		FROM PERIODOCONTABLE
		WHERE EjercicioID	= Var_EjercicioVig
			AND PeriodoID	= Var_PeriodoVig
			AND Estatus 	= Estatus_NoCerrado
	INTO    Var_FechInicio,	    Var_FechFin;


	SELECT  EjercicioID, 		PeriodoID, 		Inicio, 			Fin INTO
			Var_EjercicioID, 	Var_PeriodoID, 	Var_FechInicio, 	Var_FechFin
		FROM PERIODOCONTABLE
		WHERE Inicio	<= Var_FechFin
		AND Fin		>= Var_FechFin;

	IF (IFNULL(Var_EjercicioID, Entero_Cero) = Entero_Cero) THEN
		SELECT	MAX(EjercicioID),	 MAX(PeriodoID), 	MAX(Inicio), 		MAX(Fin) INTO
				Var_EjercicioID, 	Var_PeriodoID, 		Var_FechInicio, 	Var_FechFin
			FROM PERIODOCONTABLE
			WHERE Fin	<= Var_FechFin;
	END IF;


	IF(Var_FechaFin >= IFNULL(Var_FechFin,Fecha_Vacia))THEN

		INSERT INTO TMPCONTABLE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
								Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
		SELECT 				 	Aud_NumTransaccion, 		Var_FechaSistema,	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
								SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)),
								SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)),
								CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
										SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2))
									 ELSE	Decimal_Cero
								END,
								CASE WHEN MAX(Cue.Naturaleza) =  VarAcreedora THEN
										SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2))
									 ELSE	Decimal_Cero
								END
		FROM CUENTASCONTABLES Cue,
			  DETALLEPOLIZA   Pol
			WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
				AND Pol.Fecha 	  		<= Var_FechaFin
		GROUP BY Cue.CuentaCompleta;


		SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte < Var_FechaFin);

		IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN

				UPDATE TMPCONTABLE Tmp, SALDOSCONTABLES Sal
					SET Tmp.SaldoInicialDeu =  CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
														Sal.SaldoFinal
													ELSE
														Decimal_Cero
												END,
						Tmp.SaldoInicialAcr =  CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
													Sal.SaldoFinal
												ELSE
													Decimal_Cero
												END
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Sal.FechaCorte		= Var_FechaCorte
				  AND Sal.CuentaCompleta 	= Tmp.CuentaContable;
		END IF;


		CALL EVALFORMULAREGPRO(Var_CarteraVenNetaS,			Var_CarteraVenNetaF,	SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_TitulosBancariosS,		Var_TitulosBancariosF,	SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CarteraTotalS,			Var_CarteraTotalF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CarteraNetaS,			Var_CarteraNetaF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_ComisionCobradasS,		Var_ComisionCobradasF,	SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_MargenFinancieroS,		Var_MargenFinancieroF,	SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_MargenFinancieroS,		Var_MargenFinancieroF,	SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CapitalNetoS,			Var_CapitalNetoF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_Grupo2S,					Var_Grupo2F,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_Capital2111S,			Var_Capital2111F,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CrediValoresS,			Var_CrediValoresF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CapIns,					Var_CapInsF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_ResultadoNeto,			Var_ResultadoNetoF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_EstimacionS,				Var_EstimacionF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_OtrosPasivos,			Var_OtrosPasivosF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_OtrosGastS,				Var_OtrosGastF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CarCredNetaS,			Var_CarCredNetaF,		SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CarVenS,					Var_CarVenF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_DepositS,				Var_DepositF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_CapContS,				Var_CapContF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_PropMaqS,				Var_PropMaqF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_OtrosActS,				Var_OtrosActF,			SaldosActuales,		PorFecha, 			Var_FechFin);
		CALL EVALFORMULAREGPRO(Var_TotCarteraS,				Var_TotCarteraF,		SaldosActuales,		PorFecha, 			Var_FechFin);




	ELSE
		IF  (Par_FinEjercicio = Var_No) THEN

			SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte <= Var_FechaFin);

			INSERT INTO TMPCONTABLE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
									SaldoDeudor,				SaldoAcreedor)
			SELECT 				 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
									CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
											THEN
												SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2))
											ELSE
												Decimal_Cero
									END,
									CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora
											THEN
												SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2))
											ELSE
												Decimal_Cero
									END
			FROM CUENTASCONTABLES Cue,
				  SALDOSCONTABLES   Sal
				WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
					AND Sal.FechaCorte	 = Var_FechaCorte
			GROUP BY Cue.CuentaCompleta;


			CALL EVALFORMULAREGPRO(Var_CarteraVenNetaS,			Var_CarteraVenNetaF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_TitulosBancariosS,		Var_TitulosBancariosF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CarteraTotalS,			Var_CarteraTotalF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CarteraNetaS,			Var_CarteraNetaF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_ComisionCobradasS,		Var_ComisionCobradasF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_MargenFinancieroS,		Var_MargenFinancieroF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CapitalNetoS,			Var_CapitalNetoF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_Grupo2S,					Var_Grupo2F,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_Capital2111S,			Var_Capital2111F,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CrediValoresS,			Var_CrediValoresF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CapIns,					Var_CapInsF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_ResultadoNeto,			Var_ResultadoNetoF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_EstimacionS,				Var_EstimacionF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_OtrosPasivos,			Var_OtrosPasivosF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
          	CALL EVALFORMULAREGPRO(Var_OtrosGastS,				Var_OtrosGastF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CarCredNetaS,			Var_CarCredNetaF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
            CALL EVALFORMULAREGPRO(Var_CarVenS,					Var_CarVenF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_DepositS,				Var_DepositF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
            CALL EVALFORMULAREGPRO(Var_CapContS,				Var_CapContF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_CarteraTotalRiesS,		Var_CarteraTotalRiesF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_PropMaqS,				Var_PropMaqF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_OtrosActS,				Var_OtrosActF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAREGPRO(Var_TotCarteraS,				Var_TotCarteraF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);



		ELSE


			SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte <= Var_FechaFin);
			INSERT INTO TMPCONTABLE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
									SaldoDeudor,				SaldoAcreedor)
			SELECT 				 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
									CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
											THEN
												SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2))
											ELSE
												Decimal_Cero
									END,
									CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora
											THEN
												SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2))
											ELSE
												Decimal_Cero
									END
			FROM CUENTASCONTABLES Cue,
				  SALDOCONTACIERREJER   Sal
				WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
					AND Sal.FechaCorte	 = Var_FechaCorte
			GROUP BY Cue.CuentaCompleta;


			CALL EVALFORMULAPERIFINPRO(Var_CarteraVenNetaS,			Var_CarteraVenNetaF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_TitulosBancariosS,		Var_TitulosBancariosF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_CarteraTotalS,			Var_CarteraTotalF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_CarteraNetaS,			Var_CarteraNetaF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_ComisionCobradasS,		Var_ComisionCobradasF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_MargenFinancieroS,		Var_MargenFinancieroF,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_CapitalNetoS,			Var_CapitalNetoF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_Grupo2S,					Var_Grupo2F,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_Capital2111S,			Var_Capital2111F,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_CrediValoresS,			Var_CrediValoresF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_CapIns,					Var_CapInsF,			SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_ResultadoNeto,			Var_ResultadoNetoF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_EstimacionS,				Var_EstimacionF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			CALL EVALFORMULAPERIFINPRO(Var_OtrosPasivos,			Var_OtrosPasivosF,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);

		END IF;
	END IF;


	DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
	INSERT INTO TMPREGCREDITOS (NumTransaccion,		CreditoID,		Monto)
	SELECT	Aud_NumTransaccion,	S.CreditoID,
			(S.SalCapVigente+S.SalCapAtrasado+S.SalCapVencido+S.SalCapVenNoExi+S.SalIntOrdinario+S.SalIntProvision+S.SalIntAtrasado+S.SalMoratorios+S.SalIntVencido+S.SaldoMoraVencido)
		FROM SALDOSCREDITOS S,
			CALRESCREDITOS	C
		WHERE CONVERT(S.FechaCorte,DATE) = Var_FechaCorteMax
			AND S.FechaCorte= C.Fecha
			AND S.CreditoID	= C.CreditoID
			AND S.EstatusCredito IN (Credito_Vigente,Credito_Vencido);



	DROP TABLE IF EXISTS TMPCREDITOINVGAR2;
	CREATE TEMPORARY TABLE TMPCREDITOINVGAR2
	SELECT SUM(T.MontoEnGar) AS MontoEnGar , T.CreditoID
		FROM TMPREGCREDITOS		F,
			 CREDITOINVGAR	T
		WHERE	F.CreditoID		=	T.CreditoID
			AND FechaAsignaGar <= Var_FechaFin
	AND F.NumTransaccion = Aud_NumTransaccion
		GROUP BY T.CreditoID;


	UPDATE	TMPREGCREDITOS	Tmp,
			TMPCREDITOINVGAR2	Gar	SET
		Tmp.GarantiaLiq =	Gar.MontoEnGar
	WHERE  Gar.CreditoID = Tmp.CreditoID
	AND Tmp.NumTransaccion = Aud_NumTransaccion;



	DROP TABLE IF EXISTS TMPHISCREDITOINVGAR2;
	CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR2
	SELECT SUM(Gar.MontoEnGar) AS MontoEnGar , Gar.CreditoID
		FROM TMPREGCREDITOS		Tmp,
			 HISCREDITOINVGAR	Gar
		WHERE	Gar.Fecha > Var_FechaFin
		  AND	Gar.FechaAsignaGar <= Var_FechaFin
		  AND	Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
		  AND	Gar.CreditoID = Tmp.CreditoID
		  AND Tmp.NumTransaccion = Aud_NumTransaccion
		GROUP BY Gar.CreditoID;

	UPDATE	TMPREGCREDITOS		Tmp,
			TMPHISCREDITOINVGAR2	Gar
		SET Tmp.GarantiaLiq = IFNULL(Tmp.GarantiaLiq, Decimal_Cero) + Gar.MontoEnGar
		WHERE	Gar.CreditoID = Tmp.CreditoID
		  AND	Tmp.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
	CREATE temporary TABLE TMPMONTOGARCUENTAS (
	SELECT Blo.Referencia,	SUM(CASE WHEN Blo.NatMovimiento = Var_NatMovimiento
					THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
				 ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
			END) AS MontoEnGar
		FROM	BLOQUEOS 		Blo,
				TMPREGCREDITOS Tmp
			WHERE DATE(Blo.FechaMov) <= Var_FechaFin
				AND Blo.TiposBloqID = Var_TiposBloqID
				AND Blo.Referencia  = Tmp.CreditoID
				AND	Tmp.NumTransaccion = Aud_NumTransaccion
		 GROUP BY Blo.Referencia);

	UPDATE	TMPREGCREDITOS 		Tmp,
			TMPMONTOGARCUENTAS 	Blo
		SET Tmp.GarantiaLiq = IFNULL(Tmp.GarantiaLiq, Decimal_Cero) +MontoEnGar
	WHERE Blo.Referencia  = Tmp.CreditoID
	AND Tmp.NumTransaccion = Aud_NumTransaccion;
	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;


	UPDATE	TMPREGCREDITOS	Tmp SET
		Tmp.GarantiaLiq =	Tmp.Monto
	WHERE GarantiaLiq > Monto
	AND Tmp.NumTransaccion = Aud_NumTransaccion;


	SET Var_CreditosGL = (SELECT SUM(GarantiaLiq)
								FROM TMPREGCREDITOS
								WHERE NumTransaccion = Aud_NumTransaccion);
	SET Var_CreditosGL	:= IFNULL(Var_CreditosGL, Decimal_Cero);







	INSERT INTO TMPREGESTADISTICOS (ConEstadisIndID,		Indicador,			Naturaleza,			SaldoDeudor,		SaldoAcreedor)
	SELECT 							Con.ConEstadisIndID,	Decimal_Cero,		MAX(Tmp.Naturaleza),
									CASE WHEN MAX(Tmp.Naturaleza) = VarDeudora
											 THEN
												IFNULL(SUM(Tmp.SaldoInicialDeu), Decimal_Cero) -
												IFNULL(SUM(Tmp.SaldoInicialAcr), Decimal_Cero) +
												SUM(ROUND(IFNULL(Tmp.SaldoDeudor, Decimal_Cero), 2)) -
												SUM(ROUND(IFNULL(Tmp.SaldoAcreedor, Decimal_Cero), 2))
											 ELSE
												Decimal_Cero
										END AS SaldoDeudorFin,
										CASE WHEN MAX(Tmp.Naturaleza) = VarAcreedora
												 THEN
													IFNULL(SUM(Tmp.SaldoInicialAcr), Entero_Cero) -
													IFNULL(SUM(Tmp.SaldoInicialDeu), Entero_Cero) +
													SUM(ROUND(IFNULL(Tmp.SaldoAcreedor, Entero_Cero), 2)) -
													SUM(ROUND(IFNULL(Tmp.SaldoDeudor, Entero_Cero), 2))
												 ELSE
													Decimal_Cero
										END AS SaldoAcredorFin
	FROM CONCEPESTAINDICA Con
	LEFT OUTER JOIN TMPCONTABLE Tmp
		ON  Tmp.CuentaContable LIKE  Con.Formula
		AND Tmp.NumeroTransaccion = Aud_NumTransaccion
	 GROUP BY Con.Formula, Con.ConEstadisIndID
	ORDER BY Con.ConEstadisIndID;





	SET Var_FechFinMasDias := DATE_ADD(Var_FechaFin, INTERVAL NumeroDias_mes DAY);

	DROP TABLE IF EXISTS TMPMONTOINVERSIONESREG;

	IF(Par_Anio=2014 AND Par_Mes < 12) THEN
		CREATE temporary TABLE TMPMONTOINVERSIONESREG
		(SELECT SUM(Inv.Monto )+
						SUM(CASE WHEN  Inv.FechaVenAnt> Fecha_Vacia AND   Inv.FechaVenAnt <= FechaVencimiento THEN
						ROUND( ( ( (DATEDIFF(Var_FechaFin,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						ELSE
						ROUND( ( ( (DATEDIFF(Var_FechaFin,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						END

					) AS Suma
					FROM INVERSIONES Inv
						INNER JOIN	CLIENTES Cli ON Cli.ClienteID	= Inv.ClienteID
						LEFT JOIN	EQU_INVERSIONES Eq ON  Inv.InversionID = Eq.InversionIDSAFI
						WHERE Inv.ClienteID<>Cliente_Inst
							 AND ((Inv.Estatus = Var_Vigente
											AND	(Inv.FechaVencimiento > Var_FechaFin
											AND Inv.FechaVencimiento <= Var_FechFinMasDias) )
							   OR   ( Inv.Estatus = Var_Pagada
										AND	(Inv.FechaVencimiento > Var_FechaFin
											AND Inv.FechaVencimiento <= Var_FechFinMasDias) )
							  OR   ( Inv.Estatus = Var_Cancelada
									AND Inv.FechaVencimiento > Var_FechaFin
								AND Inv.FechaVencimiento <= Var_FechFinMasDias
								AND Inv.FechaVenAnt != Fecha_Vacia
								AND Inv.FechaVenAnt >= Var_FechaFin) )
		);
	ELSE

			CREATE temporary TABLE TMPMONTOINVERSIONESREG
			SELECT SUM(Monto) + SUM(SaldoProvision) AS Suma
				FROM HISINVERSIONES Inv
				WHERE FechaCorte = Var_FechaFin
				AND Inv.Estatus = Var_Vigente
				AND	(Inv.FechaVencimiento > Var_FechaFin
				AND Inv.FechaVencimiento <= Var_FechFinMasDias);
	END IF;



	UPDATE 	TMPREGESTADISTICOS Tmp,
			TMPMONTOINVERSIONESREG	Reg
	SET 	SaldoAcreedor = SaldoAcreedor + Suma
	WHERE ConEstadisIndID = 18;


	SET Var_Grupo3S		:= Var_CrediValoresS - Var_CreditosGL;



	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CarteraVenNetaS	WHERE ConEstadisIndID = 9;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_CarVenS 			WHERE ConEstadisIndID = 8;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_TitulosBancariosS WHERE ConEstadisIndID = 16;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CarteraTotalS		WHERE ConEstadisIndID = 21;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_CarteraTotalRiesS	WHERE ConEstadisIndID = 20;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CarteraNetaS		WHERE ConEstadisIndID = 32;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_ComisionCobradasS WHERE ConEstadisIndID = 36;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_MargenFinancieroS WHERE ConEstadisIndID = 43;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_MargenFinancieroS WHERE ConEstadisIndID = 50;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CapitalNetoS + 0.01 WHERE ConEstadisIndID = 2;

    UPDATE TMPREGESTADISTICOS SET Indicador = Var_DepositS 		WHERE ConEstadisIndID = 12;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_CapContS 		WHERE ConEstadisIndID = 13;

    UPDATE TMPREGESTADISTICOS SET Indicador = Var_Grupo2S 			WHERE ConEstadisIndID = 52;

	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CrediValoresS 	WHERE ConEstadisIndID = 54;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CapIns			WHERE ConEstadisIndID = 29;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_ResultadoNeto		WHERE ConEstadisIndID = 45;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CreditosGL		WHERE ConEstadisIndID = 55;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_Capital2111S		WHERE ConEstadisIndID = 56;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_CarCredNetaS		WHERE ConEstadisIndID = 6;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_OtrosGastS		WHERE ConEstadisIndID = 57;
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_PropMaqS			WHERE ConEstadisIndID = 26;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_OtrosActS			WHERE ConEstadisIndID = 27;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_TotCarteraS		WHERE ConEstadisIndID = 23;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_EstimacionS		WHERE ConEstadisIndID IN (5,24);
	UPDATE TMPREGESTADISTICOS SET Indicador = (((Var_Grupo2S * 0.02) + Var_Grupo3S) * 0.08) + ((((Var_Grupo2S * 0.02) + Var_Grupo3S) * 0.08) * 0.3) WHERE ConEstadisIndID = 18;



	UPDATE TMPREGESTADISTICOS
		SET Indicador = CASE WHEN Naturaleza = VarDeudora
							THEN SaldoDeudor
						 WHEN Naturaleza = VarAcreedora
							THEN SaldoAcreedor
						 ELSE Indicador
					END;


	UPDATE TMPREGESTADISTICOS	SET Indicador = ABS(Indicador ) WHERE ConEstadisIndID = 24;
	UPDATE TMPREGESTADISTICOS	SET Indicador = ABS(Indicador ) WHERE ConEstadisIndID = 5;


	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_Cap2111			:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 56), Decimal_Cero);
	SET Var_GtosOrg2111		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 57), Decimal_Cero);


    SET Var_IndiceCapital	:= Var_Cap2111 - Var_GtosOrg2111;



	SET Var_CapRiesgos	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 52), Decimal_Cero);
    SET Var_CapRiesgos	:= Var_CapRiesgos + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 53), Decimal_Cero);
    SET Var_CapRiesgos	:= Var_CapRiesgos * 0.08;

    UPDATE TMPREGESTADISTICOS SET Indicador = Var_CapRiesgos WHERE ConEstadisIndID = 3;

	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 3), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
    UPDATE TMPREGESTADISTICOS SET Indicador = Var_IndiceCapital WHERE ConEstadisIndID = 2;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_IndiceCapital / Var_Auxiliar)*100 WHERE ConEstadisIndID = 1;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_CarteraVencida	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 5), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 6), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_CarteraVencida / Var_Auxiliar)*100 WHERE ConEstadisIndID = 4;
	UPDATE TMPREGESTADISTICOS SET Indicador = abs(Indicador) WHERE ConEstadisIndID = 4;




	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_Solvencia	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 8), Decimal_Cero);
	SET Var_Solvencia	:= Var_Solvencia - IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 9), Decimal_Cero);
	SET Var_Solvencia	:= Var_Solvencia - IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 10), Decimal_Cero);
	SET Var_Solvencia	:= Var_Solvencia - IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 11), Decimal_Cero);
	SET Var_Auxiliar	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 12), Decimal_Cero);
	SET Var_Auxiliar	:= Var_Auxiliar + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 13), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_Solvencia / Var_Auxiliar)*100 WHERE ConEstadisIndID = 7;


	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_CoefLiquidez	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 15), Decimal_Cero);
	SET Var_CoefLiquidez	:= Var_CoefLiquidez + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 16), Decimal_Cero);
	SET Var_CoefLiquidez	:= Var_CoefLiquidez + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 17), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 18), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_CoefLiquidez / Var_Auxiliar)*100 WHERE ConEstadisIndID = 14;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_IndMorosidad	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 20), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 21), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_IndMorosidad / Var_Auxiliar)*100 WHERE ConEstadisIndID = 19;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_FondeoActivos	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 23), Decimal_Cero);
	SET Var_FondeoActivos	:= Var_FondeoActivos - IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 24), Decimal_Cero);
	SET Var_FondeoActivos	:= Var_FondeoActivos + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 25), Decimal_Cero);
	SET Var_FondeoActivos	:= Var_FondeoActivos + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 26), Decimal_Cero);
	SET Var_FondeoActivos	:= Var_FondeoActivos + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 27), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 28), Decimal_Cero);
	SET Var_Auxiliar		:= Var_Auxiliar + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 29), Decimal_Cero);
	SET Var_Auxiliar		:= Var_Auxiliar + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 30), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_FondeoActivos / Var_Auxiliar)*100 WHERE ConEstadisIndID = 22;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_CreditoNeto		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 32), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 33), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_CreditoNeto / Var_Auxiliar)*100 WHERE ConEstadisIndID = 31;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_AutoOperativa	:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 35), Decimal_Cero);
	SET Var_AutoOperativa	:= Var_AutoOperativa + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 36), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 37), Decimal_Cero);
	SET Var_Auxiliar		:= Var_Auxiliar + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 38), Decimal_Cero);
	SET Var_Auxiliar		:= Var_Auxiliar + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 39), Decimal_Cero);
	SET Var_Auxiliar		:= Var_Auxiliar + IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 40), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_AutoOperativa / Var_Auxiliar)*100 WHERE ConEstadisIndID = 34;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_GastosAdmon		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 42), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 43), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_GastosAdmon / Var_Auxiliar)*100 WHERE ConEstadisIndID = 41;



	SET Var_Auxiliar		:= Decimal_Cero;

	SET Var_ActIniPerF		:= IFNULL((SELECT Formula FROM CONCEPESTAINDICA WHERE ConEstadisIndID = 46), '');


		IF(Par_Mes > 1 )THEN

			CALL EVALFORMULAREGPRO(Var_ActIniPer,	Var_ActIniPerF,	'H',	'F', 	Var_FechaFinEnero);
		ELSE


			CALL EVALFORMULAREGPRO(Var_ActIniPer,	Var_ActIniPerF,	'H',	'F', 	Var_FechaFinDic);

		END IF;


	SET Var_ActIniPer		:= IFNULL(Var_ActIniPer, Decimal_Cero);
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_ActIniPer WHERE ConEstadisIndID = 46;
	SET Var_ActFinPer		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 47), Decimal_Cero);


    SET Var_Auxiliar		:= (SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 47);
	UPDATE TMPREGESTADISTICOS SET Indicador = Var_Auxiliar WHERE ConEstadisIndID = 48;
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_ResultadoNeto / Var_Auxiliar)*100 WHERE ConEstadisIndID = 44;



	SET Var_Auxiliar		:= Decimal_Cero;
	SET Var_MargenFinan		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 50), Decimal_Cero);
	SET Var_Auxiliar		:= IFNULL((SELECT Indicador FROM TMPREGESTADISTICOS WHERE ConEstadisIndID = 51), Decimal_Cero);
	IF(Var_Auxiliar = Entero_Cero)THEN SET Var_Auxiliar	:= 1; END IF;
	UPDATE TMPREGESTADISTICOS SET Indicador = (Var_MargenFinan / Var_Auxiliar)*100 WHERE ConEstadisIndID = 49;




SET @id := IFNULL((SELECT MAX(EstadisIndID) FROM ESTADISTICOINDICA), Entero_Cero);
	INSERT INTO ESTADISTICOINDICA(EstadisIndID,		ConEstadisIndID,		Anio,		Mes,			Indicador)
			SELECT 				  @id := @id +1,	ConEstadisIndID,		Par_Anio,	Par_Mes,		Indicador
				FROM TMPREGESTADISTICOS;


END IF;




SET Par_NumErr 		:= Entero_Cero;
SET Par_ErrMen 		:= 'Proceso Realizado Exitosamente';

		DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;
		DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

	END ManejoErrores;

		IF(Par_Salida = Salida_SI)THEN
			SELECT EstadisIndID,		ConEstadisIndID,		Mes,		Anio,
				   IFNULL(Indicador, Decimal_Cero) AS Indicador
				FROM ESTADISTICOINDICA
				WHERE	Mes		= Par_Mes
					AND Anio	= Par_Anio;
		END IF;

END TerminaStore$$