-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREMESAHORRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREMESAHORRO`;

DELIMITER $$
CREATE PROCEDURE `CIERREMESAHORRO`(
	/* Proceso cierre de cuentas al mes*/
	Par_FechaOperacion	DATE,				--  Fecha de La operacion
	Par_FechaAplicacion	DATE,  				--  Fecha de Aplicacion
	/*Parametros de Auditoria*/
	Par_EmpresaID		INT,				--  ID de la Empresa
	Aud_Usuario			INT,				--  ID del Usuario
	Aud_FechaActual		DATETIME,			--  Fecha Actual

	Aud_DireccionIP		VARCHAR(15),		--  Direccion IP
	Aud_ProgramaID		VARCHAR(50),		--  Programa ID
	Aud_Sucursal		INT,				--  Sucursal ID
	Aud_NumTransaccion	BIGINT				--  Numero de Transaccion
)
TerminaStore: BEGIN

    /* DECLARACION DE VARIABLES */
	DECLARE	Var_GeneraInt		INT;				-- si genera intereses la cuenta
	DECLARE	Var_EsServic		INT;				--
	DECLARE	Var_EsBanca			INT;				-- el tipo de interes que tiene
	DECLARE	Var_TipoInt			INT;				-- el valor que cobra comicion por apertura
	DECLARE	Var_ComAper			DECIMAL (12,2);		-- el iva de la comision por apertura
	DECLARE	Var_IvaComAper		DECIMAL (12,2);		-- anio del ejecicio
	DECLARE	Var_AnioActual		INT;				-- mes del ejercicio
	DECLARE	Var_MesActual		INT;				-- no se usa
	DECLARE	Var_ComMaCu			DECIMAL (12,2);		-- nose usa
	DECLARE	Var_IvaComMaCu		DECIMAL (12,2);		-- no se usa
	DECLARE	Var_ComAniv			DECIMAL (12,2);		--
	DECLARE	Var_IvaComAniv		DECIMAL (12,2);		-- iva sobre comiciones
	DECLARE	Var_CobraBE			DECIMAL (12,2);		--
	DECLARE	Var_CobraSPEI		DECIMAL (12,2);		-- si cobra espei
	DECLARE	Var_ComFalCob		DECIMAL (12,2);		-- comision por falta de pago
	DECLARE	Var_IvaComFalCo		DECIMAL (12,2);		-- iva sobre comison falta de pago
	DECLARE	Var_ExDispSeg		DECIMAL (12,2);		-- exigible
	DECLARE	Var_ComDispSeg		DECIMAL (12,2);		-- comision
	DECLARE	Var_IvaComDiSe		DECIMAL (12,2);		-- iva
	DECLARE Var_MovComAper		VARCHAR(4);			-- Concepto de movimientos
	DECLARE Var_MovComAniv		VARCHAR(4);			-- Concepto de movimientos
	DECLARE Var_MovComDisS		VARCHAR(4);			-- Concepto de movimientos
	DECLARE Var_MovComManC		VARCHAR(4);			-- Concepto de movimientos
	DECLARE Var_MovComFalC		VARCHAR(4);			-- Concepto de movimientos
	DECLARE Var_MovRendGra		VARCHAR(45);		-- Concepto de Pago de Rendimiento Cta.Gravado
	DECLARE Var_MovRendExc		VARCHAR(45);		-- Concepto de Pago de Rendimiento Cta.Excento
	DECLARE Var_MovRetISR		VARCHAR(45); 		-- Concepto de Retencion ISR Cta
	DECLARE	Var_MinutosBit 		INT;				-- minutos sobre fecha y hora
	DECLARE	Var_FecBitaco 		DATETIME;			-- fecha para la bitacora
	DECLARE	Var_Empresa			INT;				-- empresa del proceso
	DECLARE Var_SalMinDF		DECIMAL(12,2);	-- Salario minimo segun el df
	DECLARE Var_SalMinAn		DECIMAL(12,2);	-- Salario minimo anualizado segun el df
	DECLARE Var_GeneraEdoAuto	CHAR(1);
	DECLARE GeneracionSI		CHAR(1);
	DECLARE Var_FechaProceso  	VARCHAR(10);
	DECLARE Var_GeneraEdoAutoeneracionSI	CHAR(1);
	DECLARE Par_NumErr			INT(11);
	DECLARE Par_ErrMen			VARCHAR(350);
	DECLARE Cancelado			CHAR(1);
	DECLARE CancelaMenor		INT(11);
	DECLARE Var_ISR_pSocio		CHAR(1);
	DECLARE ISRpSocio			VARCHAR(10);
    DECLARE Var_ContadorCta		INT(11);
	DECLARE Var_ValorUMA		DECIMAL(12,4);
    DECLARE Var_ClienteEsp		INT(11);
	DECLARE Var_MovComSalProm	VARCHAR(5);		-- Concepto de Movimientos Comision de Saldo Promedio

    /* DECLARACION DE CONSTANTES */
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE Entero_Dos			INT;
	DECLARE Entero_Cinco		INT;
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Entero_Cien			INT;
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	EstatusBloq			CHAR(1);
	DECLARE	EstatusActi			CHAR(1);
	DECLARE	EstatusCan  		CHAR(1);
	DECLARE	Var_Si				CHAR(1);
	DECLARE	Var_No				CHAR(1);
	DECLARE	Var_Diario			CHAR(1);
	DECLARE	Var_Mes				CHAR(1);
	DECLARE	Pro_CieMesCta		INT;
	DECLARE	Pro_MovCtaAlt		INT;
	DECLARE	Pro_CtaAhoMod		INT;
	DECLARE	Pro_HisCuenAh		INT;
	DECLARE	Pro_HisMovCta		INT;
	DECLARE	Pro_SaldoProm		INT;
	DECLARE	Pro_Profun			INT;
	DECLARE Var_CancelaAut		CHAR(1);
	DECLARE Var_FecActual 		DATETIME;
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Pol_Automatica		CHAR(1);
	DECLARE	VarConcepConta		INT;
	DECLARE	DesConcepConta		VARCHAR(150);
	DECLARE	Procedimiento		VARCHAR(20);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE DiasMes				INT;
	DECLARE Fre_DiasAnio		INT;
	DECLARE Par_Poliza			BIGINT;
	DECLARE var_NumMovs			INT;
 	DECLARE No_constante		VARCHAR(10);
	DECLARE GeneraInteresSi		CHAR(1);
	DECLARE EnteroUno			INT(11);
	DECLARE	ProcesoCierre		CHAR(1);
	DECLARE	InstAhorro			INT(11);
    DECLARE	Est_NoAplicado		CHAR(1);
    DECLARE	Est_Aplicado		CHAR(1);
    DECLARE EstatusFactP		CHAR(1);
	DECLARE ValorUMA			VARCHAR(15);
    DECLARE ClienteSofi			INT(11);
    DECLARE CliEspecifico		VARCHAR(20);
    DECLARE UltimoDiaMes		DATE;
    DECLARE RendimientoCta		INT(11);		-- Tipo: Rendimiento de la Cuenta
    DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_InvVigente		CHAR(1);

	/*Asignacion de Constantes */
	SET Par_ErrMen 		:= '';		-- valor iniciar para el parametro de Mensaje de error
	SET Aud_ProgramaID  := 'CIERREMESAHORRO';-- valor que se utilizara para guardar registro de auditoria
	SET	Cadena_Vacia	:= '';	-- valor vacio
	SET	Fecha_Vacia		:= '1900-01-01';-- fecha inicial cuando no se tiene una fecha para ocupar
	SET	Entero_Cero		:= 0;	-- valor cero para settear a otras variables
	SET Entero_Dos		:= 2;	-- valor dos para settear a otras variables
	SET Entero_Cinco	:= 5;	-- valor cinco para settear a otras variables
	SET	Decimal_Cero	:= 0.0; -- valor cero con decimales para settear a otras variables
	SET Entero_Cien		:= 100; -- valor cien para settear a otras variables
	SET	Var_Diario		:= 'D';	-- variable para saber si es un dia
	SET	Var_Mes			:= 'M';	-- variable para saber si es un mes
	SET	Var_Si			:= 'S'; -- variable con valor S para comparar
	SET	Var_No			:= 'N'; -- variable con valor N para comparar
	SET	EstatusBloq		:= 'B'; -- Estatus Bloqueado
	SET	EstatusActi		:= 'A'; -- Estatus Activo
	SET	EstatusCan		:= 'C'; -- Estatus Cancelado
	SET	Pro_CieMesCta 	:= 400; -- Proceso Batch de cierre de mes de ahorro
	SET	Pro_MovCtaAlt	:= 401; -- Proceso Batch alta de movimientos de cierre mensual
	SET	Pro_CtaAhoMod	:= 402; -- Proceso Batch actualizar saldo en cuentas de ahorro
	SET	Pro_HisCuenAh	:= 403; -- Proceso Batch para historial de Cuenta Ahorro
	SET	Pro_HisMovCta	:= 404; -- Proceso Batch para historial de movimientos de Cuenta
	SET	Pro_SaldoProm	:= 405; -- Proceso Batch para calculo de saldo promedio
	SET	Pro_Profun		:= 408; -- Proceso Batch para programa profun
	SET CancelaMenor	:= 904;	-- Proceso Batch para cancelacion de cliente por mayoria de edad
	SET ISRpSocio		:= 'ISR_pSocio';-- constante para isr por socio de PARAMGENERALES
    SET No_constante	:= 'N';					-- constante NO

	SET	Salida_NO		:= 'N';	-- Salida en pantalla NO
	SET	Pol_Automatica	:= 'A';	-- Automatica
	SET	Nat_Cargo		:= 'C';	-- Naturaleza Cargo
	SET	Nat_Abono		:= 'A';	-- Naturaleza Abono

	SET	VarConcepConta	:= 200; -- Concepto Contable
	SET	DesConcepConta	:= (SELECT Descripcion FROM CONCEPTOSCONTA WHERE ConceptoContaID = VarConcepConta);
	SET	Procedimiento	:= 'CIERREMESAHORRO';-- valor que se utilizara para guardar registro  del proceso


	-- Asignacion de Variables
	SET	Var_AnioActual 	:= (SELECT (YEAR(Par_FechaOperacion)));
	SET	Var_MesActual 	:= (SELECT (MONTH(Par_FechaOperacion)));

	SET	Var_MovComAper	:= '206'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Comision Apertura
	SET	Var_MovComAniv	:= '208'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Comision Aniversario
	SET	Var_MovComDisS	:= '214'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Comision Disp. Seguridad
	SET	Var_MovComManC	:= '202'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Comision manejo de Cuenta
	SET	Var_MovComFalC	:= '204'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Comision Falso Cobro
	SET	Var_MovRendGra	:= '200'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Pago de Rendimiento Cta.Gravado
	SET	Var_MovRendExc	:= '201'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Pago de Rendimiento Cta.Excento
	SET	Var_MovRetISR	:= '220'; -- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Retencion ISR Cta
	SET	Var_FecBitaco	:= NOW(); --
	SET Par_Poliza 		:= 0;     --
	SET var_NumMovs 	:= 0;	  --
	SET DiasMes			:= DAY(last_day(Par_FechaOperacion));
	SET Var_GeneraEdoAutoeneracionSI := 'S'; -- Genera Automaticamente informacion para Edo Cuenta SI
	SET GeneraInteresSi	:= 'S';	  -- Genera Interes si = 'S'.
    SET EnteroUno		:=	 1;	  -- Entero Uno
	SET ProcesoCierre	:= 'H';  -- Proceso de Tipo Cierre
    SET InstAhorro		:=   2;
	SET Est_NoAplicado	:= 'N';  -- Estatus No Aplicado
    SET Est_Aplicado	:= 'A';  -- Estatus Aplicado
    SET EstatusFactP	:= 'P';  -- Estatus Pendiente
	SET ValorUMA		:= 'ValorUMABase';
	SET ClienteSofi		:= 15;
    SET CliEspecifico	:= 'CliProcEspecifico';
    SET UltimoDiaMes	:= last_day(Par_FechaOperacion);
	SET RendimientoCta	:= 1;		-- Tipo: Rendimiento de la Cuenta
    SET	Var_MovComSalProm	:= '230'; -- Corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Comision por Saldo Promedio
	SET Est_Vigente		:= 'V';
	SET Est_Vencido		:= 'B';
	SET Est_InvVigente	:= 'N';

	 SELECT 		EmpresaDefault, DiasInversion,	SalMinDF, GeneraEdoCtaAuto,FechaSistema,CancelaAutMenor
		INTO 	Var_Empresa,	Fre_DiasAnio,	Var_SalMinDF, Var_GeneraEdoAuto,Var_FecActual,Var_CancelaAut
		FROM 	PARAMETROSSIS;
    -- optenemos el parametro para saber si se esta calculando el ISR por socio
	SELECT ValorParametro INTO Var_ISR_pSocio
		FROM PARAMGENERALES
			WHERE LlaveParametro=ISRpSocio;

    	SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;

    SELECT ValorParametro INTO Var_ClienteEsp
    FROM PARAMGENERALES
    WHERE LlaveParametro = CliEspecifico;

	SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio ,No_constante);
	SET Var_SalMinDF	:= IFNULL(Var_SalMinDF , Decimal_Cero);
	SET Fre_DiasAnio 	:= IFNULL(Fre_DiasAnio , Entero_Cero);
	SET Var_SalMinAn 	:= Var_SalMinDF * 5 * Var_ValorUMA; -- Salario minimo General Anualizado
	SET Cancelado		:="C";

	/* Se eliminan los datos de las tablas de paso */
	TRUNCATE TABLE TMPCUENTASAHOCI;
	TRUNCATE TABLE TMPCTASAHOMOV;
	TRUNCATE TABLE TMPCONTAMOVS;
	TRUNCATE TABLE TMPMOVSCTA;

	/* SE INSERTAN LOS DATOS EN UNA TABLA DE PASO
		* ESTO PARA NO AFECTAR LOS DATOS REALES SINO HASTA EL FINAL Y EL CALCULO DE INTERESES
		* SEA DE FORMA MASIVA */

	INSERT INTO TMPCUENTASAHOCI (
		CuentaAhoID,  			SucursalID,  				ClienteID,  			MonedaID, 				TipoCuentaID,
		FechaApertura,  		Saldo,						SaldoDispon,  			SaldoBloq,				SaldoSBC,
		SaldoIniMes,  			CargosMes,					AbonosMes,				Comisiones,  			SaldoProm,
		TasaInteres,			InteresesGen,				ISR,  					TasaISR,  				SaldoIniDia,
		CargosDia,  			AbonosDia,  				Estatus,				AnioAper,				MesAper,
		SaldoAnterior,			TipoPersona,				GeneraInteres,			TipoInteres,			EsServicio,
		EsBancaria,				ComManejoCta,				ComFalsoCobro,			ExPrimDispSeg,			PagaIVA,
		PagaISR,				EsConcentradora,			SucursalOrigen,
		ComApertura,
		ComAniversario,
		ComDispSeg,
		Iva,
		IvaComApertura,
		IvaComManejoCta,
		IvaComAniv,
		IvaComFalsoCob,
		IvaComDispSeg,

        PagaIDE,
        GatMesAnt,
        ClasificacionConta,
        ISRReal,
        CobraSalProm,
		ExcentaCobSaldProm,
		EmpresaID,

        Usuario,					FechaActual, 			DireccionIP, 			ProgramaID,			Sucursal,
        NumTransaccion)
	SELECT
			CA.CuentaAhoID,  		CA.SucursalID,  			CA.ClienteID,  			CA.MonedaID,				CA.TipoCuentaID,
			CA.FechaApertura,  		CA.Saldo,					CA.SaldoDispon,  		CA.SaldoBloq,				CA.SaldoSBC,
			CA.SaldoIniMes,  		CA.CargosMes,				CA.AbonosMes, 			CA.Comisiones,  			CA.SaldoProm,
			CA.TasaInteres,  		CA.InteresesGen,  			CA.ISR,					SU.TasaISR,  				CA.SaldoIniDia,
			CA.CargosDia, 			CA.AbonosDia, 				CA.Estatus,				YEAR(CA.FechaApertura), 	MONTH(CA.FechaApertura),
			CA.SaldoDispon, 		Cli.TipoPersona,			TiCta.GeneraInteres,	TiCta.TipoInteres,			TiCta.EsServicio ,
			TiCta.EsBancaria,		TiCta.ComManejoCta,			TiCta.ComFalsoCobro,	TiCta.ExPrimDispSeg,		Cli.PagaIVA,
			Cli.PagaISR,			TiCta.EsConcentradora,		Cli.SucursalOrigen,

            CASE WHEN ((YEAR(CA.FechaApertura))= Var_AnioActual && (MONTH(CA.FechaApertura))= Var_MesActual) THEN TiCta.ComApertura ELSE Entero_Cero END AS ComApertura ,
			CASE WHEN ((MONTH(CA.FechaApertura))= Var_MesActual && (YEAR(CA.FechaApertura))<> Var_AnioActual) THEN TiCta.ComAniversario ELSE Entero_Cero END AS ComAniversario ,
			CASE WHEN (TiCta.ExPrimDispSeg = Var_Si) THEN TiCta.ComDispSeg ELSE Entero_Cero END AS ComDispSeg ,
			CASE WHEN (Cli.PagaIVA = Var_Si) THEN SU.Iva ELSE Entero_Cero END AS Iva,
			CASE WHEN (Cli.PagaIVA = Var_Si) THEN CASE WHEN ((YEAR(CA.FechaApertura))= Var_AnioActual && (MONTH(CA.FechaApertura))= Var_MesActual) THEN (TiCta.ComApertura *SU.Iva) ELSE Entero_Cero END  ELSE Entero_Cero END AS IvaComApertura ,
			CASE WHEN (Cli.PagaIVA = Var_Si) THEN (TiCta.ComManejoCta*SU.Iva) ELSE Entero_Cero END AS IvaComManejoCta ,
			CASE WHEN (Cli.PagaIVA = Var_Si) THEN CASE WHEN ((MONTH(CA.FechaApertura))= Var_MesActual && (YEAR(CA.FechaApertura))<> Var_AnioActual) THEN (TiCta.ComAniversario *SU.Iva) ELSE Entero_Cero END ELSE Entero_Cero END AS IvaComAniv ,
			CASE WHEN (Cli.PagaIVA = Var_Si) THEN (TiCta.ComFalsoCobro*SU.Iva) ELSE Entero_Cero END AS IvaComFalsoCob ,
			CASE WHEN (Cli.PagaIVA = Var_Si) THEN CASE WHEN (TiCta.ExPrimDispSeg = Var_Si) THEN (TiCta.ComDispSeg*SU.Iva) ELSE Entero_Cero END ELSE Entero_Cero END AS IvaComDispSeg ,

            CASE WHEN (TiCta.EsConcentradora = Var_Si) THEN Var_No ELSE Cli.PagaIDE END AS PagaIDE ,
			Gat,
            TiCta.ClasificacionConta,
            CA.ISRReal,
            CASE WHEN (TiCta.ComisionSalProm > Decimal_Cero) THEN Var_Si ELSE Var_No END AS CobraSalProm,
			TiCta.ExentaCobroSalPromOtros AS ExcentaCobSaldProm,
			Par_EmpresaID,

			Aud_Usuario,			Aud_FechaActual, 			Aud_DireccionIP, 			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion
		FROM 	CUENTASAHO		CA,
				CLIENTES		Cli,
				TIPOSCUENTAS	TiCta,
				SUCURSALES		SU
			WHERE	(CA.Estatus 		= EstatusBloq
				OR		CA.Estatus 			= EstatusActi)
				AND 	CA.ClienteID  		= Cli.ClienteID
				AND 	CA.TipoCuentaID 	= TiCta.TipoCuentaID
				AND 	Cli.SucursalOrigen 	= SU.SucursalID;


	/* se insertan datos que calculan el saldo promedio si es que los hay -- */
	INSERT INTO TMPMOVSCTA (
		CuentaAhoID, SaldoPromedio)
		SELECT Movs.CuentaAhoID, SUM(Movs.CantidadMov)/DiasMes AS SaldoPromedio
			FROM (SELECT CuentaAhoID, Fecha, NatMovimiento, CASE WHEN (NatMovimiento = Nat_Abono)
                                                                    THEN (CantidadMov*(DATEDIFF(UltimoDiaMes,Fecha) +1))
                                                                    ELSE ((CantidadMov*(DATEDIFF(UltimoDiaMes,Fecha) +1))*-1) END AS CantidadMov
					FROM CUENTASAHOMOV
					 WHERE 	Fecha >= DATE_ADD(Par_FechaOperacion, INTERVAL -1*(DAY(Par_FechaOperacion))+1 DAY)
						AND Fecha <= last_day(Par_FechaOperacion)) AS Movs
		 GROUP BY Movs.CuentaAhoID;

	/* SE HACE EL CALCULO DEL SALDO PROMEDIO*/
	DROP TABLE IF EXISTS TMPSALDOPROMAHORRO;
	CREATE TABLE TMPSALDOPROMAHORRO (	CuentaAhoID	BIGINT,
						SaldoPromedio	DECIMAL(18,2),
						 PRIMARY KEY (CuentaAhoID)
					  );

	INSERT INTO TMPSALDOPROMAHORRO
	  SELECT CuentaAhoID, IFNULL(SaldoIniMes,0)
	  FROM TMPCUENTASAHOCI;

	UPDATE TMPSALDOPROMAHORRO Sal
		INNER JOIN TMPMOVSCTA Tmp ON Tmp.CuentaAhoID = Sal.CuentaAhoID
			SET Sal.SaldoPromedio = Sal.SaldoPromedio + IFNULL(Tmp.SaldoPromedio,0);

	UPDATE 	TMPCUENTASAHOCI TCA
		INNER JOIN TMPSALDOPROMAHORRO Movs ON TCA.CuentaAhoID= Movs.CuentaAhoID
			SET TCA.SaldoProm = Movs.SaldoPromedio;

	DROP TABLE IF EXISTS TMPSALDOPROMAHORRO;


	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(	Pro_SaldoProm, 		Par_FechaOperacion, 	Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	/**** Se hace la generacion de interes, dependiendo del tipo de cuenta del cliente, si este paga ISR  y genero
		* intereses y EL MONTO DE SALDO PROMEDIO es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
		* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL MONTO ORIGINAL,
		* si no es CERO */
	/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/

	-- ===================================================================== --
	/*Tabla Temporal para las Tasas*/
    DROP TABLE IF EXISTS TMPTASASCTAHORRO;
	CREATE TABLE TMPTASASCTAHORRO(
			CuentaAhoID 	BIGINT,
			Tasa 			DECIMAL(12,4),
			SaldoProm 		DECIMAL(18,2),
            TipoCuentaID 	INT(11),
            TipoPersona		CHAR(1),
            MonedaID		INT(11),
			PRIMARY KEY (CuentaAhoID)
	);

	/*Insertamos los Datos*/
    INSERT INTO TMPTASASCTAHORRO(
				CuentaAhoID,	Tasa,			SaldoProm,		TipoCuentaID,
                TipoPersona,	MonedaID)
		SELECT  CuentaAhoID, 	Decimal_Cero, 	SaldoProm,		TipoCuentaID,
				TipoPersona,	MonedaID
			FROM TMPCUENTASAHOCI;

	/*Actualizamos las Tasas*/
     UPDATE	TMPTASASCTAHORRO AS TC
			INNER JOIN TASASAHORRO   TA ON TA.TipoCuentaID    = TC.TipoCuentaID
					SET    TC.Tasa = TA.Tasa
				WHERE
							TA.MonedaID     = TC.MonedaID
					AND    	TA.TipoPersona   = TC.TipoPersona
					AND    	TA.MontoInferior <= TC.SaldoProm
					AND    	TA.MontoSuperior >= TC.SaldoProm ;


	UPDATE  TMPCUENTASAHOCI TCA
				INNER JOIN TMPTASASCTAHORRO  TA ON TA.CuentaAhoID    = TCA.CuentaAhoID
	   SET
	      TCA.TasaInteres   = TA.Tasa,
	      TCA.InteresesGen  = (TCA.SaldoProm*DiasMes*TA.Tasa)/(Fre_DiasAnio*Entero_Cien),
	      TCA.Gat       	= FUNCIONCALCTAGATAHO(Par_FechaOperacion,TCA.FechaApertura,TA.Tasa)
	    WHERE
			TCA.GeneraInteres = Var_Si;

	DROP TABLE IF EXISTS TMPTASASCTAHORRO;

	-- ===================================================================== --

	-- LLamada para obtener los rendimientos de las cuentas para el calculo del interes REAL
	CALL RENDIMIENTOSCTASPRO(
		Par_FechaOperacion,		RendimientoCta,
		Var_Empresa, 			Aud_Usuario, 	Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion);

     /*Actualizamos ISR a la tabla temporal*/
     -- Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna.
	UPDATE 	TMPCUENTASAHOCI TCA SET
		TCA.ISR	=	CASE WHEN Var_ISR_pSocio=Var_Si THEN
						TCA.ISRReal
					ELSE
						CASE WHEN  TCA.SaldoProm > Var_SalMinAn OR TCA.TipoPersona = 'M' THEN
							CASE WHEN TCA.TipoPersona = 'M' THEN
									ROUND((TCA.SaldoProm * DiasMes * TCA.TasaISR) / (Entero_Cien * Fre_DiasAnio), 2)
								ELSE
									ROUND(((TCA.SaldoProm-Var_SalMinAn) * DiasMes * TCA.TasaISR) / (Entero_Cien * Fre_DiasAnio), 2)
								END
						ELSE
							Decimal_Cero
						END
					END
		WHERE	TCA.GeneraInteres 	= Var_Si;

		-- ==================Calculo de ISR PARA LAS CUENTAS QUE GENERAN INTERESES ===================================

        SELECT COUNT(CuentaAhoID) INTO Var_ContadorCta
				FROM TMPCUENTASAHOCI
					WHERE GeneraInteres = GeneraInteresSi;

		 IF(Var_ContadorCta > Entero_Cero) THEN
					TRUNCATE CTESVENCIMIENTOS;

					INSERT INTO CTESVENCIMIENTOS(
							Fecha,				ClienteID,			EmpresaID,			UsuarioID,				FechaActual,
							DireccionIP,		ProgramaID,			Sucursal,   		NumTransaccion)
                    SELECT  UltimoDiaMes, 		ctas.ClienteID,     Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion
						FROM TMPCUENTASAHOCI ctas
						WHERE GeneraInteres = GeneraInteresSi
						GROUP BY ctas.ClienteID;

                    CALL CALCULOISRPRO( UltimoDiaMes,     UltimoDiaMes,   	  EnteroUno,            ProcesoCierre,          Salida_NO,
										Par_NumErr,				Par_ErrMen,			  Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
										Aud_DireccionIP,		Aud_ProgramaID,		  Aud_Sucursal,		    Aud_NumTransaccion);

					DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

					/*Actualizamos el ISR de las Cuentas de Ahorro*/
						UPDATE 	TMPCUENTASAHOCI TCA
							SET	TCA.ISR	= FNTOTALISRCTE(ClienteID,InstAhorro,CuentaAhoID)
									WHERE TCA.GeneraInteres = GeneraInteresSi;

					/*Actualizamos el ISR Pagado de la tabla COBROISR*/
						UPDATE COBROISR isr
						INNER JOIN TMPCUENTASAHOCI tmp  ON  isr.ClienteID     = tmp.ClienteID
														AND isr.ProductoID    = tmp.CuentaAhoID
														AND tmp.GeneraInteres = GeneraInteresSi
						SET isr.Estatus = Est_Aplicado
										WHERE isr.InstrumentoID = InstAhorro
										AND   isr.Estatus		= Est_NoAplicado;

			END IF;
		-- ==================  FIN DE ISR   ===================================

		-- ================== INICIO CALCULO DE COMISION DE SALDO PROMEDIO ================================
		UPDATE 	TMPCUENTASAHOCI TCA, TIPOSCUENTAS TIP SET
			TCA.ComSalProm	=	CASE WHEN TCA.SaldoProm < TIP.SaldoPromMinReq THEN
							ROUND(TIP.ComisionSalProm,2)
						ELSE
							Decimal_Cero
						END,
			TCA.IVAComSalProm = CASE WHEN TCA.SaldoProm < TIP.SaldoPromMinReq THEN
							ROUND(TIP.ComisionSalProm * TCA.Iva,2)
						ELSE
							Decimal_Cero
						END
			WHERE	TCA.TipoCuentaID = TIP.TipoCuentaID
				AND TCA.CobraSalProm = Var_Si
				AND TCA.Estatus = EstatusActi
				AND DATE_FORMAT(TCA.FechaApertura, '%Y%m') != DATE_FORMAT(Var_FecActual, '%Y%m');

		DROP TABLE IF EXISTS TMPINSTRUMENTOSCUENTA;
		CREATE TABLE TMPINSTRUMENTOSCUENTA (
			CuentaAhoID BIGINT(12),
			Registros 	INT(11), -- Registros de C-Cedes O-Credito I-Inversion
			PRIMARY KEY (CuentaAhoID)
		);

		-- Insertamos Registros si la Cuenta tiene ligado Creditos
		INSERT INTO TMPINSTRUMENTOSCUENTA(
			CuentaAhoID,	Registros)
		SELECT Tmp.CuentaAhoID,  COUNT(Cre.CreditoID)
			FROM TMPCUENTASAHOCI AS Tmp
				INNER JOIN CREDITOS AS Cre ON Tmp.CuentaAhoID = Cre.CuentaID
			WHERE Tmp.CobraSalProm = Var_Si
				AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
			GROUP BY Tmp.CuentaAhoID;

		-- Actualizamos los saldos de Comision de Saldo Promedio
		UPDATE TMPCUENTASAHOCI Tmp
			INNER JOIN TMPINSTRUMENTOSCUENTA Inst ON Tmp.CuentaAhoID = Inst.CuentaAhoID
		SET
			ComSalProm = Decimal_Cero,
			IVAComSalProm = Decimal_Cero
		WHERE Tmp.CobraSalProm = Var_Si
			AND Tmp.ExcentaCobSaldProm = Var_Si;

		DELETE FROM TMPINSTRUMENTOSCUENTA;
		-- Insertamos Registros si la Cuenta tiene ligado Inversiones
		INSERT INTO TMPINSTRUMENTOSCUENTA(
			CuentaAhoID,	Registros)
		SELECT Tmp.CuentaAhoID,  COUNT(Inv.InversionID)
			FROM TMPCUENTASAHOCI AS Tmp
				INNER JOIN INVERSIONES AS Inv ON Tmp.CuentaAhoID = Inv.CuentaAhoID
			WHERE Tmp.CobraSalProm = Var_Si
				AND Inv.Estatus = Est_InvVigente
			GROUP BY Tmp.CuentaAhoID;

		-- Actualizamos los saldos de Comision de Saldo Promedio
		UPDATE TMPCUENTASAHOCI Tmp
			INNER JOIN TMPINSTRUMENTOSCUENTA Inst ON Tmp.CuentaAhoID = Inst.CuentaAhoID
		SET
			ComSalProm = Decimal_Cero,
			IVAComSalProm = Decimal_Cero
		WHERE Tmp.CobraSalProm = Var_Si
			AND Tmp.ExcentaCobSaldProm = Var_Si;

		DELETE FROM TMPINSTRUMENTOSCUENTA;
		-- Insertamos Registros si la Cuenta tiene ligado Inversiones
		INSERT INTO TMPINSTRUMENTOSCUENTA(
			CuentaAhoID,	Registros)
		SELECT Tmp.CuentaAhoID,  COUNT(Ced.CedeID)
			FROM TMPCUENTASAHOCI AS Tmp
				INNER JOIN CEDES AS Ced ON Tmp.CuentaAhoID = Ced.CuentaAhoID
			WHERE Tmp.CobraSalProm = Var_Si
				AND Ced.Estatus = Est_Vigente
			GROUP BY Tmp.CuentaAhoID;

		-- Actualizamos los saldos de Comision de Saldo Promedio
		UPDATE TMPCUENTASAHOCI Tmp
			INNER JOIN TMPINSTRUMENTOSCUENTA Inst ON Tmp.CuentaAhoID = Inst.CuentaAhoID
		SET
			ComSalProm = Decimal_Cero,
			IVAComSalProm = Decimal_Cero
		WHERE Tmp.CobraSalProm = Var_Si
			AND Tmp.ExcentaCobSaldProm = Var_Si;


	-- ================== FIN CALCULO DE COMISION DE SALDO PROMEDIO ===================================

	UPDATE TMPCUENTASAHOCI TMPC SET GatReal =
							FUNCIONCALCGATREAL(	TMPC.Gat ,
											(SELECT InflacionProy AS ValorGatHis
												FROM INFLACIONACTUAL
												WHERE FechaActualizacion =
													(SELECT MAX(FechaActualizacion)
													FROM INFLACIONACTUAL)));

	-- Pago por rendimiento cta.gravado */

	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovRendGra,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	/* se llama a TMPCTASAHOMOVALT para  ejecutar los movimientos de
	-- Pago por rendimiento cta.excento */
	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovRendExc,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	/****se llama a TMPCTASAHOMOVALT para  ejecutar los movimientos de
		*comisiones por apertura y reflejarlo en el saldo */
	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovComAper,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	/*  se llama a TMPCTASAHOMOVALT para  ejecutar los movimientos de
	-- comisiones por aniversario y reflejarlo en el saldo */
	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovComAniv,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	/* se llama a TMPCTASAHOMOVALT para  ejecutar los movimientos de
	Retencion ISR */
	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovRetISR,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	/* se llama a TMPCTASAHOMOVALT para  ejecutar los movimientos de
	-- comisiones por manejo de Cuenta y reflejarlo en el saldo */
	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovComManC,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	/* se llama a TMPCTASAHOMOVALT para  ejecutar los movimientos de Comision de Saldo por Promedio */
	CALL TMPCTASAHOMOVALT(	Par_FechaOperacion,	Var_MovComSalProm,		Entero_Cero,		Entero_Cero,		Par_EmpresaID,
							Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(	Pro_MovCtaAlt, 		Par_FechaOperacion, Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	-- Cobro de IDE para SofiExpress y para los otros clientes.
	IF(Var_ClienteEsp = ClienteSofi) THEN
		CALL COBROIDEMENS015ALT(	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);
	ELSE
		CALL COBROIDEMENSALT(	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);
	END IF;
	/* se obtiene el numero de movimientos si es mayor que cero se crea una poliza contable*/
	SET var_NumMovs := (SELECT COUNT(*) FROM TMPCTASAHOMOV);
	IF (var_NumMovs>Entero_Cero) THEN
		CALL MAESTROPOLIZAALT(	Par_Poliza,		Par_EmpresaID,	Par_FechaOperacion,	Pol_Automatica,		VarConcepConta,
								DesConcepConta,	Salida_NO, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);


	END IF;


	UPDATE TMPCTASAHOMOV
		SET PolizaID = Par_Poliza;

	/* se insertan los valores que son iguales para todos los detalle de poliza .*/
	INSERT INTO TMPCONTAMOVS (
		ProcedimientoCont,	ClienteID, 			TipoPersona, 			SucursalOrigen,		CuentaAhoID,
		TipoCuentaID, 		GeneraInteres, 		MonedaID,				Instrumento,		Fecha,

		PolizaID,			Referencia,			Descripcion,			NatMovimiento,		TipoMovAhoID,
		Cargos,
		Abonos,
		SucursalCta,		ClasificacionConta,CentroCostoID,			CuentaCompleta,
		EmpresaID,			Usuario, 			FechaActual, 			DireccionIP,		ProgramaID,
		Sucursal, 			NumTransaccion)
		SELECT	Procedimiento,		Cue.ClienteID,		Cue.TipoPersona,		Cue.SucursalOrigen,	Cue.CuentaAhoID,
				Cue.TipoCuentaID, 	Cue.GeneraInteres,	Cue.MonedaID,			Cue.CuentaAhoID,	 Par_FechaOperacion,
				Par_Poliza,			Aud_NumTransaccion,	movs.DescripcionMov,  	movs.NatMovimiento,	TipoMovAhoID,
				CASE WHEN movs.NatMovimiento = Nat_Cargo THEN movs.CantidadMov ELSE Entero_Cero END AS Cargos,
				CASE WHEN movs.NatMovimiento = Nat_Abono THEN movs.CantidadMov ELSE Entero_Cero END AS Abonos,
				Cue.SucursalID,		Cue.ClasificacionConta, Entero_Cero,Cadena_Vacia,

				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM	TMPCUENTASAHOCI Cue,
					TMPCTASAHOMOV movs
				WHERE Cue.CuentaAhoID = movs.CuentaAhoID;

	/* Se manda a llamar el SP que inserta en DETALLEPOLIZA los
	-- movimientos contables comisiones por apertura y reflejarlo en el saldo*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovComAper,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	/* Se manda a llamar el SP que inserta en DETALLEPOLIZA los
	-- movimientos contables comisiones por aniversario y reflejarlo en el saldo*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovComAniv,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	/* se llama a POLIZACIERREMESPRO para  ejecutar los movimientos CONTABLES
	-- Pago por rendimiento cta.gravado*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovRendGra,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	/* Se manda a llamar el SP que inserta en DETALLEPOLIZA los
	-- movimientos contables  Pago por rendimiento cta.excento*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovRendExc,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	/* Se manda a llamar el SP que inserta en DETALLEPOLIZA los
	-- movimientos contables ISR*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovRetISR,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	/* Se manda a llamar el SP que inserta en DETALLEPOLIZA los
	-- movimientos contables  comisiones por manejo de Cuenta y reflejarlo en el saldo*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovComManC,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	/* Se manda a llamar el SP que inserta en DETALLEPOLIZA los
	-- movimientos contables Comision por Saldo Promedio*/
	CALL POLIZACIERREMESPRO(	Par_Poliza,			Par_EmpresaID,	Var_MovComSalProm,	Aud_Usuario, 		Aud_FechaActual,
								Aud_DireccionIP, 	Aud_ProgramaID,	Aud_Sucursal, 	Aud_NumTransaccion);

	CALL TMPCTASAHOACT();


	IF Var_CancelaAut="S" THEN
		SET Var_FecBitaco	:= NOW();
		CALL CANCSOCMENORCTAPRO(
			Par_FechaOperacion,	Cancelado,		Entero_Cero,		Entero_Cero,	 Entero_Cero,
			Entero_Cero,		Cadena_Vacia,	Decimal_Cero,		Entero_Cero,	 Cadena_Vacia,
			Entero_Cero,		Salida_NO,		Par_NumErr, 		Par_ErrMen,		 Var_Empresa,
			Aud_Usuario	,		Aud_FechaActual, Aud_DireccionIP,	Aud_ProgramaID,	 Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
		CALL BITACORABATCHALT(
			CancelaMenor, 		Var_FecActual, 		Var_MinutosBit,	Var_Empresa,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

	/* Proceso Mensual que cobra a cada socio que decidio participar. en PROFUN
	SI no tiene saldo suficiente no se cobra.*/

	CALL CLICOBPROFUNMESPRO(
							Par_FechaOperacion,		Salida_NO,		Par_NumErr,			Par_ErrMen,			Par_Poliza,
							Var_Empresa,			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,			Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	CALL BITACORABATCHALT( 	Pro_Profun, 		Par_FechaOperacion,		Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

    -- Actualizamos la tabla temporal para efectuar el paso a la tabla historica

    UPDATE 	CUENTASAHO CA,TMPCUENTASAHOCI TCA SET
		TCA.Saldo			= 	CA.Saldo,
        TCA.CargosMes		=	(TCA.CargosMes+CA.CargosMes),
		TCA.SaldoDispon		=  	CA.SaldoDispon
		WHERE 	TCA.CuentaAhoID 	= 	CA.CuentaAhoID;

	/* se usa en el CIERREMESAHORRO, ACTUALIZA EL ESTATUS DE LAS CUENTAS DE LOS MENORES
		QUE FUERON CANCELADOS A C, E INSERTA EN LA TABLA DE CONTROL LAS CUENTAS QUE
		FUERON CANCELADAS POR PANTLLA PARA QUE SEAN TOMADOS EN EL PASE A HISTORICO */
	CALL HISCUECANCELAPRO(
		Par_FechaOperacion);

     CALL TMPCTASAHOACT();	/* Se actualizan saldos de las Cuentas */
	-- Proceso de Cancelacion de Socios Menores
	IF Var_CancelaAut="S" THEN
		SET	Var_FecBitaco	:= NOW();
		/* se manda a llamar al sp que realiaza la afectacion contable de los socios menores que se cancelaron
		de maneraautomatica CANCSOCMENORCTAPRO */
		CALL POLIZACANCSOCMENOR(
			Par_FechaOperacion,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP	,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion	);
	END IF;

	/* se actualizan los datos que tenemos en la tabla de control TMPCUENTASAHOCI
	solo de socios menores
	para que sean tomados correctamente al pase al historico  */
	UPDATE 	CUENTASAHO CA,TMPCUENTASAHOCI TCA, CANCSOCMENORCTA	MEN  SET
		TCA.CargosDia		=  CA.CargosDia	,
		TCA.CargosMes		=  CA.CargosMes	,
		TCA.AbonosMes		=  CA.AbonosMes	,
		TCA.AbonosDia		=  CA.AbonosDia	,
		TCA.Saldo			=  CA.Saldo,
		TCA.SaldoDispon		=  CA.SaldoDispon,
		TCA.Estatus			=  CA.Estatus,
		TCA.ISRReal			=  CA.ISRReal
		WHERE 	CA.CuentaAhoID 	= 	TCA.CuentaAhoID
			AND	TCA.CuentaAhoID	= 	MEN.CuentaAhoID;

	/* se actualizan los datos que tenemos en la tabla de CUENTASAHO solo de socios menores
	para que sean tomados correctamente al pase al historico  */
	UPDATE 	CUENTASAHO CA,	TMPCUENTASAHOCI TCA,	CANCSOCMENORCTA	MEN SET
		CA.CargosDia		=  Entero_Cero	,
		CA.CargosMes		=  Entero_Cero	,
		CA.AbonosMes		=  Entero_Cero	,
		CA.AbonosDia		=  Entero_Cero	,
		CA.SaldoIniMes		=  Entero_Cero	,
		CA.ISRReal			=  Decimal_Cero
		WHERE 	CA.CuentaAhoID 	= 	TCA.CuentaAhoID
			AND	TCA.CuentaAhoID	= 	MEN.CuentaAhoID;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	CALL BITACORABATCHALT( 	Pro_CtaAhoMod, 		Par_FechaOperacion,		Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		-- ==================Se actualizan los Factores===================================


	TRUNCATE TMPACTUALIZAFACTOR;
	/*SE ACTUALIZAN LOS SALDOS DE LOS FACTORES Y DE TOTAL CAPTACION*/
	UPDATE  FACTORAHORRO FA,TMPCUENTASAHOCI TC
		SET FA.Saldo=(FA.Saldo+(InteresesGen-ISR))
		WHERE  FA.CuentaAhoID=TC.CuentaAhoID
            AND FA.Fecha>=UltimoDiaMes
			AND FA.Estatus=EstatusFactP;

	INSERT INTO  TMPACTUALIZAFACTOR
		SELECT ClienteID,SUM(InteresesGen-ISR) AS InteresesGen
			FROM TMPCUENTASAHOCI GROUP BY ClienteID;

	UPDATE  FACTORAHORRO FA,TMPACTUALIZAFACTOR TC
		SET FA.TotalCaptacion=(FA.TotalCaptacion+TC.InteresesGen)
		WHERE	FA.ClienteID =TC.ClienteID
            AND FA.Fecha>=UltimoDiaMes
			AND FA.Estatus=EstatusFactP;

	UPDATE  FACTORINVERSION FI,TMPACTUALIZAFACTOR TC
		SET FI.TotalCaptacion=(FI.TotalCaptacion+TC.InteresesGen)
		WHERE	FI.ClienteID =TC.ClienteID
            AND FI.Fecha>=UltimoDiaMes
			AND FI.Estatus=EstatusFactP;

	UPDATE  FACTORCEDES FC,TMPACTUALIZAFACTOR TC
		SET FC.TotalCaptacion=(FC.TotalCaptacion+TC.InteresesGen)
		WHERE	FC.ClienteID =TC.ClienteID
            AND FC.Fecha>=UltimoDiaMes
			AND FC.Estatus=EstatusFactP;

	UPDATE TOTALCAPTACION TCA,TMPACTUALIZAFACTOR TC
		SET TCA.TotalCaptacion=(TCA.TotalCaptacion+TC.InteresesGen)
		WHERE	TCA.ClienteID =TC.ClienteID
            AND TCA.Fecha>=UltimoDiaMes
			AND TCA.Estatus=EstatusFactP;

	TRUNCATE TMPACTUALIZAFACTOR;

		-- ==================Fin de Actualizacion===================================

	/* se llama a `HIS-CUENTASAHOALT` para conservar un historico de
	-- las cuentas de ahorro*/
	CALL `HIS-CUENTASAHOALT`(Par_FechaOperacion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	CALL BITACORABATCHALT(	Pro_HisCuenAh, 		Par_FechaOperacion, 	Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							/* para mantener un historico de los movimientos se hace
	-- un CALL a `HIS-CUENAHOMOVALT`*/
	CALL `HIS-CUENAHOMOVALT`(Par_FechaOperacion);

	TRUNCATE TABLE TMPCTASAHOMOV;
	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL CREPASHISTORICOPRO( 	Par_FechaOperacion,	Var_Empresa,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	CALL BITACORABATCHALT(	Pro_HisMovCta, 		Par_FechaOperacion, 	Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	CALL BITACORABATCHALT(	Pro_CieMesCta, 		Par_FechaOperacion, 	Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	-- Validacion para ejecutar store de generacion de informacion para Estados de Cuenta por Clientes
	SET Var_FechaProceso := (SELECT DATE_FORMAT(Par_FechaOperacion, '%Y%m'));
	IF (IFNULL(Var_GeneraEdoAuto, Cadena_Vacia) != Cadena_Vacia) THEN

		IF (Var_GeneraEdoAuto =Var_GeneraEdoAutoeneracionSI )THEN
			CALL EDOCTAPRINCIPALPRO(Var_FechaProceso, Par_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP,
									Aud_ProgramaID,	  Aud_Sucursal,  Aud_NumTransaccion);

			-- Actualizar el campo MesProceso de EDOCTAPARAMS
			UPDATE EDOCTAPARAMS
				SET MesProceso = Var_FechaProceso;
		END IF;
	END IF;

	-- Proceso para genera informacion para las Constancias de Retenciones
	CALL CONSTANCIARETENCIONPRO (
		Var_FechaProceso,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
        Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,	  	Aud_Sucursal,
        Aud_NumTransaccion);


END TerminaStore$$