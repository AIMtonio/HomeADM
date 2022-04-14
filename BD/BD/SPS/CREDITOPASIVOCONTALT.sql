-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOPASIVOCONTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOPASIVOCONTALT`;
DELIMITER $$


CREATE PROCEDURE `CREDITOPASIVOCONTALT`(
# =====================================================================
# -- SP para dar de alta un  credito pasivo contingente--
# =====================================================================
	Par_CreditoID				BIGINT(20),				-- Numero de Credito
	Par_Monto					DECIMAL(18,2),			-- Monto de Capital de la ministracion
	Par_PolizaID				BIGINT(12),				-- ID de la poliza en caso de generar nuevo credito pasivo
    Par_TipoCalculoInteres		CHAR(1),				-- Tipo de Calculo de interes fechaPactada	: P, fechaReal: R
	Par_GarantiaID				INT(11),				-- ID de garantia fira

    Par_Salida					CHAR(1),				-- Tipo de Salida S. Si N. No
	INOUT	Par_NumErr			INT(11),				-- Numero de Error
	INOUT	Par_ErrMen			VARCHAR(400),			-- Mensaje de Error
	/*Parametros de Auditoria*/
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			--  Variable con el ID del control de Pantalla
	DECLARE Var_FechaSistema		DATE;					--  Fecha Actual del Sistema
	DECLARE Var_Consecutivo			VARCHAR(50);			--  Variable campo de pantalla
	DECLARE Var_CreditoFondeoID		BIGINT(20);				--  Numero de Credito de Fonde (Credito Pasivo)
	-- Variables para los datos extraidos de la tabla de creditos
	DECLARE Var_LineaFondeoID   	INT(11);				--  Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	DECLARE Var_InstitutFondID		INT(11);				--  id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
	DECLARE Var_Folio		   		VARCHAR(150);			--  Folio del Fondeo corresponde con lo que da la inst de fondeo.
	DECLARE Var_TipoCalInteres		INT(11);				--  1 .- Saldos Insolutos 2 .- Monto Original (Saldos Globales)
	DECLARE Var_CalcInteresID		INT(11);				--  Formula para el calculo de Interes
	DECLARE Var_TasaBase			INT(11);				--  Tasa Base, necesario dependiendo de la Formula
	DECLARE Var_SobreTasa			DECIMAL(12,4);			--  Si es formula dos (Tasa base mas puntos), aqui se definen  Los puntos
	DECLARE Var_TasaFija			DECIMAL(12,4);			--  Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha tasa fija
	DECLARE Var_PisoTasa			DECIMAL(12,4);			--  Piso, Si es formula tres
	DECLARE Var_TechoTasa			DECIMAL(12,4);			--  Techo, Si es formula tres
	DECLARE Var_FactorMora			DECIMAL(12,4);			--  Factor de Moratorio
	DECLARE Var_Monto				DECIMAL(14,2);			--  Monto del Credito de Fondeo
	DECLARE Var_MonedaID			INT(11);				--  moneda
	DECLARE Var_FechaInicio			DATE;					--  Fecha de Inicio
	DECLARE Var_FechaVencim			DATE;					--  Fecha de Vencimiento
	DECLARE Var_TipoPagoCap			CHAR(1);				--  Tipo de Pago de Capital C .-Crecientes I .- Iguales L .-Libres
	DECLARE Var_FrecuenciaCap		CHAR(1);				--  Frecuencia de Pago de las Amortizaciones de Capital S .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo B.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual
	DECLARE Var_PeriodicidadCap		INT(11);				--  Periodicidad de Capital en dias
	DECLARE Var_NumAmortizacion		INT(11);				--  Numero de Amortizaciones o Cuotas (de Capital)
	DECLARE Var_FrecuenciaInt		CHAR(1);				--  Frecuencia de Interes S .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo B.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual
	DECLARE Var_PeriodicidadInt		INT(11);				--  Periodicidad de Interes en dias
	DECLARE Var_NumAmortInteres		INT(11);				--  Numero de Amortizaciones (cuotas) de Interes
	DECLARE Var_MontoCuota			DECIMAL(12,2);			--  Monto de la Cuota
	DECLARE Var_FechaInhabil		CHAR(1);				--  Fecha Inhabil: S.-Siguiente  A.-Anterior
	DECLARE Var_CalendIrregular		CHAR(1);				--  Calendario Irregular S.- Si N.-No
	DECLARE Var_AjusFecUlVenAmo		CHAR(1); 				--  Ajustar la fecha de vencimiento de la ultima amortizacion a fecha de vencimiento de credito S.-Si  N.-No
	DECLARE Var_AjusFecExiVen		CHAR(1);				--  Ajustar Fecha de exigibilidad a fecha de vencimiento S.-Si  N.-No
	DECLARE Var_NumTransacSim		BIGINT(20);				--  Numero de transaccion en el simulador de Amortizaciones
	DECLARE Var_PlazoID				VARCHAR(20);			--  Plazo del credito Corresponde con la tabla CREDITOSPLAZOS
	DECLARE Var_PagaIVA				CHAR(1);				--  indica si paga IVA valores :  Si = "S" / No = "N")
	DECLARE Var_IVA					DECIMAL(12,4);			--  indica el valor del iva si es que Paga IVA = si
	DECLARE Var_MargenPag			DECIMAL(12,2);			--  Margen para Pagos Iguales.
	DECLARE Var_InstitucionID		INT(11);				--  Numero de Institucion (INSTITUCIONES)
	DECLARE Var_NumCtaInstit		VARCHAR(20);			--  Numero de Cuenta Bancaria.
	DECLARE Var_PlazoContable		CHAR(1);				--  plazo contable C.- Corto plazo L.- Largo Plazo
	DECLARE Var_TipoInstitID		INT(11);				--  Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
	DECLARE Var_NacionalidadIns		CHAR(1);				--  Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON*/
	DECLARE Var_FechaContable		DATE;					--  Indica la fecha contable
	DECLARE Var_ComDispos			DECIMAL(12,2);			--  Comision por disposicion.
	DECLARE Var_IvaComDispos		DECIMAL(12,2);			--  IVA Comision por disposicion.
	DECLARE Var_CobraISR			CHAR(1);				--  Indica si cobra o no ISR Si = S No = N
	DECLARE Var_TasaISR				DECIMAL(12,2);			--  Tasa del ISR
	DECLARE Var_TasaPasiva			DECIMAL(14,4);			--  Tasa del ISR
	DECLARE Var_MargenPriCuota		INT(11);				--  Margen para calcular la primer cuota
	DECLARE Var_CapitalizaInteres	CHAR(1);
    DECLARE Var_PagosParciales		CHAR(1);
	DECLARE Var_TipoFondeador		CHAR(1);
	DECLARE Var_AfectacionConta		CHAR(1);
	DECLARE Par_Consecutivo			BIGINT(12);
	DECLARE Var_Refinancia			CHAR(1);				--  Refinanciamiento de Intereses S:Si N:No
    DECLARE Var_SaldoLinea			DECIMAL(14,2);			-- Saldo de la linea
    DECLARE Var_ConsecutivoID		BIGINT(20);
	DECLARE Var_ProdCreditoID		INT(11);
    DECLARE Var_Clasificacion		CHAR(1);            	-- clasificacion del credito
	DECLARE	Var_SucCliente			INT(11);
	DECLARE Var_SubClasifica		INT(11);
	DECLARE Var_ConGaranFira		INT(11);
	DECLARE Var_Cargos  			DECIMAL(14,4);
	DECLARE Var_Abonos  			DECIMAL(14,4);
	DECLARE Var_CreditoStr  		VARCHAR(20);
    DECLARE Var_ConGaranCorr		INT(11);
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				--  Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					--  Fecha Vacia
	DECLARE	Entero_Cero				INT;					--  Entero Cero
	DECLARE	Decimal_Cero			DECIMAL;				--  Decimal Cero
	DECLARE	SalidaNo				CHAR(1);				--  Constante SI
	DECLARE	SalidaSi				CHAR(1);				--  Constante NO
	DECLARE	EstatusInactivo			CHAR(1);				--  Estatus Inactivo
	DECLARE ProcesoMinistra			CHAR(1);				--  proceso cambio de ministracion pantalla
	DECLARE ProcesoCambioFondeo		CHAR(1);				--  proceso cambio de fuente de fondeo
    DECLARE ProcesoContingente		CHAR(1);				--  proceso credito contingente
    DECLARE ConstanteNo         	CHAR(1);                --  Constamnte no
    DECLARE Alta_Pasivo				INT(11);
    DECLARE Act_TipoActInteres		INT(11);				--  Actualizacion AMORTICREDITOACT
    DECLARE Ult_Cuotas				CHAR(1);
    DECLARE Nat_Cargo       		CHAR(1);				-- Naturaleza de Cargo
    DECLARE Nat_Abono				CHAR(1);				-- Naturaleza abono
    DECLARE ConCapital				INT(11);
    DECLARE DescripcionMov			VARCHAR(50);
	DECLARE GarantiaFonaga			INT(11);
    DECLARE TipoFondeador			CHAR(2);				-- Tipo de fondeador

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
    SET Decimal_Cero				:= 0.0;
	SET	EstatusInactivo				:= 'I';
	SET SalidaSi					:= 'S';
	SET ProcesoMinistra				:= 'M';
    SET ProcesoCambioFondeo			:= 'F';
    SET ProcesoContingente			:= 'C';
    SET ConstanteNo         		:= 'N';
    SET Alta_Pasivo					:= 2;
    SET Act_TipoActInteres			:= 1;
    SET Ult_Cuotas					:= 'U';
    SET Nat_Cargo       			:= 'C';
    SET Nat_Abono					:= 'A';
    SET ConCapital					:= 1;
	SET GarantiaFonaga				:= 2;
    SET DescripcionMov				:= 'CREACION CREDITO PASIVO CONT';
    SET TipoFondeador				:= 'F';
    SET Var_NacionalidadIns			:= 'N';
    SET Var_MargenPriCuota			:= 0;
    SET Var_FechaContable			:= Fecha_Vacia;
    SET Var_MargenPag				:= 0.0;
	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOPASIVOCONTALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual := NOW();
		SET Var_FechaSistema:= (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
                                    WHERE EmpresaID = Par_EmpresaID);
		SELECT
			LineaFondeo,				InstitFondeoID,					CreditoID,					TipoCalInteres,				CalcInteresID,
			TasaBase,					SobreTasa,						TasaFija,					PisoTasa,					TechoTasa,
			FactorMora,					MontoCredito,					MonedaID,					FechaInicio,				FechaVencimien,
			TipoPagoCapital,			FrecuenciaCap,					PeriodicidadCap,			FrecuenciaInt,				PeriodicidadInt,
			NumAmortInteres,			MontoCuota,						FechaInhabil,				CalendIrregular,			AjusFecUlVenAmo,
			AjusFecExiVen,				NumTransacSim,					PlazoID,					TipoFondeo,	    			Refinancia,
            NumAmortizacion
		INTO
			Var_LineaFondeoID,			Var_InstitutFondID,				Var_Folio,					Var_TipoCalInteres,			Var_CalcInteresID,
			Var_TasaBase,				Var_SobreTasa,					Var_TasaFija,				Var_PisoTasa,				Var_TechoTasa,
			Var_FactorMora,				Var_Monto,						Var_MonedaID,				Var_FechaInicio,			Var_FechaVencim,
			Var_TipoPagoCap,			Var_FrecuenciaCap,				Var_PeriodicidadCap,		Var_FrecuenciaInt,			Var_PeriodicidadInt,
            Var_NumAmortInteres,		Var_MontoCuota,					Var_FechaInhabil,			Var_CalendIrregular,		Var_AjusFecUlVenAmo,
            Var_AjusFecExiVen,			Var_NumTransacSim,				Var_PlazoID,				Var_TipoFondeador,			Var_Refinancia,
            Var_NumAmortizacion
		FROM CREDITOSCONT
		WHERE CreditoID = Par_CreditoID;

		SELECT
			InstitutFondID,					InstitucionID,					NumCtaInstit,			TasaPasiva,				SaldoLinea
		INTO
			Var_InstitutFondID,				Var_InstitucionID,				Var_NumCtaInstit,		Var_TasaPasiva,			Var_SaldoLinea
		FROM LINEAFONDEADOR
			WHERE LineaFondeoID = Var_LineaFondeoID;

		SELECT TipoInstitID INTO Var_TipoInstitID
			FROM INSTITUTFONDEO IFN
				LEFT OUTER JOIN INSTITUCIONES INS ON IFN.InstitucionID 	= INS.InstitucionID
				WHERE  IFN.InstitutFondID	= Var_InstitutFondID;

        SET Var_TipoInstitID:=IFNULL(Var_TipoInstitID,Entero_Cero);

        -- valores para polizas
        SELECT   Cre.ProductoCreditoID,    Cre.ClasiDestinCred, 	Cli.SucursalOrigen,		Des.SubClasifID
			INTO   Var_ProdCreditoID,        Var_Clasificacion,		Var_SucCliente,     	Var_SubClasifica
		FROM  CLIENTES Cli,	DESTINOSCREDITO Des, CREDITOSCONT Cre
			WHERE Cre.CreditoID = Par_CreditoID
				AND Cre.ClienteID = Cli.ClienteID
				AND Cre.DestinoCreID = Des.DestinoCreID;

		SELECT CobraIVAInteres
			INTO Var_PagaIVA
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID=Var_ProdCreditoID;

		SELECT IVA
			INTO Var_IVA
		FROM SUCURSALES
		WHERE SucursalID=Var_SucCliente;

		IF(IFNULL(Var_SaldoLinea,Decimal_Cero) < Par_Monto)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Saldo de la Linea es Insuficiente para el Monto del Credito Pasivo Contingente.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		/*NOTA: Planear para un control de cambios depués que estos datos sean parametrizables, estos datos estan asi ya que en un correo se especifican que para
		el caso de CONSOL asi aplica.*/
		SET Var_ComDispos 			:= 0.0;
		SET Var_IvaComDispos 		:= 0.0;
		SET Var_CobraISR			:= 'S';
		SET Var_TasaISR				:= 0.0;
		SET Var_PagosParciales		:= 'S';
		SET Var_CapitalizaInteres	:= 'N';
		SET Var_PlazoContable		:= 'L';
		SET Var_Folio				:= Par_CreditoID; --  queda pendiente este registrar en pantalla ya que debe ser la relacion con el credito FIRA

		--  Se da de alta el credito Pasivo
		CALL CREDITOFONDEAGROALT(
			Var_LineaFondeoID,		Var_InstitutFondID,			Var_Folio,				Var_TipoCalInteres,			Var_CalcInteresID,
			Var_TasaBase,			Var_SobreTasa,				Var_TasaPasiva,			Var_PisoTasa,				Var_TechoTasa,
			Var_FactorMora,			Var_Monto,					Var_MonedaID,			Var_FechaInicio,			Var_FechaVencim,
			Var_TipoPagoCap,		Var_FrecuenciaCap,			Var_PeriodicidadCap,	Var_NumAmortizacion,		Var_FrecuenciaInt,
			Var_PeriodicidadInt,	Var_NumAmortInteres,		Var_MontoCuota,			Var_FechaInhabil,			Var_CalendIrregular,
			Cadena_Vacia,			Cadena_Vacia,				Entero_Cero,			Entero_Cero,				Var_AjusFecUlVenAmo,
			Var_AjusFecExiVen,		Aud_NumTransaccion,			Var_PlazoID,			Var_PagaIVA,				Var_IVA,
			Var_MargenPag,			Var_InstitucionID,			Cadena_Vacia,			Var_NumCtaInstit,			Var_PlazoContable,
			Var_TipoInstitID,		Var_NacionalidadIns,		Var_FechaContable,		Var_ComDispos,				Var_IvaComDispos,
			Var_CobraISR,			Var_TasaISR,				Var_MargenPriCuota,		Var_CapitalizaInteres,		Var_PagosParciales,
			Var_TipoFondeador,		SalidaSi,					Var_Refinancia,			Ult_Cuotas,					ConstanteNo,
			Par_NumErr,				Par_ErrMen,					Var_CreditoFondeoID,	Par_EmpresaID,				Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_Consecutivo := IFNULL(Var_CreditoFondeoID,Entero_Cero);

		--  Se actualiza ID en tabla de CREDITOSCONT
        UPDATE CREDITOSCONT SET
			CreditoFondeoID= Var_CreditoFondeoID
		WHERE CreditoID = Par_CreditoID;

        -- Actualizar Tabla de CREDITOFONDEO con es contingente y ID garantia
        UPDATE CREDITOFONDEO SET
			SaldoCapVigente		= Par_Monto,
			EsContingente		= SalidaSi,
            TipoGarantiaFIRAID	= Par_GarantiaID
		WHERE CreditoFondeoID = Var_CreditoFondeoID;

		-- Se dan de alta las amortizaciones
        CALL AMORTICREDITOCONTALT(
			Var_CreditoFondeoID,		Aud_NumTransaccion,		Entero_Cero,		Entero_Cero,		Par_Monto,
            Alta_Pasivo,				ConstanteNo,		 	Par_NumErr,   		Par_ErrMen,     	Par_EmpresaID,
            Aud_Usuario,        		Aud_FechaActual,	 	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        -- Actualizacion de intereses
        CALL AMORTIZAFONDEOACT(
			Var_CreditoFondeoID,	Act_TipoActInteres,		Par_TipoCalculoInteres,		ConstanteNo,		Par_NumErr,
            Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        -- Se realiza alta de movimientos operativos
        INSERT INTO CREDITOFONDMOVS(
			CreditoFondeoID, 	AmortizacionID, 	Transaccion, 	FechaOperacion, 	FechaAplicacion,
            TipoMovFonID, 		NatMovimiento, 		MonedaID, 		Cantidad, 			Descripcion,
            Referencia, 		EmpresaID, 			Usuario, 		FechaActual, 		DireccionIP,
            ProgramaID, 		Sucursal, 			NumTransaccion)
		SELECT
			Var_CreditoFondeoID,	Amo.AmortizacionID, 	Aud_NumTransaccion,		Var_FechaSistema,		Var_FechaSistema,
            ConCapital,				Nat_Cargo,				Var_MonedaID,			Amo.SaldoCapVigente,	DescripcionMov,
            Var_NumCtaInstit,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion

		FROM AMORTIZAFONDEO Amo WHERE CreditoFondeoID= Var_CreditoFondeoID
			AND Estatus=ConstanteNo;

		-- Se actualiza la linea de fondeo de credito
		CALL SALDOSLINEAFONACT(
			Var_LineaFondeoID,	Nat_Cargo,			Par_Monto,			ConstanteNo,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        -- Validamos el tipo de garantia para asignar el concepto contable
        IF(Par_GarantiaID= GarantiaFonaga)THEN

			SET Var_ConGaranFira:= 62;
            SET Var_ConGaranCorr:= 63;
        ELSE
			SET Var_ConGaranFira:= 64;
            SET Var_ConGaranCorr:= 65;
        END IF;

        -- Referencia para la poliza
        SET Var_CreditoStr	:= CONCAT("Cred.",CONVERT(Var_CreditoFondeoID, CHAR(20)));

        -- Se genera contabilidad cargo Cuentas de orden dependiendo ndel tipo de garantia Fira.
		SET	Var_Cargos		  := Par_Monto;
		SET	Var_Abonos	      := Decimal_Cero;

		CALL POLIZASCREDITOCONTPRO(
			Par_PolizaID,         Par_EmpresaID,      Var_FechaSistema,    		Par_CreditoID,      Var_ProdCreditoID,
			Var_SucCliente,       Var_ConGaranFira,   Var_Clasificacion,        Var_SubClasifica,   Var_Cargos,
			Var_Abonos,           Var_MonedaID,       DescripcionMov,     		Var_CreditoStr,     ConstanteNo,
			Par_NumErr,			  Par_ErrMen,         Var_ConsecutivoID,    	Aud_Usuario,        Aud_FechaActual,
			Aud_DireccionIP,	  Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

         -- Se genera contabilidad abono Cuentas de orden dependiendo del tipo de garantia Fira.
		SET	Var_Cargos		  := Decimal_Cero ;
		SET	Var_Abonos	      := Par_Monto;

		-- Se genera contabilidad Abono.
        CALL POLIZASCREDITOCONTPRO(
			Par_PolizaID,         Par_EmpresaID,      Var_FechaSistema,    		Par_CreditoID,      Var_ProdCreditoID,
			Var_SucCliente,       Var_ConGaranCorr,   Var_Clasificacion,        Var_SubClasifica,   Var_Cargos,
			Var_Abonos,           Var_MonedaID,       DescripcionMov,     		Var_CreditoStr,     ConstanteNo,
			Par_NumErr,			  Par_ErrMen,         Var_ConsecutivoID,    	Aud_Usuario,        Aud_FechaActual,
			Aud_DireccionIP,	  Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr			:= Entero_Cero;
		SET Par_ErrMen			:=CONCAT('Credito Pasivo Agregado Exitosamente: ', Var_CreditoFondeoID);
		SET Var_Consecutivo		:= Var_CreditoFondeoID;
		SET Var_Control			:= 'CreditoID';

	END ManejoErrores;

	IF(Par_Salida=SalidaSi)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Consecutivo AS Consecutivo,
				Var_Control AS Control;
	END IF;
END TerminaStore$$