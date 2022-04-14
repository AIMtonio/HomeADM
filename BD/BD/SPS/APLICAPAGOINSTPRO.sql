-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICAPAGOINSTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICAPAGOINSTPRO`;
DELIMITER $$

CREATE PROCEDURE `APLICAPAGOINSTPRO`(
	-- ========================================================================================================
	-- ------------------------ SP PARA APLICACION DE PAGOS INSTITUCIONES (NOMINA)-----------------------------
	-- ========================================================================================================
	Par_FolioNominaID		INT(11),			-- Folio del registro
	Par_FolioCargaID		INT(11),			-- Folio de la aplicacion del pago
	Par_EmpresaNominaID		INT(11),			-- ID de la empresa de nomina
	Par_CreditoID			BIGINT(12),			-- ID del credito
	Par_ClienteID			INT(11),			-- ID del empleado de nomina
	Par_NomEmpleado			VARCHAR(200),		-- Nombre del empleado de nomina

	Par_MontoPago			DECIMAL(18,2),		-- Monto del pago
	Par_ProductoCredito		VARCHAR(200),		-- Nombre del producto de credito
	Par_FechaPagoDesc		DATE,				-- Fecha de aplicaion del pago de credito
	Par_MontoTotDesc		DECIMAL(18,2),		-- Monto total del descuento
	Par_EstPagoDesc			CHAR(1),			-- Estatus del pago

	Par_EstPagoInst			CHAR(1),			-- Estatus de la institucion de nomina
	Par_InstitucionID		INT(11),			-- ID de la institucion bancaria
	Par_NumCuenta			VARCHAR(30),		-- Numero de cuenta de la institucion bancaria
	Par_MovConciliado		BIGINT(20),			-- Movimiento conciliado
	Par_MontoPagoInst		DECIMAL(18,2),		-- Total del monto conciliado

	Par_FechaPagoInst		DATE,				-- Fecha de la conciliacion
	Par_Salida				CHAR(1),			-- Indica si espera select de salida
	Par_Poliza				BIGINT,				-- Numero de poliza
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	INOUT Par_Consecutivo	BIGINT,				-- Consecutivo

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT,				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT				-- Parametro de auditoria
	)
TerminaStore: BEGIN

	DECLARE Var_InstitNominaID  VARCHAR(20);	-- Variable para el id de la institucion de nomina
	DECLARE Var_Control         VARCHAR(100);	-- Variable de control
	DECLARE Var_NumeroAmort		INT(11);		-- Cantidad de amortizaciones afectadas
	DECLARE Var_AmortizacionID	INT(11);		-- ID de la amortizacion
	DECLARE Var_Offset			INT(11);		-- Variable de apoyo para obtener los rangos de registros
	DECLARE Var_FechaVenci		DATE;			-- Fecha de vencimiento de la cuota
	DECLARE Var_FechaExigible	DATE;			-- Fecha exigible de la cuota
	DECLARE Var_FechaSistema	DATE;			-- Fecha del sistema
	DECLARE Var_AplicaTablaReal	CHAR(1);		-- Indica si aplica tabla real S:SI/N:NO
	DECLARE Var_ConvenioNominaID	INT(11);	-- ID del convenio
	DECLARE Var_DomiciliaPago	CHAR(1);		-- Indica si el convenio domicilia pago S:SI/N:NO
	DECLARE var_Frecuencia		CHAR(2);		-- Frecuancia del credito

	DECLARE Var_CuentaTrans     VARCHAR(25);	-- Cuenta Contable de Pago Transito
	DECLARE Var_NomenclaturaCR  VARCHAR(30);	-- NomenclaturaCR en la tabla PARAMETROSNOMINA
	DECLARE Var_Abono			CHAR(1);		-- Variable para abono
	DECLARE	Var_Descripcion		VARCHAR(100);	-- Descripcion del movimiento
	DECLARE Var_TipoMovAhoID	CHAR(4);		-- Tipo del movimiento, tabla: TIPOSMOVSAHO
	DECLARE Var_AltaEncPoliza	CHAR(1);		-- Alta de encabezado de poliza
	DECLARE Var_AltaDetPol		CHAR(1);		-- Alta detalle de poliza de ahorro
	DECLARE Var_CentroCostoCli	VARCHAR(10);	-- Centro de Costos Sucursal Cliente
	DECLARE Var_CentroCostoOri	VARCHAR(10);	-- Centro de Costos Sucursal Origen
	DECLARE Var_CentroCostosID  INT(11);		-- Centro de Costos Sucursal Cliente/Origen
	DECLARE Var_Exigible		DECIMAL(18,4);	-- Exigible del credito
	DECLARE Var_EsPrePago		CHAR(1);		-- El credito no es Prepago
	DECLARE Var_Finiquito		CHAR(1);		-- Si se necesita que se genere poliza
	DECLARE Var_MontoPago		DECIMAL(18,2);	-- Monto del pago aplicado
	DECLARE Var_CuentaAhoID		BIGINT(12);		-- ID de la cuenta de ahorro
	DECLARE Var_EspCuentaCon	CHAR(1);		-- Indica si especifica cuenta contable
	DECLARE Var_EstatusCarga	INT(11);		-- Estatus de los folios
	DECLARE Fecha_Vacia 		DATE;			-- Fecha vacia


	DECLARE Estatus_Activo  CHAR(1);			-- Constante estatus activo 'A'
	DECLARE Estatus_Vigente	CHAR(1);			-- Estatus vigente 'V'
	DECLARE Cadena_Vacia    CHAR(1);			-- Constante cadena vacia
	DECLARE Entero_Cero     INT(11);			-- Constante entero cero
	DECLARE SalidaSI        CHAR(1);			-- Constante salida si
	DECLARE Entero_Uno      INT(11);			-- Constante entero uno
	DECLARE Cons_No			CHAR(1);			-- Constante NO
	DECLARE Cons_Si			CHAR(1);			-- Constante SI
	DECLARE Cons_Mensual	CHAR(1);			-- Constante frecuencia mensual
	DECLARE Cons_Quincena	CHAR(1);			-- Constante frecuencia quincenal
	DECLARE Cons_Catorcena	CHAR(1);			-- Constante frecuencia catorcenal
	DECLARE Cons_Semanal	CHAR(1);			-- Constante frecuencia Semanal
	DECLARE Cons_Proceso	VARCHAR(50);		-- Constante nombre de proceso
	DECLARE Tip_Instrumento CHAR(3);			-- Tipo instrumento
	DECLARE SalidaNO		CHAR(1);			-- Salida no
	DECLARE Pago_CargoCuenta CHAR(1);			-- Cargo a cuenta
	DECLARE Con_Origen		CHAR(1);			-- Constante Origen donde se llama el SP (S= SAFI, W=WS)
	DECLARE RespaldaCredSI	CHAR(1);		-- Constante para respaldar el credito
	DECLARE Tipo_Instrumento CHAR(5);			-- Tipo de instrumento
	DECLARE Est_Pagado		CHAR(1);			-- Estatus pagado
	DECLARE Est_Procesado	CHAR(1);			-- Estatus procesado
	DECLARE Est_Aplicado	CHAR(1);			-- Estatus Aplicado

	SET Estatus_Activo		:= 'A';
	SET Estatus_Vigente		:= 'V';
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET SalidaSI			:= 'S';
	SET SalidaNO			:= 'N';
	SET Var_Offset			:= 0;
	SET Entero_Uno			:= 1;
	SET Cons_No				:= 'N';
	SET Cons_Si				:= 'S';
	SET Cons_Mensual		:= 'M';
	SET Cons_Quincena		:= 'Q';
	SET Cons_Catorcena		:= 'C';
	SET Cons_Semanal		:= 'S';
	SET Var_Abono			:= 'A';
	SET Var_Descripcion		:= 'APLICACION PAGO INSTITUCION';
	SET Var_TipoMovAhoID	:= '101';
	SET Var_AltaEncPoliza	:= 'N';
	SET Var_AltaDetPol		:= 'S';
	SET Cons_Proceso		:= 'APLICAPAGOINSTPRO';
	SET Var_CentroCostoCli	:='&SC';
	SET Var_CentroCostoOri	:='&SO';
	SET Tipo_Instrumento	:= '11';
	SET Var_EsPrePago		:= 'N';
	SET Var_Finiquito		:= 'N';
	SET Pago_CargoCuenta	:= 'C';
	SET Con_Origen			:= 'S';
	SET RespaldaCredSI		:= 'S';
	SET Est_Pagado			:= 'P';
	SET Est_Procesado		:= 'P';
	SET Est_Aplicado		:= 'A';
	SET Fecha_Vacia			:= '1900-01-01';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-APLICAPAGOINSTPRO');
							SET Var_Control := 'SQLEXCEPTION' ;
				END;


		# Se obtiene la Cuenta Contable Pago Transito
		SET Var_EspCuentaCon :=(SELECT IFNULL(EspCtaCon,Cons_No)
							FROM INSTITNOMINA
							WHERE InstitNominaID = Par_EmpresaNominaID);

		IF (Var_EspCuentaCon = Cons_Si)THEN
			SET Var_CuentaTrans := (SELECT IFNULL(CtaContable,Cadena_Vacia)
									FROM INSTITNOMINA
									WHERE InstitNominaID = Par_EmpresaNominaID);
		ELSE
			SET Var_CuentaTrans :=(SELECT IFNULL(CtaPagoTransito,Cadena_Vacia)
							FROM PARAMETROSNOMINA
							LIMIT 1);
		END IF;


		# Se obtiene el Centro de Costos
		SET Var_NomenclaturaCR := (SELECT IFNULL(NomenclaturaCR,Cadena_Vacia)
							FROM PARAMETROSNOMINA
							LIMIT 1);

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

		IF(IFNULL(Par_FolioCargaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen	:= 'El numero de folio esta vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EmpresaNominaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen	:= 'La empresa de nomina esta vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CreditoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen	:= 'El credito esta vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT * FROM CREDITOS WHERE CreditoID = Par_CreditoID) THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'El credito no existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_NomenclaturaCR, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen	:= 'La Nomenclatura Centro de Costo esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene la Cuenta de Ahorro
		SELECT  Cre.CuentaID,	Cre.ClienteID
		INTO Var_CuentaAhoID,	Par_ClienteID
			FROM CREDITOS Cre
			INNER JOIN DESCNOMINAREAL Pag ON Cre.CreditoID= Pag.CreditoID
			WHERE Pag.FolioNominaID= Par_FolioNominaID;

		-- INICIO SECCION ALTA DEL DETALLE DE POLIZA
		IF(Var_NomenclaturaCR = Var_CentroCostoCli)THEN
			SET Var_CentroCostosID :=(SELECT sucursalOrigen FROM CLIENTES
								WHERE ClienteID =Par_ClienteID);
			SET Var_CentroCostosID := FNCENTROCOSTOS(Var_CentroCostosID);
		ELSE
			IF (Var_NomenclaturaCR = Var_CentroCostoOri) THEN
				SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
			END IF;
		END IF;

		-- OBTENER DATOS DE LA INSTITUCION DE NOMINA
		SELECT AplicaTabla
			INTO Var_AplicaTablaReal
			FROM INSTITNOMINA
			WHERE InstitNominaID = Par_EmpresaNominaID;

		SET Var_AplicaTablaReal := IFNULL(Var_AplicaTablaReal,Cons_No);

		-- OBTENER EL ID DEL CONVENIO DE NOMINA
		SELECT c.ConvenioNominaID INTO Var_ConvenioNominaID
			FROM CREDITOS c
			WHERE c.CreditoID = Par_CreditoID;

		SET Var_ConvenioNominaID := IFNULL(Var_ConvenioNominaID,Entero_Cero);

		-- SABER SI EL CREDITO DOMICILIA PAGOS O NO
		SELECT DomiciliacionPagos INTO Var_DomiciliaPago
			FROM CONVENIOSNOMINA
			WHERE ConvenioNominaID = Var_ConvenioNominaID
			AND InstitNominaID = Par_EmpresaNominaID;

		SET Var_DomiciliaPago := IFNULL(Var_DomiciliaPago,Cadena_Vacia);

		-- Se realiza el Respaldo de las Tablas Reales
		CALL RESPAGOINSTPRO(
			Par_FolioCargaID,	Par_FolioNominaID,	Par_CreditoID, 			Par_MontoPago,			Par_MovConciliado,
			SalidaNO, 			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- SE HACE EL REGISTRO A LA TABLA REAL SI Y SOLO SI NO DOMICILIA PAGOS Y SI APLICA TABLA REAL

		IF(Var_AplicaTablaReal = Cons_Si AND Var_DomiciliaPago = Cons_No)THEN
			SELECT FrecuenciaCap INTO var_Frecuencia
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

			-- Frecuencia mensual
			IF (var_Frecuencia = Cons_Mensual)THEN
				SET Var_FechaExigible := (LAST_DAY(Var_FechaSistema));
			END IF;

			-- frecuencia quincenal
			IF (var_Frecuencia = Cons_Quincena)THEN
				IF(DAY( Var_FechaSistema ) <= 15 )THEN
					SET Var_FechaExigible := CAST(CONCAT( YEAR (Var_FechaSistema),'-',
														MONTH(Var_FechaSistema),'-',15) AS DATE);
				ELSE
					SET Var_FechaExigible := LAST_DAY(Var_FechaSistema);
				END IF;
			END IF;

			-- frecuencia catorcenal
			IF (var_Frecuencia = Cons_Catorcena)THEN
				IF(DAY( Var_FechaSistema ) <= 14 )THEN
					SET Var_FechaExigible := CAST(CONCAT( YEAR (Var_FechaSistema),'-',
														MONTH(Var_FechaSistema),'-',14) AS DATE);
				ELSE
					SET Var_FechaExigible := LAST_DAY(Var_FechaSistema);
				END IF;
			END IF;

			-- frecuencia semanal
			IF (var_Frecuencia = Cons_Semanal)THEN
				SET Var_FechaExigible := DATE_ADD(Var_FechaSistema, INTERVAL (4 - WEEKDAY(Var_FechaSistema) ) DAY);
			END IF;

			-- SI AUN NO EXISTE EL REGISTRO EN LA TABLA REAL
			IF NOT EXISTS(SELECT * FROM AMORTCRENOMINAREAL
									WHERE CreditoID = Par_CreditoID)THEN

				-- INICIO DEL CICLO PARA REGISTRAR EN LA TABLA REAL
				SET @Par_FolioNominaID	:= (SELECT IFNULL(MAX(FolioNominaID),Entero_Cero)  FROM AMORTCRENOMINAREAL);
				SET @Var_TmpFechaVencim := Var_FechaExigible;

				INSERT INTO AMORTCRENOMINAREAL (
						FolioNominaID,		CreditoID,		AmortizacionID,		FechaVencimiento,	FechaExigible,
						FechaPagoIns,		Estatus,		EstatusPagoBan,		EmpresaID,			Usuario,
						FechaActual,		DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
				SELECT @Par_FolioNominaID := @Par_FolioNominaID + Entero_Uno,
											amo.CreditoID, 	amo.AmortizacionID,	Var_FechaExigible, 	IF(var_Frecuencia = Cons_Semanal,Var_FechaExigible,FUNCIONDIAHABIL(Var_FechaExigible,Entero_Uno,Entero_Uno)),
						Par_FechaPagoDesc, 	IF(amo.Estatus = Est_Pagado,Est_Pagado,Estatus_Activo),
											IF(amo.Estatus = Est_Pagado,Est_Aplicado,Estatus_Vigente),	Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
						FROM AMORTICREDITO amo
						WHERE amo.CreditoID = Par_CreditoID;

					SET @fechaTemp = Var_FechaExigible;

					UPDATE AMORTCRENOMINAREAL
						SET FechaVencimiento = @fechaTemp:= FNSUMAFECHAXFRECUENCIA(@fechaTemp,var_Frecuencia),
							FechaExigible 	=	FUNCIONDIAHABIL(@fechaTemp,Entero_Uno,Entero_Uno),
							FechaPagoIns 	= Fecha_Vacia
					WHERE CreditoID = Par_CreditoID
					AND AmortizacionID > Entero_Uno;

			ELSE

				UPDATE AMORTCRENOMINAREAL REL
				INNER JOIN DESCNOMINAREAL DET ON  REL.CreditoID = DET.CreditoID  AND REL.AmortizacionID = DET.AmortizacionID
				INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID AND DET.AmortizacionID = AMO.AmortizacionID
												AND DET.NumTransaccion = AMO.NumTransaccion  AND AMO.Estatus = Est_Pagado
				SET
					REL.FechaPagoIns = Var_FechaSistema,
							REL.Estatus 	= Est_Pagado,
							REL.EstatusPagoBan 	= Est_Aplicado,
							REL.NumTransaccion	= DET.NumTransaccion
				WHERE DET.FolioCargaID = Par_FolioCargaID;

			END IF;-- FIN VALIDA SI YA EXISTE REGISTRO

			-- ACTUALIZA EL ESTATUS A PROCESADO DE LA TABLA DESCNOMINAREAL
			UPDATE DESCNOMINAREAL SET
				EstatPagBanco = Est_Aplicado
			WHERE FolioNominaID = Par_FolioNominaID
				AND CreditoID = Par_CreditoID;

			-- Se actualiza el Estatuso de todo el folio
			UPDATE DESCNOMINAREAL SET
				Estatus = Est_Procesado
			WHERE FolioCargaID = Par_FolioCargaID;

			-- Se actualiza el Folio en que que se realizo el proceso de Pago con respecto al Folio de Nomina
			UPDATE DESCNOMINAREAL SET
				FolioProcesoID = Par_FolioCargaID
			WHERE FolioNominaID = Par_FolioNominaID;

			-- Se actualiza el Movimienot de Conciliacion
			UPDATE TESOMOVSCONCILIA SET
				EstAplicaInst=Est_Aplicado
			WHERE InstitucionID = Par_InstitucionID
			AND NumCtaInstit = Par_NumCuenta
			AND NumeroMov = Par_MovConciliado;

		END IF; -- FIN NO DOMICILIA PAGOS Y APLICA TABLA REAL

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Pago(s) Aplicado(s) con Exito.';

	END ManejoErrores; #fin del manejador de errores


		IF (Par_Salida = SalidaSI) THEN
			SELECT Par_NumErr AS NumErr,
				   Par_ErrMen AS ErrMen,
				   'institNominaID' AS control,
				   Par_EmpresaNominaID AS consecutivo;
		END IF;

END TerminaStore$$