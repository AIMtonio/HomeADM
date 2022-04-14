
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESVENCIMAPORTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONDICIONESVENCIMAPORTALT`;
DELIMITER $$

CREATE PROCEDURE `CONDICIONESVENCIMAPORTALT`(
# ====================================================================================
# ------ SP PARA SAR DE ALTA LAS CONDICIONES DE VENCIMIENTO DE UNA APORTACION---------
# ====================================================================================
	Par_AportacionID				INT(11),			-- ID de la aportacion, hace referencia a la tabla (APORTACIONES)
	Par_ReinversionAutomatica 		CHAR(1),			-- Indica Si/No reinvierte automaticamente\nS) Si\nN) No
	Par_TipoReinversion 			CHAR(3),			-- Indica el tipo de reinversion\nC) Capital\nCI) Capital mas interes\nN) Ninguna
	Par_OpcionAport 				INT(11),			-- ID del Tipo de Aportacion, hace referencia a la tabla TIPOSAPORTACIONES
	Par_Cantidad 					DECIMAL(12,2),		-- Indica cuando + o cuanto - se esta renovando (esto si el OpcionAportID es Renovacion con + o - )

	Par_Monto 						DECIMAL(18,2),		-- Indica el monto de la aportacion original
	Par_MontoRenovacion 			DECIMAL(18,2),		-- Indica la diferencia entre la renovacion + o - con el campo Monto
	Par_MontoGlobal 				DECIMAL(18,2),		-- Indica el Monto mas el capital de las inversiones vigentes del grupo familiar
	Par_TipoPago 					CHAR(1),			-- Indica Tipo de Pago\nV) Vencimiento\nE) Programado\n
	Par_DiaPago 					INT(11),			-- Indica el dia de Pago si se selecciono Tipo de pago Programado

	Par_Plazo 						INT(11),			-- Plazo en dias de la aportacion
	Par_PlazoOriginal 				INT(11),			-- Plazo Original de la aportacion
	Par_FechaInicio					DATE,				-- Fecha de Inicio de la aportacion
	Par_FechaVencimiento 			DATE,				-- Fecha de Vencimiento de la aportacion
	Par_TasaBruta 					DECIMAL(12,4),		-- Tasa Bruta de la aportacion

	Par_TasaISR 					DECIMAL(12,4),		-- Tasa ISR de la aportacion
	Par_TasaNeta 					DECIMAL(12,4),		-- Tasa Neta de la aportacion
	Par_CapitalizaInteres 			CHAR(1),			-- Indica Si/No capitaliza Interes\nS) Si\nN) No
	Par_GatNominal 					DECIMAL(12,2),		-- GAT nominal de la aportacion
	Par_InteresGenerado 			DECIMAL(12,2),		-- Interes generado de la aportacion

	Par_ISRRetener 					DECIMAL(12,4),		-- ISR a retener de la aaportacion
	Par_InteresRecibir 				DECIMAL(12,2),		-- Interes Recibir de la aportacion
	Par_TotalRecibir 				DECIMAL(18,2),		-- Monto total a recibir
	Par_Notas 						VARCHAR(500),		-- Notas
	Par_Especificaciones 			VARCHAR(700),		-- Especificaciones especiales

	Par_Estatus 					CHAR(1),			-- Indica el Estatus de la Aportacion\nP) Pendiente\nA) Autorizada\nR) Por Autorizar \n
	Par_Reinversion 				CHAR(1),			-- Indica si realiza reinversion automatica de las condiciones de la Nueva aportacion\nP) Posteriormente\nS) Si\nN) No
	Par_GatReal						DECIMAL(12,2),		-- Indica el valor del GAT Real
	Par_ConsolidarSaldos			CHAR(1),			-- Indica si Consolida Aportaciones Vigentes que venzan el mismo día que la Aportación a Consolidar. Aplica para Tipo de Reinversión con Más. S: SI N: No (default)
	Par_Condiciones					VARCHAR(700),		-- Indica las Condiciones
	Par_Salida 						CHAR(1), 			-- Salida en Pantalla

	INOUT Par_NumErr 				INT(11),			-- Parametro de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),		-- Parametro de mensaje de error
	Par_EmpresaID 					INT(11),			-- Parametro de Auditoria
	Aud_Usuario 					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 					VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal 					INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 				BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE Var_TipoAportID			INT(11);			-- Tipo de Aportacion.
	DECLARE Var_ClienteID			INT(11);			-- Número de Cliente.
	DECLARE Var_Especif				VARCHAR(250);		-- Especificaciones
	DECLARE Var_Calific				CHAR(1);			-- Calificacion del cliente
	DECLARE Var_Tasa 				DECIMAL(18,4);		-- Tasa calculada
	DECLARE Var_TasaFV				CHAR(1);			-- variable de Tasa Fija o Variable
	DECLARE Var_EspTasa				CHAR(1);			-- Guarda si la aportacion especifica tasa o no
	DECLARE Var_Estatus				CHAR(1);			-- Estatus de las condiciones de vencimiento
	DECLARE Var_AportID				INT(11);			-- Numero de Aportacion para consolidación.
	DECLARE Var_PlazoOriginal		INT(11);			-- Plazo en días capturado por el usuario desde pantalla.
	DECLARE Var_Plazo				INT(11);			-- Plazo real en días que hay entre la fecha de Inicio y la fecha de Vencimiento.

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia 			CHAR(1);			-- Cadena Vacia
	DECLARE Entero_Cero				TINYINT;			-- Entero Cero
	DECLARE Constante_NO			CHAR(1);			-- Constante No (N)
	DECLARE Constante_SI 			CHAR(1);			-- Constante Si (S)
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante Fecha Vacia
	DECLARE AportacionConMAS		INT(11);			-- Constante Aportacion con MAS
	DECLARE AportacionConMENOS		INT(11);			-- Aportacion con MENOS
	DECLARE TipoPago_Programado		CHAR(1);			-- Tipo de pago Programado (E)
	DECLARE Estatus_Pendiente		CHAR(1);			-- Estatus Pendiente
	DECLARE Estatus_Autorizada		CHAR(1);			-- Estatus Autorizada
	DECLARE Con_TasaFija			CHAR(1);			-- Constante Tasa Fija
	DECLARE Estatus_PorAutorizar	CHAR(1);			-- Estatus Por Autorizar
	DECLARE	TipoReg_CondV			INT(11);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Constante_NO		:= 'N';
	SET Constante_SI		:= 'S';
	SET Decimal_Cero		:= 00.00;
	SET Fecha_Vacia			:= '1900-01-01';
	SET AportacionConMAS	:= 2;
	SET AportacionConMENOS	:= 3;
	SET TipoPago_Programado	:= 'E';
	SET Estatus_Pendiente	:= 'P';
	SET Con_TasaFija		:= 'F';
	SET Estatus_Autorizada	:= 'A';
	SET Estatus_PorAutorizar := 'R';
	SET Par_MontoGlobal 	:= IFNULL(Par_MontoGlobal, Entero_Cero);
	SET Var_Especif 		:= '';
	SET	TipoReg_CondV		:= 02;			-- Tipo de Registro Alta de condiciones de vencimiento.

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr :=	999;
				SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CONDICIONESVENCIMAPORTALT');
				SET Var_Control	:= 'sqlException';
			END;

		DELETE FROM CONDICIONESVENCIMAPORT WHERE AportacionID = Par_AportacionID;

		IF(IFNULL(Par_AportacionID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:=	1;
			SET Par_ErrMen	:=	'No existe el Numero de Aportacion';
			SET Var_Control	:=	'aportacionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ReinversionAutomatica, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr	:=	2;
			SET Par_ErrMen	:=	'Indique Si o No Existe Reinversion Automatica';
			SET Var_Control	:=	'reinversionAutomNo';
			LEAVE ManejoErrores;
		END IF;

		SELECT
			TipoAportacionID,		ClienteID
		INTO
			Var_TipoAportID,		Var_ClienteID
		FROM APORTACIONES
		WHERE AportacionID = Par_AportacionID;

		SET Aud_FechaActual := NOW();

		SET Var_TasaFV := (SELECT TasaFV FROM TIPOSAPORTACIONES WHERE TipoAportacionID	= Var_TipoAportID);

		SET Var_EspTasa := (SELECT EspecificaTasa FROM TIPOSAPORTACIONES WHERE TipoAportacionID=Var_TipoAportID);
		SET Var_EspTasa :=IFNULL(Var_EspTasa,Constante_NO);

		# SE INVIERTEN LOS VALORES DE LOS PLAZOS, DEBIDO A QUE EN CONDICIONES SE GUARDABAN DE MANERA INVERSA AL REGISTRO DE APORTACIONES.
		SET Var_Plazo := Par_PlazoOriginal;
		SET Var_PlazoOriginal := Par_Plazo;

		-- Si reinvierte automaticamente
		IF(Par_ReinversionAutomatica = Constante_SI) THEN

			IF(IFNULL(Par_TipoReinversion, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	3;
				SET Par_ErrMen	:=	'El Tipo de Reinversion esta vacio';
				SET Var_Control	:=	'reinversion';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_OpcionAport, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	4;
				SET Par_ErrMen	:=	'El Tipo de Aportacion esta vacio';
				SET Var_Control	:=	'opcionAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto, Decimal_Cero) = Decimal_Cero) THEN
				SET Par_NumErr	:=	5;
				SET Par_ErrMen	:=	'El Monto de Aportacion esta vacio';
				SET Var_Control	:=	'montoNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MontoRenovacion, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	6;
				SET Par_ErrMen	:=	'El Monto de Renovacion esta vacio';
				SET Var_Control	:=	'montoRenovNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoPago, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	8;
				SET Par_ErrMen	:=	'El Monto de Aportacion esta vacio';
				SET Var_Control	:=	'tipoPagoNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_PlazoOriginal, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr	:=	9;
				SET Par_ErrMen	:=	'El Plazo esta vacio';
				SET Var_Control	:=	'plazoNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaInicio, Fecha_Vacia) = Fecha_Vacia) THEN
				SET Par_NumErr	:=	11;
				SET Par_ErrMen	:=	'La Fecha de Inicio esta vacia';
				SET Var_Control	:=	'fechaInicioNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaVencimiento, Fecha_Vacia) = Fecha_Vacia) THEN
				SET Par_NumErr	:=	12;
				SET Par_ErrMen	:=	'La Fecha de Inicio esta vacia';
				SET Var_Control	:=	'fechaVencimNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TasaBruta, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	13;
				SET Par_ErrMen	:=	'La Tasa Bruta esta vacia';
				SET Var_Control	:=	'tasaBrutaNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TasaISR, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	14;
				SET Par_ErrMen	:=	'La Tasa ISR esta vacia';
				SET Var_Control	:=	'tasaISRNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TasaNeta, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	15;
				SET Par_ErrMen	:=	'La Tasa Neta esta vacia';
				SET Var_Control	:=	'tasaNetaNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoPago = TipoPago_Programado) THEN
				IF(IFNULL(Par_CapitalizaInteres, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:=	16;
					SET Par_ErrMen	:=	'Indique si Capitaliza Interes';
					SET Var_Control	:=	'capitalizaNuevaAport';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_GatNominal, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	17;
				SET Par_ErrMen	:=	'El Gat Nominal esta vacio';
				SET Var_Control	:=	'gatNominalNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_InteresGenerado, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	18;
				SET Par_ErrMen	:=	'El Interes Generado esta vacio';
				SET Var_Control	:=	'interesGenNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ISRRetener, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	19;
				SET Par_ErrMen	:=	'EL ISR Retener esta vacio';
				SET Var_Control	:=	'isrRetenerNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_InteresRecibir, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	20;
				SET Par_ErrMen	:=	'El Interes Retener esta vacio';
				SET Var_Control	:=	'intRecibirNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TotalRecibir, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr	:=	21;
				SET Par_ErrMen	:=	'El Total a Recibir esta vacio';
				SET Var_Control	:=	'totRecibirNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_GatReal, Decimal_Cero) = Decimal_Cero) THEN
				SET Par_NumErr	:=	24;
				SET Par_ErrMen	:=	'El GAT Real esta vacio';
				SET Var_Control	:=	'gatRealNuevaAport';
				LEAVE ManejoErrores;
			END IF;

			IF((Par_OpcionAport = AportacionConMAS AND IFNULL(Par_ConsolidarSaldos,Constante_NO) = Constante_NO)
				OR Par_OpcionAport = AportacionConMENOS) THEN
				IF(IFNULL(Par_Cantidad, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:=	25;
					SET Par_ErrMen	:=	'La Cantidad esta vacia';
					SET Var_Control	:=	'cantidad';
				LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_TipoPago = TipoPago_Programado) THEN
				IF(IFNULL(Par_DiaPago, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:=	26;
					SET Par_ErrMen	:=	'El dia de Pago esta vacio';
					SET Var_Control	:=	'diaPagoNuevaAport';
				END IF;
			END IF;

			IF(Par_OpcionAport = AportacionConMAS)THEN
				IF(IFNULL(Par_ConsolidarSaldos, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:=	27;
					SET Par_ErrMen	:=	'Consolidar Saldos esta vacio';
					SET Var_Control	:=	'consolidarSaldos';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_OpcionAport = AportacionConMAS)THEN
				IF(IFNULL(Par_ConsolidarSaldos, Cadena_Vacia) = Constante_SI) THEN
					IF(NOT EXISTS(SELECT * FROM APORTCONSOLIDADAS WHERE AportConsID = Par_AportacionID))THEN
						SET Par_NumErr	:=	27;
						SET Par_ErrMen	:=	'No Existen Aportaciones a Consolidar.';
						SET Var_Control	:=	'consolidarSaldos';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			INSERT INTO CONDICIONESVENCIMAPORT(
				AportacionID,		ReinversionAutomatica,		TipoReinversion,		OpcionAportID,			Cantidad,
				Monto,				MontoRenovacion,			MontoGlobal,			TipoPago,				DiaPago,
				Plazo,				PlazoOriginal,				FechaInicio,			FechaVencimiento,		TasaBruta,
				TasaISR,			TasaNeta,					CapitalizaInteres,		GatNominal,				InteresGenerado,
				ISRRetener,			InteresRecibir,				TotalRecibir,			Notas,					Especificaciones,
				Estatus,			Reinversion,				GatReal,				ConsolidarSaldos,		Condiciones,
				EmpresaID,			UsuarioID,					FechaActual,			DireccionIP,			ProgramaID,
				Sucursal,			NumTransaccion)
			VALUES (
				Par_AportacionID,		Par_ReinversionAutomatica,	Par_TipoReinversion,	Par_OpcionAport,		Par_Cantidad,
				Par_Monto,				Par_MontoRenovacion,		Par_MontoGlobal,		Par_TipoPago,			Par_DiaPago,
				Var_Plazo,				Var_PlazoOriginal,			Par_FechaInicio,		Par_FechaVencimiento,	Par_TasaBruta,
				Par_TasaISR,			Par_TasaNeta,				Par_CapitalizaInteres,	Par_GatNominal,			Par_InteresGenerado,
				Par_ISRRetener,			Par_InteresRecibir,			Par_TotalRecibir,		Par_Notas,				Par_Especificaciones,
				Estatus_PorAutorizar,	Par_Reinversion,			Par_GatReal,			Par_ConsolidarSaldos,	Par_Condiciones,
				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			-- Si la aportacion cambio de tasa manualmente, se hace el insert a la tabla CAMBIOTASAAPORT
			IF (Var_TasaFV = Con_TasaFija AND Var_EspTasa=Constante_SI) THEN

				SET Var_Calific	:= (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID=Var_ClienteID);
				SET Var_Tasa	:= ROUND(FUNCIONTASAAPORTACION(Var_TipoAportID , Var_PlazoOriginal, Par_MontoGlobal, Var_Calific, Aud_Sucursal),2);

				IF(Var_Tasa <> Par_TasaBruta)THEN
					CALL CAMBIOTASAAPORTALT(
						Par_AportacionID,	Var_Tasa,			Par_TasaBruta,		TipoReg_CondV,		Constante_NO,
						Par_NumErr,			Par_ErrMen,			Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			END IF;
		END IF;

		# SI NO REINVIERTE O NO ES RENOVACIÓN CON MÁS, SE ELIMINAN EL GRUPO DE CONSOLIDACIÓN.
		IF(Par_ReinversionAutomatica = Constante_NO OR Par_OpcionAport != AportacionConMAS)THEN
			SET Var_AportID := (SELECT AportacionID FROM APORTCONSOLIDADAS WHERE AportConsID = Par_AportacionID);
			SET Var_AportID := IFNULL(Var_AportID,Entero_Cero);

			IF(Var_AportID != Entero_Cero)THEN
				CALL APORTCONSOLIDADASBAJ(
					Var_AportID,		Entero_Cero,		Constante_NO,		Par_NumErr,			Par_ErrMen,
					Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		END IF;

		-- Si NO reinvierte automaticamente
		IF(Par_ReinversionAutomatica = Constante_NO) THEN
			INSERT INTO CONDICIONESVENCIMAPORT(
				AportacionID,		ReinversionAutomatica,		TipoReinversion,		OpcionAportID,			Cantidad,
				Monto,				MontoRenovacion,			MontoGlobal,			TipoPago,				DiaPago,
				Plazo,				PlazoOriginal,				FechaInicio,			FechaVencimiento,		TasaBruta,
				TasaISR,			TasaNeta,					CapitalizaInteres,		GatNominal,				InteresGenerado,
				ISRRetener,			InteresRecibir,				TotalRecibir,			Notas,					Especificaciones,
				Estatus,			Reinversion,				GatReal,				Condiciones,			EmpresaID,
				UsuarioID,			FechaActual,				DireccionIP,			ProgramaID,				Sucursal,
				NumTransaccion
			)
			VALUES (
				Par_AportacionID,	Par_ReinversionAutomatica,	Par_TipoReinversion,	Par_OpcionAport,		Par_Cantidad,
				Par_Monto,			Par_MontoRenovacion,		Par_MontoGlobal,		Par_TipoPago,			Par_DiaPago,
				Var_Plazo,			Var_PlazoOriginal,			Par_FechaInicio,		Par_FechaVencimiento,	Par_TasaBruta,
				Par_TasaISR,		Par_TasaNeta,				Par_CapitalizaInteres,	Par_GatNominal,			Par_InteresGenerado,
				Par_ISRRetener,		Par_InteresRecibir,			Par_TotalRecibir,		Par_Notas,				Par_Especificaciones,
				Estatus_Autorizada,	Par_Reinversion,			Par_GatReal,			Par_Condiciones,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion
			);
		END IF;

		# SE ACTUALIZA SI LA APORTACIÓN TIENE CONDICIONES CAPTURADAS.
		UPDATE APORTACIONES
		SET ConCondiciones = Constante_SI
			WHERE AportacionID = Par_AportacionID;

		SET Par_NumErr := 00;
		SET Par_ErrMen := CONCAT('Condiciones de Vencimiento Grabadas Exitosamente.');
		SET Var_Control := 'aportacionID';

	END ManejoErrores;


	IF(Par_Salida = Constante_SI)THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_AportacionID AS consecutivo;
	END IF;

END TerminaStore$$

