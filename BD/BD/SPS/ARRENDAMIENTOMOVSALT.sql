-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAMIENTOMOVSALT`;DELIMITER $$

CREATE PROCEDURE `ARRENDAMIENTOMOVSALT`(
	-- STORED PROCEDURE PARA DAR DE ALTA LOS MOVIMIENTOS DE LOS ARRENDAMIENTOS
	Par_ArrendaID			BIGINT(12),			-- Id del Arrendamiento
	Par_ArrendaAmortiID		INT(4),				-- Id de la Amortizacion del arrendamiento
	Par_Transaccion			BIGINT(20),			-- Numero de transaccion
	Par_FechaOperacion		DATE,				-- Fecha de Operacion
	Par_FechaAplicacion		DATE,				-- Fecha de Aplicacion

	Par_TipoMovArrendaID	INT(4),				-- Tipo de Movimiento del arrendamiento
	Par_NatMovimiento		CHAR(1),			-- Naturaleza del movimiento Cargo o Abono
	Par_MonedaID			INT(11),			-- Id de la moneda
	Par_Cantidad			DECIMAL(14,4),		-- Cantidad del movimiento
	Par_Descripcion			VARCHAR(100),		-- Descripcion del movimiento

	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT(20),
	Par_Salida 				CHAR(1),			-- Indica si el sp tendra salida
	INOUT Par_NumErr		INT(11),			-- Numero de salida que retorna el sp
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de salida
	INOUT Par_Consecutivo	BIGINT,				-- Consecutivo
	Par_ModoPago			CHAR(1),			-- Forma de pago

	Aud_EmpresaID			INT(11),			-- Id de la empresa
	Aud_Usuario				INT(11),			-- Usuario
	Aud_FechaActual			DATETIME,			-- Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Id del programa
	Aud_Sucursal			INT(11),			-- Numero de sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Numero de transaccion
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_ArrendaStatus  	CHAR(1);			-- Estatus del arrendamiento
	DECLARE Var_ClienteID   	INT(11);			-- Id del cliente
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero cero
	DECLARE	Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Mon_MinPago			DECIMAL(14,4);		-- Monto mínimo permitido
	DECLARE Con_MontoMin		CHAR(20);			-- Concepto monto mínimo en la tabla de parametros
	DECLARE	Nat_Cargo			CHAR(1);			-- Naturaleza Cargo
	DECLARE	Nat_Abono			CHAR(1);			-- Naturaleza Abono
	DECLARE	Arrenda_Vigente		CHAR(1);			-- Estatus vigente del arrendamiento
	DECLARE	Arrenda_Vencido		CHAR(1);			-- Estatus vencido del arrendamiento
	DECLARE	Est_Autorizado		CHAR(1);			-- Estatus autorizado del arrendamiento
	DECLARE Salida_Si			CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE	Salida_NO       	CHAR(1);			-- Indica que no se devuelve un mensaje de salida

	DECLARE	Pro_PagArrendamiento	VARCHAR(50);	-- Programa pago de arrendamiento
	DECLARE	Des_PagoArrendamiento	VARCHAR(50);	-- Descripción pago de arrendamiento


	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';							-- Valor de cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';				-- Valor de fecha vacia.
	SET Entero_Cero				:= 0;							-- Valor de entero cero.
	SET Decimal_Cero			:= 0.00;						-- Valor de decimal cero.
	SET Nat_Cargo				:= 'C';							-- Valor de Cargo
	SET Nat_Abono				:= 'A';							-- Valor de Abono
	SET Arrenda_Vigente			:= 'V';							-- Valor de Vigente
	SET Arrenda_Vencido			:= 'B';							-- Valor de Vencido
	SET Est_Autorizado			:= 'A';							-- Valor de autorizado
	SET Salida_Si				:= 'S';      					-- Si se devuelve una salida Si
	SET Salida_NO				:= 'N';   						-- NO se devuelve una salida No
	SET Pro_PagArrendamiento	:= 'PAGOARRENDAMIENTOPRO';		-- Valor programa de pago arrendamiento
	SET Des_PagoArrendamiento	:= 'PAGO DE ARRENDAMIENTO';		-- Descripción para pago de arrendamiento
	SET Con_MontoMin			:= 'MontoMinPago';				-- Valor de Descripción del monto mínimo

	SET Var_Control				:= '';							-- Valor inicial de la variable de control

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: ARRENDAMIENTOMOVSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SELECT	ValorParametro
		  INTO 	Mon_MinPago
			FROM PARAMGENERALES
			WHERE	LlaveParametro = Con_MontoMin;

		SELECT	Estatus,	ClienteID
		  INTO	Var_ArrendaStatus,	Var_ClienteID
			FROM ARRENDAMIENTOS
			WHERE	ArrendaID = Par_ArrendaID;

		SET	Par_ArrendaID			:= IFNULL(Par_ArrendaID, Entero_Cero);
		SET	Var_ArrendaStatus		:= IFNULL(Var_ArrendaStatus, Cadena_Vacia);
		SET	Par_Transaccion			:= IFNULL(Par_Transaccion, Entero_Cero);
		SET	Par_FechaOperacion		:= IFNULL(Par_FechaOperacion, Fecha_Vacia);
		SET Par_FechaAplicacion		:= IFNULL(Par_FechaAplicacion, Fecha_Vacia);
		SET	Par_NatMovimiento		:= IFNULL(Par_NatMovimiento, Cadena_Vacia);
		SET	Par_Cantidad			:= IFNULL(Par_Cantidad, Decimal_Cero);
		SET	Par_Descripcion			:= IFNULL(Par_Descripcion, Cadena_Vacia);
		SET	Par_Referencia			:= IFNULL(Par_Referencia, Cadena_Vacia);
		SET	Par_TipoMovArrendaID	:= IFNULL(Par_TipoMovArrendaID, Entero_Cero);

		IF(Par_ArrendaID	= Entero_Cero )THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'El Numero de Arrendamiento esta vacio';
			SET Var_Control		:= 'arrendaID';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF (Var_ArrendaStatus	= Cadena_Vacia) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'El Arrendamiento no Existe.';
			SET Var_Control		:= 'arrendaID';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF ((Var_ArrendaStatus != Arrenda_Vigente) AND (Var_ArrendaStatus != Arrenda_Vencido) AND (Var_ArrendaStatus != Est_Autorizado)) THEN
			SET Par_NumErr		:= 003;
			SET Par_ErrMen		:= 'Estatus del Arrendamiento Incorrecto.';
			SET Var_Control		:= 'arrendaID';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Transaccion	= Entero_Cero)THEN
			SET Par_NumErr		:= 004;
			SET Par_ErrMen		:= 'El numero de Movimiento esta vacio.';
			SET Var_Control		:= 'arrendaID';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_FechaOperacion	= Fecha_Vacia)THEN
			SET Par_NumErr		:= 005;
			SET Par_ErrMen		:= 'La Fecha de Operacion esta Vacia.';
			SET Var_Control		:= 'arrendaID';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaAplicacion	= Fecha_Vacia) THEN
			SET Par_NumErr		:= 006;
			SET Par_ErrMen		:= 'La Fecha de Aplicacion esta Vacia.';
			SET Var_Control		:= 'fechaAplicacion';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento	= Cadena_Vacia)THEN
			SET Par_NumErr		:= 007;
			SET Par_ErrMen		:= 'La naturaleza del Movimiento esta vacia.';
			SET Var_Control		:= 'natMovimiento';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			IF(Par_NatMovimiento<>Nat_Abono)THEN
				SET Par_NumErr		:= 008;
				SET Par_ErrMen		:= 'La naturaleza del Movimiento es Incorrecta.';
				SET Var_Control		:= 'natMovimiento';
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NatMovimiento<>Nat_Abono)THEN
			IF(Par_NatMovimiento<>Nat_Cargo)THEN
				SET Par_NumErr		:= 009;
				SET Par_ErrMen		:= 'La naturaleza del Movimiento es Incorrecta.';
				SET Var_Control		:= 'natMovimiento';
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Cantidad	< Mon_MinPago) THEN
			SET Par_NumErr		:= 010;
			SET Par_ErrMen		:= 'Cantidad del Movimiento de Arrendamiento Incorrecta';
			SET Var_Control		:= 'cantidad';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;


		IF(Par_Descripcion	= Cadena_Vacia) THEN
			SET Par_NumErr		:= 011;
			SET Par_ErrMen		:= 'La Descripcion del Movimiento esta vacia.';
			SET Var_Control		:= 'descripcion';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Referencia	= Cadena_Vacia) THEN
			SET Par_NumErr		:= 012;
			SET Par_ErrMen		:= 'La Referencia esta vacia.';
			SET Var_Control		:= 'referencia';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoMovArrendaID	= Entero_Cero) THEN
			SET Par_NumErr		:= 013;
			SET Par_ErrMen		:= 'El Tipo de Movimiento esta vacio.';
			SET Var_Control		:= 'tipoMovArrendamientoID';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF (Var_ArrendaStatus != Est_Autorizado) THEN
			IF(NOT EXISTS(SELECT ArrendaAmortiID
							FROM ARRENDAAMORTI
							WHERE	ArrendaID       = Par_ArrendaID
							AND	ArrendaAmortiID = Par_ArrendaAmortiID)) THEN
				SET Par_NumErr		:= 014;
				SET Par_ErrMen		:= 'La Amortizacion no existe.';
				SET Var_Control		:= 'arrendaAmortiID';
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		INSERT ARRENDAMIENTOMOVS(ArrendaID,				ArrendaAmortiID,		Transaccion,		FechaOperacion,			FechaAplicacion,
								TipoMovArrendaID,		NatMovimiento,			MonedaID,			Cantidad,				Descripcion,
								Referencia,				PolizaID,				EmpresaID,			Usuario,				FechaActual,
								DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion
								)
						VALUES(	Par_ArrendaID,			Par_ArrendaAmortiID,	Par_Transaccion,	Par_FechaOperacion,		Par_FechaAplicacion,
								Par_TipoMovArrendaID,	Par_NatMovimiento,		Par_MonedaID,		Par_Cantidad,			Par_Descripcion,
								Par_Referencia,			Par_Poliza,				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


		IF ((Par_Descripcion = Des_PagoArrendamiento) AND (Aud_ProgramaID = Pro_PagArrendamiento)) THEN

			CALL DETALLEPAGARRENDAPRO(Par_ArrendaAmortiID,	Par_ArrendaID,			Par_FechaOperacion,		Par_Transaccion,	Var_ClienteID,
									  Par_Cantidad,			Par_TipoMovArrendaID,	Salida_NO,				Par_NumErr,			Par_ErrMen,
									  Par_ModoPago,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
									  Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
		END IF;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

	-- Fin del SP
END TerminaStore$$