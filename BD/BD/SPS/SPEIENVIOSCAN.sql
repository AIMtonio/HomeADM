DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSCAN`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSCAN`(
# =====================================================================================
# ------- STORE PARA REALIZAR UNA CANCELACION DE UN ENVIO SPEI ---------
# =====================================================================================
	Par_Folio						BIGINT(20),					-- Identificador unico de la tabla SPEIENVIOS
	Par_ClaveRastreo				VARCHAR(30),				-- Clave de Rastreo de la Orden de Pago
	Par_Comentario					VARCHAR(500),				-- Comentario correspondiente a la Cancelacion de la Orden de Pago

	Par_Salida						CHAR(1),					-- Indica si se regresara un resultado
	INOUT Par_NumErr				INT(11),					-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				-- Mensaje de Error

	-- Parametros de Auditoria
	Par_EmpresaID					INT(11),					-- Parametro de Auditoria
	Aud_Usuario						INT(11),					-- Parametro de Auditoria
	Aud_FechaActual					DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP					VARCHAR(20),				-- Parametro de Auditoria
	Aud_ProgramaID					VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal					INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion				BIGINT(20)					-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(200);				-- Variable de control
	DECLARE Var_Estatus				CHAR(1);					-- estatus del envio
	DECLARE Var_FechaSis			DATE;						-- fecha sistema
	DECLARE Var_Monto				DECIMAL(16,2);				-- Monto
	DECLARE Var_ComisionTrans		DECIMAL(16,2);				-- Comision de transferencia
	DECLARE Var_IVAComision			DECIMAL(16,2);				-- IVA comision
	DECLARE Var_DescMov				VARCHAR(150);				-- Descripcion de Movimiento
	DECLARE Var_Refe				VARCHAR(50);				-- Referencia
	DECLARE Var_Referencia			VARCHAR(50);				-- Referencia
	DECLARE Var_CuentaAho			BIGINT(12);					-- cuenta ahorro
	DECLARE Var_Poliza				BIGINT(20);					-- Numero de Poliza
	DECLARE Var_ClienteID			INT(11);					-- Numero de Cliente
	DECLARE Var_EstatusEnv			INT(3);						-- Estatus de envio
	DECLARE Var_Esta				CHAR(1);					-- Estatus de la remesa en safi
	DECLARE Var_EstatusRem			INT(3);						-- Estatus de la remesa
	DECLARE Var_ConPago				VARCHAR(40);				-- Conceto de pago de las remesas
	DECLARE Var_CtaBeneficiario		VARCHAR(40);				-- Cuenta Beneficiario
	DECLARE Var_InstiIDBenefi		INT(11);					-- ID de la Institucion Beneficiaria
	DECLARE Var_CtaBancosBenefi		VARCHAR(20);				-- Cuenta de Bancos del Beneficiario solo cuando es Retiro
	DECLARE Var_ClaveRastreo		VARCHAR(20);				-- Clave de rastreo de una remesa
	DECLARE Var_SpeiRemID			BIGINT(20);					-- Identificador de una remesa
	DECLARE Var_Cuenta				VARCHAR(50);
	DECLARE Var_ClabeInst			VARCHAR(18);
	DECLARE Var_InstiIDS			INT(11);      				-- institucion ordenante
	DECLARE Var_NumCtaInstit		VARCHAR(20);  				-- cuenta de la institucion ordenante
	DECLARE Var_Refere				VARCHAR(35);
	DECLARE Par_Consecutivo			BIGINT(20);
	DECLARE Var_Consecutivo			BIGINT(20);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);					-- constante cadena vacia
	DECLARE Entero_Cero				INT(11);					-- Constante entero cero
	DECLARE Decimal_Cero			DECIMAL;					-- constante decimal cero
	DECLARE SalidaSI				CHAR(1);					-- Constante salida si
	DECLARE SalidaNO				CHAR(1);					-- Constante salida NO
	DECLARE Estatus_Pen				CHAR(1);					-- estatus pendiente
	DECLARE Estatus_Env				CHAR(1);					-- Estatus enviada
	DECLARE Estatus_Aut				CHAR(1);					-- estatus autorizada
	DECLARE Estatus_Ver				CHAR(1);					-- estatus verificado
	DECLARE Act_Cancelada			INT(11);					-- actualizacion cancelada
	DECLARE Act_CanceladaCone		INT(11);					-- actualizacion a cancelada por conecta
	DECLARE Act_RemCancelado		INT(11);					-- Actualizadion de cancelacion de remesas
	DECLARE Mon_Pesos				INT(11);					-- Moneda pesos
	DECLARE AltaPoliza_SI			CHAR(1);					-- Indica si se realizara el alta de Poliza
	DECLARE CtoConRec_Spei			INT(11);					-- Concepto Contable de RECEPCION SPEI
	DECLARE Nat_Abono				CHAR(1);					-- Tipo Abono
	DECLARE Nat_Cargo				CHAR(1);					-- Tipo Cargo
	DECLARE AltaMovAhorro_SI		CHAR(1);					-- SI Alta Movimientos Ahorro
	DECLARE AltaMovAhorro_NO		CHAR(1);					-- NO Alta Movimientos Ahorro
	DECLARE CtoAho_Spei				INT(11);					-- Concepto Ahorro Pasivo
	DECLARE Estatus_Liq				INT(11);					-- Estatus liquidada
	DECLARE Pago_Agente				VARCHAR(40);				-- Pago a agentes
	DECLARE Fonde_Pag				VARCHAR(40);				-- Fondeo pagador
	DECLARE Env_Dinero				VARCHAR(40);				-- Envio de dinero
	DECLARE CtoCon_RemSpei			INT(11);					-- Concepto Contable de REMESAS SPEI
	DECLARE CtoConFon_Spei			INT(11);					-- Concepto Contable de REMESAS SPEI
	DECLARE Reti_Spei				VARCHAR(40);				-- Retiro de dinero
	DECLARE Var_Automatico			CHAR(1);
	DECLARE Var_TipoMovID			INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';						-- Cadena Vacia
	SET Entero_Cero					:= 0;						-- Entero Cero
	SET Decimal_Cero				:= 0.0;						-- Decimal Cero
	SET SalidaSI					:= 'S';						-- Salida SI
	SET SalidaNO					:= 'N';						-- Salida NO
	SET Estatus_Pen					:= 'P';						-- Estatus pendiente
	SET Estatus_Aut					:= 'A';						-- Estatus autorizada
	SET Estatus_Ver					:= 'V';						-- Estatus veririficado
	SET Act_Cancelada				:= 3;						-- Actualizacion cancelada
	SET Act_CanceladaCone			:= 10;						-- Actualiacion de estatus y estatus envios a cancelado
	SET Act_RemCancelado			:= 3;						-- Actualizacion de cancelacion de remesas
	SET Mon_Pesos					:= 1;						-- Moneda Pesos
	SET AltaPoliza_SI				:= 'S';						-- Si Alta de Poliza
	SET Var_Poliza					:= 0;						-- Inicializar Poliza
	SET CtoConRec_Spei				:= 809;						-- Concepto Contable de RECEPCION SPEI
	SET Nat_Abono					:= 'A';						-- Tipo Abono
	SET Nat_Cargo					:= 'C';						-- Tipo Cargo
	SET AltaMovAhorro_SI			:= 'S';						-- SI Alta Movimientos Ahorro
	SET CtoAho_Spei					:= 1;						-- Concepto Ahorro Pasivo
	SET Estatus_Env					:= 'E';						-- Estatus enviada
	SET Estatus_Liq					:= 2;						-- Estatus liquidada
	SET Pago_Agente					:= 'PAGO A AGENTES';		-- Pago a agentes
	SET Fonde_Pag					:= 'FONDEO A PAGADOR';		-- Fondeo pagador
	SET Env_Dinero					:= 'ENVIO DE DINERO';		-- Envio de dinero
	SET Reti_Spei					:= 'RETIRO SPEI';			-- Retiro de dinero
	SET CtoCon_RemSpei				:= 813;						-- Concepto Contable de REMESAS SPEI
	SET CtoConFon_Spei				:= 811;						-- Concepto contable FONDEO A PAGADOR
	SET AltaMovAhorro_NO			:= 'N';						-- NO Alta Movimientos Ahorro
	SET Var_Automatico				:= 'P';
	SET Var_TipoMovID				:= 14;						-- Envio de efectivo de banco a caja

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSCAN');
				SET Var_Control	= 'sqlException';
			END;

		IF(IFNULL(Par_Folio,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:='El Folio esta Vacio.';
			SET Var_Control	:= 'folio' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClaveRastreo,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'La Clave de Rastreo esta Vacia.';
			SET Var_Control	:= 'claveRastreo' ;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		/*---------------CANCELACIONES DE REMESAS-----------------------*/

		SELECT		Estatus,	EstatusRem,		ClaveRastreo,		SpeiRemID
			INTO	Var_Esta,	Var_EstatusRem,	Var_ClaveRastreo,	Var_SpeiRemID
			FROM	SPEIREMESAS
			WHERE	ClaveRastreo = Par_ClaveRastreo;

		SET Var_ClaveRastreo	:= IFNULL(Var_ClaveRastreo, Cadena_Vacia);
		SET Var_SpeiRemID		:= IFNULL(Var_SpeiRemID, Entero_Cero);

		IF (Var_SpeiRemID <> Entero_Cero) THEN

			SELECT	PS.Clabe,			CO.CuentaAhoID, 	CT.NumCtaInstit,		CT.InstitucionID
			INTO 	Var_ClabeInst, 		Var_Cuenta,			Var_NumCtaInstit,		Var_InstiIDS
				FROM PARAMETROSSPEI PS
					JOIN CUENTASAHOTESO CT ON  PS.Clabe = CT.CueClave
					JOIN CUENTASAHO CO ON CT.CuentaAhoID = CO.CuentaAhoID
					JOIN CLIENTES CTE ON CO.ClienteID = CTE.ClienteID
				WHERE	PS.EmpresaID	= Par_EmpresaID;

			/*  CANCELACION DE SPEI REMESAS */

			/* Mientras que el estatus sea Enviado (E), y estatus de envio sea diferente de liquidado
				Se permite la cancelacion por conecta
				*/
			IF(Var_Esta = Estatus_Env AND Var_EstatusRem != Estatus_Liq ) THEN
				SELECT	LEFT(FNDECRYPTSAFI(ConceptoPago),40),
						CONVERT(FNDECRYPTSAFI(MontoTransferir),DECIMAL(16,2)),
						CuentaAho,		ComisionTrans,		IVAComision,		ReferenciaNum
				INTO	Var_ConPago,	Var_Monto,
						Var_CuentaAho,	Var_ComisionTrans,	Var_IVAComision,	Var_Refe
					FROM SPEIREMESAS
					WHERE ClaveRastreo = Par_ClaveRastreo;

				/*SI LA CANCELACION ES DE PAGO A AGENTES*/
				IF(Var_ConPago = Pago_Agente || Var_ConPago = Fonde_Pag) THEN
					-- Llamada al store de actualizacion de estatus
					CALL SPEIREMESASACT(
						Var_SpeiRemID,		Par_ClaveRastreo,	Entero_Cero,		Entero_Cero,		Act_RemCancelado,
						SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control	:= 'claveRastreo' ;
						LEAVE ManejoErrores;
					END IF;

					-- Reversa de los cargos del monto y las comisionesy contabilidad
					-- CONTASPEISPRO

					-- se setea la fecha de operaciona fecha del sistema
					SELECT	FechaSistema
						INTO	Var_FechaSis
						FROM	PARAMETROSSIS;

					-- Descripcion de movimiento Cancelacion SPEI
					SET Var_DescMov		:= 'CANCELACION REMESA SPEI';
					SET Var_Referencia	:= (RTRIM(CONVERT(Var_Refe,CHAR(7))));

					-- cliente
					SELECT	ClienteID	INTO	Var_ClienteID
						FROM	CUENTASAHO
						WHERE	CuentaAhoID = Var_CuentaAho;

					CALL CONTASPEISPRO(
						Par_Folio,				Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,		Var_FechaSis,
						Var_Monto,				Var_ComisionTrans,	Var_IVAComision,	Var_DescMov,		Var_Referencia,
						Var_CuentaAho,			AltaPoliza_SI,		Var_Poliza,			CtoConFon_Spei,		Nat_Cargo,
						AltaMovAhorro_SI,		Var_CuentaAho,		Var_ClienteID,		Nat_Abono,			CtoAho_Spei,
						Entero_Cero,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control	:= 'claveRastreo' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				/*SI LA CANCELACION ES DE ENVIO DE DINERO*/
				IF(Var_ConPago = Env_Dinero) THEN
					-- Llamada al store de actualizacion de estatus
					CALL SPEIREMESASACT(
						Var_SpeiRemID,		Par_ClaveRastreo,		Entero_Cero,		Entero_Cero,		Act_RemCancelado,
						SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control	:= 'claveRastreo' ;
						LEAVE ManejoErrores;
					END IF;

					-- Reversa de los cargos del monto y las comisionesy contabilidad
					-- CONTASPEISPRO

					-- se setea la fecha de operaciona fecha del sistema
					SELECT	FechaSistema 	INTO	Var_FechaSis
						FROM	PARAMETROSSIS;

					-- Descripcion de movimiento Cancelacion SPEI
					SET Var_DescMov := 'CANCELACION REMESA SPEI';

					SET	Var_Referencia	:= (RTRIM(CONVERT(Var_Refe,CHAR(7))));

					-- cliente
					SELECT	ClienteID	INTO	Var_ClienteID
						FROM	CUENTASAHO
						WHERE	CuentaAhoID	= Var_CuentaAho;

					CALL CONTASPEISPRO(
						Par_Folio,			Aud_Sucursal,		Mon_Pesos,				Var_FechaSis,			Var_FechaSis,
						Var_Monto,			Var_ComisionTrans,	Var_IVAComision,		Var_DescMov,			Var_Referencia,
						Entero_Cero,		AltaPoliza_SI,		Var_Poliza,				CtoCon_RemSpei,			Nat_Cargo,
						AltaMovAhorro_NO,	Entero_Cero,		Entero_Cero,			Nat_Abono,				CtoAho_Spei,
						Entero_Cero,		SalidaNO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control	:= 'claveRastreo' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				CALL SPEIENVIOSACT(
					Par_Folio,			Par_ClaveRastreo,	Entero_Cero,		Entero_Cero,	Par_Comentario,
					Cadena_Vacia,		Entero_Cero,		Entero_Cero,		Act_Cancelada,	SalidaNO,
					Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					SET Var_Control	:= 'claveRastreo' ;
					LEAVE ManejoErrores;
				END IF;

				SET Var_Refere := CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));

				CALL TESORERIAMOVIMIALT(
					Var_Cuenta,			Var_FechaSis,		Var_Monto,				Var_DescMov,	 	Var_Refere,
					Cadena_Vacia,     	Nat_Abono,  		Var_Automatico, 		Var_TipoMovID,  	Entero_Cero,
					Par_Consecutivo,	SalidaNO,        	Par_NumErr,         	Par_ErrMen,     	Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control	:= 'numero' ;
					LEAVE ManejoErrores;
				END IF;

				CALL SALDOSCUENTATESOACT(
					Var_NumCtaInstit,	Var_InstiIDS,		Var_Monto,				Nat_Abono,			Par_Consecutivo,
					SalidaNO,			Par_NumErr,       	Par_ErrMen,     		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control	:= 'numero' ;
					LEAVE ManejoErrores;
				END IF;

				CALL POLIZAREMESASPRO(
					Var_Poliza,				Par_EmpresaID,		Var_FechaSis,		Var_SpeiRemID,		Aud_Sucursal,
					Entero_Cero, 			Var_Monto,			Mon_Pesos,			Var_DescMov,	    Var_SpeiRemID,
					Var_Consecutivo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control	:= 'numero' ;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr := 9000;
				SET Par_ErrMen := CONCAT('El SPEI con Estatus: ',Var_Esta, ' no puede ser cancelado');
				SET Var_Control:= 'claveRastreo' ;
				LEAVE ManejoErrores;
			END IF;

		ELSE
			/*---------------CANCELACIONES DE ENVIOS-----------------------*/
			SELECT	Estatus,		EstatusEnv,			LEFT(FNDECRYPTSAFI(ConceptoPago),40)
				INTO	Var_Estatus,	Var_EstatusEnv,		Var_ConPago
				FROM SPEIENVIOS
				WHERE	FolioSpeiID	= Par_Folio
					AND	ClaveRastreo	= Par_ClaveRastreo;

			/* El spei debe de existir en envios, con tipo de pago dif de devolucion */
			IF EXISTS (SELECT	ClaveRastreo
				FROM SPEIENVIOS
				WHERE	ClaveRastreo	= Par_ClaveRastreo
					AND	FolioSpeiID		= Par_Folio
					AND	TipoPagoID		!= Entero_Cero) THEN

				/* CANCELACION DE SPEI ENVIOS PANTALLA (VENTANILLA)*/

				/* Mientras que el estatus sea Pendiente (P), Autorizado (A) o Verificado por Tesoreria (V)
				Se permite la cancelacion
					*/
				IF(Var_Estatus = Estatus_Pen || Var_Estatus = Estatus_Aut || Var_Estatus = Estatus_Ver) THEN
					-- Se valida si la cancelacion un Retiro de SPEI
					IF(Reti_Spei = Var_ConPago) THEN
						-- Llamada al store de actualizacion de estatus
						CALL SPEIENVIOSACT(
							Par_Folio,			Par_ClaveRastreo,	Entero_Cero,		Entero_Cero,	Par_Comentario,
							Cadena_Vacia,		Entero_Cero,		Entero_Cero,		Act_Cancelada,	SalidaNO,
							Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET Var_Control	:= 'claveRastreo' ;
							LEAVE ManejoErrores;
						END IF;
						-- Reversa de los cargos del monto y las comisionesy contabilidad
						-- CONTASPEISPRO
						SELECT	CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),
								ReferenciaNum,		LEFT(FNDECRYPTSAFI(CuentaBeneficiario),20)
							INTO	Var_Monto,		Var_Refe,			Var_CtaBeneficiario
							FROM SPEIENVIOS
							WHERE	ClaveRastreo = Par_ClaveRastreo;

						SET	Var_Referencia	:= (RTRIM(CONVERT(Var_Refe,CHAR(7))));

						SELECT	CHT.InstitucionID,		CHT.NumCtaInstit
							INTO	Var_InstiIDBenefi,		Var_CtaBancosBenefi
							FROM CUENTASAHOTESO CHT
								JOIN	CUENTASAHO CH ON CHT.CuentaAhoID = CH.CuentaAhoID
								JOIN	CLIENTES CL ON CH.ClienteID = CL.ClienteID
							WHERE	CHT.CueClave = Var_CtaBeneficiario;

						CALL SPEIRETIROCAN(
							Var_InstiIDBenefi,	Var_CtaBancosBenefi,	Var_Monto,			Par_Folio,			Var_Referencia,
							SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET Var_Control	:= 'claveRastreo' ;
							LEAVE ManejoErrores;
						END IF;

					ELSE
						-- Llamada al store de actualizacion de estatus
						CALL SPEIENVIOSACT(
							Par_Folio,			Par_ClaveRastreo,		Entero_Cero,		Entero_Cero,		Par_Comentario,
							Cadena_Vacia,		Entero_Cero,			Entero_Cero,		Act_Cancelada,		SalidaNO,
							Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET Var_Control	:= 'claveRastreo' ;
							LEAVE ManejoErrores;
						END IF;
						-- Reversa de los cargos del monto y las comisionesy contabilidad
						-- CONTASPEISPRO

						-- se setea la fecha de operaciona  fecha del sistema
						SELECT	FechaSistema 	INTO	Var_FechaSis	FROM	PARAMETROSSIS;

						-- Monto transferir del spei, comision he IVA.

						SELECT	CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),
								ComisionTrans,			IVAComision,		ReferenciaNum,		CuentaAho
						INTO	Var_Monto,
								Var_ComisionTrans,		Var_IVAComision,	Var_Refe,			Var_CuentaAho
							FROM SPEIENVIOS
							WHERE	ClaveRastreo = Par_ClaveRastreo;

						-- Descripcion de movimiento Cancelacion SPEI
						SET Var_DescMov := 'CANCELACION SPEI';

						SET	Var_Referencia	:= (RTRIM(CONVERT(Var_Refe,CHAR(7))));

						-- cliente
						SELECT	ClienteID	INTO	Var_ClienteID
							FROM CUENTASAHO
							WHERE	CuentaAhoID	= Var_CuentaAho;

						CALL CONTASPEISPRO(
							Par_Folio,				Aud_Sucursal,			Mon_Pesos,				Var_FechaSis,		Var_FechaSis,
							Var_Monto,				Var_ComisionTrans,		Var_IVAComision,		Var_DescMov,		Var_Referencia,
							Var_CuentaAho,			AltaPoliza_SI,			Var_Poliza,				CtoConRec_Spei,		Nat_Cargo,
							AltaMovAhorro_SI,		Var_CuentaAho,			Var_ClienteID,			Nat_Abono,			CtoAho_Spei,
							Entero_Cero,			SalidaNO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET Var_Control	:= 'claveRastreo';
							LEAVE ManejoErrores;
						END IF;
					END IF;

				/*  CANCELACION DE SPEI ENVIOS(VENTANILLA) */

				/* Mientras que el estatus sea Enviado (E), y estatus de envio sea diferente de liquidado
					Se permite la cancelacion por conecta
					*/
				ELSEIF(Var_Estatus = Estatus_Env AND Var_EstatusEnv != Estatus_Liq) THEN
					-- Llamada al store de actualizacion de estatus
					CALL SPEIENVIOSACT(
						Par_Folio,			Par_ClaveRastreo,	Entero_Cero,		Entero_Cero,			Par_Comentario,
						Cadena_Vacia,		Entero_Cero,		Entero_Cero,		Act_CanceladaCone,		SalidaNO,
						Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control	:= 'claveRastreo';
						LEAVE ManejoErrores;
					END IF;
					-- Reversa de los cargos del monto y las comisionesy contabilidad
					-- CONTASPEISPRO

					-- se setea la fecha de operaciona  fecha del sistema
					SELECT	FechaSistema	INTO	Var_FechaSis
						FROM PARAMETROSSIS;

					-- Monto transferir del spei, comision he IVA.

					SELECT	CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),
							ComisionTrans,			IVAComision,		ReferenciaNum,		CuentaAho
					INTO	Var_Monto,
							Var_ComisionTrans,		Var_IVAComision,	Var_Refe,			Var_CuentaAho
						FROM SPEIENVIOS
						WHERE	ClaveRastreo = Par_ClaveRastreo;

					-- Descripcion de movimiento Cancelacion SPEI
					SET	Var_DescMov := 'CANCELACION SPEI';

					SET	Var_Referencia	:= (RTRIM(CONVERT(Var_Refe,CHAR(7))));

					-- cliente
					SELECT	ClienteID	INTO	Var_ClienteID
						FROM CUENTASAHO
						WHERE	CuentaAhoID	= Var_CuentaAho;

					CALL CONTASPEISPRO(
						Par_Folio,			Aud_Sucursal,			Mon_Pesos,			Var_FechaSis,		Var_FechaSis,
						Var_Monto,			Var_ComisionTrans,		Var_IVAComision,	Var_DescMov,		Var_Referencia,
						Var_CuentaAho,		AltaPoliza_SI,			Var_Poliza,			CtoConRec_Spei,		Nat_Cargo,
						AltaMovAhorro_SI,	Var_CuentaAho,			Var_ClienteID,		Nat_Abono,			CtoAho_Spei,
						Entero_Cero,		SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Var_Control	:= 'claveRastreo' ;
						LEAVE ManejoErrores;
					END IF;

				ELSE
					SET Par_NumErr	:= 500;
					SET Par_ErrMen	:= CONCAT('El SPEI con Estatus: ',Var_Estatus, ' no puede ser cancelado');
					SET Var_Control	:= 'claveRastreo' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Transaccion Realizada Correctamente';
		SET Var_Control:= 'claveRastreo' ;

	END ManejoErrores;

		IF(Par_Salida = SalidaSI) THEN
			SELECT Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Entero_Cero AS consecutivo;
		END IF;

END TerminaStore$$