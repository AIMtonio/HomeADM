-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BONIFICACIONESALT`;

DELIMITER $$
CREATE PROCEDURE `BONIFICACIONESALT`(
	-- =====================================================================================
	-- -------------------- STORE PARA EL ALTA DE BONIFICACIONES POR WS --------------------
	-- =====================================================================================

	Par_ClienteID 				INT(11),		-- ID de Cliente
	Par_CuentaAhoID				BIGINT(12),		-- ID de Cuenta de Ahorro
	Par_Monto					DECIMAL(14,2), 	-- Monto de la Bonificacion
	Par_Meses 					INT(11),		-- Numero de meses / Amortizaciones
	Par_TipoDispersion 			CHAR(1),		-- Tipo de Dispersión \n"S" = SPEI \n"C"= Cheque \n"O"= Orden Pago

	Par_CuentaClabe 			VARCHAR(18),	-- Cuenta Clave (El campo requerido si la Dispersión es SPEI)
	Par_UsuarioRegistro 		INT(11),		-- ID del Usuario de Consumo del WS'
	INOUT Par_BonificacionID 	BIGINT(20),		-- ID de Tabla

	Par_Salida 					CHAR(1), 		-- Salida en Pantalla
	INOUT Par_NumErr 			INT(11),		-- Parametro de numero de error
	INOUT Par_ErrMen 			VARCHAR(400),	-- Parametro de mensaje de error

	Par_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Parametros
	DECLARE Par_Fecha 				DATE;			-- Fecha de Alta de la Bonificacion
	DECLARE Par_FechaVencimiento 	DATE;			-- Fecha de Termino de la Bonificacion
	DECLARE Par_FechaDispersion 	DATE;			-- Fecha de Dispersion

	-- Declaracion de Variables
	DECLARE Var_ClienteID			INT(11);		-- Numero de Cliente
	DECLARE Var_Meses 				INT(11);		-- Numero de Meses
	DECLARE Var_UsuarioID 			INT(11);		-- Numero de Usuario
	DECLARE Var_CuentaAhoID 		BIGINT(12);		-- Numero de maximo de Amortizaciones
	DECLARE Var_CtaCliente 			BIGINT(12);		-- Numero de Amortizacion Actual

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_SI 					CHAR(1);		-- Constante SI
	DECLARE Con_NO 					CHAR(1);		-- Constante NO
	DECLARE Est_Inactivo 			CHAR(1);		-- Constante Estatus Inactiva
	DECLARE Est_Vigente 			CHAR(1);		-- Constante Estatus Vigente

	DECLARE Tipo_SPEI 				CHAR(1);		-- Constante Tipo de Dispersion SPEI
	DECLARE Tipo_Cheque 			CHAR(1);		-- Constante Tipo de Dispersion Cheque
	DECLARE Tipo_OrdenPago 			CHAR(1);		-- Constante Tipo de Dispersion Orden de Pago
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero

	DECLARE Entero_Uno 				INT(11);		-- Constante Entero uno
	DECLARE Longitud_Clabe 			INT(11);		-- Constante Longitud valida de una Cuenta clabe
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decumal Cero

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET Con_SI 						:= 'S';
	SET Con_NO 						:= 'N';
	SET Est_Inactivo 				:= 'I';
	SET Est_Vigente 				:= 'V';

	SET Tipo_SPEI 					:= 'S';
	SET Tipo_Cheque 				:= 'C';
	SET Tipo_OrdenPago 				:= 'O';
	SET Fecha_Vacia 				:= '1900-01-01';
	SET	Entero_Cero					:= 0;

	SET Entero_Uno 					:= 1;
	SET Longitud_Clabe 				:= 18;
	SET	Decimal_Cero				:= 0.0;

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Par_Fecha
	FROM PARAMETROSSIS LIMIT 1;

	-- Se validan parametros nulos
	SET Par_BonificacionID 	:= Entero_Cero;
	SET Par_ClienteID 		:= IFNULL(Par_ClienteID , Entero_Cero);
	SET Par_CuentaAhoID		:= IFNULL(Par_CuentaAhoID , Entero_Cero);
	SET Par_Fecha 			:= IFNULL(Par_Fecha , Fecha_Vacia);
	SET Par_Monto 			:= IFNULL(Par_Monto , Cadena_Vacia);
	SET Par_Meses			:= IFNULL(Par_Meses , Cadena_Vacia);
	SET Par_TipoDispersion 	:= IFNULL(Par_TipoDispersion , Cadena_Vacia);
	SET Par_CuentaClabe 	:= IFNULL(Par_CuentaClabe , Cadena_Vacia);
	SET Par_UsuarioRegistro := IFNULL(Par_UsuarioRegistro, Entero_Cero);
	set Par_FechaDispersion := IFNULL(Par_FechaDispersion, Fecha_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-BONIFICACIONESALT');
		END;

		IF( Par_CuentaAhoID = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT CuentaAhoID
		INTO Var_CuentaAhoID
		FROM CUENTASAHO
		WHERE CuentaAhoID = Par_CuentaAhoID;

		SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);

		IF( Var_CuentaAhoID = Entero_Cero ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := CONCAT('El Numero de ', FNSAFILOCALECTE(), ' esta Vacio.');
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID
		INTO Var_ClienteID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

		SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

		IF( Var_ClienteID = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := CONCAT('El Numero de ', FNSAFILOCALECTE(), ' esta Vacio.');
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Monto = Entero_Cero ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Monto esta vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT CuentaAhoID
		INTO Var_CtaCliente
		FROM CUENTASAHO
		WHERE CuentaAhoID = Par_CuentaAhoID
		  AND ClienteID = Par_ClienteID;

		SET Var_CtaCliente := IFNULL(Var_CtaCliente, Entero_Cero);

		IF( Var_CtaCliente = Cadena_Vacia ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('La Cuenta No Pertene al ', FNSAFILOCALECTE(), '.');
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoDispersion = Cadena_Vacia ) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'El Tipo de Dispersion está Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoDispersion NOT IN ( Tipo_SPEI, Tipo_Cheque, Tipo_OrdenPago ) ) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'El Tipo de Dispersion no es Valido.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoDispersion = Tipo_SPEI ) THEN

			IF( Par_CuentaClabe = Cadena_Vacia ) THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'La Cuenta Clabe está Vacia.';
				LEAVE ManejoErrores;
			END IF;

			IF( LENGTH(Par_CuentaClabe) <> Longitud_Clabe ) THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'La Cuenta Clabe no es Valida.';
				LEAVE ManejoErrores;
			END IF;

		ELSE

			SET Par_CuentaClabe := Cadena_Vacia;
		END IF;

		IF( Par_Meses = Entero_Cero ) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'Los Meses estan Vacios.';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_UsuarioRegistro = Entero_Cero ) THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'El Usuario que registra esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
		INTO Var_UsuarioID
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioRegistro;

		SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);

		IF( Var_UsuarioID = Entero_Cero ) THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'El Usuario que registra no Existe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(BonificacionID), Entero_Cero) + 1
		INTO Par_BonificacionID
		FROM BONIFICACIONES FOR UPDATE;

		SET Var_Meses := Par_Meses - Entero_Uno;
		SET Par_FechaVencimiento := DATE_ADD(LAST_DAY(Par_Fecha), INTERVAL Var_Meses MONTH);
		SET Aud_FechaActual := NOW();

		-- Ajustar el estatus de nacimiento de la bonificacion Est_Inactivo
		INSERT INTO BONIFICACIONES(
			BonificacionID,			ClienteID,				CuentaAhoID,		FechaInicio,		FechaVencimiento,
			Monto,					Meses,					TipoDispersion,		CuentaClabe,		Estatus,
			UsuarioRegistro,		FechaDispersion,		FolioDispersion,
			EmpresaID,				Usuario,				FechaActual,		DireccionIP,
			ProgramaID,				Sucursal,				NumTransaccion)
		VALUES (
			Par_BonificacionID,		Par_ClienteID,			Par_CuentaAhoID,	Par_Fecha,			Par_FechaVencimiento,
			Par_Monto,				Par_Meses,				Par_TipoDispersion,	Par_CuentaClabe,	Est_Inactivo,
			Par_UsuarioRegistro,	Par_FechaDispersion,	Entero_Cero,
			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Abono realizado exitosamente.';

	END ManejoErrores;

	IF( Par_Salida = Con_SI ) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Par_BonificacionID AS consecutivo;
	END IF;

END TerminaStore$$