-- SP CARRECLACONTAFONDEOPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CARRECLACONTAFONDEOPRO;

DELIMITER $$


CREATE PROCEDURE CARRECLACONTAFONDEOPRO(
	-- Stored Procedure para dar de alta el cambio de fondeo de credito
	Par_CreditoID						BIGINT(12),		-- ID del credito de activo (Une con tabla CREDITOS).
	Par_CreditoFondeoID					BIGINT(20),		-- ID de Credito de Pasivo (Une con tabla CREDITOFONDEO).
	Par_NumTransaccionPro				BIGINT(20),		-- Numero de Transaccion para el proceso masivo
	Par_PolizaID						INT(11),		-- ID de la Poliza

	Par_NumPro 							INT(11),		-- Numero de Proceso

	Par_Salida							CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr					INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),		-- ID de la Empresa
	Aud_Usuario							INT(11),		-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,		-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),	-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),	-- Identificador del Programa
	Aud_Sucursal						INT(11),		-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)		-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;			-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);			-- Salida Si
	DECLARE Cons_SI						CHAR(1);			-- Salida Si
	DECLARE Cons_NO						CHAR(1);			-- Salida Si
	DECLARE RecursoFondeador    		CHAR(1);          	-- Constante Recurso Fondeador
    DECLARE RecursoPropio       		CHAR(1);          	-- Constante Recurso Propio
	DECLARE Est_Pagado 					CHAR(1);			-- Estatus de Pagado
	DECLARE Est_Cancelado 				CHAR(1);			-- Estatus de Cancelado
	DECLARE Est_RelacionActiva			CHAR(1);			-- Estatus de la relacion entre el credito Activo y pasivo (A= Activa)
	DECLARE Est_RelacionVencida			CHAR(1);			-- Estatus de la relacion entre el credito Activo y pasivo (V= Vencida)
	DECLARE Est_ErrorVal				CHAR(1);			-- Estatus de Error en validacion
	DECLARE Est_SinVal					CHAR(1);			-- Estatus de Registro sin validacion
	DECLARE Car_CapVigente				INT(11);			-- Concepto de Capital Vigente de CONCEPTOSCARTERA
	DECLARE Car_CapAtrasado				INT(11);			-- Concepto de Capital Atrasado de CONCEPTOSCARTERA
	DECLARE Car_CapVencido				INT(11);			-- Concepto de Capital Vencido de CONCEPTOSCARTERA
	DECLARE Car_CapVencidoNoExi			INT(11);			-- Concepto de Capital Vencido No Exigible de CONCEPTOSCARTERA
	DECLARE Car_IntOrdinario 			INT(11);			-- Concepto de Interes Ordinario de CONCEPTOSCARTERA
	DECLARE Car_IntAtrasado 			INT(11);			-- Concepto de Interes Atrasado de CONCEPTOSCARTERA
	DECLARE Car_IntVencido 				INT(11);			-- Concepto de Interes Vencido de CONCEPTOSCARTERA
	DECLARE Car_IntMoraDev				INT(11);			-- Concepto de Interes Moratorio de CONCEPTOSCARTERA
	DECLARE Car_IntMoraVen				INT(11);			-- Concepto de Interes Moratorio Vencido de CONCEPTOSCARTERA
	DECLARE Car_IntMoraCVen				INT(11);			-- Concepto de Interes Moratorio Cartera Vencida de CONCEPTOSCARTERA
	DECLARE Car_ComFaltaPag				INT(11);			-- Concepto de Comision por Falta de pago de CONCEPTOSCARTERA
	DECLARE Car_ComAnual				INT(11);			-- Concepto de Comision por anualidad de CONCEPTOSCARTERA
	DECLARE SubCtaFondeador				CHAR(3);			-- SubCuenta de fondeador de CUENTASMAYOR
	DECLARE ProcesoContable				VARCHAR(50);		-- Nombre del Proceso Contable
	DECLARE TipoInstruCred				INT(11);			-- Tipo de Instrumento Credito
	DECLARE CambioFuenteUnico			INT(11);			-- Proceso de Cambio de Fuente de Fondeo Unico
	DECLARE DescrProceso				VARCHAR(50);		-- Nombre del Procedimiento
	DECLARE CambioFuenteMasivo			INT(11);
	DECLARE EtiquetaEnviado 			CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_EstatusCre				CHAR(1);			-- Estatus del Credito
	DECLARE Var_Control					VARCHAR(50);		-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo
	DECLARE Var_CreditoID				BIGINT(12);			-- Variable del numero del crédito
	DECLARE Var_CreditoFondeoID			BIGINT(20);			-- Variable del Credito pasivo FOndeo
	DECLARE Var_LineaFondeoID			INT(11);			-- Variable de Linea de Fondeo
	DECLARE Var_RelCreditoPasivoID		BIGINT(12);			-- Variable del consecutivo del de la tabla RELCREDPASIVO
	DECLARE Var_CounRelCredPasID		INT(11);			-- Variable contador
	DECLARE Var_CreditoFondeoActID		BIGINT(20);			-- ID del Credito de Fondeo actual para el Credito
	DECLARE Var_MonedaID				INT(11);			-- ID de la Moneda
	DECLARE Var_SaldoCapVigent			DECIMAL(14,2);		-- Saldo Capital Vigente	
	DECLARE Var_SaldoCapAtrasad			DECIMAL(14,2);		-- Saldo de Capital Atrasado
	DECLARE Var_SaldoCapVencido			DECIMAL(14,2);		-- Saldo de Capital Vencido
	DECLARE Var_SaldCapVenNoExi			DECIMAL(14,2);		-- Saldo de Capital Vencido no Exigible
	DECLARE Var_SaldoInterOrdin			DECIMAL(14,4);		-- Saldo de Interes Ordinario
	DECLARE Var_SaldoInterAtras			DECIMAL(14,4);		-- Saldo de Interes Atrasado
	DECLARE Var_SaldoInterVenc			DECIMAL(14,4);		-- Saldo de Interes Vencido
	DECLARE Var_SaldoInterProvi			DECIMAL(14,4);		-- Saldo de Interes Provisionado
	DECLARE Var_SaldoMoratorios			DECIMAL(14,2);		-- Saldo de Moratorios
	DECLARE Var_SaldComFaltPago			DECIMAL(14,2);		-- Saldo de Comision por Falta de Pago
	DECLARE Var_SaldoOtrasComis			DECIMAL(14,2);		-- Saldo de Otras Comisiones
	DECLARE Var_SaldoMoraVencido		DECIMAL(14,2);		-- Saldo de Moratorio Vencido
	DECLARE Var_SaldoMoraCarVen			DECIMAL(14,2);		-- Saldo de Moratorio Cartera Vencida
	DECLARE Var_SaldoComAnual			DECIMAL(14,2);		-- Saldo de Comision Anual
	DECLARE Var_InstitFondeoNueID		INT(11);			-- Institicion de Fondeo ID Nuevo
	DECLARE Var_InstitFondeoActID		INT(11);			-- Institicion de Fondeo ID Actual
	DECLARE Var_FechaSistema			DATE;				-- Fecha Actual del Sistema
	DECLARE Var_ValidarEtiqCambFond		CHAR(1);			-- Validar cambio de fuente de fondeo
	DECLARE Var_EtiquetaFondeo			CHAR(1);			-- Etiqueta de fondeo
	DECLARE Var_CantRegError 			INT(11);			-- Cantidad de registros con error.
	DECLARE Var_CantRegProc 			INT(11);			-- Cantidad de registros a procesar.
	

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					:= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						:= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							:= 'S';				-- Salida Si
	SET Cons_NO							:= 'N';				-- Salida Si
	SET RecursoFondeador				:= 'F';
	SET RecursoPropio       			:= 'P';
	SET Est_Pagado						:= 'P';				-- Estatus de Pagado
	SET Est_Cancelado 					:= 'P';				-- Estatus de Cancelado
	SET Est_RelacionActiva				:= 'A';				-- Estatus de la relacion entre el credito Activo y pasivo (A= Activa)
	SET Est_RelacionVencida				:= 'V';				-- Estatus de la relacion entre el credito Activo y pasivo (V= Vencida)
	SET Est_ErrorVal 					:= 'E';				-- Estatus de Error en validacion
	SET Est_SinVal 						:= 'R';				-- Estatus de Registro sin validacion
	SET Car_CapVigente					:= 1;				-- Concepto de Capital Vigente de CONCEPTOSCARTERA
	SET Car_CapAtrasado					:= 2;				-- Concepto de Capital Atrasado de CONCEPTOSCARTERA
	SET Car_CapVencido 					:= 3;				-- Concepto de Capital Vencido de CONCEPTOSCARTERA		
	SET Car_CapVencidoNoExi				:= 4;				-- Concepto de Capital Vencido no exigible de CONCEPTOSCARTERA
	SET Car_IntOrdinario				:= 19;				-- Concepto de Interes Ordinario de CONCEPTOSCARTERA
	SET Car_IntAtrasado					:= 20;				-- Concepto de Interes Atrasado de CONCEPTOSCARTERA
	SET Car_IntVencido					:= 21;				-- Concepto de Interes Vencido de CONCEPTOSCARTERA
	SET Car_IntMoraDev					:= 33;				-- Concepto de Interes Moratorio Devengado de CONCEPTOSCARTERA
	SET Car_IntMoraVen 					:= 34;				-- Concepto de Interes Moratorio Vencido de CONCEPTOSCARTERA
	SET Car_IntMoraCVen					:= 35;				-- Concepto de Interes Moratorio Car Vencido de CONCEPTOSCARTERA
	SET Car_ComFaltaPag					:= 7;				-- Concepto de Comision por falta de pago de CONCEPTOSCARTERA
	SET Car_ComAnual					:= 56;				-- Concepto de Comision por anualidad de CONCEPTOSCARTERA
	SET SubCtaFondeador					:= '&FD';			-- SubCuenta de fondeador de CUENTASMAYOR
	SET ProcesoContable					:= 'CARRECLACONTAFONDEOPRO'; -- Nombre del Proceso Contable
	SET TipoInstruCred					:= 11;				-- Tipo de Instrumento Credito
	SET CambioFuenteUnico				:= 1;				-- Proceso de Cambio de Fuente de Fondeo Unico
	SET CambioFuenteMasivo				:= 2;				-- Proceso de cambio de fuente de fondeo masivo
	SET DescrProceso					:= 'Cambio Fuente Fondeo'; -- Nombre del Procedimiento
	SET EtiquetaEnviado 				:= 'E';
	SET Aud_FechaActual					:= NOW();
	-- Declaracion de Valores Default
	SET Par_CreditoID					:= IFNULL(Par_CreditoID ,Entero_Cero);
	SET Par_CreditoFondeoID				:= IFNULL(Par_CreditoFondeoID ,Entero_Cero);

	ManejoErrores:BEGIN
		
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-RELCREDPASIVOPRO");
			SET Var_Control = 'sqlException';
		END;
		

		IF(Par_NumPro = CambioFuenteUnico) THEN
			IF(Par_CreditoID = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Especifique el Numero de Credito a Fondear.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT 		CreditoID,			Estatus
				INTO 	Var_CreditoID,		Var_EstatusCre
				FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

			IF(IFNULL(Var_CreditoID, Entero_Cero ) = Entero_Cero) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'El Numero de Credito a Fondear No Existe.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_EstatusCre IN (Est_Pagado, Est_Cancelado)) THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'Estatus del Credito no valido.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_CreditoFondeoID <> Entero_Cero) THEN
				SELECT 		CreditoFondeoID
					INTO 	Var_CreditoFondeoID
					FROM CREDITOFONDEO
					WHERE CreditoFondeoID = Par_CreditoFondeoID;

				IF(IFNULL(Var_CreditoFondeoID, Entero_Cero ) = Entero_Cero) THEN
					SET Par_NumErr := 4;
					SET Par_ErrMen := 'El Numero de Credito de Pasivo a Fondear No Existe.';
					SET Var_Control := 'creditoFondeoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SELECT 		FechaSistema, ValidarEtiqCambFond
				INTO 	Var_FechaSistema, Var_ValidarEtiqCambFond
				FROM PARAMETROSSIS;
			IF Var_ValidarEtiqCambFond = SalidaSI THEN 
				SELECT EtiquetaFondeo INTO Var_EtiquetaFondeo FROM CREDITOS WHERE CreditoID = Par_CreditoID;
				IF Var_EtiquetaFondeo = Cons_NO THEN
					SET Par_NumErr := 5;
					SET Par_ErrMen := 'Credito no enviado';
					SET Var_Control := 'creditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SELECT 		REL.CreditoFondeoID,		FON.InstitutFondID			
				INTO 	Var_CreditoFondeoActID,		Var_InstitFondeoActID	
				FROM RELCREDPASIVO REL
				INNER JOIN CREDITOFONDEO FON ON FON.CreditoFondeoID = REL.CreditoFondeoID
				WHERE CreditoID = Par_CreditoID
				AND EstatusRelacion = Est_RelacionActiva;

			SET Var_CreditoFondeoActID := IFNULL(Var_CreditoFondeoActID, Entero_Cero);

			SELECT	 	MonedaID,				SaldoCapVigent,			SaldoCapAtrasad,		SaldoCapVencido,		SaldCapVenNoExi,
						SaldoInterOrdin,		SaldoInterAtras,		SaldoInterVenc,			SaldoInterProvi,		SaldoMoratorios,
						SaldComFaltPago,		SaldoOtrasComis,		SaldoMoraVencido,		SaldoMoraCarVen,		SaldoComAnual
				INTO 	Var_MonedaID,			Var_SaldoCapVigent,		Var_SaldoCapAtrasad,	Var_SaldoCapVencido,	Var_SaldCapVenNoExi,		
						Var_SaldoInterOrdin,	Var_SaldoInterAtras,	Var_SaldoInterVenc,		Var_SaldoInterProvi,	Var_SaldoMoratorios,
						Var_SaldComFaltPago,	Var_SaldoOtrasComis,	Var_SaldoMoraVencido,	Var_SaldoMoraCarVen,	Var_SaldoComAnual
				FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

			SET Var_InstitFondeoNueID :=0;
			IF(Par_CreditoFondeoID <> 0 ) THEN
				SELECT 		InstitutFondID,				LineaFondeoID
					INTO 	Var_InstitFondeoNueID,		Var_LineaFondeoID
					FROM CREDITOFONDEO
					WHERE CreditoFondeoID = Par_CreditoFondeoID;
			END IF;
			
			-- Llenamos la tabla temporal de reclasificaciones
			DELETE FROM TMP_CARDETPOLIZA WHERE NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Capital Vigente
			IF(Var_SaldoCapVigent > Entero_Cero) THEN
				-- 1.- Cargo de Capital Vigente la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapVigente, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldoCapVigent,			Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Capital Vigente a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapVigente, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoCapVigent,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;
			
			-- Insertamos los movimientos de Capital Atrasado
			IF(Var_SaldoCapAtrasad > Entero_Cero) THEN
				-- 1.- Cargo de Capital Atrasado a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapAtrasado, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldoCapAtrasad,		Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Capital Atrasado a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapAtrasado, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoCapAtrasad,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Capital Vencido
			IF(Var_SaldoCapVencido > Entero_Cero) THEN
				-- 1.- Cargo de Capital Vencido a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapVencido, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldoCapVencido,		Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Capital Vencido a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapVencido, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoCapVencido,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Capital Vencido no Exigible
			IF(Var_SaldCapVenNoExi > Entero_Cero) THEN
				-- 1.- Cargo de Capital Vencido a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapVencidoNoExi, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldCapVenNoExi,		Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Capital Vencido a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_CapVencidoNoExi, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldCapVenNoExi,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Interes Ordinario
			IF(Var_SaldoInterOrdin > Entero_Cero) THEN
				-- 1.- Cargo de Interes Ordinario a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntOrdinario, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldoInterOrdin,		Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Interes Ordinario a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntOrdinario, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoInterOrdin,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Interes Atrasado
			IF(Var_SaldoInterAtras > Entero_Cero) THEN
				-- 1.- Cargo de Interes Atrasado a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntAtrasado, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldoInterAtras,			Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Interes Atrasado a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntAtrasado, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoInterAtras,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Interes Vencido
			IF(Var_SaldoInterVenc > Entero_Cero) THEN
				-- 1.- Cargo de Interes Vencido a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		MonedaID,			Cargos,						Abonos,
							Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,			NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntVencido, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							Par_CreditoID,		Var_MonedaID,		Var_SaldoInterVenc,			Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion;

				-- 2.- Abono de Interes Vencido a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntVencido, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoInterVenc,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Interes Provisionado
			IF(Var_SaldoInterProvi > Entero_Cero) THEN
				-- 1.- Cargo de Interes Provisionado (Ordinario) a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntOrdinario, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							CONVERT(Par_CreditoID, CHAR),		
							Var_MonedaID,		Var_SaldoInterProvi,	Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;

				-- 2.- Abono de Interes Provisionado (Ordinario) a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntOrdinario, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoInterProvi,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Interes Moratorio (Pendiente: Cta. Orden Moratorios - Corr. Cta Orden Moratorios)
			IF(Var_SaldoMoratorios > Entero_Cero) THEN
				-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraDev, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							CONVERT(Par_CreditoID, CHAR),		
							Var_MonedaID,		Var_SaldoMoratorios,	Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;

				-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraDev, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoMoratorios,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;
			
			-- Insertamos los movimientos de Comision por falta de Pago (Pendiente: Cta. Orden Comision Falta Pago - Corr. Cta. Orden Com. Falta Pago)
			IF(Var_SaldComFaltPago > Entero_Cero) THEN
				-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraDev, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							CONVERT(Par_CreditoID, CHAR),		
							Var_MonedaID,		Var_SaldComFaltPago,	Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;

				-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraDev, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldComFaltPago,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de otras comisiones

			-- Insertamos los movimientos de Interes Moratorio Vencido
			IF(Var_SaldoMoraVencido > Entero_Cero) THEN
				-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraVen, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							CONVERT(Par_CreditoID, CHAR),		
							Var_MonedaID,		Var_SaldoMoraVencido,	Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;

				-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraVen, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoMoraVencido,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Interes Moratorio Vencido
			IF(Var_SaldoMoraCarVen > Entero_Cero) THEN
				-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraCVen, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							CONVERT(Par_CreditoID, CHAR),		
							Var_MonedaID,		Var_SaldoMoraCarVen,	Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;

				-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraCVen, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoMoraCarVen,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			-- Insertamos los movimientos de Comision por Anualidad
			IF(Var_SaldoComAnual > Entero_Cero) THEN
				-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_ComAnual, SubCtaFondeador,	Var_InstitFondeoNueID, Aud_Sucursal),
							CONVERT(Par_CreditoID, CHAR),		
							Var_MonedaID,		Var_SaldoComAnual,	Entero_Cero,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;

				-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	Par_CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(Par_CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(Par_CreditoID, Car_ComAnual, SubCtaFondeador,	Var_CreditoFondeoActID, Aud_Sucursal),	
							CONVERT(Par_CreditoID, CHAR),
							Var_MonedaID,		Entero_Cero,			Var_SaldoComAnual,
							DescrProceso,		CONVERT(Par_CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion;
			END IF;

			INSERT INTO DETALLEPOLIZA (
					EmpresaID,			PolizaID,				Fecha,					CentroCostoID,			CuentaCompleta,
					Instrumento,		MonedaID,				Cargos,					Abonos,					Descripcion,
					Referencia,			ProcedimientoCont,		TipoInstrumentoID,		RFC,					TotalFactura,
					FolioUUID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
					Sucursal,			NumTransaccion
			)
			SELECT	EmpresaID,			PolizaID,				Fecha,					CentroCostoID,			CuentaCompleta,
					Instrumento,		MonedaID,				Cargos,					Abonos,					Descripcion,
					Referencia,			ProcedimientoCont,		TipoInstrumentoID,		RFC,					TotalFactura,
					FolioUUID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion
				FROM TMP_CARDETPOLIZA
				WHERE NumTransaccion = Aud_NumTransaccion;


			-- Realizamos de baja si el credito ya tiene Asiganda un credito Pasivo
			UPDATE RELCREDPASIVO
				SET EstatusRelacion = Est_RelacionVencida,

					EmpresaID       = Aud_EmpresaID,
					Usuario 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID
				AND EstatusRelacion = Est_RelacionActiva;

			IF(Par_CreditoFondeoID > Entero_Cero) THEN
				-- Damos de Alta el nuevo registro del credito Asociada a una cuenta de Pasivo
				SELECT MAX(RelCreditoPasivoID)
					INTO Var_RelCreditoPasivoID
						FROM RELCREDPASIVO;
				SET Var_RelCreditoPasivoID := IFNULL(Var_RelCreditoPasivoID, Entero_Cero);
				SET Var_RelCreditoPasivoID := Var_RelCreditoPasivoID + 1;

				INSERT INTO RELCREDPASIVO (	
						RelCreditoPasivoID,		CreditoID,				CreditoFondeoID,		EstatusRelacion, 			EmpresaID,
						Usuario,				FechaActual,			DireccionIP,			ProgramaID,					Sucursal,
						NumTransaccion
					)
					VALUES(	 
						Var_RelCreditoPasivoID,	Par_CreditoID,			Par_CreditoFondeoID,	Est_RelacionActiva,		Aud_EmpresaID,
						Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion
					);

				-- Actualizamos la informacion del Credito
				UPDATE CREDITOS SET
					TipoFondeo		= RecursoFondeador,
					InstitFondeoID  = Var_InstitFondeoNueID,
					LineaFondeo		= Var_LineaFondeoID,

					EmpresaID       = Aud_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;
			ELSE
				-- Actualizamos la informacion del Credito
				UPDATE CREDITOS SET
					TipoFondeo		= RecursoPropio,
					InstitFondeoID  = Entero_Cero,
					LineaFondeo		= Entero_Cero,

					EmpresaID       = Aud_EmpresaID,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;
			END IF;
			

			DELETE FROM TMP_CARDETPOLIZA WHERE NumTransaccion = Aud_NumTransaccion;


			-- El registro se inserto correctamente
			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:= 'Proceso Realizada Correctamente.';
			SET Var_Consecutivo	:= Par_CreditoID;
			SET Var_Control	:= 'creditoID';
		END IF;

		IF(Par_NumPro = CambioFuenteMasivo) THEN
			SELECT 		FechaSistema
				INTO 	Var_FechaSistema
				FROM PARAMETROSSIS;

			SELECT 		COUNT(Estatus)
				INTO 	Var_CantRegError
			 	FROM TMP_CARFONDEOMASIVO
			 	WHERE NumTransaccion = Par_NumTransaccionPro
			 	AND Estatus IN (Est_SinVal);

			IF(Var_CantRegError > Entero_Cero) THEN
				SET Par_NumErr = 1;
				SET Par_ErrMen = concat("Existen registros que no pasaron por el proceso de validacion.");
				SET Var_Control = 'sqlException';
				LEAVE ManejoErrores;
			END IF;

			SELECT 		COUNT(Estatus)
				INTO 	Var_CantRegError
			 	FROM TMP_CARFONDEOMASIVO
			 	WHERE NumTransaccion = Par_NumTransaccionPro
			 	AND Estatus IN (Est_ErrorVal);

			IF(Var_CantRegError > Entero_Cero) THEN
				SET Par_NumErr = 1;
				SET Par_ErrMen = concat("Existen registros con errores en validacion.");
				SET Var_Control = 'sqlException';
				LEAVE ManejoErrores;
			END IF;

			SELECT 		COUNT(Estatus)
				INTO 	Var_CantRegProc
			 	FROM TMP_CARFONDEOMASIVO
			 	WHERE NumTransaccion = Par_NumTransaccionPro
			 	AND Estatus NOT IN (Est_SinVal, Est_ErrorVal);

			IF(Var_CantRegProc = Entero_Cero) THEN
				SET Par_NumErr = 1;
				SET Par_ErrMen = concat("No se encontraron registros a procesar.");
				SET Var_Control = 'sqlException';
				LEAVE ManejoErrores;
			END IF;

			-- Llenamos la tabla temporal de reclasificaciones
			DELETE FROM TMP_CARDETPOLIZA WHERE NumTransaccion = Aud_NumTransaccion;
			DELETE FROM TMP_MASIVOPOLIZA WHERE NumTransaccion = Aud_NumTransaccion;

			INSERT INTO TMP_MASIVOPOLIZA(
						CreditoID,				MonedaID,				SaldoCapVigent,			SaldoCapAtrasad,			SaldoCapVencido,
						SaldCapVenNoExi,		SaldoInterOrdin,		SaldoInterAtras,		SaldoInterVenc,				SaldoInterProvi,
						SaldoMoratorios,		SaldComFaltPago,		SaldoOtrasComis,		SaldoMoraVencido,			SaldoMoraCarVen,
						SaldoComAnual,			InstitutFondActID,		InstitutFondNueID,		NumTransaccion)

			SELECT	 	MAS.CreditoID, 			CRE.MonedaID,			CRE.SaldoCapVigent,		CRE.SaldoCapAtrasad,	CRE.SaldoCapVencido,
						CRE.SaldCapVenNoExi,	CRE.SaldoInterOrdin,	CRE.SaldoInterAtras,	CRE.SaldoInterVenc,		CRE.SaldoInterProvi,
			            CRE.SaldoMoratorios,	CRE.SaldComFaltPago,	CRE.SaldoOtrasComis,	CRE.SaldoMoraVencido,	CRE.SaldoMoraCarVen,
			            CRE.SaldoComAnual,		CRE.InstitFondeoID,		MAS.InstitutFondID,		Aud_NumTransaccion
				FROM CREDITOS CRE
				INNER JOIN TMP_CARFONDEOMASIVO MAS ON MAS.CreditoID = CRE.CreditoID
				WHERE  MAS.NumTransaccion = Par_NumTransaccionPro;

			-- Insertamos los movimientos de Capital Vigente
			-- 1.- Cargo de Capital Vigente la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapVigente, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldoCapVigent,				Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),	ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoCapVigent > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Capital Vigente a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,		Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapVigente, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,				SaldoCapVigent,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoCapVigent > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;
			
			
			-- Insertamos los movimientos de Capital Atrasado
			-- 1.- Cargo de Capital Atrasado a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapAtrasado, SubCtaFondeador,		InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldoCapAtrasad,			Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoCapAtrasad > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Capital Atrasado a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapAtrasado, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(Par_CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoCapAtrasad,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoCapAtrasad > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;
			

			-- Insertamos los movimientos de Capital Vencido
			-- 1.- Cargo de Capital Vencido a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapVencido, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldoCapVencido,			Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoCapVencido > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Capital Vencido a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapVencido, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoCapVencido,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoCapVencido > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Capital Vencido no Exigible
				-- 1.- Cargo de Capital Vencido a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapVencidoNoExi, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldCapVenNoExi,		Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldCapVenNoExi > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Capital Vencido a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_CapVencidoNoExi, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldCapVenNoExi,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldCapVenNoExi > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Interes Ordinario
			-- 1.- Cargo de Interes Ordinario a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntOrdinario, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldoInterOrdin,			Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoInterOrdin > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Ordinario a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntOrdinario, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoInterOrdin,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoInterOrdin > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Interes Atrasado
			-- 1.- Cargo de Interes Atrasado a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(Par_CreditoID, Car_IntAtrasado, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldoInterAtras,			Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoInterAtras > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Atrasado a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntAtrasado, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(Par_CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoInterAtras,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
				WHERE SaldoInterAtras > Entero_Cero
				AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Interes Vencido
			-- 1.- Cargo de Interes Vencido a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,			PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		MonedaID,			Cargos,						Abonos,
						Descripcion,		Referencia,			ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,			NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,		Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntVencido, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CreditoID,			MonedaID,			SaldoInterVenc,				Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,		Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoInterVenc > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Vencido a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntVencido, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoInterVenc,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoInterVenc > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Interes Provisionado
				-- 1.- Cargo de Interes Provisionado (Ordinario) a la nueva Institucion de fondeo
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(CreditoID, Car_IntOrdinario, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
							CONVERT(CreditoID, CHAR),		
							MonedaID,			SaldoInterProvi,		Entero_Cero,
							DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,			TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
						FROM TMP_MASIVOPOLIZA
						WHERE SaldoInterProvi > Entero_Cero
						AND NumTransaccion = Aud_NumTransaccion;

				-- 2.- Abono de Interes Provisionado (Ordinario) a la Institucion de fondeo actual
				INSERT INTO TMP_CARDETPOLIZA (
							CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
							CuentaCompleta,		
							Instrumento,		
							MonedaID,			Cargos,					Abonos,
							Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
							TotalFactura,		FolioUUID,				NumTransaccion
					)
					SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
							FN_CARCONTAVAR(CreditoID, Car_IntOrdinario, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
							CONVERT(CreditoID, CHAR),
							MonedaID,			Entero_Cero,			SaldoInterProvi,
							DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
							Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
						FROM TMP_MASIVOPOLIZA
						WHERE SaldoInterProvi > Entero_Cero
						AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Interes Moratorio (Pendiente: Cta. Orden Moratorios - Corr. Cta Orden Moratorios)
			-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraDev, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CONVERT(CreditoID, CHAR),		
						MonedaID,			SaldoMoratorios,		Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoMoratorios > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraDev, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoMoratorios,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoMoratorios > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;
			
			-- Insertamos los movimientos de Comision por falta de Pago (Pendiente: Cta. Orden Comision Falta Pago - Corr. Cta. Orden Com. Falta Pago)
			-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraDev, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CONVERT(CreditoID, CHAR),		
						MonedaID,			SaldComFaltPago,		Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldComFaltPago > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraDev, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldComFaltPago,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldComFaltPago > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de otras comisiones

			-- Insertamos los movimientos de Interes Moratorio Vencido
			-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraVen, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CONVERT(CreditoID, CHAR),		
						MonedaID,			SaldoMoraVencido,		Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoMoraVencido > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(Par_CreditoID, Car_IntMoraVen, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoMoraVencido,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoMoraVencido > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Interes Moratorio Vencido
			-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraCVen, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CONVERT(Par_CreditoID, CHAR),		
						MonedaID,			SaldoMoraCarVen,		Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoMoraCarVen > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_IntMoraCVen, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoMoraCarVen,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoMoraCarVen > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- Insertamos los movimientos de Comision por Anualidad
			-- 1.- Cargo de Interes Moratorio a la nueva Institucion de fondeo
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,					Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,			TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,				Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_ComAnual, SubCtaFondeador,	InstitutFondNueID, Aud_Sucursal),
						CONVERT(CreditoID, CHAR),		
						MonedaID,			SaldoComAnual,	Entero_Cero,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,	TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoComAnual > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			-- 2.- Abono de Interes Moratorio a la Institucion de fondeo actual
			INSERT INTO TMP_CARDETPOLIZA (
						CreditoID,			EmpresaID,				PolizaID,				Fecha,					CentroCostoID,
						CuentaCompleta,		
						Instrumento,		
						MonedaID,			Cargos,					Abonos,
						Descripcion,		Referencia,				ProcedimientoCont,		TipoInstrumentoID,		RFC,
						TotalFactura,		FolioUUID,				NumTransaccion
				)
				SELECT 	CreditoID,			Aud_EmpresaID,			Par_PolizaID,			Var_FechaSistema,		FN_CARCENTROCOSTO(CreditoID, Car_CapVigente, Aud_Sucursal),
						FN_CARCONTAVAR(CreditoID, Car_ComAnual, SubCtaFondeador,	InstitutFondActID, Aud_Sucursal),	
						CONVERT(CreditoID, CHAR),
						MonedaID,			Entero_Cero,			SaldoComAnual,
						DescrProceso,		CONVERT(CreditoID, CHAR),ProcesoContable,		TipoInstruCred,			Cadena_Vacia,
						Entero_Cero,		Cadena_Vacia,			Aud_NumTransaccion
					FROM TMP_MASIVOPOLIZA
					WHERE SaldoComAnual > Entero_Cero
					AND NumTransaccion = Aud_NumTransaccion;

			INSERT INTO DETALLEPOLIZA (
						EmpresaID,			PolizaID,				Fecha,					CentroCostoID,			CuentaCompleta,
						Instrumento,		MonedaID,				Cargos,					Abonos,					Descripcion,
						Referencia,			ProcedimientoCont,		TipoInstrumentoID,		RFC,					TotalFactura,
						FolioUUID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
						Sucursal,			NumTransaccion
				)
				SELECT	EmpresaID,			PolizaID,				Fecha,					CentroCostoID,			CuentaCompleta,
						Instrumento,		MonedaID,				Cargos,					Abonos,					Descripcion,
						Referencia,			ProcedimientoCont,		TipoInstrumentoID,		RFC,					TotalFactura,
						FolioUUID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion
					FROM TMP_CARDETPOLIZA
					WHERE NumTransaccion = Aud_NumTransaccion;


			UPDATE RELCREDPASIVO REL
				INNER JOIN TMP_CARFONDEOMASIVO TMP ON TMP.CreditoID = REL.CreditoID AND TMP.NumTransaccion = Par_NumTransaccionPro AND REL.EstatusRelacion = Est_RelacionActiva
					SET REL.EstatusRelacion = Est_RelacionVencida,
						REL.EmpresaID       = Aud_EmpresaID,
						REL.Usuario 		= Aud_Usuario,
						REL.FechaActual 	= Aud_FechaActual,
						REL.DireccionIP 	= Aud_DireccionIP,
						REL.ProgramaID 		= Aud_ProgramaID,
						REL.Sucursal 		= Aud_Sucursal,
						REL.NumTransaccion 	= Aud_NumTransaccion;

			SELECT MAX(RelCreditoPasivoID)
						INTO @Num
							FROM RELCREDPASIVO;
					SET @Num := IFNULL(@Num, Entero_Cero);


			INSERT INTO RELCREDPASIVO (	
						RelCreditoPasivoID,		CreditoID,				CreditoFondeoID,		EstatusRelacion, 			EmpresaID,
						Usuario,				FechaActual,			DireccionIP,			ProgramaID,					Sucursal,
						NumTransaccion
					)
					 
				SELECT	@Num:=@Num + 1 AS ID,			CreditoID,				CreditoFondeoID,		Est_RelacionActiva,		Aud_EmpresaID,
						Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion
					FROM TMP_CARFONDEOMASIVO
					WHERE NumTransaccion = Par_NumTransaccionPro AND CreditoFondeoID > Entero_Cero;

			-- Actualizamos la informacion del Credito
			UPDATE CREDITOS CRE 
				INNER JOIN TMP_CARFONDEOMASIVO TMP ON TMP.CreditoID = CRE.CreditoID AND TMP.NumTransaccion = Par_NumTransaccionPro AND TMP.CreditoFondeoID > Entero_Cero
				SET
				CRE.TipoFondeo		= RecursoFondeador,
				CRE.InstitFondeoID  = Var_InstitFondeoNueID,
				CRE.LineaFondeo		= Var_LineaFondeoID,

				CRE.EmpresaID       = Aud_EmpresaID,
				CRE.Usuario         = Aud_Usuario,
				CRE.FechaActual     = Aud_FechaActual,
				CRE.DireccionIP     = Aud_DireccionIP,
				CRE.ProgramaID      = Aud_ProgramaID,
				CRE.Sucursal        = Aud_Sucursal,
				CRE.NumTransaccion  = Aud_NumTransaccion;
				-- Actualizamos la informacion del Credito
				UPDATE CREDITOS CRE 
				INNER JOIN TMP_CARFONDEOMASIVO TMP ON TMP.CreditoID = CRE.CreditoID AND TMP.NumTransaccion = Par_NumTransaccionPro AND TMP.CreditoFondeoID = Entero_Cero
					SET
					CRE.TipoFondeo		= RecursoPropio,
					CRE.InstitFondeoID  = Entero_Cero,
					CRE.LineaFondeo		= Entero_Cero,

					CRE.EmpresaID       = Aud_EmpresaID,
					CRE.Usuario         = Aud_Usuario,
					CRE.FechaActual     = Aud_FechaActual,
					CRE.DireccionIP     = Aud_DireccionIP,
					CRE.ProgramaID      = Aud_ProgramaID,
					CRE.Sucursal        = Aud_Sucursal,
					CRE.NumTransaccion  = Aud_NumTransaccion;

			DELETE FROM TMP_CARDETPOLIZA WHERE NumTransaccion = Aud_NumTransaccion;

			-- El registro se inserto correctamente
			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:= 'Proceso Realizado Correctamente.';
			SET Var_Consecutivo	:= Var_RelCreditoPasivoID;
			SET Var_Control	:= 'registroCompleto';
		END IF;	
		
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_Consecutivo			AS	Consecutivo;
	END IF;
END TerminaStore$$
