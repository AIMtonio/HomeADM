-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBABONOBONIFICAWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBABONOBONIFICAWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBABONOBONIFICAWSPRO`(
	-- ====================================================================================
	-- -------- STORE PARA REALIZAR UN ABONO POR BONIFICACION DESDE WS - CREDICLUB --------
	-- ====================================================================================
	Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_CuentaAhoID			BIGINT(12),			-- Numero de cuenta
	Par_Monto				DECIMAL(12,2),		-- Monto
	Par_Meses				INT(11),			-- Numero de meses a dispersar
	Par_TipoDispersion		CHAR(1),			-- Tipo de Dispersion

	Par_CuentaClabe			VARCHAR(18),		-- Cuenta Clabe para la dispersion por SPEI
	INOUT Par_Poliza		BIGINT(20),			-- Numero de poliza
	Par_Salida 				CHAR(1),			-- Indica SI / No Salida en Pantalla
	INOUT Par_NumErr 		INT(11),			-- Parametro de numero de error
	INOUT Par_ErrMen 		VARCHAR(400),		-- Parametro de mensaje de error

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Control
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_MonedaID			INT(11);		-- Moneda id de la cuenta
	DECLARE Var_EstatusCuenta		CHAR(1);		-- Estatus de la cuenta
	DECLARE Var_CuentaID			BIGINT(12);		-- Numero de cuenta

	DECLARE Var_ClienteID			INT(11);		-- ID del cliente
	DECLARE Var_UsuarioID			INT(11);		-- ID del Usuario que realiza operacion
	DECLARE Var_SucursalID			INT(11);		-- Numero de Sucursal
	DECLARE Var_DescripcionMov		VARCHAR(45);	-- Descripcion de movimiento
	DECLARE Var_ReferenciaMov		VARCHAR(50);	-- Referencia del movimiento

	DECLARE Var_CenCosto			INT(11);		-- Centro de Costos
	DECLARE Var_CtaContable			VARCHAR(50);	-- Cuenta Contable
	DECLARE	Var_Instrumento			VARCHAR(20);	-- Instrumento
	DECLARE Var_Cargos				DECIMAL(14,4);	-- Monto de los cargos
	DECLARE Var_Abonos				DECIMAL(14,4);	-- Monto de los abonos

	DECLARE Var_Referencia			VARCHAR(50);	-- Referencia del movimiento
	DECLARE Var_Procedimiento		VARCHAR(30);	-- Nombre del procedimieto
	DECLARE Var_TipoInstrumentoID	INT(11);		-- Tipo de Instrumento
	DECLARE Var_ClaveUsuario		VARCHAR(50);	-- Clave del usuario
	DECLARE Var_SucursalCliente		INT(11);		-- Sucursal del cliente

	DECLARE Var_BonificacionID 		BIGINT(20);		-- Numero de Bonificacion

	-- DECLARACION DE CONSTANTES
	DECLARE Constante_SI			CHAR(1);		-- Constante valor SI
	DECLARE Constante_NO			CHAR(1);		-- Constante valor NO
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero CERO
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decimal CERO

	DECLARE Cuenta_Bloqueada		CHAR(1);		-- Estatus Cuenta Bloqueada
	DECLARE Cuenta_Inactiva			CHAR(1);		-- Estatus Cuenta Inactiva
	DECLARE Cuenta_Cancelada		CHAR(1);		-- Estatus Cuenta Cancelada
	DECLARE Cuenta_Registrada		CHAR(1);		-- Estatus Cuenta Registrada
	DECLARE Nat_MovAbono			CHAR(1); 		-- Naturaleza de movimiento tipo ABONO

	DECLARE Nat_MovCargo			CHAR(1);		-- Naturaleza de movimiento tipo CARGO
	DECLARE Mov_BonificacionID		INT(11);		-- ID del movimiento de Bonificacion hace referencia a la tabla TIPOSMOVSAHO
	DECLARE EncPoliza_NO			CHAR(1);		-- NO encabezado de poliza
	DECLARE ConcepContaAbono		INT(11);		-- Concepto Contable tipo ABONO
	DECLARE DetPoliza_SI			CHAR(1);		-- SI al detalle de poliza

	DECLARE AhorroBonifica			INT(11);		-- ID del concepto de ahorro gace referencia a la tabla CONCEPTOSAHORRO
	DECLARE CtaContableVacia		VARCHAR(50);	-- Cuenta contable Vacia
	DECLARE Mov_Bloqueo				CHAR(1);		-- Constante del movimiento tipo BLOQUEO
	DECLARE Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE Bloqueo_Bonifica		INT(11);		-- ID del tipo de Bloqueo
	DECLARE Bloqueo_BonificaDesc	VARCHAR(50);	-- Descripción del tipo de bloqueo
	DECLARE Constante_SPEI			CHAR(1);		-- Tipo de dispersion SPEI

	-- ASIGNACION DE CONSTANTES
	SET Constante_SI				:= 'S';
	SET Constante_NO				:= 'N';
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 00.00;
	SET Cuenta_Bloqueada 			:= 'B';
	SET Cuenta_Inactiva 			:= 'I';
	SET Cuenta_Cancelada 			:= 'C';
	SET Cuenta_Registrada 			:= 'R';
	SET Nat_MovAbono				:= 'A';
	SET Nat_MovCargo				:= 'C';
	SET Mov_BonificacionID			:= 31;
	SET EncPoliza_NO				:= 'N';
	SET ConcepContaAbono			:= 45;
	SET DetPoliza_SI				:= 'S';
	SET AhorroBonifica				:= 33;
	SET CtaContableVacia			:= '0000000000000000000000000';
	SET Mov_Bloqueo					:= 'B';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Bloqueo_Bonifica			:= 22;
	SET Bloqueo_BonificaDesc		:= 'BLOQUEO POR BONIFICACION';
	SET Constante_SPEI				:= 'S';
	SET Var_BonificacionID			:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr :=	999;
				SET Par_ErrMen :=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CRCBABONOBONIFICAWSPRO');
				SET Var_Control	:= 'sqlException';
			END;


		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		IF (IFNULL(Par_CuentaAhoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Cuenta Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_ClienteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Numero de Cliente Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_Monto, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El Monto Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;


		SET Var_CuentaID := (SELECT CuentaAhoID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);

		IF (IFNULL(Var_CuentaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'El Numero de Cuenta No existe.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_TipoDispersion, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'El Tipo de Dispersion Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_TipoDispersion, Cadena_Vacia) = Constante_SPEI) THEN
			IF (IFNULL(Par_CuentaClabe, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 006;
				SET Par_ErrMen  := 'La Cuenta Clabe Esta Vacia.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (IFNULL(Par_Meses, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 007;
			SET Par_ErrMen  := 'El Numero de Meses Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Aud_Usuario, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 008;
			SET Par_ErrMen  := 'El Numero de Usuario Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Aud_ProgramaID, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 009;
			SET Par_ErrMen  := 'El Nombre del Programa Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Aud_DireccionIP, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := 010;
			SET Par_ErrMen  := 'La Direccion IP Esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Aud_Sucursal,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 011;
			SET Par_ErrMen  := 'El Numero de Sucursal Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;


		SET Var_ClienteID := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID AND ClienteID = Par_ClienteID);

		IF (IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 012;
			SET Par_ErrMen  := 'El Numero de Cuenta no Corresponde al Numero de Cliente.';
			LEAVE ManejoErrores;
		END IF;


		SET Var_EstatusCuenta:= (SELECT Estatus FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID AND ClienteID = Par_ClienteID);

		IF (Var_EstatusCuenta = Cuenta_Bloqueada) THEN
			SET Par_NumErr  := 013;
			SET Par_ErrMen  := 'La Cuenta Esta Bloqueada.';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_EstatusCuenta = Cuenta_Cancelada) THEN
			SET Par_NumErr  := 014;
			SET Par_ErrMen  := 'La Cuenta Esta Cancelada.';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_EstatusCuenta = Cuenta_Inactiva) THEN
			SET Par_NumErr  := 015;
			SET Par_ErrMen  := 'La Cuenta Esta Inactiva.';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_EstatusCuenta = Cuenta_Registrada) THEN
			SET Par_NumErr  := 016;
			SET Par_ErrMen  := 'La Cuenta No Esta Activa.';
			LEAVE ManejoErrores;
		END IF;

		SET Var_UsuarioID := (SELECT UsuarioID FROM USUARIOS WHERE UsuarioID = Aud_Usuario);

		IF (IFNULL(Var_UsuarioID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 017;
			SET Par_ErrMen  := 'Numero de Usuario Incorrecto.';
			LEAVE ManejoErrores;
		END IF;

		SET Var_SucursalID	:= (SELECT SucursalID FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);

		IF (IFNULL(Var_SucursalID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 018;
			SET Par_ErrMen  := 'Numero de Sucursal Incorrecto.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Poliza, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 019;
			SET Par_ErrMen  := 'El Numero de Poliza Esta Vacio.';
			LEAVE ManejoErrores;
		END IF;


		SET Var_DescripcionMov	:= (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Mov_BonificacionID);
		SET Var_ReferenciaMov	:= Par_CuentaAhoID;
		SET Var_MonedaID		:= (SELECT MonedaID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
		SET Var_SucursalCliente := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_ClienteID );


		-- 1) Se manda a llamar SP de CARGO/ABONO CUENTA
		CALL CARGOABONOCUENTAPRO(
			Par_CuentaAhoID, 		Par_ClienteID,		Aud_NumTransaccion, 	Var_FechaSistema, 		Var_FechaSistema,
			Nat_MovAbono,			Par_Monto,			Var_DescripcionMov, 	Var_ReferenciaMov,		Mov_BonificacionID,
			Var_MonedaID, 			Var_SucursalCliente, EncPoliza_NO,			ConcepContaAbono,		Par_Poliza,
			DetPoliza_SI, 			AhorroBonifica,		Nat_MovAbono, 			Entero_Cero,			Constante_NO,
			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,   		Aud_NumTransaccion
		);
		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;



		SET Var_CenCosto := (SELECT S.CentroCostoID FROM CUENTASAHO C INNER JOIN SUCURSALES S ON C.SucursalID = S.SucursalID
							WHERE C.CuentaAhoID = Par_CuentaAhoID LIMIT 1);
		SET Var_CtaContable := (SELECT ValorParametro FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'CtaContablePteBonificaciones');
		SET Var_CtaContable := (IFNULL(Var_CtaContable, CtaContableVacia));
		SET Var_Instrumento := Par_CuentaAhoID;
		SET Var_Abonos		:= Decimal_Cero;
		SET Var_Cargos		:= Par_Monto;
		SET Var_Referencia 	:= Par_CuentaAhoID;
		SET Var_Procedimiento := 'CRCBABONOBONIFICAWSPRO';
		SET Var_TipoInstrumentoID := Mov_BonificacionID;

		-- 2) Se manda a llamar SP de ALTA DE DETALLE POLIZA
		CALL DETALLEPOLIZASALT(
			Par_EmpresaID,			Par_Poliza,			Var_FechaSistema,		Var_CenCosto,			Var_CtaContable,
			Var_Instrumento,		Var_MonedaID,		Var_Cargos,				Var_Abonos,				Var_DescripcionMov,
			Var_Referencia,			Var_Procedimiento,	Var_TipoInstrumentoID,	Cadena_Vacia,				Decimal_Cero,
			Cadena_Vacia,			Constante_NO,		Par_NumErr,				Par_ErrMen,				Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		);
		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;



		SET Var_ClaveUsuario := (SELECT Clave FROM USUARIOS WHERE UsuarioID = Var_UsuarioID);
		SET Var_ClaveUsuario := (IFNULL(Var_ClaveUsuario, Cadena_Vacia));


		-- 3) Se llama al SP BONIFICACIONESALT
		CALL BONIFICACIONESALT(
			Var_ClienteID,			Par_CuentaAhoID,	Par_Monto,				Par_Meses,				Par_TipoDispersion,
			Par_CuentaClabe,		Var_UsuarioID,		Var_BonificacionID,		Constante_NO,			Par_NumErr,
			Par_ErrMen, 			Par_EmpresaID,		Aud_Usuario, 			Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- 4) Se manda a llamar SP de BLOQUEOS
		CALL BLOQUEOSPRO(
			Entero_Cero,			Mov_Bloqueo,		Par_CuentaAhoID,		Var_FechaSistema,		Par_Monto,
			Fecha_Vacia,			Bloqueo_Bonifica,	Bloqueo_BonificaDesc,	Var_BonificacionID,		Var_ClaveUsuario,
			Cadena_Vacia,			Constante_NO,		Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion
		);
		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= 'Abono realizado exitosamente';

	END ManejoErrores;

	IF(Par_Salida = Constante_SI)THEN
		SELECT 	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Cadena_Vacia	AS control,
				Entero_Cero		AS consecutivo;
	END IF;

END TerminaStore$$