-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERRERESERVASOFIPOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERRERESERVASOFIPOPRO`;
DELIMITER $$

CREATE PROCEDURE `CIERRERESERVASOFIPOPRO`(
	-- SP PARA REALIZAR EPRC (ESTIMACION PREVENTIVA PARA RIESGOS CREDITICIOS) PARA SOFIPOS
	 Par_Fecha 				DATETIME,				-- Fecha fin de mes para la EPRC
	 Par_AplicaConta 		CHAR(1), 				-- Aplicacion contable: SI
	 Par_PolizaID			BIGINT(20),				-- Numero de Poliza

	 -- Parametros de auditoria
	 Par_EmpresaID 			INT(11),
	 Aud_Usuario 			INT(11),
	 Aud_FechaActual 		DATETIME,
	 Aud_DireccionIP 		VARCHAR(15),
	 Aud_ProgramaID 		VARCHAR(50),
	 Aud_Sucursal 			INT(11),
	 Aud_NumTransaccion 	BIGINT(20)
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_RegContaEPRC	CHAR(1);			-- Regsitro contable de EPRC
	DECLARE Var_DivideEPRC	 	CHAR(1);			-- Division EPRC de Capital e Interes
	DECLARE Var_EPRCIntMorato	CHAR(1);			-- EPRC de Intereses Moratorios
	DECLARE Var_TipoInstitucion CHAR(2);			-- Tipo de Institucion
	DECLARE Var_PorComercial 	DECIMAL(12,6);      -- Porcentaje Clasificacion Credito Comercial

    DECLARE	Var_PorResComercial	DECIMAL(12,6);		-- Porcentaje Clasificacion de Reestructura de Credito Comercial
	DECLARE Var_PorVivienda 	DECIMAL(12,6);		-- Porcentaje Clasificacion Credito Vivienda
	DECLARE Var_PorConsumo 		DECIMAL(12,6);		-- Porcentaje Clasificacion Credito Consumo
	DECLARE	Var_PorZonMargCon	DECIMAL(12,6);		-- Porcentaje Clasificacion Credito Consumo Zona Marginada
	DECLARE	Var_PorMicroCre		DECIMAL(12,6);		-- Porcentaje Clasificacion Comercial MicroCredito
	DECLARE	Var_PorZonMargMicro	DECIMAL(12,6);		-- Porcentaje Clasificacion Comercial MicroCredito Zona Marginada

	DECLARE Var_PorcReserva 	DECIMAL(12,4);		-- Porcentaje de Reserva

    DECLARE Var_SaldoInteres 	DECIMAL(14,2);		-- Saldo de Intereses Reservadas
	DECLARE Var_SaldoCapital 	DECIMAL(14,2);		-- Saldo de Capital Reservada
	DECLARE Var_CreditoID 		BIGINT(12);			-- Numero de Credito
	DECLARE Var_Clasifica 		CHAR(1);			-- Clasificacion de Credito: CONSUMO, COMERCIAL, VIVIENDA
	DECLARE Var_CuentaID 		BIGINT(12);			-- Numero de Cuenta

    DECLARE Var_ClienteID		BIGINT;				-- Numero de Cliente
	DECLARE Var_ResOrigen		CHAR(1);			-- Origen del Credito: REESTRUCTURA O RENOVACION
	DECLARE Var_MonCobTotal 	DECIMAL(14,2); 		-- Monto Total de las Garantias
	DECLARE Var_PorCeroDias 	DECIMAL(12,6);		-- Porcentaje de reservas para Cero dias de Atraso
	DECLARE Var_InvGarantia		DECIMAL(14,2);      -- Monto de Inversiones en Garantia

    DECLARE Var_InvGarantiaHis	DECIMAL(14,2);		-- Monto de las Inversiones en Garantias Historicas
	DECLARE Var_Esmarginada	 	CHAR(1);			-- Indica si la Localidad del Cliente es de Zona Marginada
	DECLARE Var_MonCubCapita 	DECIMAL(14,2); 		-- Monto Cubierto de Capital.
	DECLARE Var_MonCubIntere 	DECIMAL(14,2); 		-- Monto Cubierto de Interes.
	DECLARE Var_SaldoCobert 	DECIMAL(14,2); 		-- Saldo de la Cobertura

    DECLARE Var_ResCapitaCub 	DECIMAL(14,2); 		-- Reserva por el Monto de Capital Cubierto.
	DECLARE Var_ResIntereCub 	DECIMAL(14,2); 		-- Reserva por el Monto de Interes Cubierto.
	DECLARE Var_NumCreditos		INT(11);			-- Numero de Creditos
	DECLARE Var_FecApl 			DATE;				-- Fecha de aplicacion de la EPRC
	DECLARE Var_CRBalance		VARCHAR(60);		-- Nomenclatura de Balance

    DECLARE	Var_CuentaEPRC		VARCHAR(50);		-- Cuenta para realizar la EPRC
	DECLARE	Var_CenCosEPRC		VARCHAR(10);		-- Centro de Costos EPRC
	DECLARE	Var_ConcepConta		INT;				-- Conceptos Contables
	DECLARE Var_NomResult 		VARCHAR(60);	    -- Nomenclatura Estado de Resultados
	DECLARE Var_CRResul			VARCHAR(60);        -- Nomenclatura Cuenta de Resultados

    DECLARE Var_NomPtePrinci	VARCHAR(60);		-- Nomenclatura Cuenta Puente
	DECLARE Var_CRPtePrinci		VARCHAR(60);		-- Nomenclatura Cuenta de Resultados Puente
	DECLARE Var_CueMayRes 		VARCHAR(15);        -- Cuenta Mayor EPRC, Resultados
	DECLARE Var_CueMayPtePri	VARCHAR(25);		-- Cuenta Mayor EPRC Cuenta de Resultados Puente
	DECLARE Var_NomBalance 		VARCHAR(60);        -- Nomenclatura Balance

    DECLARE Var_CueMayBal 		VARCHAR(25);		-- Cuenta Mayor EPRC, Balance
	DECLARE Var_EsHabil 		CHAR(1);			-- Dia habil Fecha Actual
	DECLARE Var_CRBalIntere		VARCHAR(60);		-- Nomenclatura Cuenta de Balance
	DECLARE Var_NomBalIntere	VARCHAR(60);		-- Nomenclatura Balance EPRC Int.Ord y Moratorio
	DECLARE Var_CueMayBalInt	VARCHAR(25);        -- Cuenta Mayor Balance Int.Ord y Moratorio

    DECLARE Var_NomResIntere	VARCHAR(60);        -- Nomenclatura Resultados EPRC Int.Ord y Moratorio
	DECLARE Var_CueMayResInt	VARCHAR(25);        -- Cuenta Contable Mayor Resultados EPRC Int.Ord y Moratorio
	DECLARE Var_CRResIntere		VARCHAR(60);		-- EPRC Cta. Puente de Int.Normal y Moratorio
	DECLARE Var_NomPteIntere	VARCHAR(60);        -- Nomenclatura Cta. Puente de Int.Normal y Moratorio
	DECLARE Var_CRPteIntere		VARCHAR(60);		-- Resultados EPRC Int.Ord y Moratorio

    DECLARE Var_CueMayPteInt	VARCHAR(25);		-- Cuenta Contable Mayor Puente EPRC Int.Ord y Moratorio
	DECLARE Var_FecAntRes 		DATE;				-- Fecha de la ultima reserva
    DECLARE Var_NumRegCal       INT;				-- Numero de registros para el calculo de las estimaciones
	DECLARE Var_MontoBaseEstCub	DECIMAL(14,2);		-- Monto base de la estimacion de la parte cubierta
    DECLARE Var_MontoBaseEstExp	DECIMAL(14,2);		-- Monto base de la estimacion de la parte expuesta
	DECLARE Var_MicroCredito	INT;
	DECLARE Var_SubClasifID		INT;
    DECLARE Var_Reacreditamiento	CHAR(1);		-- Indica si se permite el Reacreditamiento
    DECLARE Var_Reacredita		CHAR(1);		-- Indica si el credito es reacreditado

	-- Declaracion de Constantes
	DECLARE Decimal_Cien 		DECIMAL(12,2);
	DECLARE String_Cero     	CHAR(1);
	DECLARE Decimal_Cero 		DECIMAL(12,2);
	DECLARE MetParametrico 		CHAR(1);
	DECLARE TipoExpuesta 		CHAR(1);
	DECLARE Cadena_Vacia 		CHAR(1);

	DECLARE Fecha_Vacia 		DATE;
	DECLARE Entero_Cero 		INT;
	DECLARE Esta_Desembolso		CHAR(1);
	DECLARE Estatus_Vencida 	CHAR(1);

	DECLARE SI_ReservaMora		CHAR(1);
	DECLARE NOPagaIVA 			CHAR(1);
	DECLARE EPRC_Resultados		CHAR(1);
	DECLARE NO_DivideEPRC		CHAR(1);
	DECLARE NO_ReservaMora		CHAR(1);

	DECLARE Estatus_Pagado 		CHAR(1);
	DECLARE Esta_Activa 		CHAR(1);
	DECLARE Cla_Comercial 		CHAR(1);
	DECLARE Cla_Consumo 		CHAR(1);
	DECLARE Cla_Vivienda 		CHAR(1);
	DECLARE Cla_MicroCredito	CHAR(1);

	DECLARE Expuesto 			CHAR(1);
	DECLARE EsOficial 			CHAR(1);
	DECLARE MarginadaSi 		CHAR(1);
	DECLARE MarginadaNo 		CHAR(1);
	DECLARE NatBloqueo			CHAR(1);

	DECLARE BloqueoGarLiq		INT;
	DECLARE Gar_Liquida 		INT;
	DECLARE Clas_DepInstit 		INT;
	DECLARE Pro_CierreGeneral	VARCHAR(20);
	DECLARE Si_AplicaConta 		CHAR(1);

	DECLARE Pol_Automatica 		CHAR(1);
	DECLARE Con_GenReserva 		INT;
	DECLARE Ref_GenReserva 		VARCHAR(50);
	DECLARE Par_SalidaNO 		CHAR(1);
	DECLARE Con_Resultados 		INT;

	DECLARE Con_PtePrinci		INT;
	DECLARE Cec_SucOrigen 		VARCHAR(10);
	DECLARE Cec_SucCliente		VARCHAR(10);
	DECLARE Con_Balance 		INT;
	DECLARE Procedimiento 		VARCHAR(20);

	DECLARE Con_BalIntere		INT;
	DECLARE Con_ResIntere 		INT;
	DECLARE Con_PteIntere 		INT;
	DECLARE For_CueMayor 		CHAR(3);
	DECLARE For_Clasifica 		CHAR(3);

	DECLARE	For_SubClasif		CHAR(3);
	DECLARE For_TipProduc 		CHAR(3);
	DECLARE For_Moneda 			CHAR(3);
    DECLARE Ref_CanReserva  	VARCHAR(50);
	DECLARE Tip_InsCredito		INT;

	DECLARE Var_SaldoGarHipo	DECIMAL(12,2);
    DECLARE Var_EsFiscal		CHAR(1);
    DECLARE Cons_NO				CHAR(1);
    DECLARE Cons_SI				CHAR(1);
    DECLARE CreRenovacion		CHAR(1);
	DECLARE TipCre_Nuevo		CHAR(1);
	DECLARE TipCre_Reestructura	CHAR(1);
    DECLARE Var_Contador		INT(11);
    DECLARE Var_NumRegistros	INT(11);


	-- Asignacion de Constantes
	SET Decimal_Cien 		:= 100.00; 				-- Decimal cien
	SET Decimal_Cero 		:= 0.00; 				-- Decimal cero
	SET String_Cero     	:= '0';         		-- String cero

	SET MetParametrico 		:= 'P'; 				-- Metodologia de calificacion: Parametrico o Experiencia Pago
	SET TipoExpuesta 		:= 'E'; 				-- Tipo de calificacion: Expuesta
	SET Cadena_Vacia 		:= ''; 					-- Cadena Vacia

	SET Fecha_Vacia 		:= '1900-01-01'; 		-- Fecha vacia
	SET Entero_Cero 		:= 0; 					-- Entero cero
	SET Esta_Desembolso		:= 'D';					-- Estatus Credito Reestructurado : DESEMBOLSADO
	SET Estatus_Vencida 	:= 'B'; 				-- Estatus del Credito: Vencido

	SET SI_ReservaMora		:= 'S';					-- Si realiza Reserva de Moratorios
	SET NOPagaIVA 			:= 'N'; 				-- Paga IVA: No
	SET EPRC_Resultados		:= 'R';					-- Estimacion en Cuentas de Resultados
	SET NO_DivideEPRC		:= 'N';					-- NO Divide en la EPRC en Principal(Capital) e Interes
	SET NO_ReservaMora		:= 'N';					-- No realiza Reserva de Moratorios

	SET Estatus_Pagado 		:= 'P'; 				-- Estatus del Credito: Pagado
	SET Esta_Activa 		:= 'A'; 				-- Estatus del porcentaje de reserva: Activo
	SET Cla_Comercial 		:= 'C';					-- Tipo de Cartera: Comercial
	SET Cla_Consumo 		:= 'O'; 				-- Tipo de Cartera: Consumo
	SET Cla_Vivienda 		:= 'H'; 				-- Tipo de Cartera: Hipotecario o vivienda
	SET Cla_MicroCredito	:= 'M';         		-- Tipo de Cartera: MICROCREDITO

	SET Expuesto			:= 'E';					-- Tipo rango: parte expuesta.
	SET EsOficial 			:= 'S';					-- Es Direccion Oficial: SI
	SET MarginadaSi 		:= 'S';					-- Localidad marginada: SI
	SET MarginadaNo 		:= 'N';					-- Localidad marginada: NO
	SET NatBloqueo			:= 'B';					-- Naturaleza: Bloqueo

	SET BloqueoGarLiq		:= 8; 					-- Tipo de bloqueo 8: Garantia Liquida
	SET Gar_Liquida 		:= 1; 					-- Tipo de Garantia Liquida
	SET Clas_DepInstit 		:= 1; 					-- Clasificacion de la Garantia: Depositos en la Institucion
	SET Pro_CierreGeneral 	:= 'CIERREGENERALPRO';		-- Proceso CIERREGENERALPRO
	SET Si_AplicaConta 		:= 'S'; 				-- Aplica Asientos Contables: SI

	SET Pol_Automatica 		:= 'A'; 				-- Generacion Poliza Automatica: SI
	SET Con_GenReserva 		:= 56; 					-- Concepto: Generacion de Reservas
	SET Ref_GenReserva 		:= 'GENERACION DE RESERVAS'; -- Referencia Generacion de Reservas
	SET Par_SalidaNO 		:= 'N'; 				-- Indica Salida:NO
	SET Con_Resultados 		:= 18; 		 			-- Concepto Contable: EPRC, Resultados

	SET Con_PtePrinci		:= 38; 					-- Concepto Contable: EPRC Cta. Puente de Principal
	SET Cec_SucOrigen 		:= '&SO'; 				-- Centro de Costos a Tomar: Sucursal Origen
	SET Cec_SucCliente		:= '&SC'; 				-- Centro de Costos a Tomar: Sucursal del Cliente
	SET Con_Balance 		:= 17; 					-- Concepto Contable: EPRC, Balance
	SET Procedimiento 		:= 'POLIZACREDITOPRO'; 	-- Procedimiento: Poliza de Credito

	SET Con_BalIntere		:= 36; 					-- Concepto Contable: Balance. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
	SET Con_ResIntere 		:= 37; 		 			-- Concepto Contable: Resultados. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
	SET Con_PteIntere 		:= 39; 		 			-- Concepto Contable: EPRC Cta. Puente de Int.Normal y Moratorio
	SET For_CueMayor 		:= '&CM'; 				-- Nomenclatura Cuenta de Mayor
	SET For_Clasifica 		:= '&CL';				-- Nomenclatura por Clasificacion

	SET For_SubClasif 		:= '&SC'; 				-- Nomenclatura por SubClasificacion
	SET For_TipProduc 		:= '&TP';				-- Nomenclatura por Tipo de Producto de Credito
	SET For_Moneda 			:= '&TM'; 				-- Nomenclatura por Tipo de Moneda o Divisa
	SET Ref_CanReserva  	:= 'ACT.RESERVAS.';    	-- Referencia: Actualizacion de Reservas
	SET	Tip_InsCredito		:= 11;					-- Tipo de Instrumento: Credito

	SET Var_EsFiscal		:= 'S';					-- Es fiscal
	SET Cons_NO				:= 'N';					-- Constante NO
	SET Cons_SI				:= 'S';					-- Constante SI
	SET CreRenovacion		:= 'O';					-- Credito Renovado
	SET TipCre_Nuevo		:= 'N';					-- Tipo de Credito Nuevo
	SET TipCre_Reestructura	:= 'R';					-- Tipo de Credito Reestructurado

	-- Se obtiene el tipo de institucion
	SET Var_TipoInstitucion := (SELECT TipoInstitucion FROM PARAMSCALIFICA);

	TRUNCATE TABLE TMPESTIMACREDPREV;
	select convert(ifnull(ValorParametro, String_Cero), unsigned) into Var_MicroCredito
		from PARAMGENERALES
		where LlaveParametro = 'ClasifMicrocredito';

	SELECT IFNULL(ValorParametro, Cons_NO) INTO Var_Reacreditamiento
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'Reacreditamiento';

	SET Var_MicroCredito 		:= IFNULL(Var_MicroCredito, Entero_Cero);
    SET Var_Reacreditamiento	:= IFNULL(Var_Reacreditamiento, Cons_NO);

	-- Se obtiene la parametrizacion de reservas
	SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCIntMorato INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCIntMorato
		FROM PARAMSRESERVCASTIG
		WHERE EmpresaID = Par_EmpresaID;

	SET	Var_RegContaEPRC 		:= IFNULL(Var_RegContaEPRC, EPRC_Resultados);
	SET	Var_DivideEPRC			:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
	SET	Var_EPRCIntMorato		:= IFNULL(Var_EPRCIntMorato, NO_ReservaMora);

	-- Se obtiene el numero de creditos para el registro de la poliza
	SET Var_NumCreditos := (SELECT COUNT(CreditoID) AS CreditoID FROM CREDITOS);
	SET Var_NumCreditos := IFNULL(Var_NumCreditos, Entero_Cero);

	-- Se elimina registros de la tabla TMPDETPOLIZA
	TRUNCATE TMPDETPOLIZA;

	-- Se obtiene la ultima fecha para la cancelacion contable de la reserva anterior
	SET Var_FecAntRes	:= (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE AplicaConta = Si_AplicaConta);
	SET Var_FecAntRes	:= IFNULL(Var_FecAntRes, Fecha_Vacia);

	-- Se obtiene la fecha siguiente
	CALL DIASFESTIVOSCAL(
		Par_Fecha, 		Entero_Cero, 		Var_FecApl, 		Var_EsHabil, 		Par_EmpresaID,
		Aud_Usuario, 	Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID, 	Aud_Sucursal,
		Aud_NumTransaccion);

	 -- Si el ultimo dia del mes es domingo se realiza la estimacion y con esa misma fecha debe registrar la poliza
	 IF(Var_FecApl > Par_Fecha)THEN
			SET Var_FecApl = LAST_DAY(Par_Fecha);
		END IF;

	-- Se obtiene el numero de creditos para realizar las estimaciones para la afectacion contable
	SET Var_NumRegCal := (SELECT COUNT(CreditoID) FROM CALRESCREDITOS WHERE Fecha = Par_Fecha AND AplicaConta = Si_AplicaConta);
	SET Var_NumRegCal := IFNULL(Var_NumRegCal, Entero_Cero);

	-- Se compara que el numero de creditos a realizar las estimaciones sea mayor a cero
	IF(Var_NumRegCal > Entero_Cero) THEN
		-- Aplica Asientos Contables: SI
		SET Par_AplicaConta = Si_AplicaConta;
	END IF;

	-- Seleccion de Cuentas de Mayor y Nomenclatura de Centro de Costos
	SELECT Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomBalance, Var_CueMayBal, Var_CRBalance
		FROM CUENTASMAYORCAR
		WHERE ConceptoCarID = Con_Balance;

	SELECT Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomResult, Var_CueMayRes, Var_CRResul
		FROM CUENTASMAYORCAR
		WHERE ConceptoCarID = Con_Resultados;

	SELECT Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomPtePrinci, Var_CueMayPtePri, Var_CRPtePrinci
		FROM CUENTASMAYORCAR
		WHERE ConceptoCarID = Con_PtePrinci;

	SELECT Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomBalIntere, Var_CueMayBalInt, Var_CRBalIntere
		FROM CUENTASMAYORCAR
		WHERE ConceptoCarID = Con_BalIntere;

	SELECT Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomResIntere, Var_CueMayResInt, Var_CRResIntere
		FROM CUENTASMAYORCAR
		WHERE ConceptoCarID = Con_ResIntere;

	SELECT Nomenclatura, Cuenta, NomenclaturaCR INTO Var_NomPteIntere, Var_CueMayPteInt, Var_CRPteIntere
		FROM CUENTASMAYORCAR
		WHERE ConceptoCarID = Con_PteIntere;

	SET Var_NomBalance	:= IFNULL(Var_NomBalance, Cadena_Vacia);
	SET Var_NomResult   := IFNULL(Var_NomResult, Cadena_Vacia);
	SET Var_CueMayBal   := IFNULL(Var_CueMayBal, Cadena_Vacia);
	SET Var_CueMayRes   := IFNULL(Var_CueMayRes, Cadena_Vacia);
	SET	Var_CRBalance	:= IFNULL(Var_CRBalance, Cadena_Vacia);

    SET	Var_CRResul			:= IFNULL(Var_CRResul, Cadena_Vacia);
	SET Var_NomBalIntere   	:= IFNULL(Var_NomBalIntere, Cadena_Vacia);
	SET Var_CueMayBalInt	:= IFNULL(Var_CueMayBalInt, Cadena_Vacia);
	SET	Var_CRBalIntere		:= IFNULL(Var_CRBalIntere, Cadena_Vacia);
	SET Var_NomResIntere   	:= IFNULL(Var_NomResIntere, Cadena_Vacia);

    SET Var_CueMayResInt   	:= IFNULL(Var_CueMayResInt, Cadena_Vacia);
	SET	Var_CRResIntere		:= IFNULL(Var_CRResIntere, Cadena_Vacia);
	SET Var_NomPtePrinci   	:= IFNULL(Var_NomPtePrinci, Cadena_Vacia);
	SET Var_CueMayPtePri   	:= IFNULL(Var_CueMayPtePri, Cadena_Vacia);
	SET	Var_CRPtePrinci		:= IFNULL(Var_CRPtePrinci, Cadena_Vacia);

	SET Var_NomPteIntere   	:= IFNULL(Var_NomPteIntere, Cadena_Vacia);
	SET Var_CueMayPteInt   	:= IFNULL(Var_CueMayPteInt, Cadena_Vacia);
	SET	Var_CRPteIntere		:= IFNULL(Var_CRPteIntere, Cadena_Vacia);


	-- =========================== CANCELACION CONTABLE DE LA GENERACION DE RESERVA ANTERIOR ==============================
	IF (Var_FecAntRes != Fecha_Vacia AND Par_AplicaConta = Si_AplicaConta) THEN
		SET Ref_CanReserva  := CONCAT(Ref_CanReserva, CONVERT(DATE(Var_FecAntRes), CHAR));

		IF(Par_PolizaID = Entero_Cero) THEN
			-- Se verifca que el numero de creditos sea mayor a cero para generar la poliza
			IF (Var_NumCreditos > Entero_Cero)THEN

				CALL MAESTROPOLIZAALT(
					Par_PolizaID,     	Par_EmpresaID,  	Var_FecApl,     	Pol_Automatica,     Con_GenReserva,
					Ref_GenReserva, 	Par_SalidaNO,   	Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

			END IF;
		END IF;

		-- Verifica si Divide la Reserva en Interes y Capital
		IF(Var_DivideEPRC = NO_DivideEPRC) THEN
				-- Registro Contable en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,          	`Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,			`MonedaID`,           	`Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,			`ProcedimientoCont`,  	`CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,		`SubClasificacion`)
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
					  AND Cre.DestinoCreID = Des.DestinoCreID;

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
					`PolizaID`,           	`Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      	`MonedaID`,           	`Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       	`ProcedimientoCont`,  	`CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,		`SubClasificacion`)
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
					  AND Cre.DestinoCreID = Des.DestinoCreID;


			ELSE -- Si divide la Reserva en Interes y Capital

				-- Reserva de Capital en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           	`Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      	`MonedaID`,          	`Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       	`ProcedimientoCont`,  	`CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,		`SubClasificacion`)
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
					  AND Cre.DestinoCreID = Des.DestinoCreID;

				-- Reserva de Interes en Balance
				INSERT INTO `TMPDETPOLIZA` (
					`PolizaID`,           	`Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      	`MonedaID`,           	`Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       	`ProcedimientoCont`,  	`CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,		`SubClasificacion`)
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
					  AND Cre.DestinoCreID = Des.DestinoCreID;


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
					`PolizaID`,           	`Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,     	 	`MonedaID`,           	`Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       	`ProcedimientoCont`,  	`CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,		`SubClasificacion`)
				SELECT  Par_PolizaID,     Var_FecApl,
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
					  AND Cre.DestinoCreID = Des.DestinoCreID;

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
					`PolizaID`,           	`Fecha`,        `CentroCostoID`,    `CuentaCompleta`,
					`Instrumento`,      	`MonedaID`,           	`Cargos`,       `Abonos`,           `Descripcion`,
					`Referencia`,       	`ProcedimientoCont`,  	`CreditoID`,    `Clasificacion`,    `ProductoCreditoID`,
					`ConceptoContable`,		`SubClasificacion`)
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
					  AND Cre.DestinoCreID = Des.DestinoCreID;

			END IF; -- Termina if(Var_DivideEPRC = NO_DivideEPRC) then


		-- Creacion de las Cuentas Contables apartir de su nomenclatura y parametrizacion
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

		-- Actualizacion de la Cuenta por clasificacion (CONSUMO,COMERCIAL,VIVIENDA)
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

		-- Actualizacion de la Cuenta por SubClasificacion de Cartera
		UPDATE TMPDETPOLIZA Pol, SUBCTASUBCLACART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_SubClasif, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.SubClasificacion = Sub.ClasificacionID
			  AND LOCATE(For_SubClasif, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta por Producto de Credito
		UPDATE TMPDETPOLIZA Pol, SUBCTAPRODUCCART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_TipProduc, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID = Pol.ConceptoContable
			  AND Pol.ProductoCreditoID = Sub.ProducCreditoID
			  AND LOCATE(For_TipProduc, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta por Tipo de Moneda
		UPDATE TMPDETPOLIZA Pol, SUBCTAMONEDACART Sub SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, For_Moneda, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				   IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			  AND Sub.ConceptoCarID  = Pol.ConceptoContable
			  AND Pol.MonedaID = Sub.MonedaID
			  AND LOCATE(For_Moneda, CuentaCompleta) > Entero_Cero;


		UPDATE TMPDETPOLIZA SET
			CuentaCompleta  =   REPLACE(CuentaCompleta, '-', Cadena_Vacia);

        -- Registros de las reservas en la tabla DETALLEPOLIZA
		INSERT INTO `DETALLEPOLIZA` (
				`EmpresaID`,   		`PolizaID`,             `Fecha`,    			`CentroCostoID`,    `CuentaCompleta`,
				`Instrumento`,  	`MonedaID`,             `Cargos`,   			`Abonos`,           `Descripcion`,
				`Referencia`,   	`ProcedimientoCont`,    `TipoInstrumentoID`,	`Usuario`,			`FechaActual`,
				`DireccionIP`,		`ProgramaID`,   		`Sucursal`,				`NumTransaccion`)
		SELECT  Par_EmpresaID,  	PolizaID,           	Var_FecApl,     		CentroCostoID,		CuentaCompleta,
				Instrumento,    	MonedaID,           	Cargos,         		Abonos,				Descripcion,
				Referencia,     	ProcedimientoCont,  	Tip_InsCredito,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,       	Aud_NumTransaccion
		FROM TMPDETPOLIZA;

		TRUNCATE TMPDETPOLIZA;

	END IF; -- Termina: IF (Var_FecAntRes != Fecha_Vacia and Par_AplicaConta = Si_AplicaConta) THEN


	-- Borramos el Registro de la Reserva
	DELETE FROM CALRESCREDITOS WHERE Fecha = Par_Fecha;
	DELETE FROM GARANTIARESERVA WHERE Fecha = Par_Fecha;

	-- ================================== CALCULO DE LA ESTIMACION Y RESERVA ACTUAL ==========================================
	INSERT INTO `CALRESCREDITOS` (
		`Fecha`, 			`CreditoID`, 		`Capital`, 			`Interes`, 				`IVA`,
		`Total`, 			`DiasAtraso`, 		`Calificacion`, 	`PorcReservaExp`, 		`Reserva`,
		`TipoCalificacion`, `Metodologia`, 		`MonedaID`, 		`ProductoCreditoID`, 	`Clasificacion`,
		`AplicaConta`, 		`PorcReservaCub`,	`EmpresaID`, 		`Usuario`, 				`FechaActual`,
        `DireccionIP`,		`ProgramaID`, 		`Sucursal`, 		`NumTransaccion`)
	SELECT Sal.FechaCorte, Sal.CreditoID,
				(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) AS Capital, -- Estimacion de Capital
				CASE Sal.EstatusCredito
					WHEN Estatus_Vencida THEN Entero_Cero
					ELSE ROUND(Sal.SalIntProvision + Sal.SalIntOrdinario + Sal.SalIntAtrasado,2) + 	 -- Estimacion de Interes
						(CASE WHEN Var_EPRCIntMorato = SI_ReservaMora THEN ROUND(Sal.SalMoratorios, 2) 		 -- Estimacion de Moratorios
							 ELSE Decimal_Cero
						END )
				END,

				CASE Sal.EstatusCredito
					WHEN Estatus_Vencida THEN Entero_Cero
					ELSE
						CASE WHEN Cli.PagaIVA = NOPagaIVA OR Pro.CobraIVAInteres = NOPagaIVA THEN Decimal_Cero
							ELSE ROUND(
										(Sal.SalIntProvision + Sal.SalIntOrdinario + Sal.SalIntAtrasado + -- IVA de Interes
										(CASE WHEN Var_EPRCIntMorato = SI_ReservaMora THEN Sal.SalMoratorios 	 -- IVA de Moratorios
											ELSE Decimal_Cero
										END )) * Suc.IVA, 2)
					END
				END,

				(
					(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi) +		-- Estimacion de Capital
					(CASE Sal.EstatusCredito
						WHEN Estatus_Vencida THEN Entero_Cero
						ELSE
							ROUND(Sal.SalIntProvision + Sal.SalIntOrdinario + Sal.SalIntAtrasado,2) + 			-- Estimacion de Interes
								(CASE WHEN Var_EPRCIntMorato = SI_ReservaMora THEN ROUND(Sal.SalMoratorios, 2) 	-- Estimacion de Moratorios
									 ELSE Decimal_Cero
								 END)
					 END
					)
				) AS Total,
				 Sal.DiasAtraso, 	Sal.Calificacion,	Sal.PorcReserva/Decimal_Cien, 	Decimal_Cero, 			TipoExpuesta,
				 MetParametrico, 	Sal.MonedaID,		Pro.ProducCreditoID, 		 	Des.Clasificacion, 		Par_AplicaConta,
                 Decimal_Cero,		Par_EmpresaID,		Aud_Usuario, 					Aud_FechaActual, 		Aud_DireccionIP,
                 Aud_ProgramaID,	Aud_Sucursal, 		Aud_NumTransaccion

	FROM CLIENTES Cli,
		 SUCURSALES Suc,
		 PRODUCTOSCREDITO Pro,
		 DESTINOSCREDITO Des,
		 SALDOSCREDITOS Sal

	WHERE Sal.ProductoCreditoID = Pro.ProducCreditoID
		 AND Sal.ClienteID = Cli.ClienteID
		 AND Cli.SucursalOrigen = Suc.SucursalID
		 AND Sal.FechaCorte = Par_Fecha
		 AND Sal.DestinoCreID = Des.DestinoCreID
		 AND Sal.EstatusCredito != Estatus_Pagado;

	-- Obtenemos los Porcentajes de Reserva de Cero Dias de Atraso

	-- Porcentaje de Reserva de Cero Dias de Atraso Clasificacion: CONSUMO
	SELECT PorResCarSReest, PorResCarReest INTO Var_PorConsumo, Var_PorZonMargCon
		FROM PORCRESPERIODO
		WHERE LimInferior <= Entero_Cero
		 AND TipoInstitucion = Var_TipoInstitucion
		 AND Estatus = Esta_Activa
		 AND Clasificacion = Cla_Consumo
		 AND TipoRango = Expuesto;

	-- Porcentaje de Reserva de Cero Dias de Atraso Clasificacion: COMERCIAL
	SELECT PorResCarSReest, PorResCarReest INTO Var_PorComercial, Var_PorResComercial
		FROM PORCRESPERIODO
		WHERE LimInferior <= Entero_Cero
		 AND TipoInstitucion = Var_TipoInstitucion
		 AND Estatus = Esta_Activa
		 AND Clasificacion = Cla_Comercial
		 AND TipoRango = Expuesto;

	-- Porcentaje de Reserva de Cero Dias de Atraso Clasificacion: COMERCIAL MicroCredito
	SELECT PorResCarSReest, PorResCarReest INTO Var_PorMicroCre, Var_PorZonMargMicro
		FROM PORCRESPERIODO
		WHERE LimInferior <= Entero_Cero
		 AND TipoInstitucion = Var_TipoInstitucion
		 AND Estatus = Esta_Activa
		 AND Clasificacion = Cla_MicroCredito
		 AND TipoRango = Expuesto;

	-- Porcentaje de Reserva de Cero Dias de Atraso Clasificacion: VIVIENDA
	SELECT PorResCarSReest INTO Var_PorVivienda
		FROM PORCRESPERIODO
		WHERE LimInferior <= Entero_Cero
		 AND TipoInstitucion = Var_TipoInstitucion
		 AND Estatus = Esta_Activa
		 AND Clasificacion = Cla_Vivienda
		 AND TipoRango = Expuesto;

	SET Var_PorVivienda 	:= IFNULL(Var_PorVivienda, Entero_Cero) / Decimal_Cien;
	SET Var_PorConsumo 		:= IFNULL(Var_PorConsumo, Entero_Cero) / Decimal_Cien;
	SET Var_PorComercial 	:= IFNULL(Var_PorComercial, Entero_Cero) / Decimal_Cien;

	SET Var_PorResComercial := IFNULL(Var_PorResComercial, Entero_Cero) / Decimal_Cien;
	SET Var_PorZonMargCon 	:= IFNULL(Var_PorZonMargCon, Entero_Cero) / Decimal_Cien;

	SET Var_PorMicroCre		:= IFNULL(Var_PorMicroCre, Entero_Cero) / Decimal_Cien;
	SET Var_PorZonMargMicro	:= IFNULL(Var_PorZonMargMicro, Entero_Cero) / Decimal_Cien;


	INSERT INTO TMPESTIMACREDPREV

	SELECT  @s:=@s+1 AS Consecutivo,				Cal.CreditoID,						Cal.Capital 	AS Capital,		Cal.Interes AS Interes,						Cal.PorcReservaExp AS PorcReservaExp,
			Cal.Clasificacion	AS Clasificacion,	Cre.CuentaID 	AS CuentaID,  		Cre.ClienteID	AS ClienteID,	IFNULL(Res.Origen,Cadena_Vacia) AS Origen,	Cadena_Vacia,
			Des.SubClasifID 	AS SubClasifID,		IFNULL(Res.Reacreditado, Cons_NO),	Par_EmpresaID,					Aud_Usuario,								Aud_FechaActual,
            Aud_DireccionIP,						Aud_ProgramaID,						Aud_Sucursal,					Aud_NumTransaccion

	FROM CALRESCREDITOS Cal
		INNER JOIN CREDITOS Cre
			ON Cre.CreditoID 			= Cal.CreditoID
		INNER JOIN DESTINOSCREDITO Des
			ON Cre.DestinoCreID 		= Des.DestinoCreID
		LEFT OUTER JOIN REESTRUCCREDITO Res
			ON Res.CreditoDestinoID		= Cre.CreditoID
			AND Res.EstatusReest		= Esta_Desembolso,
			(SELECT @s:= Entero_Cero) AS S
	WHERE Cal.Fecha = Par_Fecha;

    # SE ACTUALIZAN LOS CREDITOS DE CLIENTES QUE TIENEN UNA DIRECCION FISCAL
	UPDATE TMPESTIMACREDPREV T
	INNER JOIN DIRECCLIENTE Dir
				ON Dir.ClienteID 	= T.ClienteID
				AND  Dir.Fiscal 	= Cons_SI
	INNER JOIN LOCALIDADREPUB Loc
				ON Loc.LocalidadID 	= Dir.LocalidadID
				AND Loc.EstadoID 	= Dir.EstadoID
				AND Loc.MunicipioID = Dir.MunicipioID
	SET T.EsMarginada = Loc.EsMarginada;

	# SE ACTUALIZAN LOS CREDITOS DE CLIENTES QUE SOLO TIENEN DIRECCION OFICIAL
	UPDATE TMPESTIMACREDPREV T
    INNER JOIN DIRECCLIENTE Dir
				ON Dir.ClienteID 	= T.ClienteID
				AND  Dir.Oficial 	= Cons_SI
	INNER JOIN LOCALIDADREPUB Loc
				ON Loc.LocalidadID 	= Dir.LocalidadID
				AND Loc.EstadoID 	= Dir.EstadoID
				AND Loc.MunicipioID = Dir.MunicipioID
                AND T.EsMarginada 	= Cadena_Vacia
                SET T.EsMarginada 	= Loc.EsMarginada;


    SET	Var_NumRegistros	:= (SELECT COUNT(*) FROM TMPESTIMACREDPREV);
	SET	Var_Contador		:=	1;


	-- Calculo de Estimacion Preventiva de Riesgos Crediticios
	 WHILE(Var_Contador <= Var_NumRegistros) DO

		SELECT 	CreditoID,		Capital,			Interes,			PorcReservaExp,		Clasificacion,
				CuentaID,		ClienteID,			Origen,				EsMarginada,		SubClasifID,
                Reacreditado
		INTO	Var_CreditoID,	Var_SaldoCapital,	Var_SaldoInteres, 	Var_PorcReserva,	Var_Clasifica,
				Var_CuentaID,	Var_ClienteID,		Var_ResOrigen,		Var_Esmarginada,	Var_SubClasifID,
				Var_Reacredita
		FROM 	TMPESTIMACREDPREV
        WHERE Consecutivo = Var_Contador;


			-- Inicializacion
			SET Var_MonCobTotal 	:= Entero_Cero;
			SET Var_PorCeroDias 	:= Entero_Cero;
			SET	Var_InvGarantia		:= Entero_Cero;
			SET Var_InvGarantiaHis	:= Entero_Cero;
			SET Var_SaldoCapital 	:= IFNULL(Var_SaldoCapital, Entero_Cero);
			SET Var_SaldoInteres 	:= IFNULL(Var_SaldoInteres, Entero_Cero);
			SET Var_PorcReserva 	:= IFNULL(Var_PorcReserva, Entero_Cero);
			SET Var_CuentaID 		:= IFNULL(Var_CuentaID, Entero_Cero);
			SET	Var_ResOrigen 		:= IFNULL(Var_ResOrigen, Cadena_Vacia);

			-- ----------------------------------------------------------------------------------------------------------
			-- CONSUMO
			-- ----------------------------------------------------------------------------------------------------------
			-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion CONSUMO Zona no Marginada
			IF(Var_Clasifica = Cla_Consumo AND Var_Esmarginada = MarginadaNo)THEN
				IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
					SET Var_PorCeroDias := Var_PorVivienda;
				ELSE
					SET Var_PorCeroDias := Var_PorConsumo;
				END IF;
			END IF;

			-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion CONSUMO Zona Marginada
			IF(Var_Clasifica = Cla_Consumo AND Var_Esmarginada = MarginadaSi)THEN
				IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
					SET Var_PorCeroDias := Var_PorVivienda;
				ELSE
					SET Var_PorCeroDias := Var_PorZonMargCon;
				END IF;
			END IF;


            IF(Var_Reacreditamiento = Cons_NO) THEN
				-- ----------------------------------------------------------------------------------------------------------
				-- COMERCIAL
				-- ----------------------------------------------------------------------------------------------------------
				-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion COMERCIAL que no sea Reeestructura o Renovacion
				IF(Var_Clasifica = Cla_Comercial AND Var_ResOrigen IN (Cadena_Vacia, CreRenovacion) AND Var_SubClasifID != Var_MicroCredito ) THEN
					IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
						SET Var_PorCeroDias := Var_PorComercial;
					ELSE
						SET Var_PorCeroDias := Var_PorComercial;
					END IF;
				END IF;

                -- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion COMERCIAL sea Reeestructura o Renovacion
                /*
                Se ajusta el proceso de porcentaje para los creditos reestructurados y se excluyen los renovados.*/
				IF(Var_Clasifica = Cla_Comercial AND Var_ResOrigen = TipCre_Reestructura AND Var_SubClasifID != Var_MicroCredito) THEN
					IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
						SET Var_PorCeroDias := Var_PorResComercial;
					ELSE
						SET Var_PorCeroDias := Var_PorResComercial;
					END IF;
				END IF;

			ELSE
				 -- ----------------------------------------------------------------------------------------------------------
				-- COMERCIAL CON REACREDITAMIENTO
				-- ----------------------------------------------------------------------------------------------------------
				-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion COMERCIAL que no sea Reeestructura o Renovacion
				-- Si es renovacion se considera siempre y cuando el credito sea reacreditado
				IF(Var_Clasifica = Cla_Comercial AND ((Var_ResOrigen = Cadena_Vacia) OR (Var_ResOrigen = CreRenovacion AND Var_Reacredita = Cons_SI)) AND Var_SubClasifID != Var_MicroCredito) THEN
					IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
						SET Var_PorCeroDias := Var_PorComercial;
					ELSE
						SET Var_PorCeroDias := Var_PorComercial;
					END IF;
				END IF;

				-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion COMERCIAL sea Reeestructura o Renovacion
				-- Si es renovacion se considera siempre y cuando el credito no sea reacreditado
				IF(Var_Clasifica = Cla_Comercial AND Var_ResOrigen != Cadena_Vacia AND Var_SubClasifID != Var_MicroCredito AND Var_Reacredita = Cons_NO) THEN
					IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
						SET Var_PorCeroDias := Var_PorResComercial;
					ELSE
						SET Var_PorCeroDias := Var_PorResComercial;
					END IF;
				END IF;

            END IF;

			-- ----------------------------------------------------------------------------------------------------------
			-- MICROCREDITO
			-- ----------------------------------------------------------------------------------------------------------

			-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion Comercial MicroCredito Zona no Marginada
			IF(Var_Clasifica = Cla_Comercial AND Var_SubClasifID = Var_MicroCredito AND Var_Esmarginada = MarginadaNo) THEN
				IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
					SET Var_PorCeroDias := Var_PorMicroCre;
				ELSE
					SET Var_PorCeroDias := Var_PorMicroCre;
				END IF;
			END IF;

			-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion Comercial MicroCredito Zona Marginada
			IF(Var_Clasifica = Cla_Comercial AND Var_SubClasifID = Var_MicroCredito AND Var_Esmarginada = MarginadaSi) THEN
				IF EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
					SET Var_PorCeroDias := Var_PorZonMargMicro;
				ELSE
					SET Var_PorCeroDias := Var_PorZonMargMicro;
				END IF;
			END IF;

			-- ----------------------------------------------------------------------------------------------------------
			-- VIVIENDA
			-- ----------------------------------------------------------------------------------------------------------
			-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion VIVIENDA Zona no Marginada
			IF(Var_Clasifica = Cla_Vivienda AND Var_Esmarginada = MarginadaNo) THEN
				IF NOT EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
					SET Var_PorCeroDias := Var_PorConsumo;
				 ELSE
					SET Var_PorCeroDias := Var_PorVivienda;
				END IF;
			 END IF;

			-- Se actualiza el Porcentaje de Reserva de Cero Dias Clasificacion VIVIENDA Zona Marginada
			IF(Var_Clasifica = Cla_Vivienda AND Var_Esmarginada = MarginadaSi) THEN
				IF NOT EXISTS (SELECT CreditoID FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero) THEN
					SET Var_PorCeroDias := Var_PorZonMargCon;
				 ELSE
					SET Var_PorCeroDias := Var_PorVivienda;
				END IF;
			END IF;


		 -- Obtenemos el Monto de Cobertura con Cuentas de Ahorro
		 SET Var_MonCobTotal  := (SELECT SUM(CASE WHEN NatMovimiento = NatBloqueo THEN  MontoBloq ELSE MontoBloq *-1 END)
                                    FROM BLOQUEOS Blo,
                                         CUENTASAHO Cue
                                    WHERE Blo.CuentaAhoID = Cue.CuentaAhoID
									  AND DATE(FechaMov) <= Par_Fecha
                                      AND Blo.Referencia = Var_CreditoID
									  AND Cue.ClienteID = Var_ClienteID
                                      AND Blo.TiposBloqID = BloqueoGarLiq);


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
		SET Var_SaldoGarHipo	:= Decimal_Cero;

		SET Var_InvGarantia := (SELECT SUM(Gar.MontoEnGar)
									FROM CREDITOINVGAR Gar
									WHERE Gar.FechaAsignaGar <= Par_Fecha
									 AND Gar.CreditoID = Var_CreditoID);

		SET Var_InvGarantia := IFNULL(Var_InvGarantia, Decimal_Cero);

		SET Var_InvGarantiaHis := (SELECT SUM(Gar.MontoEnGar)
									FROM HISCREDITOINVGAR Gar
									WHERE Gar.Fecha > Par_Fecha
									 AND Gar.FechaAsignaGar <= Par_Fecha
									 AND Gar.ProgramaID NOT IN (Pro_CierreGeneral)
									 AND Gar.CreditoID = Var_CreditoID );

		SET	Var_InvGarantiaHis	:= IFNULL(Var_InvGarantiaHis, Decimal_Cero);

		SET Var_InvGarantia		:= (Var_InvGarantia + Var_InvGarantiaHis);

		SET	Var_InvGarantia		:= IFNULL(Var_InvGarantia, Entero_Cero);


        IF(Var_Clasifica = Cla_Comercial) THEN

			SET Var_SaldoGarHipo	:=	(SELECT SUM(MontoGarHipo) FROM CREGARPRENHIPO WHERE CreditoID = Var_CreditoID AND MontoGarHipo > Decimal_Cero);
			SET Var_SaldoGarHipo	:=	IFNULL(Var_SaldoGarHipo,Decimal_Cero) * 0.75;

        END IF;

        SET Var_MonCobTotal	:= Var_MonCobTotal + Var_InvGarantia + Var_SaldoGarHipo;
		 		-- Inicializaciones
		SET Var_SaldoCobert  := Var_MonCobTotal;
		SET Var_MonCubCapita := Entero_Cero;
		SET Var_MonCubIntere := Entero_Cero;
		SET Var_ResCapitaCub := Entero_Cero;
		SET Var_ResIntereCub := Entero_Cero;
        SET Var_MontoBaseEstCub := Decimal_Cero;
        SET Var_MontoBaseEstExp	:= Decimal_Cero;

		 -- Se verifica si el monto de las garantias cubre el Capital e interes
        IF(Var_MonCobTotal >= (Var_SaldoCapital + Var_SaldoInteres)) THEN
            SET Var_ResCapitaCub := ROUND(Var_SaldoCapital * Var_PorCeroDias, 2); -- Reserva Capital Cubierto
            SET Var_ResIntereCub := ROUND(Var_SaldoInteres * Var_PorCeroDias, 2); -- Reserva Interes Cubierto
            SET Var_MonCubCapita := Var_SaldoCapital;	-- Monto Cubierto de Capital = Saldo de Capital
            SET Var_MonCubIntere := Var_SaldoInteres;	-- Monto Cubierto de Interes = Saldo de Interes
            SET Var_SaldoCobert  := Var_SaldoCobert - ( Var_SaldoCapital + Var_SaldoInteres);
            SET Var_MontoBaseEstCub := Var_SaldoCapital+Var_SaldoInteres; # El monto base para el calculo es el Saldo del Capital mas el Saldo de Interes
            SET Var_MontoBaseEstExp := Decimal_Cero;	# Monto base para el calculo es cero.
        END IF;

        -- Si no Cubre el Total de Capital e Interes
        IF(Var_MonCobTotal > Entero_Cero AND Var_MonCobTotal < (Var_SaldoCapital + Var_SaldoInteres)) THEN

			SET Var_MontoBaseEstCub := Var_MonCobTotal;		# Monto base es el monto de la garantia
            SET Var_MontoBaseEstExp := (Var_SaldoCapital+Var_SaldoInteres)-Var_MonCobTotal; # Monto base Saldo capital + saldo interes

            -- Cobertura del Capital
            IF(Var_MonCobTotal >= Var_SaldoCapital) THEN
                SET Var_ResCapitaCub := ROUND(Var_SaldoCapital * Var_PorCeroDias,2);
                SET Var_MonCubCapita := Var_SaldoCapital;
                SET Var_SaldoCobert  := Var_SaldoCobert - Var_SaldoCapital; -- Saldo disponible
            ELSE
                SET Var_ResCapitaCub := ROUND(Var_MonCobTotal * Var_PorCeroDias,2);
                SET Var_MonCubCapita := Var_MonCobTotal;
                SET Var_SaldoCobert	 := Entero_Cero;
            END IF;
            -- Cobertura del Interes
            IF(Var_SaldoCobert > Entero_Cero) THEN
                SET Var_ResIntereCub := ROUND(Var_SaldoCobert * Var_PorCeroDias,2); -- Reserva de interes cubierto
                SET Var_MonCubIntere := Var_SaldoCobert; -- Monto cubierto de interes
                SET Var_SaldoCobert  := Entero_Cero;  -- Saldo disponible = Cero
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
            ZonaMarginada = Var_Esmarginada,
            PorcReservaCub = Var_PorCeroDias,
            MontoBaseEstCub = Var_MontoBaseEstCub,
            MontoBaseEstExp = Var_MontoBaseEstExp

           WHERE Fecha   = Par_Fecha
              AND CreditoID = Var_CreditoID;

		UPDATE CALRESCREDITOS SET
			ReservaCapital = ROUND((Reserva - ReservaInteres), 2)
             WHERE Fecha   = Par_Fecha
              AND CreditoID = Var_CreditoID;


        SET Var_Contador := Var_Contador + 1; -- Incrementa el contador

 END WHILE;
	-- Se realiza las afectaciones contables
	IF (Par_AplicaConta = Si_AplicaConta) THEN
		SET Par_PolizaID = IFNULL(Par_PolizaID, Entero_Cero);

		IF (Par_PolizaID = Entero_Cero) THEN

			IF (Var_NumCreditos > Entero_Cero)THEN

				CALL MAESTROPOLIZAALT(
					Par_PolizaID, 		Par_EmpresaID, 	Var_FecApl, 	 	Pol_Automatica, 	Con_GenReserva,
					Ref_GenReserva, 	Par_SalidaNO, 	Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP,
					Aud_ProgramaID, 	Aud_Sucursal, 	Aud_NumTransaccion);

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
				SELECT Par_PolizaID, Var_FecApl,
							CASE WHEN Var_CRBalance = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								WHEN Var_CRBalance = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalance,
							CONVERT(Cal.CreditoID, CHAR), Cal.MonedaID,		Decimal_Cero, 	Cal.Reserva,		Ref_GenReserva,
							CONVERT(Cal.CreditoID, CHAR), Procedimiento, 	Cal.CreditoID,	Cal.Clasificacion, 	Cal.ProductoCreditoID,
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
				SELECT Par_PolizaID, Var_FecApl,
							CASE WHEN Var_CenCosEPRC = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								WHEN Var_CenCosEPRC = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR), Cal.MonedaID,	Cal.Reserva, Decimal_Cero, 	Ref_GenReserva,
							CONVERT(Cal.CreditoID, CHAR), Procedimiento, Cal.CreditoID, Cal.Clasificacion, Cal.ProductoCreditoID,
							Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
					 CREDITOS Cre,
					 CLIENTES Cli,
					 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					 AND Reserva > Decimal_Cero
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
				SELECT  Par_PolizaID, Var_FecApl,
							CASE WHEN Var_CRBalance = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalance = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalance,
							CONVERT(Cal.CreditoID, CHAR), Cal.MonedaID,		Decimal_Cero, 	Cal.SaldoResCapital,
							Ref_GenReserva, CONVERT(Cal.CreditoID, CHAR), 	Procedimiento,
							Cal.CreditoID,	Cal.Clasificacion, 	Cal.ProductoCreditoID,	Con_Balance,
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
				SELECT  Par_PolizaID, Var_FecApl,
							CASE WHEN Var_CRBalIntere = Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CRBalIntere = Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_NomBalIntere,
							CONVERT(Cal.CreditoID, CHAR), Cal.MonedaID,		Decimal_Cero, 	Cal.SaldoResInteres,
							Ref_GenReserva, CONVERT(Cal.CreditoID, CHAR), 	Procedimiento,
							Cal.CreditoID, Cal.Clasificacion, 	Cal.ProductoCreditoID,	Con_BalIntere,
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
				SELECT Par_PolizaID, Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR), Cal.MonedaID, Cal.SaldoResCapital,	Decimal_Cero,
							Ref_GenReserva, CONVERT(Cal.CreditoID, CHAR), Procedimiento, Cal.CreditoID,
							Cal.Clasificacion, Cal.ProductoCreditoID,	Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
					 CREDITOS Cre,
					 CLIENTES Cli,
					 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					 AND (IFNULL(Cal.SaldoResCapital, Decimal_Cero)) > Decimal_Cero
					 AND Cal.CreditoID = Cre.CreditoID
					 AND Cre.ClienteID = Cli.ClienteID
					 AND Cre.DestinoCreID = Des.DestinoCreID;


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
				SELECT Par_PolizaID, Var_FecApl,
							CASE WHEN Var_CenCosEPRC	= Cec_SucCliente THEN FNCENTROCOSTOS(Cli.SucursalOrigen)
								 WHEN Var_CenCosEPRC	= Cec_SucOrigen THEN FNCENTROCOSTOS(Cre.SucursalID)
								 ELSE FNCENTROCOSTOS(Aud_Sucursal)
							END,
							Var_CuentaEPRC,
							CONVERT(Cal.CreditoID, CHAR), Cal.MonedaID, 	Cal.SaldoResInteres,	Decimal_Cero,
							Ref_GenReserva, CONVERT(Cal.CreditoID, CHAR), 	Procedimiento, 		Cal.CreditoID,
							Cal.Clasificacion, Cal.ProductoCreditoID,		Var_ConcepConta,	Des.SubClasifID
				FROM CALRESCREDITOS Cal,
					 CREDITOS Cre,
					 CLIENTES Cli,
					 DESTINOSCREDITO Des
				WHERE Cal.Fecha = Par_Fecha
					 AND (IFNULL(Cal.SaldoResInteres, Decimal_Cero)) > Decimal_Cero
					 AND Cal.CreditoID = Cre.CreditoID
					 AND Cre.ClienteID = Cli.ClienteID
					 AND Cre.DestinoCreID = Des.DestinoCreID;
		END IF; -- Termina: if(Var_DivideEPRC = NO_DivideEPRC) then

 		-- Creacion de las Cuentas Contables apartir de su nomenclatura y parametrizacion
		UPDATE TMPDETPOLIZA SET
			CuentaCompleta = CASE WHEN ConceptoContable = Con_Balance THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayBal)
								 WHEN ConceptoContable = Con_Resultados THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayRes)
								 WHEN ConceptoContable = Con_BalIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayBalInt)
								 WHEN ConceptoContable = Con_ResIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayResInt)
								 WHEN ConceptoContable = Con_PtePrinci THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayPtePri)
								 WHEN ConceptoContable = Con_PteIntere THEN REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayPteInt)
							END
		WHERE (IFNULL(Cargos, Decimal_Cero) +
				 IFNULL(Abonos, Decimal_Cero) ) > Decimal_Cero
			 AND LOCATE(For_CueMayor, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta Concepto Contable: EPRC, Resultados
		UPDATE TMPDETPOLIZA SET
			CuentaCompleta = REPLACE(CuentaCompleta, For_CueMayor, Var_CueMayRes)
		WHERE Var_CueMayRes != Cadena_Vacia
			 AND Abonos > Decimal_Cero
			 AND LOCATE(For_CueMayor, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta por clasificacion (CONSUMO,COMERCIAL,VIVIENDA)
		UPDATE TMPDETPOLIZA Pol, SUBCTACLASIFCART Sub SET
			CuentaCompleta = REPLACE(CuentaCompleta,
										For_Clasifica,
										CASE WHEN Pol.Clasificacion = Cla_Comercial THEN Sub.Comercial
											 WHEN Pol.Clasificacion = Cla_Consumo THEN Sub.Consumo
											 ELSE Sub.Vivienda
										END)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				 IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			 AND Sub.ConceptoCarID = Pol.ConceptoContable
			 AND LOCATE(For_Clasifica, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta por SubClasificacion de Cartera
		UPDATE TMPDETPOLIZA Pol, SUBCTASUBCLACART Sub SET
			CuentaCompleta = REPLACE(CuentaCompleta, For_SubClasif, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				 IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			 AND Sub.ConceptoCarID = Pol.ConceptoContable
			 AND Pol.SubClasificacion = Sub.ClasificacionID
			 AND LOCATE(For_SubClasif, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta por Producto de Credito
		UPDATE TMPDETPOLIZA Pol, SUBCTAPRODUCCART Sub SET
			CuentaCompleta = REPLACE(CuentaCompleta, For_TipProduc, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				 IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			 AND Sub.ConceptoCarID = Pol.ConceptoContable
			 AND Pol.ProductoCreditoID = Sub.ProducCreditoID
			 AND LOCATE(For_TipProduc, CuentaCompleta) > Entero_Cero;

		-- Actualizacion de la Cuenta por Tipo de Moneda
		UPDATE TMPDETPOLIZA Pol, SUBCTAMONEDACART Sub SET
			CuentaCompleta = REPLACE(CuentaCompleta, For_Moneda, Sub.SubCuenta)
		WHERE (IFNULL(Cargos, Entero_Cero) +
				 IFNULL(Abonos, Entero_Cero) ) > Decimal_Cero
			 AND Sub.ConceptoCarID = Pol.ConceptoContable
			 AND Pol.MonedaID = Sub.MonedaID
			 AND LOCATE(For_Moneda, CuentaCompleta) > Entero_Cero;


		UPDATE TMPDETPOLIZA SET
			CuentaCompleta = REPLACE(CuentaCompleta, '-', Cadena_Vacia);

		-- Registros de las reservas en la tabla DETALLEPOLIZA
		INSERT INTO `DETALLEPOLIZA` (
			`EmpresaID`,    	`PolizaID`,             `Fecha`,    			`CentroCostoID`,    `CuentaCompleta`,
			`Instrumento`,  	`MonedaID`,             `Cargos`,   			`Abonos`,           `Descripcion`,
			`Referencia`,   	`ProcedimientoCont`,    `TipoInstrumentoID`,	`Usuario`,			`FechaActual`,
			`DireccionIP`,		`ProgramaID`,			`Sucursal`,             `NumTransaccion`)
		SELECT Par_EmpresaID, 	PolizaID, 				Var_FecApl, 			CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 				Cargos, 				Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 		Tip_InsCredito,			Aud_Usuario, 		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion
		FROM TMPDETPOLIZA;

	END IF;-- Termina: if (Par_AplicaConta = Si_AplicaConta) then


  TRUNCATE TMPDETPOLIZA;

END TerminaStore$$
