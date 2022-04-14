-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHISCLAVEPDFALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHISCLAVEPDFALT`;DELIMITER $$

CREATE PROCEDURE `EDOCTAHISCLAVEPDFALT`(
	-- STORED PROCEDURE PARA ACTUALIZAR LA TABLA EDOCTACLAVEPDF CON LA NUEVA CLAVE USADA EN EL ENVIO DE ESTADOS DE CUENTA POR CORREO
	Par_ClienteID			INT(11),				-- ID de Cliente
	Par_Contrasenia			VARCHAR(80),			-- Clave encriptada del cliente para el estado de cuenta que se enviara por correo
	Par_FechaActualiza		DATETIME,				-- Fecha en que se actualizo la clave que se esta pasando a Historico
	Par_FechaPaseHis		DATETIME,				-- Fecha en que se pasa a historico esta clave
	Par_UsuarioPaseHis		INT(11),				-- ID del usuario del sistema que realizo la actualizacion con la cual se genero el pase a historico

	Par_Salida				CHAR(1),				-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),				-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),			-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID			INT(11),				-- Parametros de Auditoria
	Aud_Usuario				INT(11),				-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal			INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de Control


	-- Declaracion de Constantes.
	DECLARE Var_SalidaSi				CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE Entero_Cero					INT(11);			-- Entero Cero



	-- Asignacion de Constantes
	SET	Var_SalidaSi					:= 'S';				-- El SP si genera una salida
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero





	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAHISCLAVEPDFALT');
			SET Var_Control = 'sqlException';
		END;



		IF (Par_ClienteID = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Cliente esta vacio';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;



		IF (Par_Contrasenia = Cadena_Vacia) THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La Clave esta vacia';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;



		IF (Par_FechaActualiza = Fecha_Vacia) THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'La Fecha de ultima actualizacion se encuentra vacia';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_FechaPaseHis = Fecha_Vacia) THEN
			SET	Par_NumErr 	:= 004;
			SET	Par_ErrMen	:= 'La Fecha del Pase a Histoprico se encuentra vacia';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;


		IF (Par_UsuarioPaseHis = Entero_Cero) THEN
			SET	Par_NumErr 	:= 005;
			SET	Par_ErrMen	:= 'No se ha especificado el usuario del sistema que esta realizado el pase a historico de la contraseña';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;




		INSERT INTO EDOCTAHISCLAVEPDF (	ClienteID,				FechaPaseHis,				UsuarioPaseHis,				Contrasenia,			CorreoEnvio,
										FechaActualiza,			EmpresaID,					Usuario,					FechaActual,			DireccionIP,
										ProgramaID,				Sucursal,					NumTransaccion	)
						VALUES		(	Par_ClienteID,			Par_FechaPaseHis,			Par_UsuarioPaseHis,			Par_Contrasenia,		Cadena_Vacia,
										Par_FechaActualiza,		Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion	);





		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Clave registrada en el historico con exito.';
		SET Var_Control := 'ClienteID';
		LEAVE ManejoErrores;




	END ManejoErrores; -- Fin del bloque manejo de errores



	IF (Par_Salida = Var_SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$