-- SP NOMDETCAPACIDADPAGOSOLALT

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMDETCAPACIDADPAGOSOLALT;

DELIMITER $$


CREATE PROCEDURE NOMDETCAPACIDADPAGOSOLALT(
	-- Stored Procedure para dar de alta los Detalle de claves presupuestales por sus clasificación por Solicitud de Credito
	Par_NomCapacidadPagoSolID			BIGINT(12),		-- Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.
	Par_ClasifClavePresupID				INT(11),		-- Indica el Numero de la Clasificacion de la Clave Presupuestal
	Par_DescClasifClavePresup			VARCHAR(80),	-- Indica la Descripcion de la Clasificacion de la Clave Presupuestal
	Par_ClavePresupID					INT(11),		-- Indica el Numero de la Clave Presupuestal
	Par_Clave							VARCHAR(8),		-- Indica la Clave Presupuestal, si se trata de un Concepto fijo que no Cuenta con una Clave

	Par_DescClavePresup					VARCHAR(80),	-- Indica la Descripción de las Claves Presupuestales y de los Conceptos Fijos
	Par_Monto							DECIMAL(12,2),	-- Indica el Monto por cada Clave Presupuestal Y Conceptos Fijos
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
	DECLARE Entero_Cero					INT(11);		-- Entero vacio
	DECLARE Decimal_Cero				DECIMAL(12,2);	-- Decimal Vacio
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si

	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(50);	-- Variable de Control SQL
	DECLARE Var_Consecutivo					BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_NomCapacidadPagoSolID		BIGINT(12);		-- Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.
	DECLARE Var_NomDetCapacidadPagoSolID	BIGINT(12);		-- Numero o ID para el consecutivo de la tabla

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET Decimal_Cero					= 0.0;				-- Asignacion de Decimal Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							= 'S';				-- Salida Si
	SET Cons_NO							= 'N';				-- Salida Si

	-- Declaracion de Valores Default
	SET Par_NomCapacidadPagoSolID			:= IFNULL(Par_NomCapacidadPagoSolID, Entero_Cero);
	SET Par_ClasifClavePresupID				:= IFNULL(Par_ClasifClavePresupID, Entero_Cero);
	SET Par_DescClasifClavePresup			:= IFNULL(Par_DescClasifClavePresup, Cadena_Vacia);
	SET Par_ClavePresupID					:= IFNULL(Par_ClavePresupID, Entero_Cero);
	SET Par_Clave							:= IFNULL(Par_Clave, Cadena_Vacia);
	SET Par_DescClavePresup					:= IFNULL(Par_DescClavePresup, Cadena_Vacia);
	SET Par_Monto							:= IFNULL(Par_Monto, Decimal_Cero);

ManejoErrores:BEGIN

	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMDETCAPACIDADPAGOSOLALT");
		SET Var_Control = 'sqlException';
	END;

	IF(Par_NomCapacidadPagoSolID = Entero_Cero) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique el Numero de Datos SocioEconomico por Solicitud de Credito para Capacidad  de Pago a Registrar.';
		SET Var_Control := 'nomCapacidadPagoSolID';
		LEAVE ManejoErrores;
	END IF;

	SELECT NomCapacidadPagoSolID
		INTO Var_NomCapacidadPagoSolID
		FROM NOMCAPACIDADPAGOSOL
		WHERE NomCapacidadPagoSolID = Par_NomCapacidadPagoSolID;

	IF(IFNULL(Var_NomCapacidadPagoSolID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Numero de Datos SocioEconomico por Solicitud de Credito para Capacidad de Pago a Registrar no Existe.';
		SET Var_Control := 'nomCapacidadPagoSolID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ClasifClavePresupID = Entero_Cero) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'Especifique la Clasificacion de la Clave Presupuestal.';
		SET Var_Control := 'clasifClavePresupID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_DescClasifClavePresup = Cadena_Vacia) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'Especifique la Decripcion de Clasificacion de la Clave Presupuestal.';
		SET Var_Control := 'descClasifClavePresup';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ClavePresupID = Entero_Cero) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Especifique el Numero de Clave Presupuestal.';
		SET Var_Control := 'clavePresupID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_DescClavePresup = Cadena_Vacia) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Especifique la Decripcion de la Clave Presupuestal.';
		SET Var_Control := 'descClavePresup';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Monto < Decimal_Cero) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'Especifique el Monto por cada Clave Presupuestal Y Conceptos Fijos Mayor o Igual a Cero.';
		SET Var_Control := 'monto';
		LEAVE ManejoErrores;
	END IF;

	CALL FOLIOSAPLICAACT('NOMDETCAPACIDADPAGOSOL', Var_NomDetCapacidadPagoSolID);

	INSERT INTO NOMDETCAPACIDADPAGOSOL(	NomDetCapacidadPagoSolID,		NomCapacidadPagoSolID,			ClasifClavePresupID,		DescClasifClavePresup,			ClavePresupID,
										Clave,							DescClavePresup,				Monto,						EmpresaID,						Usuario,
										FechaActual,					DireccionIP,					ProgramaID,					Sucursal,						NumTransaccion)

							VALUES(		Var_NomDetCapacidadPagoSolID,	Par_NomCapacidadPagoSolID,		Par_ClasifClavePresupID,	Par_DescClasifClavePresup,		Par_ClavePresupID,
										Par_Clave,						Par_DescClavePresup,			Par_Monto,					Aud_EmpresaID,					Aud_Usuario,
										Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,				Aud_Sucursal,					Aud_NumTransaccion);

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Detalle Datos SocioEconomico Claves Presupuestales Registrado Correctamente';
		SET Var_Consecutivo	:= Par_NomCapacidadPagoSolID;
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
