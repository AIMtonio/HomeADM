-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREFONDAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREFONDAGROPRO`;DELIMITER $$

CREATE PROCEDURE `MINISTRACREFONDAGROPRO`(
	/*Sp para alta de credito pasivo */
	Par_CreditoFondeoID							BIGINT(20),						# Numero de Fondeo de Crédito
	Par_CreditoID 								BIGINT(12),						# Numero de Crédito
	Par_NumMinistra								INT(11),						# Numero de Ministracion
	Par_MontoMinistrado							DECIMAL(14,2),					# Monto de desembolsado
    Par_TipoCalculoInteres						CHAR(1),						# Tipo de Calculo de interes fechaPactada	: P, fechaReal: R
	Par_AmortizacionIni							INT(11),						# Amortizacion de Inicio para insertar

	Par_AmortizacionFin							INT(11),						# Amortizacion fin para insertar
	Par_FechaInicio								DATE,							# Fecha de Inicio
	Par_PolizaID								BIGINT(12),						# ID de la poliza en caso de generar nuevo credito pasivo

	Par_Salida									CHAR(1),						# Salida S:Si N:No
	INOUT Par_NumErr							INT(11),						# Numero de Error
	INOUT Par_ErrMen							VARCHAR(400),					# Mensaje de Error

	INOUT Par_Consecutivo						BIGINT(20),
	/*Parametros de Auditoria*/
	Aud_EmpresaID								INT(11),
	Aud_Usuario									INT(11),
	Aud_FechaActual								DATETIME,
	Aud_DireccionIP								VARCHAR(15),
	Aud_ProgramaID								VARCHAR(50),
	Aud_Sucursal								INT(11),
	Aud_NumTransaccion							BIGINT(20)
	)
TerminaStore: BEGIN
	/** DECLARACION DE VARIABLES */
	DECLARE Var_AcfectacioConta 				CHAR(1); 						# VARIA DE AFECTACION CONTABLE SI='S',NO='N'
	DECLARE Var_AmortizacionID					INT(11);						# Variables para el CURSOR
	DECLARE Var_AmortizID						INT(11);						# Variables para el CURSOR
	DECLARE Var_Cantidad						DECIMAL(14,2);					# Variable para el CURSOR
	DECLARE Var_CapitalizaInteres				CHAR(1);						# Capitaliza Interes
	DECLARE Var_CobraISR						CHAR(1);						# Indica si cobra o no ISR Si = S No = N
	DECLARE Var_ComDis							INT(11);						# Cta. comisiÃ³n por disposiciÃ³n  con la tabla CONCEPTOSFONDEO
	DECLARE Var_ComDispos						DECIMAL(12,2);					# Comision por disposicion.
	DECLARE Var_ConcepConDes					INT(11);						# concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA
	DECLARE Var_ConcepFonCap					INT(11);						# concepto de capital que corresponde con la tabla CONCEPTOSFONDEO
	DECLARE Var_Control							VARCHAR(100);
	DECLARE Var_Crecientes						CHAR(1);						# Indica el tipo de pago de capital Creciente
	DECLARE Var_CreditoFondeoID					BIGINT(12);						# Variables para el CURSOR
	DECLARE Var_CreditoID						BIGINT(12);						# Variables para el CURSOR
	DECLARE Var_CtaOrdAbo						INT(11);						# Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO
	DECLARE Var_CtaOrdCar						INT(11);						# Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO
	DECLARE Var_CuentaClabe						VARCHAR(18);					# Cuenta Clabe de la institucion
	DECLARE Var_CuotasCap						INT(11);						# numero de cuotas de capital que devuelve el simulador*/
	DECLARE Var_CuotasInt						INT(11);						# numero de cuotas de Interes que devuelve el simulador*/
	DECLARE Var_Descripcion						VARCHAR(100);					# descripcion para los movimientos de credito pasivo
	DECLARE Var_EsHabil							CHAR(1);
	DECLARE Var_EstatusDesembolso				CHAR(1);
	DECLARE Var_EstatusPeriodo					CHAR(1);						# Almecena el Estatus del Periodo Contable
	DECLARE Var_FechaApl						DATE;							# Si la fecha de operacion no es un dia habil, se guarda en esta variable el valor de dia habil*/
	DECLARE Var_FechaFinLinea					DATE; 							# Fecha de fin de la linea de  fondeo
	DECLARE Var_FechaMaxVenci					DATE; 							# Fecha de vencimiento maximo de la linea de  fondeo
	DECLARE Var_FechaSiguienteMinistracion		DATE;							# Fecha de la siguiente Ministracion
	DECLARE Var_FechInicLinea					DATE; 							# Fecha de inicio de la linea de  fondeo
	DECLARE Var_Iguales							CHAR(1);						# Indica el tipo de pago de capital Igual
	DECLARE Var_InstitucionID					INT(11);						# Numero de Institucion (INSTITUCIONES)
	DECLARE Var_InstitutFondID					INT(11);						# id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
	DECLARE Var_IVA								DECIMAL(12,4);					# indica el valor del iva si es que Paga IVA = si
	DECLARE Var_IvaComDis						INT(11);						# Cta. iva comisiÃ³n por disposiciÃ³n  con la tabla CONCEPTOSFONDEO
	DECLARE Var_IvaComDispos					DECIMAL(12,2);					# IVA Comision por disposicion.
	DECLARE Var_Libres							CHAR(1);						# Indica el tipo de pago de capital Libre
	DECLARE Var_LineaFondeoID					INT(11);						# Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	DECLARE Var_MonedaID						INT(11);						# moneda
	DECLARE Var_MontoCancelado					DECIMAL(14,2);					# Monto Cancelado de cada ministracion
	DECLARE Var_MontoComDis						DECIMAL(12,2); 					# monto de credito mas comision mas iva
	DECLARE Var_MontoMinistrado 				DECIMAL(14,2);					# Monto Ministrado se usa en el cursor
	DECLARE Var_MontoMinistradoAgro				DECIMAL(14,2);					# Monto ministrado hasta el momento
	DECLARE Var_MontoPendAmortAnterior			DECIMAL(14,2);
	DECLARE Var_MontoPendDesembolso				DECIMAL(14,2);					# Monto Saldo capital Vigente del credito
	DECLARE Var_MontoPendDesembolsoAgro			DECIMAL(14,2);
	DECLARE Var_NacionalidadIns					CHAR(1);						# Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON
	DECLARE Var_NO								CHAR(1);						# valor no
	DECLARE Var_NumCtaInstit					VARCHAR(20);					# Numero de Cuenta Bancaria.
	DECLARE Var_NumTransaccion					BIGINT(20);						# Variable para el Cursor
	DECLARE Var_NumTranSim						BIGINT(20);
	DECLARE Var_PagaIVA							CHAR(1);						# Indica si paga IVA valores :  Si = "S" / No = "N")
	DECLARE Var_PlazoContable					CHAR(1);						# plazo contable C.- Corto plazo L.- Largo Plazo
	DECLARE Var_PolizaID						BIGINT;
	DECLARE Var_PrimerDiaMes					DATE;							# Almacena el primer dia del mes --
	DECLARE Var_SaldoCapVigent					DECIMAL(14,2);					# Monto Saldo capital Vigente del credito
	DECLARE Var_SaldosInso						INT(11);						# Tipo de calculo de interes Saldos Insolutos
	DECLARE Var_SI								CHAR(1);						# valor si
	DECLARE Var_TasaFija						INT(11);						# Indica el valor para la formula de tasa fija
	DECLARE Var_TasaISR							DECIMAL(12,2);					# Tasa del ISR
	DECLARE Var_TasaPasiva						DECIMAL(14,4);					# Tasa del Credito Pasivo esta tasa viene desde la LINEAFONDEADOR
	DECLARE Var_TipoFondeador					CHAR(1);
	DECLARE Var_TipoInstitID					INT(11);						# Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
	DECLARE Var_EncabezadoPoliza				CHAR(1);						# indica si requiere encabezado de poliza
    DECLARE Var_AmortiActual					INT(11);						# Amortizacion en curso
    DECLARE Var_FechaSis						DATE;							# Fecha del sistema
	DECLARE Var_GrupoID							INT(11);						# Numero de Grupo
	DECLARE Var_TipoGrupo						VARCHAR(2);						# Tipo de grupo
	/* DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia						CHAR(1);						# Cadena Vacia
	DECLARE	Decimal_Cero						DECIMAL(12,2);					# Decimal en Cero
	DECLARE	Entero_Cero							INT;							# Entero en Cero
	DECLARE	Entero_Uno							INT;							# Entero Uno
	DECLARE	Est_Vigente							CHAR(1);						# Estatus Vigente corresponde con tabla CREDITOFONDEO
	DECLARE	Fecha_Vacia							DATE;							# Fecha Vacia
	DECLARE	Nat_Abono							CHAR(1);						# Naturaleza de Abono
	DECLARE	Nat_Cargo							CHAR(1);						# Naturaleza de Cargo
	DECLARE	Salida_NO							CHAR(1);						# Valor para no devolver una Salida
	DECLARE	Salida_SI							CHAR(1);						# Valor para devolver una Salida
	DECLARE Act_TipoActInteres					INT(11);						# Actualizacion AMORTICREDITOACT
	DECLARE Constante_NO						CHAR(1);
	DECLARE EstatusAbierto						CHAR(1);
	DECLARE Mov_CapVigente						INT(4);							# Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO)
	DECLARE OtorgaCrePasID						CHAR(4); 						# ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO
	DECLARE Estatus_NoDesembolsada				CHAR(1);
	DECLARE EstatusDesembolsada					CHAR(1);
	DECLARE ProcesoMinistra						CHAR(1);						# proceso desembolso pantalla
	DECLARE ProcesoCambioFondeo					CHAR(1);						# proceso cambio de fuente de fondeo


	/*CURSOR PARA CREAR LAS AMORTIZACIONES DE FONDEO DE ACUERDO AL CAPITAL DESEMBOLSADO*/
	DECLARE CURSORAMORTIAGROPAS CURSOR FOR
		SELECT AMO.CreditoFondeoID,			AMO.AmortizacionID,			AMO.MontoPendDesembolso,			AMO.MontoCancelado
			FROM
			AMORTIZAFONDEOAGRO AS AMO INNER JOIN
			CREDITOFONDEO AS CRED ON AMO.CreditoFondeoID = CRED.CreditoFondeoID
			WHERE
				CRED.CreditoFondeoID = Par_CreditoFondeoID
				AND CRED.Estatus ='N'
				AND AMO.EstatusDesembolso IN(Estatus_NoDesembolsada,'C');

	/*CURSOR PARA CREAR LOS MOVIMIENTOS OPERATIVOS DEL DESEMBOLSO*/
	DECLARE CURSORFONDEOMOVS CURSOR FOR
		SELECT AMO.CreditoFondeoID,  AMO.AmortizacionID, Aud_NumTransaccion, AGRO.TmpMontoDesembolso
			FROM
			AMORTIZAFONDEO AS AMO INNER JOIN
			CREDITOFONDEO AS CRED ON AMO.CreditoFondeoID = CRED.CreditoFondeoID INNER JOIN
			AMORTIZAFONDEOAGRO AS AGRO ON AMO.AmortizacionID = AGRO.AmortizacionID AND AMO.CreditoFondeoID = AGRO.CreditoFondeoID
			WHERE
				CRED.CreditoFondeoID = Par_CreditoFondeoID
				AND CRED.Estatus ='N'
				AND AMO.Capital> Entero_Cero
				AND AMO.Estatus = 'N'
				AND	AGRO.TmpMontoDesembolso	> Entero_Cero ;



	/* ASIGNACION DE VARIABLES */
	SET Var_ComDis								:= 17;							# Cta. comisiÃ³n por disposiciÃ³n  con la tabla CONCEPTOSFONDEO
	SET Var_ConcepConDes						:= 23; 							# concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA
	SET Var_ConcepFonCap						:= 1; 							# concepto de capital que corresponde con la tabla CONCEPTOSFONDEO
	SET Var_Crecientes							:= 'C'; 						# Indica el tipo de pago de capital Creciente
	SET Var_CtaOrdAbo							:= 12;							# Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO
	SET Var_CtaOrdCar							:= 11;							# Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO
	SET Var_Descripcion							:= 'OTORGAMIENTO DE CREDITO PASIVO';  			# descripcion para los movimientos de credito pasivo
	SET Var_Iguales								:= 'I'; 						# Indica el tipo de pago de capital Igual
	SET Var_IvaComDis							:= 18;							# Cta. Iva comisiÃ³n por disposiciÃ³n  con la tabla CONCEPTOSFONDEO
	SET Var_Libres 								:= 'L';							# Indica el tipo de pago de capital Libre
	SET Var_NO									:= 'N';							# Valor SI
	SET Var_SaldosInso							:= 1;							# Tipo de calculo de interes Saldos Insolutos
	SET Var_SI									:= 'S';							# Valor SI
	SET Var_TasaFija							:= 1; 							# Indica el valor para la formula de tasa fija
	SET Estatus_NoDesembolsada 					:= 'N';

	/* ASIGNACION DE CONSTANTES */
	SET Aud_FechaActual							:= NOW();						# Toma fecha actual
	SET Cadena_Vacia							:= '';							# Cadena Vacia
	SET Constante_NO							:= 'N';
	SET Decimal_Cero							:= 0.00;						# Valor para devolver una Salida
	SET Entero_Cero								:= 0;							# Entero en Cero
	SET Entero_Uno								:= 1;							# Entero Uno
	SET Est_Vigente								:= 'N';							# Estatus Vigente corresponde con tabla CREDITOFONDEO/AMORTIZAFONDEO
	SET EstatusAbierto							:= 'N';							# Estatus Abierto del periodo contable, N significa No cerrado
	SET Fecha_Vacia								:= '1900-01-01';				# Fecha Vacia
	SET Mov_CapVigente							:= 1;							# Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO)
	SET Nat_Abono								:= 'A';							# Naturaleza de Abono
	SET Nat_Cargo								:= 'C';							# Naturaleza de Cargo
	SET Salida_NO								:= 'N';							# Valor para no devolver una Salida
	SET Salida_SI								:= 'S';							# Valor para devolver una Salida
	SET OtorgaCrePasID							:= 30; 							# ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO
	SET EstatusDesembolsada						:= 'D';							# Estatus de la Solicitud: Desembolsada
	SET ProcesoMinistra							:= 'M';
    SET ProcesoCambioFondeo						:= 'F';
    SET Act_TipoActInteres						:= 1;						# Fondeo por Financiamiento

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
			'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACREFONDAGROPRO');
			SET Var_Control := 'sqlException';
		END;

		SET Par_CreditoFondeoID := IFNULL(Par_CreditoFondeoID, Entero_Cero);

		IF(Par_CreditoFondeoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Número de Crédito de Fondeo no puede estar Vacio';
			LEAVE ManejoErrores;
		END IF;


        SET Var_FechaSis := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
									WHERE EmpresaID = Aud_EmpresaID);
		SELECT
			LineaFondeoID,			PagaIva,			ComDispos,				IvaComDispos,		PorcentanjeIVA,
			TipoFondeador,			MonedaID,			NumCtaInstit,			PlazoContable,		CobraISR,
			TasaISR,				TipoInstitID,		NacionalidadIns,		CuentaClabe,		InstitutFondID,
			CapitalizaInteres
		INTO
			Var_LineaFondeoID,		Var_PagaIVA,		Var_ComDispos,			Var_IvaComDispos,	Var_IVA,
			Var_TipoFondeador,		Var_MonedaID,		Var_NumCtaInstit,		Var_PlazoContable,	Var_CobraISR,
			Var_TasaISR,			Var_TipoInstitID,	Var_NacionalidadIns,	Var_CuentaClabe,	Var_InstitutFondID,
			Var_CapitalizaInteres
		FROM CREDITOFONDEO
			WHERE CreditoFondeoID = Par_CreditoFondeoID;



		SELECT
			lin.TasaPasiva,				lin.InstitucionID
			INTO
			Var_TasaPasiva,			Var_InstitucionID
			FROM LINEAFONDEADOR lin,
				INSTITUTFONDEO ins
				WHERE LineaFondeoID = Var_LineaFondeoID
					AND ins.InstitutFondID = lin.InstitutFondID
					limit 1;

		/*SI ES EL PRIMER DESEMBOLSO SE CREAN PRIMERO LAS AMORTIZACIONES*/
		IF(Par_NumMinistra = Entero_Uno) THEN
			IF NOT EXISTS (SELECT CreditoFondeoID FROM AMORTIZAFONDEOAGRO WHERE CreditoFondeoID = Par_CreditoFondeoID) THEN
				/*INSERTAR LAS AMORTIZACIONES DEL CALENDARIO IDEAL DEAGRO EN EL CALENDARIO IDEAL*/
				/*Todas nacen como no desembolsadas y con el mismo capital como el pendiente a desembolsar*/
				SET Var_GrupoID := (SELECT GrupoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
				SET Var_GrupoID := IFNULL(Var_GrupoID, Entero_Cero);

				# Se valida si el crédito es un crédito grupal
				IF(Var_GrupoID = Entero_Cero) THEN
					INSERT INTO AMORTIZAFONDEOAGRO(
						CreditoFondeoID,			AmortizacionID,			FechaInicio,			FechaVencimiento,			FechaExigible,
						FechaLiquida,				Estatus,				Capital,				Interes,					IVAInteres,

						SaldoCapVigente,			SaldoCapAtrasad,		SaldoInteresAtra,		SaldoInteresPro,			SaldoIVAInteres,
						SaldoMoratorios,			SaldoIVAMora,			SaldoComFaltaPa,		SaldoIVAComFalP,			SaldoOtrasComis,

						SaldoIVAComisi,				ProvisionAcum,			SaldoCapital,			SaldoRetencion,				Retencion,
						EstatusDesembolso,			MontoPendDesembolso,	TipoCalculoInteres,		EmpresaID,					Usuario,
						FechaActual,				DireccionIP,			ProgramaID,				Sucursal,					NumTransaccion)
					SELECT
						Par_CreditoFondeoID,		AmortizacionID,			FechaInicio,			FechaVencim,				FechaExigible,
						FechaLiquida,				Estatus,				Capital,				Entero_Cero,				Entero_Cero,

						SaldoCapVigente,			Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,
						Entero_Cero,				Entero_Cero,			Entero_Cero,			Entero_Cero,				Entero_Cero,

						Entero_Cero,				Entero_Cero,			SaldoCapVigente,		Entero_Cero,				Entero_Cero,
						Salida_NO,					Capital,				TipoCalculoInteres,		EmpresaID,					Usuario,
						FechaActual,				DireccionIP,			ProgramaID,				Sucursal,					NumTransaccion
					FROM AMORTICREDITOAGRO
							WHERE
							CreditoID = Par_CreditoID;
				 ELSE
				 	SET Var_TipoGrupo := (SELECT TipoOperaAgro FROM GRUPOSCREDITO WHERE GrupoID = Var_GrupoID );

					/*Alta de amortizaciones para creditos grupales no formales y globales.*/
					CALL AMORTIFONDEOAGROGRUPALALT(
						Par_CreditoFondeoID,	Var_TipoGrupo,		Salida_NO,			Par_NumErr,			Par_ErrMen,
						Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;


				/*Con el numero de transaccion se crean las amortizaciones en la tabla temporal TMPPAGAMORSIM*/
			CALL AMORTGENCREDFONPRO(
				Par_CreditoFondeoID,			Par_MontoMinistrado,		Var_TasaPasiva,			Var_PagaIVA,			Var_IVA,
				Salida_NO,						Par_NumErr,					Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			# Una vez en la tabla temporal y con los intereses calculados se actualizan los campos de la tabla del AMORTIZAFONDEOAGRO
			UPDATE AMORTIZAFONDEOAGRO AS AMO INNER JOIN TMPPAGAMORSIM AS SIM ON AMO.NumTransaccion = SIM.NumTransaccion SET
				AMO.FechaInicio 				= SIM.Tmp_FecIni,
				AMO.CreditoFondeoID				= Par_CreditoID,
				AMO.AmortizacionID				= Tmp_Consecutivo,
				AMO.FechaVencimiento			= Tmp_FecFin,
				AMO.FechaExigible				= Tmp_FecVig,
				AMO.FechaLiquida				= Fecha_Vacia,
				AMO.Estatus						= Est_Vigente,
				AMO.Capital						= Tmp_Capital,
				AMO.Interes						= Tmp_Interes,
				AMO.IVAInteres					= Tmp_Iva,
				AMO.SaldoCapVigente				= Decimal_Cero ,
				AMO.SaldoCapAtrasad				= Decimal_Cero,
				AMO.SaldoInteresAtra			= Decimal_Cero,
				AMO.SaldoInteresPro				= Decimal_Cero,
				AMO.SaldoIVAInteres				= Decimal_Cero,
				AMO.SaldoMoratorios				= Decimal_Cero,
				AMO.SaldoIVAMora				= Decimal_Cero,
				AMO.SaldoComFaltaPa				= Decimal_Cero,
				AMO.SaldoIVAComFalP				= Decimal_Cero,
				AMO.SaldoOtrasComis				= Decimal_Cero,
				AMO.SaldoIVAComisi				= Decimal_Cero,
				AMO.ProvisionAcum				= Decimal_Cero,
				AMO.SaldoCapital				= Tmp_Capital,
				AMO.Retencion					= Tmp_Retencion,
				AMO.SaldoRetencion				= Decimal_Cero
				WHERE AMO.NumTransaccion 		= Aud_NumTransaccion;


			-- se borran las amortizaciones temporales
			DELETE FROM TMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion;
			END IF;
		END IF;
		/*FIN VALIDACION DEL PRIMER DESEMBOLSO*/

		/*Una vez generadas las amortizaciones se crea*/
		-- Inicializacion de Valores por default
			SELECT
				FechInicLinea,		FechaFinLinea,		FechaMaxVenci,		CobraISR	,AfectacionConta
				INTO
				Var_FechInicLinea,	Var_FechaFinLinea,	Var_FechaMaxVenci,	Var_CobraISR, Var_AcfectacioConta
				FROM LINEAFONDEADOR lin,
					INSTITUTFONDEO ins
					WHERE LineaFondeoID 	= Var_LineaFondeoID
						AND ins.InstitutFondID = lin.InstitutFondID limit 1;
			SET Var_FechInicLinea	:= IFNULL(Var_FechInicLinea,Fecha_Vacia);
			SET Var_FechaFinLinea	:= IFNULL(Var_FechaFinLinea,Fecha_Vacia);
			SET Var_FechaMaxVenci	:= IFNULL(Var_FechaMaxVenci,Fecha_Vacia);


		CALL DIASFESTIVOSCAL(
			Par_FechaInicio,	Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

			-- se verifica si se paga o no ISR
			IF( IFNULL(Var_CobraISR,Cadena_Vacia) = Var_SI) THEN
				SET Var_TasaISR:= Var_TasaISR;
			ELSE
				SET Var_TasaISR:= Entero_Cero;
			END IF;

		UPDATE AMORTIZAFONDEOAGRO AS FOND INNER JOIN AMORTICREDITOAGRO AS AMO ON FOND.CreditoFondeoID = Par_CreditoFondeoID AND AMO.CreditoID = Par_CreditoID AND FOND.AmortizacionID = AMO.AmortizacionID SET
			FOND.TipoCalculoInteres = AMO.TipoCalculoInteres
			WHERE
				CreditoFondeoID = Par_CreditoFondeoID;

		SET Var_MontoMinistrado := Par_MontoMinistrado;

		/*ESTE CURSOR CREA LAS AMORTIZACION CON EL CAPITAL QUE SE ESTA MINISTRANDO*/
		OPEN CURSORAMORTIAGROPAS;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
				FETCH CURSORAMORTIAGROPAS INTO
					Var_CreditoFondeoID,		Var_AmortizacionID,		Var_MontoPendDesembolso,		Var_MontoCancelado;

					/*SI EL MONTO MINISTRADO ES MENOR A 0 SE SALE DEL CURSOR YA QUE SE ACABO EL CAPITAL PARA LAS AMORTIZACIONES*/
					IF(Var_MontoMinistrado <= Entero_Cero) THEN
						LEAVE CICLO;
					END IF;

					# Se valida el monto a desembolsar
					IF(Var_MontoMinistrado > Var_MontoPendDesembolso) THEN
						SET Var_MontoMinistrado 			:= Var_MontoMinistrado - Var_MontoPendDesembolso;
						SET Var_MontoPendAmortAnterior		:= Entero_Cero;
						SET Var_EstatusDesembolso 			:= EstatusDesembolsada;
					  ELSE
						/*PARA ESTE CASO EL RESTO PENDIENTE DE DESEMBOLSO PASA A SER CAPITAL DE LA SIGUIENTE AMORTIZACION*/
						SET Var_MontoPendAmortAnterior 		:= Var_MontoPendDesembolso - Var_MontoMinistrado;
						SET Var_MontoPendDesembolso 		:= Var_MontoMinistrado;
						SET Var_MontoMinistrado				:= Entero_Cero;
						SET Var_EstatusDesembolso 			:= 'N';
					END IF;

					SET Var_MontoMinistradoAgro := Var_MontoMinistradoAgro - Var_MontoPendDesembolso;

					/*Si la amortizacion aun no existe la actualizo, si no es asi se realiza update*/
					IF NOT EXISTS(SELECT AmortizacionID FROM AMORTIZAFONDEO
									WHERE CreditoFondeoID = Par_CreditoFondeoID
									AND AmortizacionID = Var_AmortizacionID) THEN

						INSERT INTO AMORTIZAFONDEO(
							CreditoFondeoID,					AmortizacionID,				FechaInicio,				FechaVencimiento,			FechaExigible,
							FechaLiquida,						Estatus,					Capital,					Interes,					IVAInteres,
							SaldoCapVigente,					SaldoCapAtrasad,			SaldoInteresAtra,			SaldoInteresPro,			SaldoIVAInteres,
							SaldoMoratorios,					SaldoIVAMora,				SaldoComFaltaPa,			SaldoIVAComFalP,			SaldoOtrasComis,
							SaldoIVAComisi,						ProvisionAcum,				SaldoCapital,				SaldoRetencion,				Retencion,
							EmpresaID,							Usuario,					FechaActual,				DireccionIP,				ProgramaID,
							Sucursal,							NumTransaccion)
						SELECT
							AMO.CreditoFondeoID,				AMO.AmortizacionID,			AMO.FechaInicio,			AMO.FechaVencimiento,		AMO.FechaExigible,
							AMO.FechaLiquida,					'N',						Var_MontoPendDesembolso,	AMO.Interes,				AMO.IVAInteres,
							AMO.SaldoCapVigente,				AMO.SaldoCapAtrasad,		AMO.SaldoInteresAtra,		AMO.SaldoInteresPro,		AMO.SaldoIVAInteres,
							AMO.SaldoMoratorios,				AMO.SaldoIVAMora,			AMO.SaldoComFaltaPa,		AMO.SaldoIVAComFalP,		AMO.SaldoOtrasComis,
							AMO.SaldoIVAComisi,					AMO.ProvisionAcum,			AMO.SaldoCapital,			AMO.SaldoRetencion,			AMO.Retencion,
							Aud_EmpresaID,						Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
							Aud_Sucursal,						AMO.NumTransaccion
						FROM AMORTIZAFONDEOAGRO AS AMO
							WHERE AMO.CreditoFondeoID = Par_CreditoFondeoID
								AND AMO.AmortizacionID = Var_AmortizacionID;
					  ELSE
						UPDATE AMORTIZAFONDEO SET
					-- 		SaldoCapVigente = Capital + Var_MontoPendDesembolso,
							Capital = Capital + Var_MontoPendDesembolso
							WHERE
							CreditoFondeoID = Var_CreditoFondeoID
							AND AmortizacionID = Var_AmortizacionID;
					END IF;

					UPDATE AMORTIZAFONDEOAGRO SET
						MontoPendDesembolso = Var_MontoPendAmortAnterior,
                        TipoCalculoInteres 	= Par_TipoCalculoInteres,
						EstatusDesembolso 	= Var_EstatusDesembolso,
						TmpMontoDesembolso	= Var_MontoPendDesembolso
						WHERE
							CreditoFondeoID = Var_CreditoFondeoID
							AND AmortizacionID = Var_AmortizacionID;

			END LOOP CICLO;
		END;
		CLOSE CURSORAMORTIAGROPAS;



		-- Se actualiza la linea de fondeo de credito
		CALL SALDOSLINEAFONACT(
			Var_LineaFondeoID,	Nat_Cargo,			Par_MontoMinistrado,			Salida_NO,				Par_NumErr,
			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
			LEAVE ManejoErrores;
		END IF;


		SET Var_EncabezadoPoliza := Var_SI;

		-- Se manda a llamar sp para hacer la parte contable por el monto total desembolsado.
		CALL CONTAFONDEOPRO(
			Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
			Par_CreditoFondeoID,					Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,	Var_ConcepFonCap,
			Var_Descripcion,						Par_FechaInicio,						Par_FechaInicio,		Par_FechaInicio,		Par_MontoMinistrado,
			CONVERT(Par_CreditoFondeoID,CHAR),		CONVERT(Par_CreditoFondeoID,CHAR),		Var_EncabezadoPoliza,	Var_ConcepConDes,		Nat_Abono,
			Nat_Cargo,								Nat_Cargo,								Nat_Abono,				Var_NO,					OtorgaCrePasID,
			Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeador,
			Salida_NO,								Var_PolizaID,							Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
			Aud_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,							Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
			LEAVE ManejoErrores;
		END IF;


		-- CUENTA ORDEN LINEA DE FONDEO --
		IF(Var_AcfectacioConta = Var_SI)THEN
			-- --------------------------------------------------------------------------------------
			-- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
			-- contingente (Cargo)
			-- --------------------------------------------------------------------------------------
			CALL CONTAFONDEOPRO(
				Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
				Par_CreditoFondeoID,					Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,	Var_CtaOrdCar,
				Var_Descripcion,						Par_FechaInicio,						Par_FechaInicio,		Par_FechaInicio,		Par_MontoMinistrado,
				CONVERT(Par_CreditoFondeoID,CHAR),		CONVERT(Par_CreditoFondeoID,CHAR),		Var_NO,					Var_ConcepConDes,		Nat_Abono,
				Nat_Abono,								Nat_Abono,								Nat_Abono,				Var_NO,					OtorgaCrePasID,
				Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeador,
				Salida_NO,								Var_PolizaID,							Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Aud_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,							Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;

			-- --------------------------------------------------------------------------------------
			-- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
			-- contingente (Abono)
			-- --------------------------------------------------------------------------------------
			CALL CONTAFONDEOPRO(
				Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
				Par_CreditoFondeoID,					Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,	Var_CtaOrdAbo,
				Var_Descripcion,						Par_FechaInicio,						Par_FechaInicio,		Par_FechaInicio,		Par_MontoMinistrado,
				CONVERT(Par_CreditoFondeoID,CHAR),		CONVERT(Par_CreditoFondeoID,CHAR),		Var_NO,					Var_ConcepConDes,		Nat_Cargo,
				Nat_Cargo,								Nat_Cargo,								Nat_Cargo,				Var_NO,					OtorgaCrePasID,
				Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeador,
				Salida_NO,								Var_PolizaID,							Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Aud_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,							Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
			LEAVE ManejoErrores;
			END IF;
		END IF; -- Afectacion contable Linea
		-- FIN CUENTA ORDEN LINEA DE FONDEO

		-- SI HAY COMISION POR DISPOSICION (AUNQUE EN CREDITOS PASIVOS AGROPECUARIOS NO APLICARIA)
		IF(IFNULL(Var_ComDispos, Decimal_Cero)) >Decimal_Cero THEN -- si hay una comision por disposicion
			-- Se manda a llamar sp para hacer la parte contable
			CALL CONTAFONDEOPRO(
				Var_MonedaID,							Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,		Var_NumCtaInstit,
				Par_CreditoFondeoID,					Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,	Var_ComDis,
				Var_Descripcion,						Par_FechaInicio,						Par_FechaInicio,		Par_FechaInicio,		Var_ComDispos,
				CONVERT(Par_CreditoFondeoID,CHAR),		CONVERT(Par_CreditoFondeoID,CHAR),		Var_NO,					Var_ConcepConDes,		Nat_Cargo,
				Nat_Cargo,								Nat_Cargo,								Nat_Abono,				Var_NO,					OtorgaCrePasID,
				Var_NO,									Entero_Cero,							Mov_CapVigente,			Var_SI,					Var_TipoFondeador,
				Salida_NO,								Var_PolizaID,							Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
				Aud_EmpresaID,							Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,							Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_IvaComDispos, Decimal_Cero)) >Decimal_Cero THEN -- si hay un iva de comision por disposicion
				-- Se manda a llamar sp para hacer la parte contable
				CALL CONTAFONDEOPRO(
				Var_MonedaID,								Var_LineaFondeoID,						Var_InstitutFondID,		Var_InstitucionID,			Var_NumCtaInstit,
				Par_CreditoFondeoID,						Var_PlazoContable,						Var_TipoInstitID,		Var_NacionalidadIns,		Var_IvaComDis,
				Var_Descripcion,							Par_FechaInicio,						Par_FechaInicio,		Par_FechaInicio,			Var_IvaComDispos,
				CONVERT(Par_CreditoFondeoID,CHAR),			CONVERT(Par_CreditoFondeoID,CHAR),		Var_NO,					Var_ConcepConDes,			Nat_Cargo,
				Nat_Cargo,									Nat_Cargo,								Nat_Abono,				Var_NO,						OtorgaCrePasID,
				Var_NO,										Entero_Cero,							Mov_CapVigente,			Var_SI,						Var_TipoFondeador,
				Salida_NO,									Var_PolizaID,							Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
				Aud_EmpresaID,								Aud_Usuario,							Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,								Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
					LEAVE ManejoErrores;
				END IF;
			END IF; -- iva comision por disposicion
		END IF; -- Comision por disposicion

		-- Se insertan los movimientos de tesoreria
		SET Var_MontoComDis := Par_MontoMinistrado -IFNULL(Var_IvaComDispos, Decimal_Cero)-IFNULL(Var_ComDispos, Decimal_Cero);
		-- Se manda a llamar sp para hacer la parte contable
		CALL CONTAFONDEOPRO(
			Var_MonedaID,							Var_LineaFondeoID,					Var_InstitutFondID,		Var_InstitucionID,			Var_NumCtaInstit,
			Par_CreditoFondeoID,					Var_PlazoContable,					Var_TipoInstitID,		Var_NacionalidadIns,		Var_ConcepFonCap,
			Var_Descripcion,						Par_FechaInicio,					Par_FechaInicio,		Par_FechaInicio,			Var_MontoComDis,
			CONVERT(Par_CreditoFondeoID,CHAR),		CONVERT(Par_CreditoFondeoID,CHAR),	Var_NO,					Var_ConcepConDes,			Nat_Abono,
			Nat_Cargo,								Nat_Cargo,							Nat_Abono,				Var_SI,						OtorgaCrePasID,
			Var_NO,									Entero_Cero,						Mov_CapVigente,			Var_NO,						Var_TipoFondeador,
			Salida_NO,								Var_PolizaID,						Par_Consecutivo,		Par_NumErr,					Par_ErrMen,
			Aud_EmpresaID,							Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,							Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			SET Par_CreditoFondeoID := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		# CURSOR para registrar el saldo de capital de las amortizaciones en capital vigente o en vencido no exigible
		OPEN CURSORFONDEOMOVS;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
				FETCH CURSORFONDEOMOVS INTO
					Var_CreditoID, 	Var_AmortizID,	Var_NumTransaccion,	Var_Cantidad;

					CALL CREDITOFONDMOVSALT(
						Var_CreditoID,						Var_AmortizID,					Var_NumTransaccion,				Var_FechaApl,					Var_FechaApl,
						Mov_CapVigente,						Nat_Cargo,						Var_MonedaID,					Var_Cantidad,					'DESEMBOLSO',
						Par_CreditoID,						'N',							Par_NumErr,						Par_ErrMen,						Par_Consecutivo,
						Aud_EmpresaID,						Aud_Usuario,					Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,
						Aud_Sucursal,						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE CICLO;
					END IF;
					UPDATE AMORTIZAFONDEOAGRO SET
						TmpMontoDesembolso = 0
						WHERE
							CreditoFondeoID = Var_CreditoID
							AND AmortizacionID = Var_AmortizID;

				END LOOP CICLO;
			END;
		CLOSE CURSORFONDEOMOVS;

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		# Se recalculan los intereses
		CALL AMORTIZAFONDEOACT(
			Par_CreditoFondeoID,Act_TipoActInteres,		Par_TipoCalculoInteres,	'N',			Par_NumErr,
            Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= CONCAT('Credito Pasivo Agregado Exitosamente: ',CONVERT(Par_CreditoFondeoID,CHAR));
		SET	Par_Consecutivo := Par_CreditoFondeoID;

	END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
			Par_ErrMen	AS ErrMen,
			'creditoFondeoID' AS control,
			Par_CreditoID AS consecutivo,
			Var_PolizaID AS CampoGenerico;
	END IF;
END TerminaStore$$