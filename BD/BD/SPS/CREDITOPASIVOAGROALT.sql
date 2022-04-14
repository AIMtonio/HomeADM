-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOPASIVOAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOPASIVOAGROALT`;

DELIMITER $$
CREATE PROCEDURE `CREDITOPASIVOAGROALT`(
	/*SP para dar de alta las ministraciones de credito*/
	Par_CreditoID				BIGINT(20),				# Numero de Credito
	Par_TipoCalculoInteres		CHAR(1),				# Tipo de Calculo de interes fechaPactada	: P, fechaReal: R
	Par_TipoGrupo				VARCHAR(2),				# NF: No Formal  G: Global  Cadena_Vacia: No Aplica
	Par_Salida					CHAR(1),				# Tipo de Salida S. Si N. No
	INOUT	Par_NumErr			INT(11),				# Numero de Error

	INOUT	Par_ErrMen			VARCHAR(400),			# Mensaje de Error
	INOUT 	Par_CreditoFondeoID	BIGINT(20),				# Número de credito Pasivo
	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			# Variable con el ID del control de Pantalla
	DECLARE Var_FechaSistema		DATE;					# Fecha Actual del Sistema
	DECLARE Var_Consecutivo			VARCHAR(50);			# Variable campo de pantalla
	DECLARE Var_CreditoFondeoID		BIGINT(20);				# Numero de Credito de Fonde (Credito Pasivo)
	#Variables para los datos extraidos de la tabla de creditos
	DECLARE Var_LineaFondeoID   	INT(11);				# Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	DECLARE Var_InstitutFondID		INT(11);				# id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
	DECLARE Var_Folio		   		VARCHAR(150);			# Folio del Fondeo corresponde con lo que da la inst de fondeo.
	DECLARE Var_TipoCalInteres		INT(11);				# 1 .- Saldos Insolutos 2 .- Monto Original (Saldos Globales)
	DECLARE Var_CalcInteresID		INT(11);				# Formula para el calculo de Interes

	DECLARE Var_TasaBase			INT(11);				# Tasa Base, necesario dependiendo de la Formula
	DECLARE Var_SobreTasa			DECIMAL(12,4);			# Si es formula dos (Tasa base mas puntos), aqui se definen  Los puntos
	DECLARE Var_TasaFija			DECIMAL(12,4);			# Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha tasa fija
	DECLARE Var_PisoTasa			DECIMAL(12,4);			# Piso, Si es formula tres
	DECLARE Var_TechoTasa			DECIMAL(12,4);			# Techo, Si es formula tres

	DECLARE Var_FactorMora			DECIMAL(12,4);			# Factor de Moratorio
	DECLARE Var_Monto				DECIMAL(14,2);			# Monto del Credito de Fondeo
	DECLARE Var_MonedaID			INT(11);				# moneda
	DECLARE Var_FechaInicio			DATE;					# Fecha de Inicio
	DECLARE Var_FechaVencim			DATE;					# Fecha de Vencimiento

	DECLARE Var_TipoPagoCap			CHAR(1);				# Tipo de Pago de Capital C .-Crecientes I .- Iguales L .-Libres
	DECLARE Var_FrecuenciaCap		CHAR(1);				# Frecuencia de Pago de las Amortizaciones de Capital S .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo B.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual
	DECLARE Var_PeriodicidadCap		INT(11);				# Periodicidad de Capital en dias
	DECLARE Var_NumAmortizacion		INT(11);				# Numero de Amortizaciones o Cuotas (de Capital)
	DECLARE Var_FrecuenciaInt		CHAR(1);				# Frecuencia de Interes S .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo B.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual

	DECLARE Var_PeriodicidadInt		INT(11);				# Periodicidad de Interes en dias
	DECLARE Var_NumAmortInteres		INT(11);				# Numero de Amortizaciones (cuotas) de Interes
	DECLARE Var_MontoCuota			DECIMAL(12,2);			# Monto de la Cuota
	DECLARE Var_FechaInhabil		CHAR(1);				# Fecha Inhabil: S.-Siguiente  A.-Anterior
	DECLARE Var_CalendIrregular		CHAR(1);				# Calendario Irregular S.- Si N.-No

	DECLARE Var_DiaPagoCapital		CHAR(1);				# Dia de pago Capital F-Pago Final de mes\ A-Por aniversario
	DECLARE Var_DiaPagoInteres		CHAR(1); 				# Dia de pago Interes F.-Pago final del mes A.-Por aniversario
	DECLARE Var_DiaMesInteres		INT;					# Dia del mes interes
	DECLARE Var_DiaMesCapital		INT;					# Dia del mes Capital
	DECLARE Var_AjusFecUlVenAmo		CHAR(1); 				# Ajustar la fecha de vencimiento de la ultima amortizacion a fecha de vencimiento de credito S.-Si  N.-No

	DECLARE Var_AjusFecExiVen		CHAR(1);				# Ajustar Fecha de exigibilidad a fecha de vencimiento S.-Si  N.-No
	DECLARE Var_NumTransacSim		BIGINT(20);				# Numero de transaccion en el simulador de Amortizaciones
	DECLARE Var_PlazoID				VARCHAR(20);			# Plazo del credito Corresponde con la tabla CREDITOSPLAZOS
	DECLARE Var_PagaIVA				CHAR(1);				# indica si paga IVA valores :  Si = "S" / No = "N")
	DECLARE Var_IVA					DECIMAL(12,4);			# indica el valor del iva si es que Paga IVA = si

	DECLARE Var_MargenPag			DECIMAL(12,2);			# Margen para Pagos Iguales.
	DECLARE Var_InstitucionID		INT(11);				# Numero de Institucion (INSTITUCIONES)
	DECLARE Var_CuentaClabe			VARCHAR(18);			# Cuenta Clabe de la institucion
	DECLARE Var_NumCtaInstit		VARCHAR(20);			# Numero de Cuenta Bancaria.
	DECLARE Var_PlazoContable		CHAR(1);				# plazo contable C.- Corto plazo L.- Largo Plazo

	DECLARE Var_TipoInstitID		INT(11);				# Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
	DECLARE Var_NacionalidadIns		CHAR(1);				# Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON*/
	DECLARE Var_FechaContable		DATE;					# Indica la fecha contable
	DECLARE Var_ComDispos			DECIMAL(12,2);			# Comision por disposicion.
	DECLARE Var_IvaComDispos		DECIMAL(12,2);			# IVA Comision por disposicion.

	DECLARE Var_CobraISR			CHAR(1);				# Indica si cobra o no ISR Si = S No = N
	DECLARE Var_TasaISR				DECIMAL(12,2);			# Tasa del ISR
	DECLARE Var_TasaPasiva			DECIMAL(14,4);			# Tasa del ISR
	DECLARE Var_MargenPriCuota		INT(11);				# Margen para calcular la primer cuota
	DECLARE Var_CapitalizaInteres	CHAR(1);
	DECLARE Var_PagosParciales		CHAR(1);
	DECLARE Var_TipoFondeador		CHAR(1);
	DECLARE Var_AfectacionConta		CHAR(1);
	DECLARE Par_Consecutivo			BIGINT(12);
	DECLARE Var_Refinancia			CHAR(1);				# Refinanciamiento de Intereses S:Si N:No
	DECLARE Var_TipoCancelacion		CHAR(1);				# Tipo de Cancelacion de la Ministración DEFAULT U: Ultimas Cuotas
	DECLARE Var_GrupoID 			INT(11);
	DECLARE Var_TipoOperacionGrupo	VARCHAR(2);				# Tipo de Operación del Grupo
	DECLARE Var_PorcentajeIVA		DECIMAL(12,2);			# Porcentaje de IVA

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE	Decimal_Cero			DECIMAL;				# Decimal Cero
	DECLARE	SalidaNo				CHAR(1);				# Constante SI
	DECLARE	SalidaSi				CHAR(1);				# Constante NO
	DECLARE	EstatusInactivo			CHAR(1);				# Estatus Inactivo
	DECLARE	EstatusIntegrantesAct	CHAR(1);				# Estatus de los Integrantes Activos
	DECLARE TipoNoFormalGrupo		VARCHAR(2);				# Grupo de tipo de operacion no formal
	DECLARE TipoGlobalGrupo			VARCHAR(2);				# Grupo de tipo de operacion global
	DECLARE RelacionVigente			CHAR(1);
	DECLARE Si_PagaIVA				CHAR(1);				# Si paga IVA
	DECLARE Cons_Si					CHAR(1);				# Constante SI
	DECLARE Cons_No					CHAR(1);				# Constante NO
	DECLARE Estatus_Vigente			CHAR(1);				# Estatus Vigente

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	EstatusInactivo				:= 'I';
	SET Var_FechaSistema 			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET SalidaSi					:= 'S';
	SET RelacionVigente				:= 'V';
	SET TipoNoFormalGrupo			:= 'NF';				# Grupo de tipo de operacion no formal
	SET TipoGlobalGrupo				:= 'G';					# Grupo de tipo de operacion global
	SET EstatusIntegrantesAct		:= 'A';
	SET Si_PagaIVA					:= 'S';
	SET Cons_Si						:= 'S';
	SET Cons_No						:= 'N';
	SET Estatus_Vigente				:= 'V';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOPASIVOAGROALT');
			SET Var_Control := 'sqlException';
		END;

		SET Aud_FechaActual := NOW();
		SET Par_TipoGrupo		:= IFNULL(Par_TipoGrupo, Cadena_Vacia);
		SET Var_PorcentajeIVA :=  (SELECT IVA FROM SUCURSALES WHERE SucursalID = 1);

		IF NOT EXISTS (SELECT CreditoID FROM RELCREDPASIVOAGRO WHERE CreditoID = Par_CreditoID AND EstatusRelacion = Estatus_Vigente) THEN
			SELECT
				LineaFondeo,				InstitFondeoID,					Var_Folio,					TipoCalInteres,				CalcInteresID,
				TasaBase,					SobreTasa,						TasaFija,					PisoTasa,					TechoTasa,
				FactorMora,					MontoCredito,					MonedaID,					FechaInicio,				FechaVencimien,
				TipoPagoCapital,			FrecuenciaCap,					PeriodicidadCap,			FrecuenciaInt,				PeriodicidadInt,
				NumAmortInteres,			MontoCuota,						FechaInhabil,				CalendIrregular,			DiaPagoCapital,
				DiaPagoInteres,				DiaMesInteres,					DiaMesCapital,				AjusFecUlVenAmo,			AjusFecExiVen,
				NumTransacSim,				PlazoID,						Si_PagaIVA,					Var_PorcentajeIVA,			Var_MargenPag,
				Var_InstitucionID,			CuentaCLABE,					Var_NumCtaInstit,			Var_PlazoContable,			Var_TipoInstitID,
				Var_NacionalidadIns,		Var_FechaContable,				Var_ComDispos,				Var_IvaComDispos,			Var_CobraISR,
				Var_TasaISR,				Var_MargenPriCuota,				Var_CapitalizaInteres,		Var_PagosParciales,			Refinancia,
				TipoCancelacion,			GrupoID,						NumAmortizacion
				INTO
				Var_LineaFondeoID,			Var_InstitutFondID,				Var_Folio,					Var_TipoCalInteres,			Var_CalcInteresID,
				Var_TasaBase,				Var_SobreTasa,					Var_TasaFija,				Var_PisoTasa,				Var_TechoTasa,
				Var_FactorMora,				Var_Monto,						Var_MonedaID,				Var_FechaInicio,			Var_FechaVencim,
				Var_TipoPagoCap,			Var_FrecuenciaCap,				Var_PeriodicidadCap,		Var_FrecuenciaInt,			Var_PeriodicidadInt,
				Var_NumAmortInteres,		Var_MontoCuota,					Var_FechaInhabil,			Var_CalendIrregular,		Var_DiaPagoCapital,
				Var_DiaPagoInteres,			Var_DiaMesInteres,				Var_DiaMesCapital,			Var_AjusFecUlVenAmo,		Var_AjusFecExiVen,
				Var_NumTransacSim,			Var_PlazoID,					Var_PagaIVA,				Var_IVA,					Var_MargenPag,
				Var_InstitucionID,			Var_CuentaClabe,				Var_NumCtaInstit,			Var_PlazoContable,			Var_TipoInstitID,
				Var_NacionalidadIns,		Var_FechaContable,				Var_ComDispos,				Var_IvaComDispos,			Var_CobraISR,
				Var_TasaISR,				Var_MargenPriCuota,				Var_CapitalizaInteres,		Var_PagosParciales,			Var_Refinancia,
				Var_TipoCancelacion,		Var_GrupoID,					Var_NumAmortizacion
				FROM CREDITOS
					WHERE CreditoID = Par_CreditoID;

            IF( Var_FechaInicio < Var_FechaSistema) THEN
				SET Var_FechaInicio := Var_FechaSistema;
            END IF;

			SET Var_NacionalidadIns := IFNULL(Var_NacionalidadIns, Cons_No);
			SET Var_MargenPriCuota 	:= IFNULL(Var_MargenPriCuota, Entero_Cero);
			SET Var_MargenPag 	:= IFNULL(Var_MargenPag, Entero_Cero);

			IF(Par_TipoGrupo != Cadena_Vacia) THEN
				SET Var_Monto := (SELECT SUM(Cre.MontoCredito)
									FROM INTEGRAGRUPOSCRE Inte INNER JOIN SOLICITUDCREDITO Sol ON Inte.GrupoID	= Var_GrupoID
										AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
										INNER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
											WHERE Inte.GrupoID	= Var_GrupoID AND Inte.Estatus = EstatusIntegrantesAct
											GROUP BY Inte.GrupoID);
				SET Var_Monto := IFNULL(Var_Monto, Entero_Cero);
			END IF;

			SELECT
				InstitutFondID,					InstitucionID,					NumCtaInstit,			TasaPasiva
				INTO
					Var_InstitutFondID,				Var_InstitucionID,				Var_NumCtaInstit,		Var_TasaPasiva
				FROM LINEAFONDEADOR
					WHERE LineaFondeoID = Var_LineaFondeoID;

			SET Var_TasaPasiva := (SELECT TasaPasiva
									FROM CREDTASAPASIVAAGRO
									WHERE CreditoID = Par_CreditoID
										ORDER BY FechaActual DESC LIMIT 1);


			-- Si no han modificado la tasa pasiva desde pantalla, se toma de la línea de fondeo.
			IF(IFNULL(Var_TasaPasiva, Entero_Cero) = Entero_Cero)THEN
				SELECT
						TasaPasiva
					INTO
						Var_TasaPasiva
					FROM LINEAFONDEADOR
						WHERE LineaFondeoID = Var_LineaFondeoID;
			END IF;

			SET Var_TasaPasiva := IFNULL(Var_TasaPasiva, Entero_Cero);

			SELECT
				TipoInstitID,		IFN.TipoFondeador
				INTO
				Var_TipoInstitID,	Var_TipoFondeador
				FROM INSTITUTFONDEO IFN
					LEFT OUTER JOIN INSTITUCIONES INS ON IFN.InstitucionID 	= INS.InstitucionID
					WHERE  IFN.InstitutFondID	= Var_InstitutFondID;

			SET Var_TipoInstitID  := IFNULL(Var_TipoInstitID, Entero_Cero);

			IF( Var_TipoInstitID = Entero_Cero ) THEN
				SET	Par_NumErr 		:= 1;
				SET	Par_ErrMen 		:= 'La Instituci&oacute;n de fondeo no Existe.';
				SET	Var_Consecutivo := Entero_Cero;
				SET Var_Control		:= Cadena_Vacia;
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
			SET Var_Folio				:= Par_CreditoID; # queda pendiente este registrar en pantalla ya que debe ser la relacion con el credito FIRA
			SET Var_TipoFondeador		:= 'F';
			SET Var_CuentaClabe 		:= IFNULL(Var_CuentaClabe, Cadena_Vacia);

			# Se da de alta el credito Pasivo
			CALL CREDITOFONDEAGROALT(
				Var_LineaFondeoID,		Var_InstitutFondID,			Var_Folio,				Var_TipoCalInteres,			Var_CalcInteresID,
				Var_TasaBase,			Var_SobreTasa,				Var_TasaPasiva,			Var_PisoTasa,				Var_TechoTasa,
				Var_FactorMora,			Var_Monto,					Var_MonedaID,			Var_FechaInicio,			Var_FechaVencim,
				Var_TipoPagoCap,		Var_FrecuenciaCap,			Var_PeriodicidadCap,	Var_NumAmortizacion,		Var_FrecuenciaInt,
				Var_PeriodicidadInt,	Var_NumAmortInteres,		Var_MontoCuota,			Var_FechaInhabil,			Var_CalendIrregular,
				Var_DiaPagoCapital,		Var_DiaPagoInteres,			Var_DiaMesInteres,		Var_DiaMesCapital,			Var_AjusFecUlVenAmo,
				Var_AjusFecExiVen,		Var_NumTransacSim,			Var_PlazoID,			Var_PagaIVA,				Var_IVA,
				Var_MargenPag,			Var_InstitucionID,			Var_CuentaClabe,		Var_NumCtaInstit,			Var_PlazoContable,
				Var_TipoInstitID,		Var_NacionalidadIns,		Var_FechaContable,		Var_ComDispos,				Var_IvaComDispos,
				Var_CobraISR,			Var_TasaISR,				Var_MargenPriCuota,		Var_CapitalizaInteres,		Var_PagosParciales,
				Var_TipoFondeador,		Cons_Si,					Var_Refinancia,			Var_TipoCancelacion,		Cons_No,
				Par_NumErr,				Par_ErrMen,					Var_CreditoFondeoID,	Aud_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_Consecutivo := IFNULL(Var_CreditoFondeoID,Entero_Cero);
			SET Par_CreditoFondeoID := IFNULL(Var_CreditoFondeoID,Entero_Cero);


			IF(Par_TipoGrupo = Cadena_Vacia) THEN
				# Se da de alta la relacion del credito Pasivo con el Credito Activo
				INSERT INTO RELCREDPASIVOAGRO(
					CreditoID,				CreditoFondeoID,		EstatusRelacion,	EmpresaID,		Usuario,				FechaActual,
					DireccionIP,			ProgramaID,				Sucursal,		NumTransaccion)
				VALUES(
					Par_CreditoID,			Var_CreditoFondeoID,	Estatus_Vigente,	Aud_EmpresaID,	Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);
			  ELSE
				# Se da de alta la relacion de los créditos activos de un grupo a un pasivo
				INSERT INTO RELCREDPASIVOAGRO(
					CreditoID,				CreditoFondeoID,		EstatusRelacion,	EmpresaID,		Usuario,				FechaActual,
					DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
				SELECT
					Cre.CreditoID,			Var_CreditoFondeoID,	Estatus_Vigente,	Aud_EmpresaID,	Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion
					FROM INTEGRAGRUPOSCRE Inte INNER JOIN SOLICITUDCREDITO Sol ON Inte.GrupoID	= Var_GrupoID
						AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
						INNER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
							WHERE Inte.GrupoID	= Var_GrupoID AND Inte.Estatus = EstatusIntegrantesAct;
			END IF;
		  ELSE
			SET Par_CreditoFondeoID := (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO
											WHERE CreditoID = Par_CreditoID AND EstatusRelacion = Estatus_Vigente);
		END IF;

		SET Par_NumErr			:= 0;
		SET Par_ErrMen			:= CONCAT('Credito Pasivo Agregado Exitosamente: ', Par_CreditoFondeoID);
	END ManejoErrores;

	IF(Par_Salida=SalidaSi)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Consecutivo AS Consecutivo,
				Var_Control AS Control;
	END IF;
END TerminaStore$$