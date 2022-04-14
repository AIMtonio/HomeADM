-- SP NOMCLAVEPRESUPMOD

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVEPRESUPMOD;

DELIMITER $$


CREATE PROCEDURE NOMCLAVEPRESUPMOD(
	-- Stored Procedure para modificar la informacion de claves presupuestales
	Par_NomClavePresupID 				INT(11),		-- Numero o Id de Clave Presupuestal
	Par_NomTipoClavePresupID			INT(11),		-- Numero o Id de la Tabla del tipo Clave Presupuestal
	Par_Clave							CHAR(8),		-- Indica el Clave que corresponde al registro presupuestal
	Par_Descripcion						VARCHAR(80),	-- Descripcion o nombre del clave presupuestal

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
	DECLARE Var_ReqClave				CHAR(8);		-- Clave que corresponde al registro presupuestal
	DECLARE Var_NomClavePresupID		INT(11);		-- ID de Clave Presupuestal

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							= 'S';				-- Salida Si
	SET Cons_NO							= 'N';				-- Salida Si

	-- Declaracion de Valores Default
	SET Par_NomTipoClavePresupID			:= IFNULL(Par_NomTipoClavePresupID, Entero_Cero);
	SET Par_Clave							:= IFNULL(Par_Clave, Cadena_Vacia);
	SET Par_Descripcion						:= IFNULL(Par_Descripcion, Cadena_Vacia);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMCLAVEPRESUPMOD");
			SET Var_Control = 'sqlException';
		END;

		SELECT 		NomClavePresupID
			INTO 	Var_NomClavePresupID
			FROM NOMCLAVEPRESUP 
			WHERE NomClavePresupID = Par_NomClavePresupID;

		IF(IFNULL(Var_NomClavePresupID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'No se encontro la clave presupuestal a eliminar.';
			SET Var_Consecutivo	:= Par_NomClavePresupID;
			SET Var_Control	:= 'clavePresupID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NomTipoClavePresupID = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Especifique el Tipo de Clave Presupuestal.';
			SET Var_Control := 'nomTipoClavePresupID';
			LEAVE ManejoErrores;
		END IF;

		SELECT NomTipoClavePresupID,	ReqClave
			INTO Var_NomTipoClavPresupID,	Var_ReqClave
				FROM NOMTIPOCLAVEPRESUP
				WHERE NomTipoClavePresupID = Par_NomTipoClavePresupID;

		SET Var_ReqClave				:= IFNULL(Var_ReqClave,Cons_NO);
		SET Var_NomTipoClavPresupID		:= IFNULL(Var_NomTipoClavPresupID,Entero_Cero);

		IF(Var_NomTipoClavPresupID = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Tipo Clave Presupuestal no Existe.';
			SET Var_Control := 'nomTipoClavePresupID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_ReqClave = Cons_SI) THEN
			IF(Par_Clave = Cadena_Vacia) THEN
				SET Par_NumErr := 4;
				SET Par_ErrMen := 'Especifique la Clave Presupuestal.';
				SET Var_Control := 'descripcion';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'Especifique la Descripcion de Clave Presupuestal.';
			SET Var_Control := 'reqClave';
			LEAVE ManejoErrores;
		END IF;

		UPDATE NOMCLAVEPRESUP
			SET NomTipoClavePresupID = Par_NomTipoClavePresupID,
				Clave = Par_Clave,
				Descripcion = Par_Descripcion,
				EmpresaID = Aud_EmpresaID,
				Usuario = Aud_Usuario,
				FechaActual = Aud_FechaActual,
				DireccionIP = Aud_DireccionIP,
				ProgramaID = Aud_ProgramaID,
				Sucursal = Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion
			WHERE NomClavePresupID = Par_NomClavePresupID;

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Claves Presupuestales Registrada Correctamente';
		SET Var_Consecutivo	:= Var_NomClavePresupID;
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
