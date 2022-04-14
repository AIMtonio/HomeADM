-- SP CARCREDITOSUSPENDIDOALT

DELIMITER ;

DROP PROCEDURE IF EXISTS CARCREDITOSUSPENDIDOALT;

DELIMITER $$


CREATE PROCEDURE CARCREDITOSUSPENDIDOALT(
	-- Stored Procedure para dar de alta los numeros De Creditos que se realizen el pase a suspendido
	Par_CreditoID						BIGINT(12),		-- ID Del Numero de Credito del cliente.
	Par_EstatusCredito					CHAR(1),		-- Estatus Anterior del Credito Ante de Realizar el pase a Defuncion.
	Par_FechaDefuncion					DATE,			-- Indicar la fecha en que el cliente fallecio.
	Par_FechaSuspencion					DATE,			-- Indicar la fecha en que se realiza la suspension.
	Par_FolioActa						VARCHAR(30),	-- Indicar el folio del acta de defuncion.

	Par_ObservDefuncion					VARCHAR(250),	-- Campo para que el usuario que realice la suspensión pueda agregar cualquier tipo de comentarios.
	Par_TotalAdeudo						DECIMAL(12,2),	-- Indicar el Total Adeudo del credito al momento de Realizar el pase a defuncion.
	Par_TotalSalCapital					DECIMAL(12,2),	-- Indicar el Total de Saldo Capital del credito al momento de Realizar el pase a defuncion.
	Par_TotalSalInteres					DECIMAL(12,2),	-- Indicar el Total de Saldo Interes del credito al momento de Realizar el pase a defuncion.
	Par_TotalSalMoratorio				DECIMAL(12,2),	-- Indicar el Total de Saldo Moratorio del credito al momento de Realizar el pase a defuncion.

	Par_TotalSalComisiones				DECIMAL(12,2),	-- Indicar el Total de Saldo Comisiones del credito al momento de Realizar el pase a defuncion.
	Par_Salida							CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr					INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),		-- ID de la Empresa
	Aud_Usuario							INT(11),		-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,		-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),	-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),	-- Identificador del Programa
	Aud_Sucursal						INT(11),		-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)		-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);		-- Entero vacio
	DECLARE	Decimal_Cero				INT(11);		-- Decimal vacio
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si
	DECLARE EstatusRegistrado			CHAR(1);		-- Estatus Defuncion R= Registrado/Aplicado,

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_CarCreditoSuspendidoID	BIGINT(12);		-- Variable Para guardar  el consecutivo de la tabla

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;			-- Asignacion de Entero Vacio
	SET Decimal_Cero					= 0.0;			-- Asignacion de Decimal Vacio
	SET	Cadena_Vacia					= '';			-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';			-- Asignacion de Salida SI
	SET Cons_SI							= 'S';			-- Salida Si
	SET Cons_NO							= 'N';			-- Salida Si
	SET EstatusRegistrado				= 'R';			-- Estatus Defuncion R= Registrado/Aplicado,

	-- Declaracion de Valores Default
	SET Par_CreditoID			:= IFNULL(Par_CreditoID ,Entero_Cero);
	SET Par_EstatusCredito		:= IFNULL(Par_EstatusCredito ,Cadena_Vacia);
	SET Par_FechaDefuncion		:= IFNULL(Par_FechaDefuncion ,Fecha_Vacia);
	SET Par_FechaSuspencion		:= IFNULL(Par_FechaSuspencion ,Fecha_Vacia);
	SET Par_FolioActa			:= IFNULL(Par_FolioActa ,Cadena_Vacia);
	SET Par_TotalAdeudo			:= IFNULL(Par_TotalAdeudo ,Decimal_Cero);
	SET Par_TotalSalCapital		:= IFNULL(Par_TotalSalCapital ,Decimal_Cero);
	SET Par_TotalSalInteres		:= IFNULL(Par_TotalSalInteres ,Decimal_Cero);
	SET Par_TotalSalMoratorio	:= IFNULL(Par_TotalSalMoratorio ,Decimal_Cero);
	SET Par_TotalSalComisiones	:= IFNULL(Par_TotalSalComisiones ,Decimal_Cero);

ManejoErrores:BEGIN

	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-CARCREDITOSUSPENDIDOALT");
		SET Var_Control = 'sqlException';
	END;

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique el Numero de Credito.';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_EstatusCredito = Cadena_Vacia) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'Especifique el Estatus del Credito.';
		SET Var_Control := 'estatusCredito';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FechaDefuncion = Fecha_Vacia) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'Especifique la Fecha de Denfuncion del Cliente.';
		SET Var_Control := 'fechaDefuncion';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FechaSuspencion = Fecha_Vacia) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'Especifique la Fecha de Suspencion del Credito.';
		SET Var_Control := 'fechaSuspencion';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FolioActa = Cadena_Vacia) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Especifique el Folio de Acta de Defuncion del Cliente.';
		SET Var_Control := 'folioActa';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ObservDefuncion = Cadena_Vacia) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Especifique el Motivo de Defuncion del Cliente.';
		SET Var_Control := 'onservDefuncion';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalAdeudo = Decimal_Cero) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Especifique el Total Adeudo del Credito.';
		SET Var_Control := 'totalAdeudo';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalCapital = Decimal_Cero) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'Especifique el Total Saldo Capital del Credito.';
		SET Var_Control := 'totalSalCapital';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalInteres < Decimal_Cero) THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'Especifique el Total Saldo Interes del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'totalSalInteres';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalMoratorio < Decimal_Cero) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'Especifique el Total Saldo Moratorio del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'totalSalMoratorio';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalComisiones < Decimal_Cero) THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'Especifique el Total Saldo Comisiones del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'totalSalComisiones';
		LEAVE ManejoErrores;
	END IF;

	CALL FOLIOSAPLICAACT('CARCREDITOSUSPENDIDO', Var_CarCreditoSuspendidoID);

	INSERT INTO CARCREDITOSUSPENDIDO(	CarCreditoSuspendidoID,		CreditoID,				EstatusCredito,			FechaDefuncion,			FechaSuspencion,
										FolioActa,					ObservDefuncion,		Estatus,				TotalAdeudo,			TotalSalCapital,
										TotalSalInteres,			TotalSalMoratorio,		TotalSalComisiones,		EmpresaID,				Usuario,
										FechaActual,				DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)

								VALUES(	Var_CarCreditoSuspendidoID,	Par_CreditoID,			Par_EstatusCredito,		Par_FechaDefuncion,		Par_FechaSuspencion,
										Par_FolioActa,				Par_ObservDefuncion,	EstatusRegistrado,		Par_TotalAdeudo,		Par_TotalSalCapital,
										Par_TotalSalInteres,		Par_TotalSalMoratorio,	Par_TotalSalComisiones,	Aud_EmpresaID,			Aud_Usuario,
										Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:='Registrado Realizado Correctamente';
		SET Var_Consecutivo	:= Var_CarCreditoSuspendidoID;
		SET Var_Control	:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	control,
				Var_Consecutivo			AS	consecutivo;
	END IF;
END TerminaStore$$
