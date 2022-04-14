-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLIGARANAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLIGARANAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `APLIGARANAGROPRO`(
	# ======================================================
	# ---- SP PARA REALIZAR APLICACION DE GARANTIAS FIRA----
	# ======================================================
	Par_CreditoID				BIGINT(12), 		-- Numero de credito al que se le aplicara la garantia
	Par_MontoTotCredSinIVA		DECIMAL(16,2),		-- Monto total de adeudo del credito sin IVA
	Par_MontoGtia				DECIMAL(16,2),		-- Monto de garantia a aplicar al credito
	Par_MontoProgEsp			DECIMAL(16,2),		-- Monto de programa especial a aplicar al credito
	Par_TipoGarantiaFira		INT(11),			-- Tipo de Garantia Fira a aplicar 1-FEGA, 2-FONAGA, 3-AMBAS

	Par_TipoProgEspFira			INT(11),			-- Tipo de programa especial Fira a aplicar
	Par_EstatusGarantia			CHAR(1),			-- Estatus de la garantia FIRA
	Par_PorcentajeGtia			DECIMAL(16,4),		-- Porcentaje de garantia a aplicar
	Par_MonedaID				INT(11),			-- Moneda del credito
	Par_Poliza					BIGINT(12),			-- Numero de poliza

	Par_CreditoContFondeador	BIGINT(12), 		-- Numero de credito Contigente Fondeador
	Par_Observacion				VARCHAR(500),		-- Observaciones
	Par_UsuarioID				INT(11),			-- ID usuario que realiza autorizacion
	Par_OrigenPago				CHAR(1),			-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_AcreditadoIDFIRA		BIGINT(20),			-- Numero de Identificador de Acreditado por FIRA

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE	Var_TotGarLiq			DECIMAL(14,2);		-- Monto total de garantia liquida
	DECLARE Var_BloqueoID			INT(11);			-- ID del bloqueo
	DECLARE Var_MontoDesblo			DECIMAL(14,2);		-- Monto desbloqueado
	DECLARE Var_Referencia			BIGINT(20);			-- Referencia ligada al bloqueo
	DECLARE Var_MonedaID			INT(11);			-- ID de la moneda
	DECLARE	Var_ContGarLiq			CHAR(1);			-- Indica la contabilidad de garantia liquida
	DECLARE Var_FechaSis			DATE;				-- Fecha del sistema
	DECLARE	Var_ClaveUsu			VARCHAR(50);		-- Indica la clave del usuario de desbloqueo
	DECLARE Var_CtaGtiaFonaga		VARCHAR(60);		-- Cuenta contable para garantia fonaga
	DECLARE Var_CtaGtiaFega			VARCHAR(60);		-- Cuenta contable para garantia fega
	DECLARE Var_ClienteID			INT(11);			-- Cliente relacionado al credito
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- Cuenta relacionada a los bloqueos de garantia liquida
	DECLARE Var_CuentaAhoIDCre		BIGINT(12);			-- Cuenta ahorro ligada al credito
	DECLARE	Var_MontoExigible		DECIMAL(16,2);		-- Monto exigible del credito
	DECLARE Var_MontoTotDeuda		DECIMAL(16,2);		-- Monto total de adeudo del credito
	DECLARE Var_EstatusCre			CHAR(1);			-- Estatus del credito
	DECLARE Var_MontoPago     		DECIMAL(16,2); 		-- Variable Monto de pago de credito aplicado inout
	DECLARE	Var_MontoIVAInt			DECIMAL(16,2);		-- Variable Monto IVA de interes pagado inout
	DECLARE	Var_MontoIVAMora		DECIMAL(16,2);		-- Variable Monto IVA moratorio pagado inout
	DECLARE	Var_MontoIVAComi		DECIMAL(16,2);		-- Variable Monto IVA de comision pagado inout
	DECLARE Var_Consecutivo			BIGINT(12);			-- Variable para consecutivo inout
	DECLARE Var_ExigiblePagado		CHAR(1);			-- Variable para saber si el exigible del credito ya fue pagado
	DECLARE Var_DiferenciaPago		DECIMAL(16,2);		-- Variable para guardar el monto de diferencia de pago aplicado
	DECLARE Var_CtaFegaCC			VARCHAR(30); 		-- Centro de costos de concepto FEGA
	DECLARE Var_CtaFonagaCC			VARCHAR(30); 		-- Centro de costos de concepto FONAGA
	DECLARE Var_CCGarantia			VARCHAR(30);		-- Centro de costos de las garantias
	DECLARE Var_CentroCostosID		INT(11);			-- Centro de costos con el que se aplicaran las garantias
	DECLARE Var_SucCliente			INT(11);			-- Sucursal cliente
	DECLARE Var_CtaContGtia			VARCHAR(50); 		-- cuenta contable con procedencia de credito
	DECLARE Var_PasCreditoID		BIGINT(20);			-- Variable que guarda el numero de credito pasivo relacionado al activo
	DECLARE	Var_MontoExigiblePas	DECIMAL(16,2);		-- Monto exigible del credito pasivo
	DECLARE Var_MontoTotDeudaPas	DECIMAL(16,2);		-- Monto total de adeudo del credito pasivo
	DECLARE Var_ExigiblePagadoPas	CHAR(1);			-- Variable para saber si el exigible del credito pasivo ya fue pagado
	DECLARE	Var_LineaFondeoIDPas	INT(11);			-- Variable que guarda la linea de fondeo del credito pasivo
	DECLARE	Var_InstitutFondIDPas	INT(11);			-- Variable que guarda la institucion de fondeo del credito pasivo
	DECLARE	Var_LineaFondeoID		INT(11);			-- Variable que guarda la linea de fondeo del credito pasivo
	DECLARE	Var_InstitucionID		INT(11);			-- Variable que guarda la institucion de fondeo del credito pasivo
	DECLARE Var_NumCtaInstit		VARCHAR(20);		-- Variable que guarda el Numero de Cuenta Bancaria
	DECLARE Var_DiferenciaPagoPas	DECIMAL(16,2);		-- Variable que guarda la diferencia de pago del credito pasivo
	DECLARE Var_MontoDeudaDespGL	DECIMAL(16,2);		-- Variable que guarda el monto deuda despues de aplicar la GL
	DECLARE Var_MontoAdeudoSinIVA	DECIMAL(16,2);		-- Variable que guarda el monto de adeudo sin iva
	DECLARE Var_SaldoGtia			DECIMAL(16,2);		-- Variable que guarda el monto de garantia
	DECLARE Var_SaldoFegaDec		DECIMAL(14,2);		-- Variable que guarda el saldo de fega decimal
	DECLARE Var_SaldoFonagaDec		DECIMAL(14,2);		-- Variable que guarda el saldo de fonaga decimal
	DECLARE Var_MontoCap 			DECIMAL(14,2);		-- Variable aplicaro para el cambio de fuente de fondeo
	DECLARE Var_SaldoFega			VARCHAR(50);		-- Variable que guarda el saldo de fega varchar
	DECLARE Var_SaldoFonaga			VARCHAR(50);		-- Variable que guarda el saldo de fonaga varchar
	DECLARE Var_CreditoStr        	VARCHAR(20);
	DECLARE Error_Key           	INT DEFAULT 0;
	DECLARE Var_CamFuenFonGarFira 	CHAR(1);	-- Parametro de Cambio Automatico de Fuente de Fondeo de Garantias Fira
	DECLARE Var_InstitFondeoID		INT(11);
	DECLARE Var_LineaFondeo 		INT(11);
	DECLARE Var_AcreditadoIDFIRA	BIGINT(20);			-- Identificador de Acreditado FIRA
	DECLARE Var_CreditoIDFIRA		BIGINT(20);			-- identificador de Credito FIRA

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT(11);
	DECLARE Decimal_Cero    		DECIMAL(16,2);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Con_SI					CHAR(1);
	DECLARE Con_NO					CHAR(1);
	DECLARE Blo_DepGarLiq			INT(11);
	DECLARE Tipo_Bloqueo    		CHAR(1);
	DECLARE Tipo_Desbloq			CHAR(1);
	DECLARE DescripDesblo			VARCHAR(50);
	DECLARE	ConcepContDevGarLiq		INT(11);
	DECLARE	DevolucionGarLiq		CHAR(1);
	DECLARE Estatus_Pagado			CHAR(1);
	DECLARE Entero_Uno				INT(11);
	DECLARE PagoCargoCuenta			CHAR(1);
	DECLARE	Cuenta_Vacia			CHAR(25);
	DECLARE	For_SucOrigen			CHAR(3);
	DECLARE	For_SucCliente			CHAR(3);
	DECLARE GarantiaFEGA			INT(11);
	DECLARE GarantiaFONAGA			INT(11);
	DECLARE	GarantiaAmbas			INT(11);
	DECLARE FiniquitoSi	        	CHAR(1);
	DECLARE FiniquitoNo	        	CHAR(1);
	DECLARE EsPrePagoNo	        	CHAR(1);
	DECLARE SI_PagaIva				CHAR(1);
	DECLARE LlaveSaldoFega			VARCHAR(50);
	DECLARE LlaveSaldoFonaga		VARCHAR(50);
	DECLARE EstatusAplicado			CHAR(1);
	DECLARE Proc_ApliGarAgro		INT(11);
	DECLARE ApliVenGar				CHAR(1);
	DECLARE	VenAgro					VARCHAR(50);
	DECLARE EstatusCre				CHAR(1);
	DECLARE EstatusVen				CHAR(1);
	DECLARE Con_RecursosPropio 		INT(11);	-- Constante Recursos Propios
	DECLARE SinLinea 				INT(11);	-- Constante Sin Linea de Fondeo
	DECLARE Con_AplicaGarantia		CHAR(1);	-- Constante
	DECLARE Est_Vigente 			CHAR(1);
	DECLARE RespaldaCredSI			CHAR(1);
	DECLARE Est_PasVigente			CHAR(1);	-- Estatus Vigente Credito Pasivo
	DECLARE Con_PagoApliGarAgro		CHAR(1);	-- Constante Origen de Pago de Aplicacion por Garantias Agro (A)

	/*CURSOR PARA OBTENER BLOQUEOS POR GARANTIA LIQUIDA DE UN CREDITO*/
	DECLARE cursor_DesBloqueo CURSOR FOR
		SELECT 		Bloq.BloqueoID,	Bloq.CuentaAhoID,	Bloq.MontoBloq, Bloq.Referencia, Cue.MonedaID
			FROM 	BLOQUEOS Bloq
					INNER JOIN CUENTASAHO Cue ON Bloq.CuentaAhoID = Cue.CuentaAhoID
			WHERE	Bloq.TiposBloqID 					= Blo_DepGarLiq
			AND 	IFNULL(Bloq.FolioBloq, Entero_Cero)	= Entero_Cero
			AND  	Bloq.NatMovimiento 					= Tipo_Bloqueo
			AND 	Bloq.Referencia 					= Par_CreditoID;


	-- Asignacion de Constantes
	SET Cadena_Vacia    			:= '';              -- String Vacio
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     			:= 0;               -- Entero en Cero
	SET Decimal_Cero    			:= 0.00;            -- Decimal Cero
	SET Salida_NO					:= 'N';				-- Salida NO
	SET Salida_SI					:= 'S';				-- Salida NO
	SET Con_SI						:= 'S';				-- Constante SI
	SET Con_NO						:= 'N';				-- Constante NO
	SET Blo_DepGarLiq     			:= 8;				-- Tipo de Bloqueo Automatico en cada Deposito
	SET Tipo_Bloqueo    			:= 'B';				-- Tipo de Movimiento de Bloqueo por garantia liquida
	SET Tipo_Desbloq				:= 'D';				-- Tipo de movimiento de Desbloqueo de garantia liquida
	SET	DescripDesblo				:= 'LIBERACION DE GL POR APLICACION GTIA FIRA';	-- Descripcion de desbloqueo de garantia liquida
	SET ConcepContDevGarLiq			:= 62;				-- Concepto contable para devolucion de garantia liquida
	SET	DevolucionGarLiq			:= 'V';				-- Operacion contable de Devolucion de Garantia liquida
	SET Estatus_Pagado				:= 'P';				-- Indica estatus pagado
	SET Entero_Uno					:= 1;				-- Entero Uno
	SET PagoCargoCuenta				:= 'C';				-- Pago con Cargo a Cuenta
	SET Cuenta_Vacia				:= '0000000000000000000000000';-- Cuenta contable vacia
	SET	For_SucOrigen				:= '&SO';			-- Nomenclatura  Centro de Costos(Sucursal Origen)
	SET	For_SucCliente				:= '&SC';			-- Nomenclatura Centro de Costos (Sucursal Cliente)
	SET GarantiaFEGA				:= 1;				-- Tipo de garantia FEGA
	SET GarantiaFONAGA				:= 2;				-- Tipo de garantia FONAGA
	SET GarantiaAmbas				:= 3;				-- Tipo de garantia ambas(FEGA Y FONAGA)
	SET	FiniquitoSi					:= 'S';				-- Si es finiquito
	SET	FiniquitoNo					:= 'N';				-- No es finiquito
	SET	EsPrePagoNo					:= 'N';				-- No es prepago
	SET SI_PagaIva					:= 'S';				-- Si paga iva
	SET LlaveSaldoFega				:= 'SaldoFega';		-- Llave de parametro para saldo fega
	SET LlaveSaldoFonaga			:= 'SaldoFonaga';	-- Llave de parametro para saldo fonaga
	SET EstatusAplicado				:= 'P';				-- Estatus de garantia FIRA P- aplicada
	SET Aud_FechaActual				:= NOW();			-- Parametro de auditoria fecha actual
	SET Proc_ApliGarAgro       		:= 9010;         	-- Proceso de Aplicacion de garantias FIRA
	SET RespaldaCredSI				:= 'S';
    SET Est_PasVigente				:= 'V';

	-- Asignacion de variables
	SET Var_ClaveUsu				:= Cadena_Vacia;
	SET Var_TotGarLiq				:= Decimal_Cero;
	SET Var_MontoExigible			:= Decimal_Cero;
	SET Var_MontoPago				:= Decimal_Cero;
	SET Var_ExigiblePagado			:= Con_NO;
	SET Var_ExigiblePagadoPas		:= Con_NO;
	SET Var_SaldoFegaDec			:= Decimal_Cero;
	SET Var_SaldoFonagaDec			:= Decimal_Cero;
	SET Var_SaldoFega				:= '0.00';
	SET Var_SaldoFonaga				:= '0.00';
	SET VenAgro						:= 'AplicaVenAgro';
	SET EstatusVen					:= 'B';
	SET Con_RecursosPropio			:= Entero_Cero;
	SET SinLinea					:= Entero_Cero;
	SET Con_AplicaGarantia 			:= 'G';
	SET Est_Vigente 				:= 'V';
	SET Con_PagoApliGarAgro			:= 'A';

	SET Par_CreditoContFondeador	:= IFNULL(Par_CreditoContFondeador, Entero_Cero);
	SET Par_Observacion				:= IFNULL(Par_Observacion, Cadena_Vacia);

	-- Se reasigna el Origen de Pago a Aplicacion de Garantia Agro para evitar el abono de capital por lineas de credito Agro Revolvente
	SET Par_OrigenPago 				:= Con_PagoApliGarAgro;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APLIGARANAGROPRO');
		END;

		SET Par_CreditoContFondeador	:= IFNULL(Par_CreditoContFondeador, Entero_Cero);
		SET Par_Observacion				:= IFNULL(Par_Observacion, Cadena_Vacia);
		SET Par_AcreditadoIDFIRA		:= IFNULL(Par_AcreditadoIDFIRA, Entero_Cero);

		SELECT	FechaSistema,	ContabilidadGL,	CamFuenFonGarFira
			INTO Var_FechaSis,	Var_ContGarLiq,	Var_CamFuenFonGarFira
			FROM PARAMETROSSIS;

		SET Var_FechaSis 	:= IFNULL(Var_FechaSis,Fecha_Vacia);
		SET Var_ContGarLiq	:= IFNULL(Var_ContGarLiq,Cadena_Vacia);
		SET Var_CamFuenFonGarFira := IFNULL(Var_CamFuenFonGarFira, Con_NO);

		-- Se obtiene informacion del credito activo
		SELECT		Cre.ClienteID,		Cre.Estatus,		Cre.CuentaID,		Cre.InstitFondeoID,	Cre.LineaFondeo
			INTO	Var_ClienteID,		Var_EstatusCre,		Var_CuentaAhoIDCre,	Var_InstitFondeoID,	Var_LineaFondeo
			FROM 	CREDITOS Cre
			WHERE 	Cre.CreditoID = Par_CreditoID;

		-- Se obtiene informacion del credito pasivo
		SELECT 		Rel.CreditoFondeoID	INTO Var_PasCreditoID
			FROM 	RELCREDPASIVOAGRO Rel
			WHERE	Rel.CreditoID	= Par_CreditoID
			  AND	Rel.EstatusRelacion = Est_PasVigente ;
		SET Var_PasCreditoID	:=	IFNULL(Var_PasCreditoID,Entero_Cero);

		SELECT 		Pas.LineaFondeoID,		Pas.InstitutFondID
			INTO	Var_LineaFondeoIDPas,	Var_InstitutFondIDPas
			FROM 	CREDITOFONDEO Pas
			WHERE 	Pas.CreditoFondeoID	= Var_PasCreditoID;

		SET Var_LineaFondeoIDPas	:= IFNULL(Var_LineaFondeoIDPas,Entero_Cero);
		SET Var_InstitutFondIDPas	:= IFNULL(Var_InstitutFondIDPas,Entero_Cero);

		SELECT		lin.LineaFondeoID,	lin.InstitucionID, 		lin.NumCtaInstit
			INTO 	Var_LineaFondeoID,	Var_InstitucionID,		Var_NumCtaInstit
			FROM 	LINEAFONDEADOR lin
			WHERE 	lin.LineaFondeoID	= Var_LineaFondeoIDPas
			AND 	lin.InstitutFondID	= Var_InstitutFondIDPas;

		IF(Par_MontoGtia<=Decimal_Cero)THEN
			SET Par_NumErr		:= 01;
			SET Par_ErrMen		:= 'El Monto para Aplicar las Garantias Debe Ser Mayor a Cero';
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
        END IF;

		-- Se sacan la Informacion de Identificadores FIRA
		SELECT AcreditadoIDFIRA, 		CreditoIDFIRA
		INTO	Var_AcreditadoIDFIRA, 	Var_CreditoIDFIRA
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_AcreditadoIDFIRA := IFNULL(Var_AcreditadoIDFIRA, Entero_Cero);
		SET Var_CreditoIDFIRA := IFNULL(Var_CreditoIDFIRA, Entero_Cero);

		/*************************************************************DESBLOQUEO GARANTIA LIQUIDA*******************************************************/

		OPEN  cursor_DesBloqueo;
		BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP
				FETCH cursor_DesBloqueo  INTO
					Var_BloqueoID, Var_CuentaAhoID, Var_MontoDesblo,	Var_Referencia,		Var_MonedaID;

					START TRANSACTION;
					Transaccion:BEGIN

					DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
					DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

						--  Se Genera el Desbloqueo operativo
						CALL BLOQUEOSPRO(
							Var_BloqueoID,		Tipo_Desbloq,		Var_CuentaAhoID,	Var_FechaSis,		Var_MontoDesblo,
							Var_FechaSis,		Blo_DepGarLiq,		DescripDesblo,		Var_Referencia,		Var_ClaveUsu,
							Cadena_Vacia,		Con_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							SET Error_Key := 99;
							LEAVE Transaccion;
						END IF;


						IF(Var_ContGarLiq = Con_SI) THEN
						  --  Se Genera el Desbloqueo Contable
							CALL CONTAGARLIQPRO(
								Par_Poliza,				Var_FechaSis,		Var_ClienteID,				Var_CuentaAhoID, 	Var_MonedaID,
								Var_MontoDesblo, 		Con_NO,				ConcepContDevGarLiq,		DevolucionGarLiq,	Blo_DepGarLiq,
								DescripDesblo,			Con_NO,				Par_NumErr,					Par_ErrMen,			Par_EmpresaID,
								Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;
						END IF;

						SET Var_TotGarLiq	:= Var_TotGarLiq + Var_MontoDesblo;

					END Transaccion;
					SET Var_CreditoStr := CONVERT(Var_Referencia, CHAR);

					IF Error_Key = 0 THEN
						COMMIT;
					END IF;
					IF Error_Key = 1 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Proc_ApliGarAgro, 	Var_FechaSis, 		Var_CreditoStr, 	'ERROR DE SQL GENERAL', 			Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Proc_ApliGarAgro, 	Var_FechaSis, 		Var_CreditoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA', 	Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Proc_ApliGarAgro, 	Var_FechaSis, 		Var_CreditoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE', Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Proc_ApliGarAgro, 	Var_FechaSis, 		Var_CreditoStr, 	'ERROR VALORES NULOS', 				Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 99 THEN
							ROLLBACK;
							START TRANSACTION;
								CALL EXCEPCIONBATCHALT(
								Proc_ApliGarAgro, 	Var_FechaSis, 		Var_CreditoStr, 	CONCAT(Par_NumErr,' - MANEJO ERRORES'),Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
								Aud_NumTransaccion);
							COMMIT;
					END IF;
				END LOOP CICLO;
			END;
		CLOSE cursor_DesBloqueo;


		SET Var_TotGarLiq		:= IFNULL(Var_TotGarLiq,Decimal_Cero);

		-- Monto Total del Adeudo
		SET Var_MontoTotDeuda	:= (SELECT FUNCIONCONFINIQCRE(Par_CreditoID));
		SET Var_MontoTotDeuda	:= IFNULL(Var_MontoTotDeuda,Decimal_Cero);

		IF (Var_MontoTotDeuda-Var_TotGarLiq) < Par_MontoGtia THEN
				SET Par_NumErr		:= 400;
				SET Par_ErrMen		:= 'El Monto de Garantia FIRA no Puede ser Mayor al Adeudo Total Menos el Monto de Garantia Liquida';
				SET Var_Control		:= 'garantiaAplicar';
				LEAVE ManejoErrores;
		END IF;


		/****************** INICIO DEL PROCESO PAGO DE CREDITO DEPENDIENDO DE LA CANTIDAD DEL MONTO DE GARANTIA LIQUIDA****************/
		IF(Var_TotGarLiq > Decimal_Cero)THEN
			/* ================================PAGO DE CREDITO ACTIVO=================================*/
			-- Monto Exigible del Adeudo
			SET Var_MontoExigible	:= (SELECT FUNCIONEXIGIBLE(Par_CreditoID));
			SET Var_MontoExigible 	:= IFNULL(Var_MontoExigible,Decimal_Cero);

			IF(IFNULL(Var_MontoExigible,Decimal_Cero) <= Decimal_Cero )THEN
			-- si el pago exigible esta en cero, quiere decir que ya se ha pagado
				SET Var_ExigiblePagado		:= Con_SI;
			END IF;

			/* si el monto ingresado es menor o igual al pago exigible y
			 el pago exigible no esta pagado, entonces hace el abono a la cuota exigible*/
			IF(Var_TotGarLiq<=Var_MontoExigible AND Var_ExigiblePagado=Con_NO) THEN
				CALL PAGOCREDITOPRO(
					Par_CreditoID,   		Var_CuentaAhoIDCre,		Var_TotGarLiq,   	Par_MonedaID,		EsPrePagoNo,
					FiniquitoNo,   			Par_EmpresaID,			Salida_NO,			Con_NO,      		Var_MontoPago,
					Par_Poliza,      		Par_NumErr,				Par_ErrMen,			Var_Consecutivo,	PagoCargoCuenta,
					Par_OrigenPago,			RespaldaCredSI,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				-- Se valida que no haya devuelto mensaje de error
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			ELSE /*SI el monto ingresado es MAYOR al pago exigible Y sea MENOR al total adeudo y
				 y el pago exigible se encuentra pagado, entonces hace el abono a la cuota exigible y/o prepago*/
				IF((Var_TotGarLiq>Var_MontoExigible)AND(Var_TotGarLiq<Var_MontoTotDeuda))THEN
					-- Se calcula la diferencia para poder realizar el prepago
					SET Var_DiferenciaPago := Var_TotGarLiq-Var_MontoExigible;

					IF(IFNULL(Var_MontoExigible,Decimal_Cero)!=Decimal_Cero)THEN

						CALL PAGOCREDITOPRO(
							Par_CreditoID,   		Var_CuentaAhoIDCre,    	Var_TotGarLiq,   	Par_MonedaID,     	EsPrePagoNo,
							FiniquitoNo,   			Par_EmpresaID,      	Salida_NO,			Con_NO,				Var_MontoPago,
							Par_Poliza,				Par_NumErr,				Par_ErrMen,			Var_Consecutivo,	PagoCargoCuenta,
							Par_OrigenPago,			RespaldaCredSI,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						-- Se valida que no haya devuelto mensaje de error
						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

					END IF;


					IF((Par_NumErr = Entero_Cero) AND (IFNULL(Var_DiferenciaPago,Decimal_Cero)>Decimal_Cero)) THEN -- si es exito Y la diferencia es mayor a cero
						/* Procedimiento del Pago del Credito "prepago" con la difrencia antes calculada */
						CALL PREPAGOCRESIGCUOPRO(
							Par_CreditoID,  	Var_CuentaAhoIDCre,    	Var_DiferenciaPago, Par_MonedaID,       Par_EmpresaID,
							Salida_NO,       	Con_NO,  				Var_MontoPago,  	Par_Poliza,         Par_OrigenPago,
							Par_NumErr,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,    	Aud_Sucursal,
							Aud_NumTransaccion);
						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				ELSE -- Si no, se comprueba que el monto a pagar sea igual al total del adeudo
					IF(Var_TotGarLiq >= Var_MontoTotDeuda)THEN
						-- Procedimiento del Pago del Credito "finiquito"
						CALL PAGOCREDITOPRO(
							Par_CreditoID,   		Var_CuentaAhoIDCre,    	Var_MontoTotDeuda,  Par_MonedaID,     	EsPrePagoNo,
							FiniquitoSi,   			Par_EmpresaID,      	Salida_NO,         	Con_NO,				Var_MontoPago,
							Par_Poliza,      		Par_NumErr,				Par_ErrMen,			Var_Consecutivo,	PagoCargoCuenta,
							Par_OrigenPago,			RespaldaCredSI,			Aud_Usuario,     	Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						-- Se valida que no haya devuelto mensaje de error
						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;
			END IF;
			/* ======================================================FIN PAGO DEL CREDITO ACTIVO======================================*/
		END IF; -- GL mayor a Cero

		SET Var_MontoDeudaDespGL	:= (SELECT FUNCIONCONFINIQCRE(Par_CreditoID));
		SET Var_MontoAdeudoSinIVA	:= (SELECT FUNCTOTDEUCRESINIIVA(Par_CreditoID));

		SET Var_MontoDeudaDespGL	:= IFNULL(Var_MontoDeudaDespGL,Decimal_Cero);
		SET Var_MontoAdeudoSinIVA	:= IFNULL(Var_MontoAdeudoSinIVA,Decimal_Cero);


		SELECT ValorParametro INTO Var_SaldoFega
			FROM PARAMGENERALES
			WHERE LlaveParametro	= LlaveSaldoFega;

		SELECT ValorParametro INTO Var_SaldoFonaga
			FROM PARAMGENERALES
			WHERE LlaveParametro	= LlaveSaldoFonaga;


		SET Var_SaldoFegaDec	:= CAST(Var_SaldoFega AS DECIMAL(14,2));
		SET Var_SaldoFonagaDec	:= CAST(Var_SaldoFonaga AS DECIMAL(14,2));
		SET Var_SaldoFegaDec	:= IFNULL(Var_SaldoFegaDec,Decimal_Cero);
		SET Var_SaldoFonagaDec	:= IFNULL(Var_SaldoFonaga,Decimal_Cero);


		IF(Par_TipoGarantiaFira = GarantiaFEGA)THEN
			SET Var_SaldoGtia	:= Var_SaldoFegaDec;

		ELSEIF(Par_TipoGarantiaFira = GarantiaFONAGA)THEN
			SET Var_SaldoGtia	:= Var_SaldoFonagaDec;

		ELSEIF(Par_TipoGarantiaFira = GarantiaAmbas)THEN
			SET Var_SaldoGtia	:= Var_SaldoFonagaDec;

		END IF;

		IF(Var_SaldoGtia >= Par_MontoGtia)THEN

			/******* SE LLAMA PROCESO PARA CREACION DE CREDITOS CONTINGENTES ANTES DE APLICAR LA GARANTIAS FIRA*******/

			IF(Var_MontoDeudaDespGL > Decimal_Cero)THEN /*Si el credito no se liquido con la aplicacion de GL*/
				-- Se llama proceso para creacion de credito contingentes
				CALL CREDITOSCONTPRO(
					Par_CreditoID,			Var_FechaSis,		Par_MontoGtia,		Con_NO,				Par_Poliza,
					Par_TipoGarantiaFira,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE

				-- Se inserta a la bitacora de aplicacion de garantias
				IF(Var_TotGarLiq > Decimal_Cero)THEN
					CALL APLIGARANAGROALT(
						Par_CreditoID,		Par_TipoGarantiaFira,		Var_PasCreditoID,		Var_ClienteID,			Var_CuentaAhoIDCre,
						Var_TotGarLiq,		Decimal_Cero,				Decimal_Cero,			Var_FechaSis,			Par_CreditoContFondeador,
						Par_Observacion,	Var_AcreditadoIDFIRA,		Var_CreditoIDFIRA,		Salida_NO,				Par_NumErr,
						Par_ErrMen,			Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

				SET Par_NumErr		:= 000;
				SET Par_ErrMen		:= 'Garantia Aplicada Exitosamente';
				SET Var_Control		:= 'creditoID';

				LEAVE ManejoErrores;
			END IF;

			/********************************************************FIN DE CREDITOS CONTINGENTES ************************************************************/


			/***********************************************************APLICACION DE GARANTIAS FIRA*********************************************************/

			/* ================================PAGO DE CREDITO ACTIVO=================================*/
			IF(Var_MontoDeudaDespGL > Decimal_Cero)THEN /*Si el credito no se liquido con la aplicacion de GL*/

				SELECT 		CuentaCompleta,		CentroCosto
					INTO 	Var_CtaGtiaFonaga,	Var_CtaFonagaCC
					FROM	CTASCONTAPLIGAR
					WHERE 	TipoGarantiaID = GarantiaFONAGA;

				SELECT 		CuentaCompleta,		CentroCosto
					INTO 	Var_CtaGtiaFega,	Var_CtaFegaCC
					FROM	CTASCONTAPLIGAR
					WHERE 	TipoGarantiaID = GarantiaFEGA;


				SET Var_CtaGtiaFonaga	:= IFNULL(Var_CtaGtiaFonaga,Cuenta_Vacia);
				SET Var_CtaGtiaFega		:= IFNULL(Var_CtaGtiaFega,Cuenta_Vacia);
				SET Var_CtaFonagaCC		:= IFNULL(Var_CtaFonagaCC,Cadena_Vacia);
				SET Var_CtaFegaCC		:= IFNULL(Var_CtaFegaCC,Cadena_Vacia);

				SET Var_SucCliente 		:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteID);
				SET Var_SucCliente		:= IFNULL(Var_SucCliente,Entero_Cero);


				IF(Par_TipoGarantiaFira = GarantiaFEGA)THEN
					SET Var_CCGarantia	:= Var_CtaFegaCC;
					SET Var_CtaContGtia	:= Var_CtaGtiaFega;

				ELSEIF(Par_TipoGarantiaFira = GarantiaFONAGA)THEN
					SET Var_CCGarantia	:= Var_CtaFonagaCC;
					SET Var_CtaContGtia	:= Var_CtaGtiaFonaga;

				ELSEIF(Par_TipoGarantiaFira = GarantiaAmbas)THEN
					SET Var_CCGarantia	:= Var_CtaFonagaCC;
					SET Var_CtaContGtia	:= Var_CtaGtiaFonaga;
				END IF;

				SET Var_CtaContGtia		:= IFNULL(Var_CtaContGtia,Cuenta_Vacia);


			   /*Se determina el Centro de Costos.*/
				IF LOCATE(For_SucOrigen, Var_CCGarantia) > Entero_Cero THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				ELSE
					IF LOCATE(For_SucCliente, Var_CCGarantia) > Entero_Cero THEN
						IF (Var_SucCliente > Entero_Cero) THEN
							 SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
						ELSE
							 SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
					ELSE
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					END IF;
				END IF;


				/* Monto Exigible del Adeudo*/
				SET Var_MontoExigible	:= (SELECT FUNCIONEXIGIBLE(Par_CreditoID));
				SET Var_MontoExigible 	:= IFNULL(Var_MontoExigible,Decimal_Cero);

				IF(IFNULL(Var_MontoExigible,Decimal_Cero) <= Decimal_Cero )THEN

				/*Si el pago exigible esta en cero, quiere decir que ya se ha pagado*/
					SET Var_ExigiblePagado		:= Con_SI;
				END IF;

				-- Monto Total del Adeudo
				SET Var_MontoTotDeuda	:= (SELECT FUNCIONCONFINIQCRE(Par_CreditoID));
				SET Var_MontoTotDeuda	:= IFNULL(Var_MontoTotDeuda,Decimal_Cero);

				/* Si el monto ingresado es menor o igual al pago exigible y
				   el pago exigible no esta pagado, entonces hace el abono a la cuota exigible*/
				IF(Par_MontoGtia<=Var_MontoExigible AND Var_ExigiblePagado=Con_NO) THEN


					CALL PAGOGARANAGROPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
						Par_CreditoID,		Var_CtaContGtia,		Var_CentroCostosID,	Par_MontoGtia,		Par_MonedaID,
						FiniquitoNo,		SI_PagaIva,				Con_NO,				Par_Poliza,			Var_MontoPago,
						Var_MontoIVAInt,    Var_MontoIVAMora,		Var_MontoIVAComi,	Var_Consecutivo,	Par_OrigenPago,
						Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;



				ELSE -- SI el monto ingresado es MAYOR al pago exigible Y sea MENOR al total adeudo y
					-- y el pago exigible se encuentra pagado, entonces hace el abono a la cuota exigible y/o prepago
					IF((Par_MontoGtia>Var_MontoExigible)AND(Par_MontoGtia<Var_MontoTotDeuda))THEN
						-- Se calcula la diferencia para poder realizar el prepago
						SET Var_DiferenciaPago := Par_MontoGtia-Var_MontoExigible;

						IF(IFNULL(Var_MontoExigible,Decimal_Cero)!=Decimal_Cero)THEN

							CALL PAGOGARANAGROPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
								Par_CreditoID,		Var_CtaContGtia,		Var_CentroCostosID,	Par_MontoGtia,		Par_MonedaID,
								FiniquitoNo,		SI_PagaIva,				Con_NO,				Par_Poliza,			Var_MontoPago,
								Var_MontoIVAInt,    Var_MontoIVAMora,		Var_MontoIVAComi, 	Var_Consecutivo,	Par_OrigenPago,
								Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


							-- Se valida que no haya devuelto mensaje de error
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

						END IF;
					ELSE -- Si no, se comprueba que el monto a pagar sea igual al total del adeudo
						IF(Par_MontoGtia >= Var_MontoTotDeuda)THEN
						-- Procedimiento del Pago del Credito "finiquito"

							CALL PAGOGARANAGROPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
								Par_CreditoID,		Var_CtaContGtia,		Var_CentroCostosID,	Var_MontoTotDeuda,	Par_MonedaID,
								FiniquitoSi,		SI_PagaIva,				Con_NO,				Par_Poliza,			Var_MontoPago,
								Var_MontoIVAInt,    Var_MontoIVAMora,		Var_MontoIVAComi,	Var_Consecutivo,	Par_OrigenPago,
								Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							-- Se valida que no haya devuelto mensaje de error
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;

				 /* ================================FIN PAGO DE CREDITO ACTIVO=================================*/


				SET ApliVenGar:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = VenAgro);
				SET ApliVenGar:= IFNULL(ApliVenGar, Con_NO);
				SET EstatusCre:= (SELECT Estatus FROM CREDITOS WHERE CreditoID = Par_CreditoID);

				 -- Paso a Vencido
				IF(ApliVenGar = Con_SI) THEN
					IF(EstatusCre = Est_Vigente) THEN
						CALL CREPASOVENGARANFIRAPRO(
							Par_CreditoID,		Salida_NO,				Par_Poliza,			Par_NumErr,				Par_ErrMen,
							Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				/*Se actualiza estatus de la garantia a P pagada en la tabla de creditos*/

				UPDATE CREDITOS SET
						EstatusGarantiaFIRA	= EstatusAplicado,

						EmpresaID			= Par_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual    		= Aud_FechaActual,
						DireccionIP     	= Aud_DireccionIP,
						ProgramaID      	= Aud_ProgramaID,
						Sucursal        	= Aud_Sucursal,
						NumTransaccion  	= Aud_NumTransaccion
					WHERE	CreditoID 		= Par_CreditoID;

				SET Var_SaldoFegaDec	:= Var_SaldoFegaDec - Par_MontoGtia;
				SET Var_SaldoFonagaDec	:= Var_SaldoFonagaDec - Par_MontoGtia;
				SET Var_SaldoFonaga		:= CAST(Var_SaldoFonagaDec AS CHAR);
				SET Var_SaldoFega		:= CAST(Var_SaldoFegaDec AS CHAR);

				-- Se actualizan los saldos de las garantias
				IF(Par_TipoGarantiaFira = GarantiaFEGA)THEN
					UPDATE PARAMGENERALES SET
						ValorParametro		= Var_SaldoFega
					WHERE LlaveParametro	= LlaveSaldoFega;

				ELSEIF(Par_TipoGarantiaFira = GarantiaFONAGA)THEN
					UPDATE PARAMGENERALES SET
						ValorParametro		= Var_SaldoFonaga
					WHERE LlaveParametro	= LlaveSaldoFonaga;

				ELSEIF(Par_TipoGarantiaFira = GarantiaAmbas)THEN
					UPDATE PARAMGENERALES SET
						ValorParametro		= Var_SaldoFonaga
					WHERE LlaveParametro	= LlaveSaldoFonaga;

				END IF;


				-- Se inserta a la bitacora de aplicacion de garantias
				CALL APLIGARANAGROALT(
					Par_CreditoID,		Par_TipoGarantiaFira,		Var_PasCreditoID,		Var_ClienteID,			Var_CuentaAhoIDCre,
					Var_TotGarLiq,		Par_PorcentajeGtia,			Par_MontoGtia,			Var_FechaSis,			Par_CreditoContFondeador,
					Par_Observacion,	Var_AcreditadoIDFIRA,		Var_CreditoIDFIRA,		Salida_NO,				Par_NumErr,
					Par_ErrMen,			Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);


				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				SET Par_NumErr		:= 000;
				SET Par_ErrMen		:= 'Garantia Aplicada Exitosamente';
				SET Var_Control		:= 'creditoID';

				/* =================================================== FIN PAGO CREDITO PASIVO ===========================================*/
			ELSE

				SET Par_NumErr		:= 10;
				SET Par_ErrMen		:= 'No Hay Saldo para Aplicar las Garantias';
				SET Var_Control		:= 'creditoID';
                LEAVE ManejoErrores;
			END IF;
		ELSE

			SET Par_NumErr		:= 10;
			SET Par_ErrMen		:= 'No Hay Saldo para Aplicar las Garantias';
			SET Var_Control		:= 'creditoID';
            LEAVE ManejoErrores;
		END IF;
		/***********************************************************FIN APLICACION DE GARANTIAS FIRA*********************************************************/

		-- CAMBIO DE FUENTE DE FONDEADOR DE UN CREDITO AGROPECUARIO
		IF(Var_CamFuenFonGarFira = Con_SI AND Var_InstitFondeoID <> Con_RecursosPropio ) THEN

			SELECT 	IFNULL(SaldoCapVigent,Decimal_Cero) + IFNULL(SaldoCapAtrasad,Decimal_Cero) +
					IFNULL(SaldoCapVencido,Decimal_Cero) + IFNULL(SaldCapVenNoExi,Decimal_Cero)
			INTO Var_MontoCap
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

			SET Var_MontoCap := IFNULL(Var_MontoCap, Decimal_Cero);

			CALL CAMBIOFONDEADORAGROPRO(
				Par_CreditoID,			Var_FechaSis,		Con_RecursosPropio,		SinLinea,				Par_Poliza,
				Var_MontoCap,			Par_UsuarioID,		Var_LineaFondeo,		Var_InstitFondeoID,		Par_MonedaID,
				Con_AplicaGarantia,		Salida_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Garantia Aplicada Exitosamente';
			SET Var_Control	:= 'creditoID';

		END IF;

		-- Si se realizo la Aplicacion de Garantia se actualiza los datos FIRA
		UPDATE CREDITOS SET
			AcreditadoIDFIRA	= Par_AcreditadoIDFIRA,
			CreditoIDFIRA		= Par_CreditoContFondeador,

			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual    		= Aud_FechaActual,
			DireccionIP     	= Aud_DireccionIP,
			ProgramaID      	= Aud_ProgramaID,
			Sucursal        	= Aud_Sucursal,
			NumTransaccion  	= Aud_NumTransaccion
		WHERE	CreditoID 		= Par_CreditoID;


	END ManejoErrores;

	IF (Par_Salida = Con_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$