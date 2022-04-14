-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOACT`;

DELIMITER $$
CREATE PROCEDURE `LINEASCREDITOACT`(
	-- Actualiza la linea de credito, Autorizacion, bajas, bloqueo
	-- Modulo de Cartera --> Registro --> Lineas de Credito
	-- Modulo de Solicitud Credito Agro --> Registro --> Solicitud de Crédito
	Par_LineaCreditoID 		BIGINT(12),			-- Numero de Linea de Credito
	Par_Autorizado			DECIMAL(12,2),		-- Monto Autorizado
	Par_Fecha				DATE,				-- Fecha de Autorizacion
	Par_Usuario				INT(11),			-- Usuario de Autorizacion
	Par_Motivo				VARCHAR(150),		-- Motivo de Autorizacion

	Par_Excedente			DECIMAL(12,2),		-- Excedente de Linea
	Par_FolioContrato		VARCHAR(150),		-- Folio de Contrato
	Par_NumAct				TINYINT UNSIGNED,	-- Numero de Actualizacion

	Par_Salida				CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Estatus				CHAR(1);		-- Estatus de Linea
	DECLARE Var_CancelaLineaCre		INT(11);		-- Estatus de Cancelacion de Linea
	DECLARE Var_ProductoCreditoID	INT(11);		-- Numero de Producto de Crédito
	DECLARE Var_MonedaID			INT(11);		-- Numero de Moneda
	DECLARE Var_SucursalID			INT(11);		-- Numero de Sucursal

	DECLARE Par_PolizaID			BIGINT(20);		-- Numero de Poliza
	DECLARE Var_Descripcion			VARCHAR(100);	-- Descripcion
	DECLARE Var_CobraComAnual		CHAR(1);		-- Indica si cobra comisión anual de linea o no
	DECLARE Var_TipoComAnual		CHAR(1);		-- Indica el tipo de comisión anual de linea
	DECLARE Var_ValorComAnual		DECIMAL(14,2);	-- Indica el valor de la comisión anual de linea

	DECLARE Var_SaldoComAnual		DECIMAL(14,2);	-- Indica el saldo pendiente de la comisión anual de linea
	DECLARE Var_MontoMaxTipoLinea	DECIMAL(12,2);	-- Indica el monto maximo en base al tipo de linea
	DECLARE Var_TipoLineaID			INT(11);		-- Tipo de Linea Credito ID
	DECLARE Var_Control				VARCHAR(50);	-- Control de Retorno en Pantalla
	DECLARE	Var_AfectacionContable	CHAR(1);		-- Afectacion Contable

	DECLARE Var_MonMaximo			DECIMAL(12,2);	-- Monto maximo Permitido
	DECLARE Var_MonMinimo			DECIMAL(12,2);	-- Monto Minimo Permitido
	DECLARE Var_Deudor				DECIMAL(12,2);	-- Monto Deudor
	DECLARE Var_MontoLinea			DECIMAL(12,2);	-- Monto de la Linea
	DECLARE Var_CreditoIDCNBV		VARCHAR(29);	-- Numero de la CNBV


	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Constante Entero Vacio
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante Decimal Vacio
	DECLARE	Act_Autoriza			INT(11);		-- Numero de Actualizacion por Autorizacion

	DECLARE	Act_Bloqueo				INT(11);		-- Numero de Actualizacion por Bloqueo
	DECLARE	Act_Desbloqueo			INT(11);		-- Numero de Actualizacion por Desbloqueo
	DECLARE	Act_Cancelacion			INT(11);		-- Numero de Actualizacion por Cancelacion
	DECLARE Act_MontoAuto			INT(11);		-- Numero de Actualizacion por Monto Automatico
	DECLARE	Act_AutorizaAgro		INT(11);		-- Numero de Actualizacion por Autorizacion Agro

	DECLARE Act_Rechaza				INT(11);		-- Numero de Actualizacion por Rechazo Agro
	DECLARE ConcepCtaOrdenDeu		INT(11);		-- Concepto Cuenta Ordenante Deudor
	DECLARE ConcepCtaOrdenCor		INT(11);		-- Concepto Cuenta Ordenante Corte
	DECLARE ConcepCtaOrdenDeuAgro	INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE ConcepCtaOrdenCorAgro	INT(11);		-- Concepto Cuenta Ordenante Corte Agro

	DECLARE	Est_Autorizada			CHAR(1);		-- Constante Estatus Autorizada
	DECLARE	Est_Inactiva			CHAR(1);		-- Constante Estatus Inactiva
	DECLARE	Est_Bloqueada			CHAR(1);		-- Constante Estatus Bloqueda
	DECLARE Est_Cancelada			CHAR(1);		-- Constante Estatus Cancelada
	DECLARE	Est_Rechazada			CHAR(1);		-- Constante Estatus Rechazada

	DECLARE AltaEncPolizaSI			CHAR(1);		-- Alta de Encabezado de Poliza SI
	DECLARE AltaEncPolizaNO			CHAR(1);		-- Alta de Encabezado de Poliza NO
	DECLARE AltaDetPolizaSI			CHAR(1);		-- Alte de Detalle Poliza SI
	DECLARE Con_NO					CHAR(1);		-- Constante NO
	DECLARE Con_SI					CHAR(1);		-- Constante SI

	DECLARE EstatusCreVigent		CHAR(1);		-- Estatus Credito Vigente
	DECLARE EstatusCreVencid		CHAR(1);		-- Estatus Credito Vencido
	DECLARE EstatusCreCastig		CHAR(1);		-- Estatus Credito Castigado
	DECLARE NombreProceso			VARCHAR(16);	-- Nombre del Proceso
	DECLARE ConceptoContaLinea		INT(11);		-- Concepto Contable Linea de Credito

	DECLARE	SalidaNO				CHAR(1);		-- Constante Salida NO
	DECLARE	SalidaSI				CHAR(1);		-- Constante Salida SI
	DECLARE	Nat_Cargo				CHAR(1);		-- Naturaleza de Cargo
	DECLARE	Nat_Abono				CHAR(1);		-- Naturaleza de Abono
	DECLARE Tip_LineaCredito		INT(11);		-- Tipo de Producto

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;
	SET	Act_Autoriza		:= 1;

	SET Act_Bloqueo			:= 2;
	SET Act_Desbloqueo		:= 3;
	SET Act_Cancelacion		:= 4;
	SET Act_MontoAuto		:= 5;
	SET Act_AutorizaAgro	:= 6;

	SET Act_Rechaza			:= 7;
	SET ConcepCtaOrdenDeu	:= 53;		/* Linea Credito Cta. Orden */
	SET ConcepCtaOrdenCor	:= 54;		/* Linea Credito Corr. Cta Orden */
	SET ConcepCtaOrdenDeuAgro	:= 138;
	SET ConcepCtaOrdenCorAgro	:= 139;

	SET	Est_Autorizada		:= 'A';
	SET	Est_Inactiva		:= 'I';
	SET	Est_Bloqueada		:= 'B';
	SET	Est_Cancelada		:= 'C';
	SET Est_Rechazada		:= 'R';
	SET	AltaEncPolizaSI		:= 'S';
	SET	AltaEncPolizaNO		:= 'N';
	SET	AltaDetPolizaSI		:= 'S';
	SET	Con_NO				:= 'N';
	SET	Con_SI				:= 'S';
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';
	SET Aud_FechaActual 	:= NOW();


	SET	NombreProceso		:= 'LINEACREDITO'; -- Nombre del proceso que dispara el escalamiento interno de PLD de acuerdo con tabla PROCESCALINTPLD
	SET	SalidaSI			:= 'S';
	SET	SalidaNO			:= 'N';

	SET EstatusCreVigent	:= 'V';			-- Creditos con estatus vigente
	SET EstatusCreVencid	:= 'B';			-- Creditos con estatus vencido
	SET EstatusCreCastig	:= 'K';			-- Creditos con estatus Castigado
	SET ConceptoContaLinea	:= 65;			/* COncepto contable para lineas de credito tabla CONCEPTOSCONTA*/

	SET Tip_LineaCredito	:= 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-LINEASCREDITOACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_FolioContrato :=IFNULL(Par_FolioContrato,Cadena_Vacia);

		IF(NOT EXISTS(SELECT LineaCreditoID
					FROM LINEASCREDITO
					WHERE LineaCreditoID = Par_LineaCreditoID)) THEN

			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Linea de Credito no existe.';
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		/* se obtienen los datos necesarios de la lineas de credtio */
		SELECT	Estatus,		ProductoCreditoID,		MonedaID,		SucursalID,		Autorizado,   TipoLineaAgroID
		 INTO	Var_Estatus,	Var_ProductoCreditoID,	Var_MonedaID,	Var_SucursalID,	Var_MontoLinea, Var_TipoLineaID
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Par_LineaCreditoID;

		SET Var_AfectacionContable:= ( SELECT AfectacionContable FROM PRODUCTOSCREDITO  WHERE ProducCreditoID = Var_ProductoCreditoID);

		-- Autorizar Linea de credito
		IF(Par_NumAct = Act_Autoriza) THEN
			-- Llamada al proceso de deteccion de nivel de riesgo del cliente, modulo PLD
			CALL DETESCALAINTPLDPRO (
				Par_LineaCreditoID,	Entero_Cero,		NombreProceso,		Entero_Cero,		SalidaNO,
				Par_NumErr,	 		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr = Entero_Cero OR Par_NumErr = 502) THEN
				IF(Var_Estatus = Est_Autorizada) THEN
					SET Par_NumErr  := 2;
					SET Par_ErrMen  := 'La Linea de Credito ya esta Autorizada.';
					SET Var_Control := 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_Estatus = Est_Inactiva) THEN
					IF (IFNULL( Par_Autorizado, Decimal_Cero)) = Decimal_Cero THEN
						SET Par_NumErr  := 5;
						SET Par_ErrMen  := 'Especificar Monto a Autorizar.';
						SET Var_Control := 'lineaCreditoID';
						LEAVE ManejoErrores;
					ELSE
						IF (IFNULL( Par_Autorizado, Decimal_Cero)) < Decimal_Cero THEN
							SET Par_NumErr  := 6;
							SET Par_ErrMen  := 'El Monto Autorizado no debe ser Negativo.';
							SET Var_Control := 'lineaCreditoID';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					/* Valida que lo solicitado no sobrepase el maximo del producto de credito*/
					SELECT	MontoMaximo,		MontoMinimo
					INTO	Var_MonMaximo,		Var_MonMinimo
						FROM	PRODUCTOSCREDITO pc
						WHERE	pc.ProducCreditoID = Var_ProductoCreditoID;

					IF(Par_Autorizado > Var_MonMaximo) THEN
						SET Par_NumErr  := 3;
						SET Par_ErrMen  := 'El Monto sobre pasa.';
						SET Var_Control := 'autorizado';
						LEAVE ManejoErrores;
					END IF;

					IF(Par_Autorizado < Var_MonMinimo) THEN
						SET Par_NumErr  := 4;
						SET Par_ErrMen  := 'El Monto es menor';
						SET Var_Control := 'autorizado';
						LEAVE ManejoErrores;
					END IF;
					/* Termina validacion */

					-- Obtiene los parametros de la linea de crédito parametrizada en el producto de crédito
					SELECT 	CobraComAnual,		TipoComAnual, 		ValorComAnual
						INTO Var_CobraComAnual,	Var_TipoComAnual,	Var_ValorComAnual
					FROM LINEASCREDITO
					WHERE LineaCreditoID = Par_LineaCreditoID;

					/*Calcula Comisión Anual*/
					IF(Var_CobraComAnual='S')THEN
						IF (Var_TipoComAnual='P' AND Var_ValorComAnual<=100 )THEN
							SET Var_SaldoComAnual := (Par_Autorizado*(Var_ValorComAnual/100));
						ELSE
							SET Var_SaldoComAnual := Var_ValorComAnual;
						END IF;
					END IF;

					UPDATE LINEASCREDITO SET
						Autorizado			= Par_Autorizado,
						FechaAutoriza		= Par_Fecha,
						UsuarioAutoriza		= Par_Usuario,
						Estatus				= Est_Autorizada,
						SaldoDisponible		= Par_Autorizado,
						SaldoComAnual		= IFNULL(Var_SaldoComAnual, Entero_Cero),

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID 	= Par_LineaCreditoID;
					SET Var_Descripcion		:= "AUTORIZACION DE LINEA DE CREDITO.";


					IF(Var_AfectacionContable = Con_SI) THEN
						/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
						CALL CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
							Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Par_Autorizado,
							Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
							AltaEncPolizaSI,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenDeu,
							Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
							Par_PolizaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
						CALL CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
							Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Par_Autorizado,
							Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
							AltaEncPolizaNO,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenCor,
							Cadena_Vacia,		Nat_Abono,				Nat_Abono,			Par_NumErr,			Par_ErrMen,
							Par_PolizaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
					END IF;


					/* ********************************************
					* Se registra el Identificador CNBV para SOFIPOS
					*********************************************** */
					CALL GENERACREDIDCNBVPRO(
							Par_LineaCreditoID,			Tip_LineaCredito,	SalidaNO,		Par_NumErr,			Par_ErrMen,
							Var_CreditoIDCNBV,			Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					/* *** Fin genera Iden CNBV ****** */

					SET Par_NumErr  := 0;
					SET Par_ErrMen  := CONCAT("Linea de Credito Autorizada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR)) ;
					SET Var_Control := 'lineaCreditoID';
					LEAVE ManejoErrores;

				END IF;
			END IF;

			IF(Par_NumErr != Entero_Cero OR Par_NumErr != 502) THEN
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_NumAct = Act_Bloqueo) THEN

			IF(IFNULL(Par_Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Motivo esta Vacio.' ;
				SET Var_Control := 'motivo';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Est_Bloqueada) THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'La Linea de Credito ya esta Bloqueada.' ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE LINEASCREDITO SET
				FechaBloqueo		= Par_Fecha,
				UsuarioBloqueo		= Par_Usuario,
				Estatus				= Est_Bloqueada,
				MotivoBloqueo		= Par_Motivo,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID 	= Par_LineaCreditoID;


			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT("Linea de Credito Bloqueada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR)) ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;


		IF(Par_NumAct = Act_Desbloqueo) THEN
			IF(IFNULL(Par_Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := 'El Motivo esta Vacio.'  ;
				SET Var_Control := 'motivo';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Est_Autorizada) THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := 'La Linea de Credito ya estaba Desbloqueada.'  ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE LINEASCREDITO SET
				FechaDesbloqueo		= Par_Fecha,
				UsuarioDesbloq		= Par_Usuario,
				Estatus				= Est_Autorizada,
				MotivoDesbloqueo	= Par_Motivo,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID 	= Par_LineaCreditoID;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT("Linea de Credito Desbloqueada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR))  ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;

		END IF;

		IF(Par_NumAct = Act_Cancelacion) THEN
			IF(IFNULL(Par_Motivo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'El Motivo esta Vacio.'   ;
				SET Var_Control := 'motivo';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Est_Cancelada) THEN
				SET Par_NumErr  := 7;
				SET Par_ErrMen  := 'La Linea de Credito ya estaba Cancelada.'    ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Est_Inactiva) THEN
				SET Par_NumErr  := 8;
				SET Par_ErrMen  := 'La Linea de Credito no se puede Cancelar, esta Inactiva'    ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_Deudor :=(SELECT SaldoDeudor FROM LINEASCREDITO WHERE LineaCreditoID = Par_LineaCreditoID );

			/*Valida que la linea no cuente con saldo deudor*/
			IF(Var_Deudor > 0) THEN
				SET Par_NumErr  := 9;
				SET Par_ErrMen  := 'La Linea No se Puede Cancelar, Aun tiene Adeudo'   ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_CancelaLineaCre :=(SELECT IFNULL(COUNT(Estatus),0) FROM CREDITOS
										WHERE LineaCreditoID = Par_LineaCreditoID
											AND (Estatus   = EstatusCreVigent
												OR Estatus = EstatusCreVencid
												OR Estatus = EstatusCreCastig));


			IF(Var_CancelaLineaCre != NULL OR Var_CancelaLineaCre > 0) THEN
				SET Par_NumErr  := 9;
				SET Par_ErrMen  := 'La Linea No se Puede Cancelar, Aun tiene Adeudo'   ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;


			UPDATE LINEASCREDITO SET
				FechaCancelacion	= Par_Fecha,
				UsuarioCancela		= Par_Usuario,
				Estatus				= Est_Cancelada,
				MotivoCancela		= Par_Motivo,
				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID 	= Par_LineaCreditoID;

			/* SE REALIZARAN LAS AFECTACIONES CONTABLES CORRESPONDIENTES.*/
			SET Var_Descripcion		:= "CANCELACION DE DE LINEA DE CREDITO.";
			/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
			IF(Var_AfectacionContable = 'S') THEN
				CALL CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
					Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Var_MontoLinea,
					Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
					AltaEncPolizaSI,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenDeu,
					Cadena_Vacia,		Nat_Abono,				Nat_Abono,			Par_NumErr,			Par_ErrMen,
					Par_PolizaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
				CALL CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
					Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Var_MontoLinea,
					Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
					AltaEncPolizaNO,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenCor,
					Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
					Par_PolizaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT("Linea de Credito Cancelada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR))  ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		/* SECCION PARA INCREMENTAL EL MONTO DE LA LINEA DE CREDITO  o cambiar la fecha de vencimiento */
		IF(Par_NumAct = Act_MontoAuto) THEN

			UPDATE LINEASCREDITO SET
				Autorizado	        = Autorizado + Par_Excedente,
				FechaVencimiento	= Par_Fecha,
				SaldoDisponible     = SaldoDisponible + Par_Excedente,
				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID 	= Par_LineaCreditoID;


			/* SOLO SI SE ESTA AUMENTANDO EL SALDO DE LA LINEA DE CREDITO, SE REALIZARAN LAS AFECTACIONES CONTABLES CORRESPONDIENTES.*/
			IF(Var_AfectacionContable = Con_SI) THEN
				IF(Par_Excedente > Decimal_Cero) THEN
					SET Var_Descripcion		:= "INCREMENTO DE LINEA DE CREDITO.";
					SET Par_Fecha 			:= (SELECT FechaSistema FROM PARAMETROSSIS);
					/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
					CALL CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
						Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Par_Excedente,
						Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
						AltaEncPolizaSI,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenDeu,
						Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
						Par_PolizaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
					CALL CONTALINEACREPRO(	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
						Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Par_Excedente,
						Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
						AltaEncPolizaNO,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,				ConcepCtaOrdenCor,
						Cadena_Vacia,		Nat_Abono,				Nat_Abono,			Par_NumErr,			Par_ErrMen,
						Par_PolizaID,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			END IF;


			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT("Linea de Credito Modificada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR)) ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;

		END IF;

			-- Autorizar Linea de credito Agro
		IF(Par_NumAct = Act_AutorizaAgro) THEN

			SET Var_TipoLineaID := IFNULL(Var_TipoLineaID,Entero_Cero);

			IF(Var_TipoLineaID = Entero_Cero) THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'La Linea de Credito no es Agro.';
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Llamada al proceso de deteccion de nivel de riesgo del cliente, modulo PLD
			CALL DETESCALAINTPLDPRO (
				Par_LineaCreditoID,	Entero_Cero,		NombreProceso,		Entero_Cero,		SalidaNO,
				Par_NumErr,	 		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr = Entero_Cero OR Par_NumErr = 502) THEN
				IF(Var_Estatus = Est_Autorizada) THEN
					SET Par_NumErr  := 2;
					SET Par_ErrMen  := 'La Linea de Credito ya esta Autorizada.';
					SET Var_Control := 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_Estatus = Est_Inactiva) THEN
					IF (IFNULL( Par_Autorizado, Decimal_Cero)) = Decimal_Cero THEN
						SET Par_NumErr  := 3;
						SET Par_ErrMen  := 'Especificar Monto a Autorizar.';
						SET Var_Control := 'autorizado';
						LEAVE ManejoErrores;
					ELSE
						IF (IFNULL( Par_Autorizado, Decimal_Cero)) < Decimal_Cero THEN
							SET Par_NumErr  := 4;
							SET Par_ErrMen  := 'El Monto Autorizado no debe ser Negativo.';
							SET Var_Control := 'autorizado';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					IF(Par_FolioContrato = Cadena_Vacia) THEN
						SET Par_NumErr  := 5;
						SET Par_ErrMen  := 'Especificar Numero de Folio.';
						SET Var_Control := 'folioContrato';
						LEAVE ManejoErrores;
					END IF;
					/* Termina validacion */

					-- Obtiene los parametros de la linea de crédito parametrizada con el tipo de linea
					SELECT 	LI.CobraComAnual,	LI.TipoComAnual,	LI.ValorComAnual,	TI.MontoLimite,			LI.Solicitado
					INTO 	Var_CobraComAnual,	Var_TipoComAnual,	Var_ValorComAnual,	Var_MontoMaxTipoLinea,	Var_MontoLinea
					FROM LINEASCREDITO LI
					INNER JOIN TIPOSLINEASAGRO TI ON LI.TipoLineaAgroID = TI.TipoLineaAgroID
					WHERE LI.LineaCreditoID = Par_LineaCreditoID;

					IF(Par_Autorizado <= Entero_Cero) THEN
						SET Par_NumErr  := 5;
						SET Par_ErrMen  := 'El Monto solicitado esta vacio.';
						SET Var_Control := 'autorizado';
						LEAVE ManejoErrores;
					END IF;

					IF(Par_Autorizado > Var_MontoLinea) THEN
						SET Par_NumErr  := 6;
						SET Par_ErrMen  := 'El Monto sobre pasa monto solicitado.';
						SET Var_Control := 'autorizado';
						LEAVE ManejoErrores;
					END IF;

					IF(Par_Autorizado > Var_MontoMaxTipoLinea) THEN
						SET Par_NumErr  := 7;
						SET Par_ErrMen  := 'El Monto sobre pasa monto maximo por tipo de linea.';
						SET Var_Control := 'autorizado';
						LEAVE ManejoErrores;
					END IF;

					/*Calcula Comisión Anual*/
					IF( Var_CobraComAnual = 'S' )THEN
						IF (Var_TipoComAnual = 'P' AND Var_ValorComAnual <= 100 )THEN
							SET Var_SaldoComAnual := (Par_Autorizado*(Var_ValorComAnual/100));
						ELSE
							SET Var_SaldoComAnual := Var_ValorComAnual;
						END IF;
					END IF;

					SET Var_SaldoComAnual := IFNULL(Var_SaldoComAnual, Entero_Cero);

					UPDATE LINEASCREDITO SET
						Autorizado			= Par_Autorizado,
						FechaAutoriza		= Par_Fecha,
						UsuarioAutoriza		= Par_Usuario,
						Estatus				= Est_Autorizada,
						SaldoDisponible		= Par_Autorizado,

						SaldoComAnual		= Var_SaldoComAnual,
						FolioContrato		= Par_FolioContrato,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID 	= Par_LineaCreditoID;
					SET Var_Descripcion		:= "AUTORIZACION DE LINEA DE CREDITO AGRO.";

					-- se manda a llamar a sp que genera los detalles contables de lineas de credito.
					-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					CALL CONTALINEASCREPRO(
						Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Par_Autorizado,
						Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
						AltaEncPolizaSI,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenDeuAgro,
						Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,
						SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_PolizaID,
						Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					CALL CONTALINEASCREPRO(
						Par_LineaCreditoID,	Entero_Cero,			Par_Fecha,			Par_Fecha,			Par_Autorizado,
						Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
						AltaEncPolizaNO,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenCorAgro,
						Cadena_Vacia,		Nat_Abono,				Nat_Abono,
						SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_PolizaID,
						Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					/* ********************************************
					* Se registra el Identificador CNBV para SOFIPOS
					*********************************************** */
					CALL GENERACREDIDCNBVPRO(
						Par_LineaCreditoID,		Tip_LineaCredito,	SalidaNO,			Par_NumErr,			Par_ErrMen,
						Var_CreditoIDCNBV,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
					/* *** Fin genera Iden CNBV ****** */

					SET Par_NumErr  := Entero_Cero;
					SET Par_ErrMen  := CONCAT("Linea de Credito Agro Autorizada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR)) ;
					SET Var_Control := 'lineaCreditoID';
					LEAVE ManejoErrores;

				END IF;
			END IF;

			IF(Par_NumErr != Entero_Cero OR Par_NumErr != 502) THEN
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_NumAct = Act_Rechaza) THEN

			IF(Var_Estatus = Est_Rechazada) THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'La Linea de Credito ya esta Rechazada.' ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE LINEASCREDITO SET
				FechaRechazo		= Par_Fecha,
				UsuarioRechazo		= Par_Usuario,
				Estatus				= Est_Rechazada,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID 	= Par_LineaCreditoID;

			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := CONCAT("Linea de Credito Rechazada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR)) ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF Par_Salida = SalidaSI THEN
		SELECT	Par_NumErr		  AS NumErr,
				Par_ErrMen		  AS ErrMen,
				Var_Control		  AS control,
				Par_LineaCreditoID AS consecutivo;
	END IF;

END TerminaStore$$