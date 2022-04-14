-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERRERESERVASOCAPPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERRERESERVASOCAPPRO`;
DELIMITER $$

CREATE PROCEDURE `CIERRERESERVASOCAPPRO`(
# ======================================================================================================================
# ---------- SP PARA REALIZAR EPRC  (ESTIMACION PREVENTIVA DE RIESGO CREDITO V. Otros clientes menos Sacimex) ----------
# ======================================================================================================================
    Par_Fecha           DATETIME,
    Par_AplicaConta     CHAR(1),
	Par_PolizaID		BIGINT(20),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE var_LimiteExpuesto  INT;
DECLARE var_TipoInstitucion CHAR(2);
DECLARE Var_Poliza          BIGINT;
DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_NomBalance      VARCHAR(50);
DECLARE Var_NomResult       VARCHAR(50);
DECLARE Var_CueMayRes       VARCHAR(15);
DECLARE Var_CueMayBal       VARCHAR(15);

DECLARE Var_NomBalIntere	VARCHAR(50);
DECLARE Var_CueMayBalInt	VARCHAR(15);
DECLARE Var_CRBalIntere		VARCHAR(10);

DECLARE Var_NomResIntere	VARCHAR(50);
DECLARE Var_CueMayResInt	VARCHAR(15);
DECLARE Var_CRResIntere		VARCHAR(10);

DECLARE Var_NomPtePrinci	VARCHAR(50);
DECLARE Var_CueMayPtePri	VARCHAR(15);
DECLARE Var_CRPtePrinci		VARCHAR(10);

DECLARE Var_NomPteIntere	VARCHAR(50);
DECLARE Var_CueMayPteInt	VARCHAR(15);
DECLARE Var_CRPteIntere		VARCHAR(10);

DECLARE	Var_CuentaEPRC		VARCHAR(50);
DECLARE	Var_CenCosEPRC		VARCHAR(10);
DECLARE	Var_ConcepConta		INT;

DECLARE Var_FecAntRes       DATE;
DECLARE Var_NumRegCal       INT;

DECLARE Var_MonCubCapita    DECIMAL(14,2);      -- Monto Cubierto de Capital.
DECLARE Var_MonCubIntere    DECIMAL(14,2);      -- Monto Cubierto de Interes.
DECLARE Var_MonCobTotal     DECIMAL(14,2);      -- Monto Cobertura Total
DECLARE Var_SaldoCobert     DECIMAL(14,2);      -- Saldo de la Cobertura
DECLARE Var_ResCapitaCub    DECIMAL(14,2);      -- Reserva por el Monto de Capital Cubierto.
DECLARE Var_ResIntereCub    DECIMAL(14,2);      -- Reserva por el Monto de Interes Cubierto.
DECLARE Var_InvGarantia		DECIMAL(14,2);
DECLARE Var_InvGarantiaHis	DECIMAL(14,2);

DECLARE Var_PorcReserva     DECIMAL(12,4);
DECLARE Var_SaldoInteres    DECIMAL(14,2);
DECLARE Var_SaldoCapital    DECIMAL(14,2);
DECLARE Var_CreditoID       BIGINT(12);
DECLARE Var_Clasifica       CHAR(1);
DECLARE Var_CuentaID        BIGINT(12);
DECLARE Var_ClienteID		BIGINT;

DECLARE Var_PorVivienda     DECIMAL(12,6);
DECLARE Var_PorConsumo      DECIMAL(12,6);
DECLARE Var_PorComercial    DECIMAL(12,6);
DECLARE	Var_PorResComercial	DECIMAL(12,6);
DECLARE	Var_PorResConsumo	DECIMAL(12,6);
DECLARE	Var_PorResVivienda	DECIMAL(12,6);

DECLARE Var_PorCeroDias     DECIMAL(12,6);

DECLARE Var_CRResul			VARCHAR(10);
DECLARE Var_CRBalance		VARCHAR(10);

DECLARE Var_RegContaEPRC	CHAR(1);
DECLARE Var_DivideEPRC	  	CHAR(1);
DECLARE Var_EPRCIntMorato	CHAR(1);
DECLARE Var_ResOrigen		CHAR(1);
DECLARE Var_EsReestruc		CHAR(1);
DECLARE Var_NumCreditos		INT(11);

DECLARE Var_MontoBaseEstCub	DECIMAL(14,2);		-- Monto base de la estimacion de la parte cubierta
DECLARE Var_MontoBaseEstExp	DECIMAL(14,2);		-- Monto base de la estimacion de la parte expuesta
/* Declaracion de Constantes */
DECLARE Decimal_Cien    	DECIMAL(12,2);
DECLARE Decimal_Cero    	DECIMAL(12,2);
DECLARE MetParametrico  	CHAR(1);
DECLARE TipoExpuesta    	CHAR(1);
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono       	CHAR(1);
DECLARE Pol_Automatica  	CHAR(1);
DECLARE Con_GenReserva  	INT;
DECLARE Ref_GenReserva  	VARCHAR(50);
DECLARE Ref_CanReserva  	VARCHAR(50);
DECLARE Par_SalidaNO    	CHAR(1);
DECLARE Con_Balance     	INT;
DECLARE Con_Resultados  	INT;
DECLARE Con_BalIntere		INT;
DECLARE Con_ResIntere  		INT;
DECLARE Con_PtePrinci		INT;
DECLARE Con_PteIntere  		INT;
DECLARE Procedimiento   	VARCHAR(20);
DECLARE For_CueMayor    	CHAR(3);
DECLARE For_TipProduc   	CHAR(3);
DECLARE For_TipCartera  	CHAR(3);
DECLARE For_Clasifica   	CHAR(3);
DECLARE	For_SubClasif		CHAR(3);
DECLARE For_Moneda      	CHAR(3);
DECLARE Cla_Comercial   	CHAR(1);
DECLARE Cla_Consumo     	CHAR(1);
DECLARE Cla_Vivienda    	CHAR(1);
DECLARE Si_AplicaConta  	CHAR(1);
DECLARE NOPagaIVA       	CHAR(1);
DECLARE Esta_Activa     	CHAR(1);
DECLARE Gar_Liquida     	INT;
DECLARE Clas_DepInstit  	INT;
DECLARE Clas_InvInstit  	INT;
DECLARE Estatus_Vigente 	CHAR(1);
DECLARE Estatus_Pagado  	CHAR(1);
DECLARE Estatus_Vencida 	CHAR(1);
DECLARE Cec_SucOrigen  		VARCHAR(10);
DECLARE Cec_SucCliente		VARCHAR(10);
DECLARE Tip_InsCredito		INT;
DECLARE EPRC_Resultados		CHAR(1);
DECLARE SI_DivideEPRC		CHAR(1);
DECLARE NO_DivideEPRC		CHAR(1);
DECLARE SI_ReservaMora		CHAR(1);
DECLARE NO_ReservaMora		CHAR(1);
DECLARE No_EsReestruc       CHAR(1);
DECLARE Si_EsReestruc       CHAR(1);
DECLARE Tipo_Renovacion		CHAR(1);
DECLARE NatBloqueo			CHAR(1);
DECLARE BloqueoGarLiq		INT;
DECLARE Pro_CierreGeneral	VARCHAR(20);
DECLARE Esta_Desembolso		CHAR(1);
DECLARE Expuesto            CHAR(1);
DECLARE Var_EsFiscal		CHAR(1);
DECLARE EsOficial 			CHAR(1);
DECLARE Con_CliProcEspe     VARCHAR(20);
DECLARE Var_CliProEsp   	INT;
DECLARE Var_TR				INT;
DECLARE Var_ATZ             INT;
DECLARE Var_TRAho			INT;
DECLARE Var_Terna			INT;
DECLARE Var_CopeTR			INT;

DECLARE CURSORRESERVA CURSOR FOR
    SELECT  Cal.CreditoID,          SUM(Cal.Capital) AS Capital,    SUM(Cal.Interes) AS Interes, MAX(Cal.PorcReservaExp) AS PorcReservaExp,   MAX(Cal.Clasificacion) AS Clasificacion,
            MAX(Cre.CuentaID) AS CuentaID, MAX(Cre.ClienteID) AS ClienteID,  MAX(Res.Origen) AS Origen
	FROM CALRESCREDITOS Cal
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = Cal.CreditoID
		LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID AND Res.EstatusReest = Esta_Desembolso
        LEFT OUTER JOIN DIRECCLIENTE Dir
				ON Cre.ClienteID = Dir.ClienteID
			LEFT OUTER JOIN LOCALIDADREPUB Loc
				ON Loc.LocalidadID = Dir.LocalidadID
				AND Loc.EstadoID = Dir.EstadoID
				AND Loc.MunicipioID = Dir.MunicipioID
                AND  CASE WHEN Dir.Fiscal = Var_EsFiscal THEN Dir.Fiscal = Var_EsFiscal
			ELSE  Oficial = EsOficial
		END
	WHERE Cal.Fecha = Par_Fecha GROUP BY Cal.CreditoID;


/* Asignacion de Constantes */
SET Decimal_Cien    := 100.00;
SET Decimal_Cero    := 0.00;
SET MetParametrico  := 'P';
SET TipoExpuesta    := 'E';
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Pol_Automatica  := 'A';
SET Con_GenReserva  := 56;
SET Par_SalidaNO    := 'N';
SET Con_Balance     := 17;       				-- Concepto Contable: EPRC, Balance
SET Con_Resultados  := 18;           		    -- Concepto Contable: EPRC, Resultados
SET Con_BalIntere	:= 36;       				-- Concepto Contable: Balance. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
SET Con_ResIntere  	:= 37;           		    -- Concepto Contable: Resultados. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
SET Con_PtePrinci	:= 38;       				-- Concepto Contable: EPRC Cta. Puente de Principal
SET Con_PteIntere  	:= 39;           		    -- Concepto Contable: EPRC Cta. Puente de Int.Normal y Moratorio
SET For_CueMayor    := '&CM';               	-- Nomenclatura Cuenta de Mayor
SET For_TipProduc   := '&TP';					-- Nomenclatura por Tipo de Producto de Credito
SET For_Clasifica   := '&CL';					-- Nomenclatura por Clasificacion
SET For_SubClasif   := '&SC';           		-- Nomenclatura por SubClasificacion
SET For_Moneda      := '&TM';               	-- Nomenclatura por Tipo de Moneda o Divisa

SET Cla_Comercial   := 'C';                     -- Tipo de Cartera: Comercial
SET Cla_Consumo     := 'O';                     -- Tipo de Cartera: Consumo
SET Cla_Vivienda    := 'H';                     -- Tipo de Cartera: Hipotecario o vivienda
SET Si_AplicaConta  := 'S';                     -- SI Aplicar Asientos Contables
SET NOPagaIVA       := 'N';
SET Estatus_Vigente := 'V';                     -- Estatus del Credito: Vigente
SET Estatus_Vencida := 'B';                     -- Estatus del Credito: Vencido
SET Estatus_Pagado  := 'P';                     -- Estatus del Credito: Pagado
SET Esta_Activa     := 'A';                     -- Estatus: Activo
SET Gar_Liquida     := 1;                       -- Tipo de Garantia Liquida
SET Clas_DepInstit  := 1;                       -- Clasificacion de la Garantia: Depositos en la Institucion
SET Clas_InvInstit  := 2;                       -- Clasificacion de la Garantia: Inversiones en la Institucion
SET Cec_SucOrigen  	:= '&SO';                   -- Centro de Costos a Tomar: Sucursal Origen
SET Cec_SucCliente	:= '&SC';                   -- Centro de Costos a Tomar: Sucursal del Cliente
SET	Tip_InsCredito	:= 11;						-- Tipo de Instrumento: Credito
SET EPRC_Resultados	:= 'R';						-- Estimacion en Cuentas de Resultados
SET SI_DivideEPRC	:= 'S';						-- SI Divide en la EPRC en Principal(Capital) e Interes
SET NO_DivideEPRC	:= 'N';						-- NO Divide en la EPRC en Principal(Capital) e Interes
SET SI_ReservaMora	:= 'S';						-- Si realiza Reserva de Moratorios
SET NO_ReservaMora	:= 'N';						-- No realiza Reserva de Moratorios
SET No_EsReestruc	:= 'N';   					-- No es credito reestructura o renovacion
SET Si_EsReestruc	:= 'S';   					-- Si es credito reestructura o renovacion
SET	Tipo_Renovacion	:= 'O';						-- Credito renovado

SET Ref_GenReserva  := 'GENERACION DE RESERVAS';
SET Ref_CanReserva  := 'ACT.RESERVAS. ';
SET Procedimiento   := 'POLIZACREDITOPRO';
SET Aud_FechaActual := NOW();
SET NatBloqueo		:= 'B';						-- Naturaleza: Bloqueo
SET BloqueoGarLiq	:= 8; 						-- Tipo de bloqueo 8: Garantia Liquida
SET Pro_CierreGeneral := 'CIERREGENERALPRO';	-- Proceso CIERREGENERALPRO
SET Esta_Desembolso	:= 'D';						-- Estatus desembolsado
SET Expuesto		:= 'E';						-- Tipo rango: parte expuesta.
SET Var_EsFiscal	:= 'S';						-- Direccion Fiscal: SI
SET EsOficial		:= 'S';						-- Direccion Oficial: SI
Set Con_CliProcEspe := 'CliProcEspecifico';
SET Var_TR 			:= 30;
SET Var_ATZ          := 10;
SET Var_TRAho		:= 26;
SET Var_Terna		:= 27;
SET Var_CopeTR		:= 30;

SELECT  TipoInstitucion,    LimiteExpuesto
    INTO var_TipoInstitucion, var_LimiteExpuesto
    FROM PARAMSCALIFICA;

SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCIntMorato INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCIntMorato
	FROM PARAMSRESERVCASTIG
	WHERE EmpresaID = Par_EmpresaID;

SET	Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
SET	Var_DivideEPRC	:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
SET	Var_EPRCIntMorato	:= IFNULL(Var_EPRCIntMorato, NO_ReservaMora);

TRUNCATE TMPDETPOLIZA;

SELECT  MAX(Fecha) INTO Var_FecAntRes
    FROM CALRESCREDITOS
    WHERE   AplicaConta = Si_AplicaConta;

SET Var_FecAntRes := IFNULL(Var_FecAntRes, Fecha_Vacia);


CALL DIASFESTIVOSCAL(
    Par_Fecha,      Entero_Cero,        Var_FecApl,         Var_EsHabil,    Par_EmpresaID,
    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);


   -- Si el último día del mes es domingo se realiza la estimación y con esa misma fecha debe registrar la póliza --
    IF(Var_FecApl > Par_Fecha)THEN
		SET Var_FecApl = LAST_DAY(Par_Fecha);
	END IF;

SELECT  COUNT(CreditoID) INTO Var_NumRegCal
    FROM CALRESCREDITOS
    WHERE Fecha         = Par_Fecha
      AND AplicaConta   = Si_AplicaConta;

SET Var_NumRegCal   = IFNULL(Var_NumRegCal, Entero_Cero);

IF(Var_NumRegCal > Entero_Cero) THEN
    SET Par_AplicaConta = Si_AplicaConta;
END IF;

SELECT COUNT(CreditoID)AS CreditoID
INTO Var_NumCreditos
FROM CREDITOS;

SET Var_NumCreditos   = IFNULL(Var_NumCreditos, Entero_Cero);

-- Seleccion de Cuentas de Mayor y Nomenclatura de Centro de Costos
SELECT  Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomBalance, Var_CueMayBal, Var_CRBalance
	FROM CUENTASMAYORCAR
	WHERE   ConceptoCarID   = Con_Balance;

SELECT  Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomResult, Var_CueMayRes, Var_CRResul
	FROM CUENTASMAYORCAR
	WHERE   ConceptoCarID   = Con_Resultados;

SELECT  Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomBalIntere, Var_CueMayBalInt, Var_CRBalIntere
	FROM CUENTASMAYORCAR
	WHERE   ConceptoCarID   = Con_BalIntere;

SELECT  Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomResIntere, Var_CueMayResInt, Var_CRResIntere
	FROM CUENTASMAYORCAR
	WHERE   ConceptoCarID   = Con_ResIntere;

SELECT  Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomPtePrinci, Var_CueMayPtePri, Var_CRPtePrinci
	FROM CUENTASMAYORCAR
	WHERE   ConceptoCarID   = Con_PtePrinci;

SELECT  Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomPteIntere, Var_CueMayPteInt, Var_CRPteIntere
	FROM CUENTASMAYORCAR
	WHERE   ConceptoCarID   = Con_PteIntere;

SET Var_NomBalance   := IFNULL(Var_NomBalance, Cadena_Vacia);
SET Var_NomResult   := IFNULL(Var_NomResult, Cadena_Vacia);
SET Var_CueMayBal   := IFNULL(Var_CueMayBal, Cadena_Vacia);
SET Var_CueMayRes   := IFNULL(Var_CueMayRes, Cadena_Vacia);
SET	Var_CRBalance	:= IFNULL(Var_CRBalance, Cadena_Vacia);
SET	Var_CRResul		:= IFNULL(Var_CRResul, Cadena_Vacia);

SET Var_NomBalIntere   := IFNULL(Var_NomBalIntere, Cadena_Vacia);
SET Var_CueMayBalInt   := IFNULL(Var_CueMayBalInt, Cadena_Vacia);
SET	Var_CRBalIntere	:= IFNULL(Var_CRBalIntere, Cadena_Vacia);

SET Var_NomResIntere   := IFNULL(Var_NomResIntere, Cadena_Vacia);
SET Var_CueMayResInt   := IFNULL(Var_CueMayResInt, Cadena_Vacia);
SET	Var_CRResIntere	:= IFNULL(Var_CRResIntere, Cadena_Vacia);

SET Var_NomPtePrinci   := IFNULL(Var_NomPtePrinci, Cadena_Vacia);
SET Var_CueMayPtePri   := IFNULL(Var_CueMayPtePri, Cadena_Vacia);
SET	Var_CRPtePrinci	:= IFNULL(Var_CRPtePrinci, Cadena_Vacia);

SET Var_NomPteIntere   := IFNULL(Var_NomPteIntere, Cadena_Vacia);
SET Var_CueMayPteInt   := IFNULL(Var_CueMayPteInt, Cadena_Vacia);
SET	Var_CRPteIntere	:= IFNULL(Var_CRPteIntere, Cadena_Vacia);





# =========================== CANCELACION CONTABLE DE LA GENERACION DE RESERVA ANTERIOR ==============================
IF (Var_FecAntRes != Fecha_Vacia AND Par_AplicaConta = Si_AplicaConta) THEN
		SET Ref_CanReserva  := CONCAT(Ref_CanReserva, CONVERT(DATE(Var_FecAntRes), CHAR));

    IF(Par_PolizaID = Entero_Cero) THEN


		IF (Var_NumCreditos > Entero_Cero)THEN

			CALL MAESTROPOLIZAALT(
				Par_PolizaID,     Par_EmpresaID,  Var_FecApl,     Pol_Automatica,     Con_GenReserva,
				Ref_GenReserva, Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

		END IF;

	END IF;

		-- Verifica si Divide la Reserva en Interes y Capital
		IF(Var_DivideEPRC = NO_DivideEPRC) THEN
				-- Registro Contable en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,		`MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,		`ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CRBalance = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalance = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalance,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,   (Cal.SaldoResCapital + Cal.SaldoResInteres),
							Decimal_Cero,                   Ref_CanReserva, CONVERT(Cal.CreditoID, CHAR),   Procedimiento,
							Cal.CreditoID,                  Cal.Clasificacion,  Cal.ProductoCreditoID,	Con_Balance,
							Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Var_FecAntRes
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero) +
						   IFNULL(Cal.SaldoResInteres, Decimal_Cero) ) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

				-- Reserva de Capital en Estado de Resultados o Cuenta Puente
				-- Verifica si es en Cuenta Contable de Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Var_CuentaEPRC	:= Var_NomResult;
					SET	Var_CenCosEPRC	:= Var_CRResul;
					SET Var_ConcepConta := Con_Resultados;
				ELSE
					SET	Var_CuentaEPRC	:= Var_NomPtePrinci;
					SET	Var_CenCosEPRC	:= Var_CRPtePrinci;
					SET Var_ConcepConta := Con_PtePrinci;
				END IF;

				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,       Decimal_Cero,   (Cal.SaldoResCapital + Cal.SaldoResInteres),
							Ref_CanReserva,             CONVERT(Cal.CreditoID, CHAR),       Procedimiento,  Cal.CreditoID,
							Cal.Clasificacion,  Cal.ProductoCreditoID,	Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Var_FecAntRes
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero) +
						   IFNULL(Cal.SaldoResInteres, Decimal_Cero) ) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;


		ELSE -- Si divide la Reserva en Interes y Capital

				-- Reserva de Capital en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CRBalance = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalance = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalance,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,   Cal.SaldoResCapital,
							Decimal_Cero,                   Ref_CanReserva, CONVERT(Cal.CreditoID, CHAR),   Procedimiento,
							Cal.CreditoID,                  Cal.Clasificacion,  Cal.ProductoCreditoID,	Con_Balance,
							Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Var_FecAntRes
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero)) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

				-- Reserva de Interes en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CRBalIntere = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalIntere = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalIntere,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,	Cal.SaldoResInteres,
							Decimal_Cero,                   Ref_CanReserva, CONVERT(Cal.CreditoID, CHAR),   Procedimiento,
							Cal.CreditoID,                  Cal.Clasificacion,  Cal.ProductoCreditoID,	Con_BalIntere,
							Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Var_FecAntRes
					  AND (IFNULL(Cal.SaldoResInteres, Decimal_Cero) ) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;


				-- Reserva de Capital en Estado de Resultados o Cuenta Puente
				-- Verifica si es en Cuenta Contable de Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Var_CuentaEPRC	:= Var_NomResult;
					SET	Var_CenCosEPRC	:= Var_CRResul;
					SET Var_ConcepConta := Con_Resultados;
				ELSE
					SET	Var_CuentaEPRC	:= Var_NomPtePrinci;
					SET	Var_CenCosEPRC	:= Var_CRPtePrinci;
					SET Var_ConcepConta := Con_PtePrinci;
				END IF;

				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,       Decimal_Cero,   Cal.SaldoResCapital,
							Ref_CanReserva,             CONVERT(Cal.CreditoID, CHAR),       Procedimiento,  Cal.CreditoID,
							Cal.Clasificacion,  Cal.ProductoCreditoID,	Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Var_FecAntRes
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero)) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

				-- Reserva de Interes en Estado de Resultados o Cuenta Puente
				-- Verifica si es en Cuenta Contable de Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Var_CuentaEPRC	:= Var_NomResIntere;
					SET	Var_CenCosEPRC	:= Var_CRResIntere;
					SET Var_ConcepConta := Con_ResIntere;
				ELSE
					SET	Var_CuentaEPRC	:= Var_NomPteIntere;
					SET	Var_CenCosEPRC	:= Var_CRPteIntere;
					SET Var_ConcepConta := Con_PteIntere;
				END IF;

				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,       Decimal_Cero,	Cal.SaldoResInteres,
							Ref_CanReserva,             CONVERT(Cal.CreditoID, CHAR),       Procedimiento,  Cal.CreditoID,
							Cal.Clasificacion,  Cal.ProductoCreditoID,	Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Var_FecAntRes
					  AND (IFNULL(Cal.SaldoResInteres, Decimal_Cero)) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

		END IF; -- Termina if(Var_DivideEPRC = NO_DivideEPRC) then




		-- Creacion de las Cuentas Conatables apartir de su nomenclatura y parametrizacion
		UPDATE TMPDETPOLIZA SET
			CuentaCompleta  = CASE WHEN ConceptoContable = Con_Balance THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayBal)
								   WHEN ConceptoContable = Con_Resultados THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayRes)
								   WHEN ConceptoContable = Con_BalIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayBalInt)
								   WHEN ConceptoContable = Con_ResIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayResInt)
								   WHEN ConceptoContable = Con_PtePrinci THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayPtePri)
								   WHEN ConceptoContable = Con_PteIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayPteInt)
							END
		WHERE (IFNULL(Cargos, Decimal_Cero)  +
				   IFNULL(Abonos, Decimal_Cero) ) > Decimal_Cero
			  AND LOCATE(For_CueMayor, CuentaCompleta) > Entero_Cero;


		UPDATE TMPDETPOLIZA Pol, SUBCTACLASIFCART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta,
										For_Clasifica,
										CASE WHEN Pol.Clasificacion = Cla_Comercial THEN Sub.Comercial
											 WHEN Pol.Clasificacion = Cla_Consumo THEN Sub.Consumo
											 ELSE Sub.Vivienda
										END)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND LOCATE(For_Clasifica, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA Pol, SUBCTASUBCLACART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_SubClasif, Sub.SubCuenta)

		WHERE  (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.SubClasificacion    = Sub.ClasificacionID
			  AND LOCATE(For_SubClasif, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA Pol, SUBCTAPRODUCCART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_TipProduc, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.ProductoCreditoID    = Sub.ProducCreditoID
			  AND LOCATE(For_TipProduc, CuentaCompleta) > Entero_Cero;


		UPDATE TMPDETPOLIZA Pol, SUBCTAMONEDACART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_Moneda, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.MonedaID    = Sub.MonedaID
			  AND LOCATE(For_Moneda, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, '-', Cadena_Vacia);

		INSERT INTO `DETALLEPOLIZA` (
			`EmpresaID`,    `PolizaID`,             `Fecha`,    			`CentroCostoID`,    `CuentaCompleta`,
			`Instrumento`,  `MonedaID`,             `Cargos`,   			`Abonos`,           `Descripcion`,
			`Referencia`,   `ProcedimientoCont`,    `TipoInstrumentoID`,	`Usuario`,			`FechaActual`,
			`DireccionIP`,	`ProgramaID`,   		`Sucursal`,				`NumTransaccion`    )
		SELECT  Par_EmpresaID,  	PolizaID,           Var_FecApl,     	CentroCostoID,	CuentaCompleta,
					Instrumento,    	MonedaID,           Cargos,         	Abonos,			Descripcion,
					Referencia,     	ProcedimientoCont,  Tip_InsCredito,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
		FROM TMPDETPOLIZA;

		TRUNCATE TMPDETPOLIZA;

END IF; -- Termina: IF (Var_FecAntRes != Fecha_Vacia and Par_AplicaConta = Si_AplicaConta) THEN


-- Borramos el Registro de la Reserva
DELETE FROM CALRESCREDITOS WHERE Fecha = Par_Fecha;
DELETE FROM GARANTIARESERVA WHERE Fecha = Par_Fecha;






# ================================== CALCULO DE LA ESTIMACION Y RESERVA ACTUAL ==========================================

INSERT INTO `CALRESCREDITOS` (
    `Fecha`,            `CreditoID`,        `Capital`,          `Interes`,              `IVA`,
    `Total`,            `DiasAtraso`,       `Calificacion`,     `PorcReservaExp`,       `Reserva`,
    `TipoCalificacion`, `Metodologia`,      `MonedaID`,         `ProductoCreditoID`,    `Clasificacion`,
    `AplicaConta`,      `PorcReservaCub`,	`EmpresaID`,        `Usuario`,         		`FechaActual`,
    `DireccionIP`,   	`ProgramaID`,       `Sucursal`,         `NumTransaccion` )

SELECT  sal.FechaCorte, sal.CreditoID,
            (SalCapVigente + SalCapAtrasado + SalCapVencido + SalCapVenNoExi) AS Capital,
            CASE sal.EstatusCredito
                WHEN Estatus_Vencida THEN Entero_Cero
                ELSE ROUND(SalIntProvision + SalIntOrdinario + SalIntAtrasado,2) +
					(CASE WHEN Var_EPRCIntMorato = SI_ReservaMora THEN ROUND(SalMoratorios, 2)   -- Estimacion de Moratorios
						 ELSE Decimal_Cero
					END )
            END,

            CASE sal.EstatusCredito
                WHEN Estatus_Vencida THEN Entero_Cero
                ELSE
                    CASE WHEN Cli.PagaIVA = NOPagaIVA OR Pro.CobraIVAInteres = NOPagaIVA THEN Decimal_Cero
                        ELSE ROUND(
									(SalIntProvision + SalIntOrdinario + SalIntAtrasado +
									(CASE WHEN Var_EPRCIntMorato = SI_ReservaMora THEN SalMoratorios   -- Estimacion de Moratorios
										ELSE Decimal_Cero
								    END )	) * Suc.IVA, 2)
                END
            END,

            (
                (SalCapVigente + SalCapAtrasado + SalCapVencido + SalCapVenNoExi) +
                ( CASE sal.EstatusCredito
                    WHEN Estatus_Vencida THEN Entero_Cero
                    ELSE
                        ROUND(SalIntProvision + SalIntOrdinario + SalIntAtrasado,2) +
							(CASE WHEN Var_EPRCIntMorato = SI_ReservaMora THEN ROUND(SalMoratorios, 2)   -- Estimacion de Moratorios
								  ELSE Decimal_Cero
							 END )
                  END
                )
            ) AS Total,
            sal.DiasAtraso, sal.Calificacion,	sal.PorcReserva /   Decimal_Cien,   Decimal_Cero, 		TipoExpuesta,
            MetParametrico, sal.MonedaID,       Pro.ProducCreditoID,    			Des.Clasificacion,  Par_AplicaConta,
            Decimal_Cero,	Par_EmpresaID,      Aud_Usuario,            			Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion

FROM CLIENTES Cli,
             SUCURSALES Suc,
             PRODUCTOSCREDITO Pro,
             DESTINOSCREDITO Des,
             SALDOSCREDITOS sal, CREDITOS Cre

WHERE sal.ProductoCreditoID = Pro.ProducCreditoID
	  AND sal.ClienteID         = Cli.ClienteID
	  AND Cli.SucursalOrigen    = Suc.SucursalID
	  AND sal.FechaCorte        = Par_Fecha
	  AND sal.DestinoCreID      = Des.DestinoCreID
	  AND EstatusCredito        != Estatus_Pagado
	  AND sal.CreditoID 		= Cre.CreditoID
	  AND sal.EstatusCredito   != Estatus_Pagado;


-- Obtenemos los Porcentajes de Reserva de Cero Dias de Atraso
SELECT PorResCarSReest, PorResCarReest INTO Var_PorComercial, Var_PorResComercial
FROM PORCRESPERIODO
WHERE LimInferior <= Entero_Cero
      AND TipoInstitucion = TipoInstitucion
      AND Estatus = Esta_Activa
      AND Clasificacion = Cla_Comercial
	  AND TipoRango = Expuesto;

SELECT PorResCarSReest, PorResCarReest INTO Var_PorConsumo, Var_PorResConsumo
FROM PORCRESPERIODO
WHERE LimInferior <= Entero_Cero
      AND TipoInstitucion = TipoInstitucion
      AND Estatus = Esta_Activa
      AND Clasificacion = Cla_Consumo
	  AND TipoRango = Expuesto;

SELECT PorResCarSReest, PorResCarReest INTO Var_PorVivienda, Var_PorResVivienda
FROM PORCRESPERIODO
WHERE LimInferior <= Entero_Cero
      AND TipoInstitucion = TipoInstitucion
      AND Estatus = Esta_Activa
      AND Clasificacion = Cla_Vivienda
	  AND TipoRango = Expuesto;

SET Var_PorVivienda := IFNULL(Var_PorVivienda, Entero_Cero) / 100;
SET Var_PorConsumo := IFNULL(Var_PorConsumo, Entero_Cero) / 100;
SET Var_PorComercial := IFNULL(Var_PorComercial, Entero_Cero) / 100;

SET Var_PorResComercial := IFNULL(Var_PorResComercial, Entero_Cero) / 100;
SET Var_PorResConsumo := IFNULL(Var_PorResConsumo, Entero_Cero) / 100;
SET Var_PorResVivienda := IFNULL(Var_PorResVivienda, Entero_Cero) / 100;

SELECT IFNULL(ValorParametro, Entero_Cero) INTO Var_CliProEsp
    FROM PARAMGENERALES
    WHERE    LlaveParametro = Con_CliProcEspe;


-- Calculo de Garantias y Parte Cubierta
OPEN CURSORRESERVA;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP
    FETCH CURSORRESERVA INTO
        Var_CreditoID,	Var_SaldoCapital,	Var_SaldoInteres,   Var_PorcReserva,    Var_Clasifica,
        Var_CuentaID,	Var_ClienteID,		Var_ResOrigen;

        -- Inicializacion
        SET Var_MonCobTotal := Entero_Cero;
        SET Var_PorCeroDias := Entero_Cero;
		SET	Var_InvGarantia	:= Entero_Cero;
		SET Var_InvGarantiaHis	:= Entero_Cero;
        SET Var_SaldoCapital := IFNULL(Var_SaldoCapital, Entero_Cero);
        SET Var_SaldoInteres := IFNULL(Var_SaldoInteres, Entero_Cero);
        SET Var_PorcReserva := IFNULL(Var_PorcReserva, Entero_Cero);
        SET Var_CuentaID := IFNULL(Var_CuentaID, Entero_Cero);
		SET	Var_ResOrigen := IFNULL(Var_ResOrigen, Cadena_Vacia);

		# Verifica si No es un credito emproblemado (Renovacion o reestructura)
        IF(Var_ResOrigen = Cadena_Vacia ) THEN
				SET Var_EsReestruc  := No_EsReestruc;

				IF(Var_Clasifica = Cla_Vivienda) THEN
					IF NOT EXISTS (SELECT CreditoID FROM  CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND GarHipotecaria > 0) THEN
						SET Var_PorCeroDias := Var_PorConsumo;
					 ELSE
						SET Var_PorCeroDias := Var_PorVivienda;
					END IF;
				ELSEIF (Var_Clasifica = Cla_Consumo) THEN
						IF EXISTS (SELECT CreditoID FROM  CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND GarHipotecaria > 0) THEN
							SET Var_PorCeroDias := Var_PorVivienda;
						ELSE
							SET Var_PorCeroDias := Var_PorConsumo;
						END IF;

					ELSE
						IF EXISTS (SELECT CreditoID FROM  CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND GarHipotecaria > 0) THEN
							SET Var_PorCeroDias := Var_PorVivienda;
						ELSE
							SET Var_PorCeroDias := Var_PorComercial;
						END IF;

				END IF;
		ELSE -- Es un credito emproblemado (Reestructura o Renovacion)
				SET Var_EsReestruc  := Si_EsReestruc;

				IF(Var_Clasifica = Cla_Vivienda) THEN
					IF NOT EXISTS (SELECT CreditoID FROM  CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND GarHipotecaria > 0) THEN
						SET Var_PorCeroDias := Var_PorResConsumo;
					ELSE
						SET Var_PorCeroDias := Var_PorResVivienda;
					END IF;

				ELSEIF (Var_Clasifica = Cla_Consumo) THEN

						IF EXISTS (SELECT CreditoID FROM  CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND GarHipotecaria > 0) THEN
							SET Var_PorCeroDias := Var_PorResVivienda;
						ELSE
							SET Var_PorCeroDias := Var_PorResConsumo;
						END IF;
					ELSE

						IF EXISTS (SELECT CreditoID FROM  CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND GarHipotecaria > 0) THEN
							SET Var_PorCeroDias := Var_PorResVivienda;
						ELSE
							SET Var_PorCeroDias := Var_PorResComercial;
						END IF;

				END IF;

        END IF; -- Termina:  if(Var_ResOrigen = Cadena_Vacia ) then
		IF(Var_CliProEsp NOT IN ( Var_TR, Var_ATZ, Var_TRAho, Var_Terna, Var_CopeTR)) THEN
		-- Obtenemos el Monto de Cobertura con Cuentas de Ahorro
		 SET Var_MonCobTotal  := (SELECT SUM(CASE WHEN NatMovimiento = NatBloqueo THEN  MontoBloq ELSE MontoBloq *-1 END)
                                    FROM BLOQUEOS Blo,
                                         CUENTASAHO Cue
                                    WHERE Blo.CuentaAhoID = Cue.CuentaAhoID
									  AND DATE(FechaMov) <= Par_Fecha
                                      AND Blo.Referencia = Var_CreditoID
									  AND Cue.ClienteID = Var_ClienteID
                                      AND Blo.TiposBloqID = BloqueoGarLiq);
        END IF;

        SET Var_MonCobTotal := IFNULL(Var_MonCobTotal, Entero_Cero);

        -- Registramos el Detalle de Cobertura de la Garantia de Cuenta de Ahorro
        IF(Var_MonCobTotal > Entero_Cero) THEN
            INSERT INTO GARANTIARESERVA VALUES(
                Par_Fecha,          Var_CreditoID,  Var_CuentaID,   Gar_Liquida,        Clas_DepInstit,
                Var_MonCobTotal,    Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        END IF;


		-- Inversiones Plazo en Garantia
		SET Var_InvGarantia 	:= Decimal_Cero;
		SET Var_InvGarantiaHis	:= Decimal_Cero;

		IF(Var_CliProEsp NOT IN ( Var_TR, Var_ATZ, Var_TRAho, Var_Terna, Var_CopeTR)) THEN
			SET Var_InvGarantia := (SELECT SUM(Gar.MontoEnGar)
									FROM CREDITOINVGAR Gar
									WHERE Gar.FechaAsignaGar <= Par_Fecha
									  AND Gar.CreditoID = Var_CreditoID);
		END IF;

		SET Var_InvGarantia := IFNULL(Var_InvGarantia, Decimal_Cero);

        IF(Var_CliProEsp NOT IN ( Var_TR, Var_ATZ, Var_TRAho, Var_Terna, Var_CopeTR)) THEN
			SET Var_InvGarantiaHis := (	SELECT SUM(Gar.MontoEnGar)
									FROM HISCREDITOINVGAR Gar
									WHERE Gar.Fecha > Par_Fecha
									  AND Gar.FechaAsignaGar <= Par_Fecha
									  AND Gar.ProgramaID NOT IN (Pro_CierreGeneral)
									  AND Gar.CreditoID = Var_CreditoID  );
		END IF;

		SET	Var_InvGarantiaHis	:= IFNULL(Var_InvGarantiaHis, Decimal_Cero);

		SET Var_InvGarantia		:= (Var_InvGarantia + Var_InvGarantiaHis);





		SET	Var_InvGarantia	:= IFNULL(Var_InvGarantia, Entero_Cero);
		SET Var_MonCobTotal	:= Var_MonCobTotal + Var_InvGarantia;

        SET Var_SaldoCobert := Var_MonCobTotal;
        SET Var_MonCubCapita := Entero_Cero;
        SET Var_MonCubIntere := Entero_Cero;
        SET Var_ResCapitaCub := Entero_Cero;
        SET Var_ResIntereCub := Entero_Cero;
		SET Var_MontoBaseEstCub := Decimal_Cero;
        SET Var_MontoBaseEstExp	:= Decimal_Cero;
        -- Si todo el Monto esta Cubierto
        IF(Var_MonCobTotal >= (Var_SaldoCapital + Var_SaldoInteres)) THEN
            SET Var_ResCapitaCub := ROUND(Var_SaldoCapital * Var_PorCeroDias, 2);
            SET Var_ResIntereCub := ROUND(Var_SaldoInteres * Var_PorCeroDias, 2);
            SET Var_MonCubCapita := Var_SaldoCapital;
            SET Var_MonCubIntere := Var_SaldoInteres;
            SET Var_SaldoCobert := Var_SaldoCobert - ( Var_SaldoCapital + Var_SaldoInteres);
            SET Var_MontoBaseEstCub := Var_SaldoCapital+Var_SaldoInteres; # El monto base para el calculo es el Saldo del Capital mas el Saldo de Interes
            SET Var_MontoBaseEstExp := Decimal_Cero;	# Monto base para el calculo es cero.
        END IF;

        -- Si no Cubre el Total de Capital e Interes
        IF(Var_MonCobTotal > Entero_Cero AND Var_MonCobTotal < (Var_SaldoCapital + Var_SaldoInteres)) THEN
            -- Cobertura del Capital
			SET Var_MontoBaseEstCub := Var_MonCobTotal;		# Monto base es el monto de la garantia
            SET Var_MontoBaseEstExp := (Var_SaldoCapital+Var_SaldoInteres)-Var_MonCobTotal; # Monto base Saldo capital + saldo interes
            IF(Var_MonCobTotal >= Var_SaldoCapital) THEN
                SET Var_ResCapitaCub := ROUND(Var_SaldoCapital * Var_PorCeroDias,2);
                SET Var_MonCubCapita := Var_SaldoCapital;
                SET Var_SaldoCobert := Var_SaldoCobert - Var_SaldoCapital;
            ELSE
                SET Var_ResCapitaCub := ROUND(Var_MonCobTotal * Var_PorCeroDias,2);
                SET Var_MonCubCapita := Var_MonCobTotal;
                SET Var_SaldoCobert := Entero_Cero;
            END IF;
            -- Cobertura del Interes
            IF(Var_SaldoCobert > Entero_Cero) THEN
                SET Var_ResIntereCub := ROUND(Var_SaldoCobert * Var_PorCeroDias,2);
                SET Var_MonCubIntere := Var_SaldoCobert;
                SET Var_SaldoCobert := Entero_Cero;
            END IF;
		END IF;

        IF(Var_MonCobTotal = Entero_Cero) THEN

			SET Var_MontoBaseEstCub := Decimal_Cero;		# Monto base es el monto de la garantia
            SET Var_MontoBaseEstExp := (Var_SaldoCapital+Var_SaldoInteres); # Monto base Saldo capital + saldo interes

        END IF;

        UPDATE CALRESCREDITOS SET
            ReservaInteres  = ROUND((Interes - Var_MonCubIntere) * PorcReservaExp, 2) + Var_ResIntereCub,
            SaldoResInteres = ROUND((Interes - Var_MonCubIntere) * PorcReservaExp, 2) + Var_ResIntereCub,
            SaldoResCapital = ROUND((Capital - Var_MonCubCapita) * PorcReservaExp, 2) + Var_ResCapitaCub,

            Reserva         = (ROUND((Interes - Var_MonCubIntere) * PorcReservaExp, 2) + Var_ResIntereCub) +
                              (ROUND((Capital - Var_MonCubCapita) * PorcReservaExp, 2) + Var_ResCapitaCub ),


            ReservaTotCubierto  = Var_ResIntereCub + Var_ResCapitaCub,
            ReservaTotExpuesto  = ROUND((Interes - Var_MonCubIntere) * PorcReservaExp, 2) +
                                  ROUND((Capital - Var_MonCubCapita) * PorcReservaExp, 2),

            MontoGarantia = Var_MonCobTotal,
			PorcReservaCub = Var_PorCeroDias,
            MontoBaseEstCub = Var_MontoBaseEstCub,
            MontoBaseEstExp = Var_MontoBaseEstExp

            WHERE Fecha   = Par_Fecha
              AND CreditoID = Var_CreditoID;

			UPDATE CALRESCREDITOS SET
			ReservaCapital = ROUND((Reserva - ReservaInteres), 2)
             WHERE Fecha   = Par_Fecha
              AND CreditoID = Var_CreditoID;

    END LOOP;
END;
CLOSE CURSORRESERVA;


IF (Par_AplicaConta = Si_AplicaConta) THEN
		SET Par_PolizaID  = IFNULL(Par_PolizaID, Entero_Cero);

		IF (Par_PolizaID = Entero_Cero) THEN

			IF (Var_NumCreditos > Entero_Cero)THEN

				CALL MAESTROPOLIZAALT(
					Par_PolizaID,     Par_EmpresaID,  Var_FecApl,     Pol_Automatica,     Con_GenReserva,
					Ref_GenReserva, Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

			END IF;

		END IF;

		-- Verifica si Divide la Reserva en Interes y Capital
		IF(Var_DivideEPRC = NO_DivideEPRC) THEN
				-- Registro Contable en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,		`MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,		`ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT   Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CRBalance = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								WHEN Var_CRBalance = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalance,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,	Decimal_Cero,   Cal.Reserva,		Ref_GenReserva,
							CONVERT(Cal.CreditoID, CHAR),   Procedimiento,  Cal.CreditoID,	Cal.Clasificacion,  Cal.ProductoCreditoID,
							Con_Balance, Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero) +
						   IFNULL(Cal.SaldoResInteres, Decimal_Cero) ) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

				-- Reserva de Capital en Estado de Resultados o Cuenta Puente
				-- Verifica si es en Cuenta Contable de Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Var_CuentaEPRC	:= Var_NomResult;
					SET	Var_CenCosEPRC	:= Var_CRResul;
					SET Var_ConcepConta := Con_Resultados;
				ELSE
					SET	Var_CuentaEPRC	:= Var_NomPtePrinci;
					SET	Var_CenCosEPRC	:= Var_CRPtePrinci;
					SET Var_ConcepConta := Con_PtePrinci;
				END IF;

				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,		`MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,		`ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT   Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CenCosEPRC = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								WHEN Var_CenCosEPRC = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,	Cal.Reserva,    Decimal_Cero,   	Ref_GenReserva,
							CONVERT(Cal.CreditoID, CHAR),   Procedimiento,  Cal.CreditoID,  Cal.Clasificacion,  Cal.ProductoCreditoID,
							Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					  AND Reserva   > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

		ELSE -- Si divide la Reserva en Interes y Capital
				-- Reserva de Capital en Balance
				INSERT INTO `TMPDETPOLIZA` (
					 `PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT   Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CRBalance = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalance = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalance,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,	Decimal_Cero, Cal.SaldoResCapital,
							Ref_GenReserva, CONVERT(Cal.CreditoID, CHAR),   Procedimiento,
							Cal.CreditoID,	Cal.Clasificacion,  Cal.ProductoCreditoID,	Con_Balance,
							Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero)) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

				-- Reserva de Interes en Balance
				INSERT INTO `TMPDETPOLIZA` (
					 `PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT   Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CRBalIntere = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalIntere = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalIntere,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,	Decimal_Cero, Cal.SaldoResInteres,
							Ref_GenReserva, CONVERT(Cal.CreditoID, CHAR),   Procedimiento,
							Cal.CreditoID,                  Cal.Clasificacion,  Cal.ProductoCreditoID,	Con_BalIntere,
							Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					  AND (IFNULL(Cal.SaldoResInteres, Decimal_Cero) ) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;
				-- Reserva de Capital en Estado de Resultados o Cuenta Puente
				-- Verifica si es en Cuenta Contable de Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Var_CuentaEPRC	:= Var_NomResult;
					SET	Var_CenCosEPRC	:= Var_CRResul;
					SET Var_ConcepConta := Con_Resultados;
				ELSE
					SET	Var_CuentaEPRC	:= Var_NomPtePrinci;
					SET	Var_CenCosEPRC	:= Var_CRPtePrinci;
					SET Var_ConcepConta := Con_PtePrinci;
				END IF;
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,       Cal.SaldoResCapital,	Decimal_Cero,
							Ref_GenReserva,             CONVERT(Cal.CreditoID, CHAR),       Procedimiento,  Cal.CreditoID,
							Cal.Clasificacion,  Cal.ProductoCreditoID,	Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					  AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero)) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;

				-- Reserva de Interes en Estado de Resultados o Cuenta Puente
				-- Verifica si es en Cuenta Contable de Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Var_CuentaEPRC	:= Var_NomResIntere;
					SET	Var_CenCosEPRC	:= Var_CRResIntere;
					SET Var_ConcepConta := Con_ResIntere;
				ELSE
					SET	Var_CuentaEPRC	:= Var_NomPteIntere;
					SET	Var_CenCosEPRC	:= Var_CRPteIntere;
					SET Var_ConcepConta := Con_PteIntere;
				END IF;
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           `Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      `MonedaID`,           `Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       `ProcedimientoCont`,  `CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,	`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR),   Cal.MonedaID,       Cal.SaldoResInteres,	Decimal_Cero,
							Ref_GenReserva,             CONVERT(Cal.CreditoID, CHAR),       Procedimiento,  Cal.CreditoID,
							Cal.Clasificacion,  Cal.ProductoCreditoID,	Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
							 CREDITOS Cre,
							 CLIENTES Cli,
							 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					  AND (IFNULL(Cal.SaldoResInteres, Decimal_Cero)) > Decimal_Cero
					  AND Cal.CreditoID = Cre.CreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cre.DestinoCreID	= Des.DestinoCreID;
		END IF; -- Termina: if(Var_DivideEPRC = NO_DivideEPRC) then




		-- Creacion de las Cuentas Conatables apartir de su nomenclatura y parametrizacion
		UPDATE TMPDETPOLIZA SET
			CuentaCompleta  = CASE WHEN ConceptoContable = Con_Balance THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayBal)
								   WHEN ConceptoContable = Con_Resultados THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayRes)
								   WHEN ConceptoContable = Con_BalIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayBalInt)
								   WHEN ConceptoContable = Con_ResIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayResInt)
								   WHEN ConceptoContable = Con_PtePrinci THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayPtePri)
								   WHEN ConceptoContable = Con_PteIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayPteInt)
							END
		WHERE  (IFNULL(Cargos, Decimal_Cero)  +
				   IFNULL(Abonos, Decimal_Cero) ) > Decimal_Cero
			  AND LOCATE(For_CueMayor, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA SET
			CuentaCompleta  = REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayRes)
		WHERE  Var_CueMayRes  != Cadena_Vacia
			  AND Abonos         > Decimal_Cero
			  AND LOCATE(For_CueMayor, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA Pol, SUBCTACLASIFCART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta,
										For_Clasifica,
										CASE WHEN Pol.Clasificacion = Cla_Comercial THEN Sub.Comercial
											 WHEN Pol.Clasificacion = Cla_Consumo THEN Sub.Consumo
											 ELSE Sub.Vivienda
										END)
		WHERE  (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND LOCATE(For_Clasifica, CuentaCompleta) > Entero_Cero;
		UPDATE TMPDETPOLIZA Pol, SUBCTASUBCLACART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_SubClasif, Sub.SubCuenta)

		WHERE  (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.SubClasificacion    = Sub.ClasificacionID
			  AND LOCATE(For_SubClasif, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA Pol, SUBCTAPRODUCCART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_TipProduc, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.ProductoCreditoID    = Sub.ProducCreditoID
			  AND LOCATE(For_TipProduc, CuentaCompleta) > Entero_Cero;


		UPDATE TMPDETPOLIZA Pol, SUBCTAMONEDACART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_Moneda, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.MonedaID    = Sub.MonedaID
			  AND LOCATE(For_Moneda, CuentaCompleta) > Entero_Cero;

		UPDATE TMPDETPOLIZA SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, '-', Cadena_Vacia);

		INSERT INTO `DETALLEPOLIZA` (
			`EmpresaID`,    `PolizaID`,             `Fecha`,    			`CentroCostoID`,    `CuentaCompleta`,
			`Instrumento`,  `MonedaID`,             `Cargos`,   			`Abonos`,           `Descripcion`,
			`Referencia`,   `ProcedimientoCont`,    `TipoInstrumentoID`,	`Usuario`,			`FechaActual`,
			`DireccionIP`,	`ProgramaID`,			`Sucursal`,             `NumTransaccion`    )
		SELECT  Par_EmpresaID,  	PolizaID,           Var_FecApl,     CentroCostoID,      CuentaCompleta,
				Instrumento,    	MonedaID,           Cargos,         Abonos,             Descripcion,
				Referencia,     	ProcedimientoCont,  Tip_InsCredito,	Aud_Usuario,    	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,	Aud_NumTransaccion
		FROM TMPDETPOLIZA;

END IF; -- Termina: if (Par_AplicaConta = Si_AplicaConta) then

TRUNCATE TMPDETPOLIZA;

END TerminaStore$$
