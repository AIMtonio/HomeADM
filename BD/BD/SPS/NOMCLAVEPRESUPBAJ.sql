-- SP NOMCLAVEPRESUPBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVEPRESUPBAJ;

DELIMITER $$


CREATE PROCEDURE NOMCLAVEPRESUPBAJ(
	-- Stored Procedure para dar dar de Baja Masiva los claves presupuestales
	Par_NomClavePresupID				INT(11),			-- Numero o Id del Clave Presupuestal
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
	DECLARE Var_BajaCompleta			TINYINT UNSIGNED;	-- Proceso para eliminar todo los claves Presupuestales
	DECLARE Var_BajaID					TINYINT UNSIGNED;	-- Proceso para eliminar una clave presupuestal

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo
	DECLARE Var_NomClavePresupID		INT(11);			-- ID de Clave Presupuestal

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					:= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						:= 'S';				-- Asignacion de Salida SI
	SET Var_BajaCompleta				:= 1;				-- Proceso para eliminar todo los claves Presupuestales
	SET Var_BajaID						:= 2;				-- Proceso para eliminar una clave presupuestal

	-- Declaracion de Valores Default
	SET Par_NomClavePresupID			:= IFNULL(Par_NomClavePresupID, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
	    BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMCLAVEPRESUPBAJ");
			SET Var_Control = 'sqlException';
		END;

		-- Proceso para eliminar todo los tipos de claves Presupuestales
		IF(Par_NumBaj = Var_BajaCompleta) THEN
			DELETE FROM NOMCLAVEPRESUP;

			-- Notificamos el mensaje de exito en borrado de tipos de claves Presupuestales
			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:= 'Proceso Realizada exitosamente';
			SET Var_Consecutivo	:= Entero_Cero;
			SET Var_Control	:= 'registroCompleto';
			LEAVE ManejoErrores;
		END IF;

		-- Proceso para eliminar una clave presupuestal
		IF(Par_NumBaj = Var_BajaID) THEN
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

			DELETE 
				FROM NOMCLAVEPRESUP 
				WHERE NomClavePresupID = Par_NomClavePresupID;

			-- Notificamos el mensaje de exito en borrado de tipos de claves Presupuestales
			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:= 'Proceso Realizada exitosamente';
			SET Var_Consecutivo	:= Entero_Cero;
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
