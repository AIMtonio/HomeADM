-- SP NOMTIPOCLAVEPRESUPBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMTIPOCLAVEPRESUPBAJ;

DELIMITER $$


CREATE PROCEDURE NOMTIPOCLAVEPRESUPBAJ(
	-- Stored Procedure para dar dar de Baja Masiva los tipos de claves presupuestales
	Par_NomTipoClavePresupID			INT(11),			-- Numero o Id del tipo Clave Presupuestal
	Par_NumBaj							TINYINT UNSIGNED,	-- Numero de baja

	Par_Salida							CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr					INT(11),			-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),			-- ID de la Empresa
	Aud_Usuario							INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal						INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)			-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;			-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);			-- Salida Si
	DECLARE Var_BajaTipoClavPresup		TINYINT UNSIGNED;	-- Proceso para eliminar los tipos de claves Presupuestales por su ID

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo
	DECLARE Var_NomTipoClavPresupID		INT(11);			-- Numero o Id de la Tabla del tipo Clave Presupuestal
	DECLARE Var_NomClavePresupID		INT(11);			-- Numero o ID de clable Presupuestal

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Var_BajaTipoClavPresup			:= 1;				-- Proceso para eliminar los tipos de claves Presupuestales por su ID

	-- Declaracion de Valores Default
	SET Par_NomTipoClavePresupID			:= IFNULL(Par_NomTipoClavePresupID, Entero_Cero);

ManejoErrores:BEGIN

	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMTIPOCLAVEPRESUPBAJ");
		SET Var_Control = 'sqlException';
	END;

	-- Proceso para eliminar los tipos de claves Presupuestales por su ID
	IF(Par_NumBaj = Var_BajaTipoClavPresup) THEN

		IF(Par_NomTipoClavePresupID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Numero de Tipo Clave Presupuestal a Eliminar es Requerido.';
			SET Var_Control := 'reqClave';
			LEAVE ManejoErrores;
		END IF;

		SELECT NomTipoClavePresupID
			INTO Var_NomTipoClavPresupID
				FROM NOMTIPOCLAVEPRESUP
				WHERE NomTipoClavePresupID = Par_NomTipoClavePresupID;

		IF(IFNULL(Var_NomTipoClavPresupID,Entero_Cero ) = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Numero de Tipo Clave Presupuestal a Eliminar no Existe.';
			SET Var_Control := 'reqClave';
			LEAVE ManejoErrores;
		END IF;

		SELECT COUNT(NomClavePresupID)
			INTO Var_NomClavePresupID
				FROM NOMCLAVEPRESUP
					WHERE NomTipoClavePresupID = Par_NomTipoClavePresupID;

		IF (Var_NomClavePresupID > Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Tipo Clave Presupuestal a Eliminar se encuentra Asociada con una Clave Presupuestal.';
			SET Var_Control := 'reqClave';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM NOMTIPOCLAVEPRESUP
			WHERE NomTipoClavePresupID = Par_NomTipoClavePresupID;

		-- Notificamos el mensaje de exito en borrado de tipos de claves Presupuestales por su ID
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Tipo Clave Presupuestal Eliminada exitosamente';
		SET Var_Consecutivo	:= Par_NomTipoClavePresupID;
		SET Var_Control	:= 'registroCompleto';
		LEAVE ManejoErrores;
	END IF;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	control,
				Var_Consecutivo			AS	consecutivo;
	END IF;
END TerminaStore$$
