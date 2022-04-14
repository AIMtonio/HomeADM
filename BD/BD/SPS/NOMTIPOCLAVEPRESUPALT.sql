-- SP NOMTIPOCLAVEPRESUPALT

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMTIPOCLAVEPRESUPALT;

DELIMITER $$


CREATE PROCEDURE NOMTIPOCLAVEPRESUPALT(
	-- Stored Procedure para dar de alta los tipos de claves presupuestales
	Par_Descripcion						VARCHAR(80),	-- Descripcion o nombre del tipo de clave presupuestal
	Par_ReqClave						CHAR(1),		-- Indicara si sera requerido ingresar una clave cuando se de de alta una clave presupuestal S=Si, N=No

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
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_NomTipoClavPresupID		INT(11);		-- Numero o Id de la Tabla del tipo Clave Presupuestal

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							= 'S';				-- Salida Si
	SET Cons_NO							= 'N';				-- Salida Si

	-- Declaracion de Valores Default
	SET Par_Descripcion					:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_ReqClave					:= IFNULL(Par_ReqClave, Cadena_Vacia);

ManejoErrores:BEGIN

	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMTIPOCLAVEPRESUPALT");
		SET Var_Control = 'sqlException';
	END;

	IF(Par_Descripcion = Cadena_Vacia) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique la Descripcion de Tipos de Claves Presupuestales.';
		SET Var_Control := 'descripcion';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ReqClave = Cadena_Vacia) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'Especifique si  Requiere Clave Presupuestal.';
		SET Var_Control := 'reqClave';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ReqClave NOT IN(Cons_SI, Cons_NO)) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'Especifique Valor Requiere Clave Presupuestal Valido (S=Si, N=No).';
		SET Var_Control := 'reqClave';
		LEAVE ManejoErrores;
	END IF;

	CALL FOLIOSAPLICAACT('NOMTIPOCLAVEPRESUP', Var_NomTipoClavPresupID);

	INSERT INTO NOMTIPOCLAVEPRESUP(	NomTipoClavePresupID,		Descripcion,			ReqClave,			EmpresaID,			Usuario,
									FechaActual,				DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)

						VALUES(		Var_NomTipoClavPresupID,	Par_Descripcion,		Par_ReqClave,		Aud_EmpresaID,		Aud_Usuario,
									Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Tipo Clave Presupuestal Registrada Correctamente.';
		SET Var_Consecutivo	:= Var_NomTipoClavPresupID;
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
