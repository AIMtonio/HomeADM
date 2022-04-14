-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQUEOSCUENTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQUEOSCUENTAPRO`;DELIMITER $$

CREATE PROCEDURE `BLOQUEOSCUENTAPRO`(
# =====================================================================================
# ------- STORE PARA LAS BLOQUEAR EL SALDO DE UNA CUENTA ---------
# =====================================================================================
	Par_BloqueoID			INT(11), 			-- Requerido solo si se trata de un desbloqueo.
	Par_NatMovimiento		CHAR(1),			-- "B" indica un Bloqueo  / "D" indica un desbloqueo
	Par_CuentaAhoID			BIGINT(12),				-- Indica la cuenta de ahorro de la que se hara el movimiento
	Par_FechaMov			DATETIME,			-- fecha en que hace el movimiento
	Par_MontoBloq			DECIMAL(12,2),		-- Cantidad del movimiento

    Par_FechaDesbloq		DATETIME,			-- Requerido solo si se trata de un desbloqueo
	Par_TiposBloqID			INT,				-- Corresponde con la tabla TIPOSBLOQUEOS
	Par_Descripcion			VARCHAR(150),		-- Indica la descripcion del bloqueo
	Par_Referencia			BIGINT,				-- Referencia del bloqueo, ejemplo num de credito
	Par_UsuarioClave		VARCHAR(25),
	Par_ContraseniaAut		VARCHAR(500),

	Par_Salida				CHAR(1),			-- indca una salida
    INOUT Par_NumErr		INT,
    INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

	-- declaracion de constantes
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Var_BloqueID		INT;
	DECLARE Nat_Bloqueo			CHAR(1);
	DECLARE Nat_Desbloqueo		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE NumErr	 			INT;
	DECLARE ErrMen	 			VARCHAR(100);
	DECLARE Var_Activa			CHAR(1);
	DECLARE Reg_Movimiento		CHAR(1);
	DECLARE Var_Si				CHAR(1);
	DECLARE SaldoBloqueado		DECIMAL(12,2);
	DECLARE Var_MensajeSalida   VARCHAR(80);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Var_Contrasenia     VARCHAR(500);
	DECLARE Var_BloqGL			INT;
	DECLARE	Est_Autorizado		CHAR(1);
	DECLARE	Est_Inactivo		CHAR(1);
	DECLARE	Est_Vigente			CHAR(1);
	DECLARE Des_RevAbonocta		INT;
	DECLARE Est_Vencido			CHAR(1);
	DECLARE BloqueoTarjeta		INT(11);

	-- Declacion de Variables
	DECLARE Var_Control	    	VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);     -- Variable consecutivo
	DECLARE Sal_Cliente			INT;
	DECLARE Sal_SaldoDispo		DECIMAL(12, 2);
	DECLARE Sal_Moneda 			INT;
	DECLARE Sal_EstatusC		CHAR(1);
	DECLARE Var_EstatusCta  	CHAR(1);
	DECLARE Var_CtaCliente   	BIGINT(12);
	DECLARE Var_FechaHora    	DATE;
	DECLARE Var_Fecha       	CHAR(20);
	DECLARE Var_FecConver   	DATETIME;
	DECLARE Var_BloqueoID		INT;
	DECLARE Var_FolioBloq		INT;
	DECLARE Var_TipoBloq		INT;
	DECLARE Var_MontoBloq		DECIMAL(12,2);
	DECLARE Var_UsuarioID		INT;
	DECLARE Var_CreditoID		BIGINT(12);
	DECLARE Blo_AutoDep			INT;
	DECLARE Blo_AutoDis			INT;
	DECLARE Blo_CancelSoc		INT;	/* tipo de bloqueo para cancelacion de socio */
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_EstCredito		CHAR(1);
	DECLARE Var_AporteCliente	DECIMAL(14,2);
	DECLARE Var_TipoBloqOrig	INT(11);
	DECLARE Var_Referencia		BIGINT;

	-- asignacion de constantes
	SET Entero_Cero     	:= 0;				-- Entero Cero
	SET Cadena_Vacia    	:= '';				-- Cadena Vacia
	SET Nat_Bloqueo     	:= 'B';				-- Naturaleza Bloqueo
	SET Nat_Desbloqueo  	:= 'D';				-- Naturaleza Desbloqueo
	SET Salida_SI       	:= 'S';				-- Salida en Pantalla SI
	SET Salida_NO       	:= 'N';				-- Salida en Pantalla NO
	SET Var_Activa      	:= 'A';				-- Estatus Activa
	SET Reg_Movimiento  	:= 'N';
	SET Var_Si          	:= 'S';				-- Constante SI
	SET Decimal_Cero    	:= 0.00;			-- DECIMAL Cero
	SET Var_BloqGL      	:= 8; 		        -- corresponde con la tabla TIPOSBLOQUEOS, DEP POR GL
	SET Blo_AutoDep     	:= 13;              -- Tipo de Bloqueo Automatico en cada Deposito
	SET Blo_AutoDis     	:= 1;               -- Tipo de desbloqueo Automatico en por dispersion
	SET Blo_CancelSoc		:= 15;				-- Tipo de desbloqueo Automatico por cancelacion de socio
	SET Est_Autorizado  	:= 'A';				-- Estatus Autorizado
	SET Est_Inactivo    	:= 'I';				-- Estatus inactivo
	SET Est_Vigente     	:= 'V';				-- Estatus Vigente
	SET Est_Vencido			:= 'B';				-- Estatus Bencido
	SET Des_RevAbonocta		:= 14;				--  Reversa por bloqueo automatico por tipo de cuenta (Abono a Cuenta)
	SET BloqueoTarjeta		:= 3;				-- Tipo de Bloqueo por tarjeta de Debito corresponde con Tipos de bloqueos

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BLOQUEOSCUENTAPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		-- Asignacion de variables
		SELECT	BloqueoID,		FolioBloq,		MontoBloq,		IFNULL(TiposBloqID,Entero_Cero),	Referencia
		  INTO	Var_BloqueoID,	Var_FolioBloq,	Var_MontoBloq,	Var_TipoBloqOrig, 					Var_Referencia
			FROM BLOQUEOS
			WHERE	BloqueoID = Par_BloqueoID;

		SET Par_TiposBloqID := IFNULL(Par_TiposBloqID, Entero_Cero);

		IF(Par_TiposBloqID = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'Tipo de bloqueo esta vacio -BloqueoPro';
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT	TiposBloqID		INTO	Var_TipoBloq
			FROM TIPOSBLOQUEOS
			WHERE  TiposBloqID	= Par_TiposBloqID;

		IF(IFNULL(Var_TipoBloq, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El tipo de Bloqueo/Desbloqueo no existe.';
			SET Var_Control:= 'NatMovimiento' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NatMovimiento, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La naturaleza del bloqueo esta vacia -BloqueoPro.';
			SET Var_Control:= 'NatMovimiento' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El Numero Cuenta esta vacio -BloqueoPro.';
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoBloq, Entero_Cero) = Entero_Cero AND Par_NatMovimiento = Nat_Bloqueo) THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El monto esta vacio -BloqueoPro.';
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La descripcion esta vacia -BloqueoPro.';
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT	CuentaAhoID,	Estatus,		SaldoBloq,		ClienteID
		  INTO	Var_CtaCliente, Var_EstatusCta, SaldoBloqueado,	Var_ClienteID
			FROM CUENTASAHO
			WHERE	CuentaAhoID = Par_CuentaAhoID;

		IF(Var_EstatusCta != Var_Activa) THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'La cuenta no esta activa -BloqueoPro.';
			SET Var_Control:= 'cuentaAhoID' ;
			LEAVE ManejoErrores;
		END IF;

		CALL SALDOSAHORROCON(Sal_Cliente,	Sal_SaldoDispo,		Sal_Moneda,		Sal_EstatusC,	Par_CuentaAhoID);

		IF(Par_NatMovimiento = Nat_Bloqueo) THEN
			IF(IFNULL(Par_Referencia, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 008;
				SET Par_ErrMen := 'La referencia esta vacia -BloqueoPro.';
				SET Var_Control:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoBloq=Var_BloqGL ) THEN
				SELECT	CreditoID,		Estatus,		AporteCliente
				  INTO	Var_CreditoID,	Var_EstCredito,	Var_AporteCliente
					FROM CREDITOS
					WHERE	CreditoID  = Par_Referencia
					  AND 	(Estatus = Est_Inactivo OR Estatus = Est_Autorizado
							OR  Estatus = Est_Vigente OR Estatus = Est_Vencido)
					  AND	ClienteID = Var_ClienteID;

				IF(IFNULL(Var_EstCredito, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 009;
					SET Par_ErrMen := 'Referencia no valida, Indicar un Numero de Credito Valido.';
					SET Var_Control:= 'NatMovimiento' ;
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Var_AporteCliente, Decimal_Cero) = Decimal_Cero) THEN
					SET Par_NumErr := 010;
					SET Par_ErrMen := 'Referencia no valida, El Credito Indicado no Requiere Garantia Liquida.';
					SET Var_Control:= 'NatMovimiento' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF((IFNULL(Par_MontoBloq, Decimal_Cero)) = Decimal_Cero OR Par_MontoBloq < Decimal_Cero) THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen := 'La Cantidad debe de ser mayor que cero.';
				SET Var_Control:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MontoBloq <= Sal_SaldoDispo AND Sal_EstatusC = Var_Activa) THEN
				UPDATE	CUENTASAHO	SET
					SaldoDispon	= SaldoDispon - Par_MontoBloq,
					SaldoBloq 	= SaldoBloq + Par_MontoBloq
				WHERE	CuentaAhoID = Par_CuentaAhoID;

				SET Reg_Movimiento 		:= 'S';
				SET Var_MensajeSalida 	:= 'Movimiento de Bloqueo Realizado. Folio: ';
			ELSE
				SET Par_NumErr := 012;
				SET Par_ErrMen := CONCAT("Saldo a bloquear es mayor al disponible. safilocale.ctaAhorro ", Par_CuentaAhoID);
				SET Var_Control:= 'BloqueoID' ;
				SET Var_Consecutivo := 001;
				LEAVE ManejoErrores;
			END IF;
		END IF;



		IF(Par_NatMovimiento = Nat_Desbloqueo)THEN
			IF(IFNULL(Var_BloqueoID, Entero_Cero) = Entero_Cero AND Par_NatMovimiento = Nat_Desbloqueo ) THEN
				SET Par_NumErr := 013;
				SET Par_ErrMen := 'El Numero de Bloqueo no existe.';
				SET Var_Control:= 'NatMovimiento' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_FolioBloq, Entero_Cero) <> Entero_Cero AND Par_NatMovimiento = Nat_Desbloqueo ) THEN
				SET Par_NumErr := 013;
				SET Par_ErrMen := 'El registro ya se encuentra desbloqueado.';
				SET Var_Control:= 'NatMovimiento' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TiposBloqID <> Var_TipoBloqOrig AND Var_TipoBloqOrig IN(Var_BloqGL,BloqueoTarjeta)) THEN
				SET Par_NumErr := 014;
				SET Par_ErrMen := 'El Tipo Desbloqueo no coincide con el Tipo de Bloqueo Orignal';
				SET Var_Control:= 'BloqueoID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_MontoBloq <= SaldoBloqueado AND Sal_EstatusC = Var_Activa) THEN
				UPDATE	CUENTASAHO	SET
					SaldoDispon	= SaldoDispon + Var_MontoBloq,
					SaldoBloq 	= SaldoBloq - Var_MontoBloq
				WHERE	CuentaAhoID = Par_CuentaAhoID;

				SET Reg_Movimiento 		:= 'S';
				SET Var_MensajeSalida 	:= 'Movimiento de Desbloqueo Realizado. Folio: ';
			ELSE
				SET Par_NumErr := 015;
				SET Par_ErrMen := CONCAT("Saldo a desbloquear es mayor al bloqueado. safilocale.ctaAhorro ", Par_CuentaAhoID);
				SET Var_Control:= 'BloqueoID' ;
				SET Var_Consecutivo := 002;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SET Var_FechaHora   := (SELECT DATE(Par_FechaMov));
		SET Var_Fecha       := (CONCAT(Var_FechaHora,' ',CONVERT(CURTIME(),CHAR(8))));
		SET Var_FecConver   := (SELECT CAST(Var_Fecha AS DATETIME));

		IF(Reg_Movimiento = Var_Si) THEN
			SET Var_BloqueID := (SELECT IFNULL(MAX(BloqueoID),Entero_Cero)+1 FROM BLOQUEOS);

			IF(Par_BloqueoID > Entero_Cero AND Par_NatMovimiento = Nat_Desbloqueo) THEN

				-- No validad cuando el Desbloqueo viene de un pago de Credito
				IF(Aud_ProgramaID != 'PAGOCREDITOPRO' AND
					(Par_TiposBloqID != Blo_AutoDep OR Par_TiposBloqID!= Blo_AutoDis OR Par_TiposBloqID != Des_RevAbonocta
					OR Par_TiposBloqID != Blo_CancelSoc )) THEN

					SELECT	UsuarioID,	Contrasenia	INTO Var_UsuarioID,Var_Contrasenia
						FROM USUARIOS
						WHERE	Clave = Par_UsuarioClave;

					SET Var_Contrasenia	:= IFNULL(Var_Contrasenia, Cadena_Vacia);

					IF(Par_ContraseniaAut != Var_Contrasenia) THEN
						SET Par_NumErr := 016;
						SET Par_ErrMen := 'Contrasena o Usuario Incorrecto.';
						SET Var_Control:= 'claveUsuarioAut' ;
						LEAVE ManejoErrores;
					END IF;

					IF(Var_UsuarioID = Aud_Usuario) THEN
						SET Par_NumErr := 017;
						SET Par_ErrMen := 'El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza.';
						SET Var_Control:= 'claveUsuarioAut' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				INSERT INTO BLOQUEOS (
					BloqueoID,		CuentaAhoID,	NatMovimiento,	FechaMov,		MontoBloq,
					FechaDesbloq,	TiposBloqID,	Descripcion,	Referencia,		FolioBloq,
					UsuarioIDAuto,	ClaveUsuAuto,	EmpresaID,		Usuario,		FechaActual,
					DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
				VALUES(
					Var_BloqueID,		Par_CuentaAhoID,	Par_NatMovimiento,	    Var_FecConver,		Var_MontoBloq,
					Par_FechaDesbloq,	Par_TiposBloqID,	UPPER(Par_Descripcion),	Var_Referencia,		Entero_Cero,
					Var_UsuarioID,    	Par_UsuarioClave,	Aud_EmpresaID,		    Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		    Aud_NumTransaccion);

				UPDATE	BLOQUEOS SET
					FolioBloq 		= Var_BloqueID,
					FechaDesbloq	= Par_FechaDesbloq
				WHERE	BloqueoID = Par_BloqueoID ;

				SET Var_BloqueID := Par_BloqueoID;

			END IF; -- EndIF es Tipo Desbloqueo


			IF(Par_NatMovimiento = Nat_Bloqueo) THEN
				INSERT INTO BLOQUEOS (
					BloqueoID,			CuentaAhoID,		NatMovimiento,			FechaMov,			MontoBloq,
					FechaDesbloq,		TiposBloqID,		Descripcion,			Referencia,			FolioBloq,
					EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
					Sucursal,			NumTransaccion)
				VALUES(
					Var_BloqueID,		Par_CuentaAhoID,	Par_NatMovimiento,		Var_FecConver,		Par_MontoBloq,
					Par_FechaDesbloq,	Par_TiposBloqID,	UPPER(Par_Descripcion),	Par_Referencia, 	Entero_Cero,
					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			SET Par_NumErr := 000;
			SET Par_ErrMen := CONCAT(Var_MensajeSalida, CONVERT(Var_BloqueID, CHAR));
			SET Var_Control:= 'bloqueoID' ;
			SET Var_Consecutivo := 000;
		END IF;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$