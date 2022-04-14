-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOBEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOBEPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOCREDITOBEPRO`(
	# ==================================================================================================================
	# --------------------------------- SP PARA APLICAR EL PAGO DE CREDITO VIA NOMINA ----------------------------------
	# ==================================================================================================================
	Par_FolioNominaID		INT(11),
	Par_ClienteID			INT(11),
	Par_CreditoID			BIGINT(12),
	Par_MontoPagar			DECIMAL(12,2),
	Par_FechaAplica			DATE,

	Par_InstitNominaID		INT(11),
	Par_FolioCargaIDTeso	INT(11),
	Par_BorraDatos			CHAR(1),
	Par_EmpresaID			INT(11),
	Par_Salida				CHAR(1),

	INOUT Var_MontoPago		DECIMAL(12,2),
	Par_Poliza				BIGINT,
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,

	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Var_EsPrePago		CHAR(1); # El credito no es Prepago
	DECLARE Var_Finiquito		CHAR(1); # Si se necesita que se genere poliza
	DECLARE Var_AltaEncPoliza	CHAR(1);
	DECLARE Var_PorAplicar		CHAR(1);
	DECLARE Var_Procesado		CHAR(1);
	DECLARE Var_Abono			CHAR(1);
	DECLARE Var_TipoMovAhoID	CHAR(4); # Tipo del movimiento, tabla: TIPOSMOVSAHO
	DECLARE Var_AltaDetPol      CHAR(1); # Alta detalle de poliza de ahorro

	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_Aplicado		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Entero_Uno			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Tipo_Instrumento	CHAR(3);
	DECLARE Procedimiento		VARCHAR(50);
	DECLARE Var_Descripcion		VARCHAR(50);# Descripcion del movimiento
	DECLARE Var_CentroCostoCli	VARCHAR(10);# Centro de Costos Sucursal Cliente
	DECLARE Var_CentroCostoOri	VARCHAR(10);# Centro de Costos Sucursal Origen
	DECLARE Pago_CargoCuenta	CHAR(1);
	DECLARE Con_Origen			CHAR(1);
	DECLARE RespaldaCredSI		CHAR(1);
	DECLARE Var_SI				CHAR(1);
	DECLARE Var_NO				CHAR(1);
	DECLARE Con_LlaveParametro	VARCHAR(50);	-- Llave de Parametro



	/* Declaracion de variables  */
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_EstatusCarga	INT;     	# Num de Folios Pendientes por aplicar
	DECLARE Var_FolioCarga		INT(11);	# FolioCargaID
	DECLARE Var_Exigible		DECIMAL(14,4);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_CuentaTrans     VARCHAR(25);# Cuenta Contable de Pago Transito
	DECLARE Var_NomenclaturaCR  VARCHAR(30);# NomenclaturaCR en la tabla PARAMETROSNOMINA
	DECLARE Var_CentroCostosID  INT(11);# Centro de Costos Sucursal Cliente/Origen
	DECLARE Var_EspCuentaCon	CHAR(1);		-- Indica si especifica cuenta contable
	DECLARE Var_Convenio		BIGINT(12);	-- Convenio de Nomina
	DECLARE Var_Estatus			CHAR(1);	-- Estatus del Credito
	DECLARE Var_Domicilia		CHAR(1);	-- Domicilia Pagos el Convenio de Nomina
	DECLARE Var_ManejaConvNom   CHAR(1);
	

	/* Asignacion de constantes */
	SET Var_EsPrePago			:='N';
	SET Var_Finiquito			:='N';
	SET Var_AltaEncPoliza		:='N';
	SET Var_PorAplicar			:='P';  # Estatus BEPAGOSNOMINA P= Aplicar
	SET Var_Procesado			:='P';  # Estatus BECARGAPAGNOMINA P=Procesado
	SET Var_Abono				:='A';  # Movimiento de Abono
	SET Var_TipoMovAhoID		:='101';# Tipo del movimiento: 101 - PAGO CREDITO
	SET Var_AltaDetPol			:='S';  # S = alta detalle de poliza de ahorro

	SET Var_Aplicado			:='A'; 	# Estatus BEPAGOSNOMINA A= Aplicado
	SET SalidaSI				:='S';
	SET SalidaNO				:='N';
	SET Entero_Cero				:= 0 ;
	SET Entero_Uno				:= 1 ;
	SET Cadena_Vacia			:='' ;
	SET Tipo_Instrumento		:= 11;
	SET Procedimiento 			:= 'PAGOCREDITOBEPRO';
	SET Var_Descripcion			:= 'PAGO DE CREDITO NOMINA';
	SET Var_CentroCostoCli      :='&SC';
	SET Var_CentroCostoOri      :='&SO';
	SET Aud_FechaActual 		:= NOW();
	SET Pago_CargoCuenta		:= 'C';
	SET Con_Origen				:= 'N';		-- Pago de Crédito Origen Nomina
	SET RespaldaCredSI			:= 'S';
	SET Var_SI					:= 'S';
	SET Var_NO                  := 'N';
	SET Con_LlaveParametro		:= 'ManejaCovenioNomina';


	-- Inicializacion
	SET	Par_FolioCargaIDTeso	:= IFNULL(Par_FolioCargaIDTeso, Entero_Cero);
     
	-- Validamos si maneja convenios de nómina 
	SELECT ValorParametro
	INTO Var_ManejaConvNom
	FROM PARAMGENERALES
	WHERE LlaveParametro = Con_LlaveParametro;
    SET Var_ManejaConvNom       :=IFNULL(Var_ManejaConvNom,Var_NO);

	-- ================= VERIFICA SI TIENE CUENTA CONTABLE ESPECIFICA ===============================
	SET Var_EspCuentaCon := (SELECT IFNULL(EspCtaCon,SalidaNO)
						   FROM INSTITNOMINA
						   WHERE InstitNominaID = Par_InstitNominaID);

	IF (Var_EspCuentaCon = SalidaSI)THEN
		-- Se obtiene la Cuenta Contable Pago Transito especifica
		SET Var_CuentaTrans := (SELECT IFNULL(CtaContable,Cadena_Vacia)
								FROM INSTITNOMINA
								WHERE InstitNominaID = Par_InstitNominaID);
	ELSE
		# Se obtiene la Cuenta Contable Pago Transito configurada por default
		SET Var_CuentaTrans := (SELECT IFNULL(CtaPagoTransito,Cadena_Vacia)
						   FROM PARAMETROSNOMINA
						   LIMIT 1);
	END IF;
	-- ================= FIN VERIFICACION CUENTA CONTABLE ESPECIFICA =================================



	# Se obtiene el Centro de Costos
	SET Var_NomenclaturaCR := (SELECT IFNULL(NomenclaturaCR,Cadena_Vacia)
						   FROM PARAMETROSNOMINA
						   LIMIT 1);

	# Se obtiene la Fecha Actual del Sistema
	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOBEPRO');
							SET Var_Control := 'SQLEXCEPTION' ;
				END;


		IF(IFNULL(Var_NomenclaturaCR, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen	:= 'La Nomenclatura Centro de Costo esta Vacia.';
				LEAVE ManejoErrores;
			END IF;

		-- Validaciones para Proceder a realizar el Pago o no

		SELECT ConvenioNominaID, Estatus
		INTO Var_Convenio,		Var_Estatus
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_Convenio := IFNULL(Var_Convenio,Entero_Cero);

		IF(Var_Convenio = Entero_Cero AND Var_ManejaConvNom = Var_SI )THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen	:= CONCAT("El Credito ",Par_CreditoID, " no tiene un Convenio ligado");
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus NOT IN ('V','B'))THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen	:= CONCAT("El Credito ",Par_CreditoID, " no tiene un Estatus valido");
			LEAVE ManejoErrores;
		END IF;

		SELECT DomiciliacionPagos
		INTO Var_Domicilia
		FROM CONVENIOSNOMINA
		WHERE ConvenioNominaID = Var_Convenio;

		SET Var_Domicilia := IFNULL(Var_Domicilia, Cadena_Vacia);

		IF(Var_Domicilia = Var_SI) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen	:= CONCAT("El Convenio ",Var_Convenio, " ligado al Credito ", Par_CreditoID, " Domicilia Pagos");
			LEAVE ManejoErrores;
		END IF;

		# Se obtiene la Cuenta de Ahorro
		SELECT  Cre.CuentaID,	Cre.ClienteID
		INTO Var_CuentaAhoID,	Par_ClienteID
			FROM CREDITOS Cre
			INNER JOIN BEPAGOSNOMINA Pag
			ON Cre.CreditoID= Pag.CreditoID
			WHERE Pag.FolioNominaID= Par_FolioNominaID;

		# Llama al store para Abonar a la cuenta del Cliente
			CALL CONTAAHORROPRO (Var_CuentaAhoID, Par_ClienteID,  Aud_NumTransaccion, Par_FechaAplica,  Par_FechaAplica,
								 Var_Abono,       Par_MontoPagar, Var_Descripcion, 	  Par_CreditoID,	Var_TipoMovAhoID,
								 Entero_Uno,      Entero_Cero,    Var_AltaEncPoliza,  Entero_Cero,		Par_Poliza,
								 Var_AltaDetPol,  Entero_Uno,	  Var_Abono,          Par_NumErr,		Par_ErrMen,
								 Par_Consecutivo, Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,
								 Procedimiento,  Aud_Sucursal,   Aud_NumTransaccion );

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			 IF(Var_NomenclaturaCR = Var_CentroCostoCli)THEN
				SET Var_CentroCostosID :=(SELECT sucursalOrigen FROM CLIENTES
									WHERE ClienteID =Par_ClienteID);
				SET Var_CentroCostosID := FNCENTROCOSTOS(Var_CentroCostosID);
			ELSE
				IF (Var_NomenclaturaCR = Var_CentroCostoOri) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
				END IF;
			END IF;

		# Llama al store para dar de alta el detalle de poliza
			CALL DETALLEPOLIZAALT(Par_EmpresaID,   		Par_Poliza,      				Par_FechaAplica,  	Var_CentroCostosID,
								  Var_CuentaTrans,		CONVERT(Par_CreditoID,CHAR),    Entero_Uno,      	Par_MontoPagar,
								  Entero_Cero,      	Var_Descripcion,				Par_CreditoID,   	Procedimiento,
								  Tipo_Instrumento, 	Cadena_Vacia,					Entero_Cero,		Cadena_Vacia,
								  SalidaNO, 		    Par_NumErr,						Par_ErrMen,         Aud_Usuario,
								  Aud_FechaActual, 		Aud_DireccionIP,				Aud_ProgramaID,   	Aud_Sucursal,
								  Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_Exigible := FUNCIONEXIGIBLE(Par_CreditoID);

			IF(Var_Exigible  > Entero_Cero AND Par_MontoPagar >= Var_Exigible) THEN
				# Llamada al store para aplicar los pagos de Credito
				CALL PAGOCREDITOPRO( Par_CreditoID,   Var_CuentaAhoID,    Var_Exigible, 		Entero_Uno, 		 	Var_EsPrePago,
									 Var_Finiquito,   Par_EmpresaID,	  SalidaNO,		  		Var_AltaEncPoliza,		 Var_MontoPago,
									 Par_Poliza,	  Par_NumErr,         Par_ErrMen,	 	 	Par_Consecutivo,		 Pago_CargoCuenta,
									 Con_Origen,	  RespaldaCredSI,	  Aud_Usuario,	  		Aud_FechaActual,		 Aud_DireccionIP,
									 Aud_ProgramaID,  Aud_Sucursal,		  Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Par_MontoPagar := Var_Exigible;

			ELSE
				IF(Var_Exigible  > Entero_Cero AND Par_MontoPagar <= Var_Exigible) THEN
					# Llamada al store para aplicar los pagos de Credito
					CALL PAGOCREDITOPRO( Par_CreditoID,   Var_CuentaAhoID,    Par_MontoPagar, 	Entero_Uno, 		 	Var_EsPrePago,
										 Var_Finiquito,   Par_EmpresaID,	  SalidaNO,		  	Var_AltaEncPoliza,		 Var_MontoPago,
										 Par_Poliza,	  Par_NumErr,         Par_ErrMen,	  	Par_Consecutivo,		 Pago_CargoCuenta,
										 Con_Origen,	  RespaldaCredSI,     Aud_Usuario,		Aud_FechaActual,		 Aud_DireccionIP,
										 Aud_ProgramaID,  Aud_Sucursal,		  Aud_NumTransaccion
										);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				ELSE
					IF(Var_Exigible = Entero_Cero)THEN
						SET Par_NumErr := Entero_Cero;
						SET Par_MontoPagar := Entero_Cero;
					END IF;
				END IF;
			END IF;


			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen := 'Pago(s) Aplicado(s) con Exito.';

		#Se actualiza el Estatus de los Pagos Aplicados
			UPDATE BEPAGOSNOMINA SET
			   Estatus			= Var_Aplicado,
			   MontoAplicado	= Par_MontoPagar ,
			   FechaAplicacion	=  Var_FechaSistema,
			   NumTransaccion	= Aud_NumTransaccion
			WHERE  FolioNominaID= Par_FolioNominaID;

		#Se obtiene el FolioCargaID que se utiliza para obtener cuantos Pagos estan pendientes por aplicarse
			SET Var_FolioCarga	:= (SELECT FolioCargaID
									FROM BEPAGOSNOMINA
									 WHERE FolioNominaID= Par_FolioNominaID);

		#Se checa cuantos folios de la carga estan Pendientes
			SET Var_EstatusCarga := (SELECT COUNT(Estatus)
									 FROM BEPAGOSNOMINA Pag
									 WHERE FolioCargaID= Var_FolioCarga
									 AND Estatus=Var_PorAplicar);

		/*En caso de que ya no existan folios pendientes de la carga se actualiza el Estatus
		en la tabla BECARGAPAGNOMINA a Procesados	*/
			IF(Var_EstatusCarga = Entero_Cero)THEN
				UPDATE BECARGAPAGNOMINA SET
					   Estatus= Var_Procesado,
					   FechaApliPago = Var_FechaSistema
				WHERE  FolioCargaID=Var_FolioCarga;
			END IF;

		# Actualiza la tabla de TESOMOVSCONCILIA
			IF(Par_FolioCargaIDTeso!= Entero_Cero)THEN
				UPDATE TESOMOVSCONCILIA SET
					   EstatusConciliaIN = Var_Aplicado
				WHERE  FolioCargaID = Par_FolioCargaIDTeso;
			END IF;

		-- LLAMADA A SP PARA REGISTRAR TABLA REAL
		IF(Par_MontoPagar > Entero_Cero )THEN
			CALL DESCNOMINAREALALT(
							Par_FolioNominaID, 	Var_FolioCarga, 	Par_InstitNominaID, 	Var_FechaSistema, 	Par_CreditoID,
							Par_MontoPagar,		Var_FechaSistema,	Var_MontoPago,			Par_FechaAplica,	Par_ClienteID,
							SalidaNO,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END ManejoErrores; #fin del manejador de errores


	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   'institNominaID' AS control,
			   Par_InstitNominaID AS consecutivo;
	END IF;

END TerminaStore$$