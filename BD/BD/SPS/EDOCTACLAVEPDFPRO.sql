-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACLAVEPDFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACLAVEPDFPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTACLAVEPDFPRO`(
	-- STORED PROCEDURE PARA REALIZAR EL ALTA O ACTUALIZACION A LA TABLA EDOCTACLAVEPDF CON LA CLAVE QUE EL CLIENTE DESEA PARA SU ENVIO POR CORREO
	Par_ClienteID			INT(11),					-- ID de Cliente
	Par_Contrasenia			VARCHAR(80),				-- Clave encriptada del cliente para el estado de cuenta que se enviara por correo

	Par_Salida				CHAR(1),					-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),					-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),				-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID			INT(11),					-- Parametros de Auditoria
	Aud_Usuario				INT(11),					-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,					-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),				-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),				-- Parametros de Auditoria
	Aud_Sucursal			INT(11),					-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)					-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control								VARCHAR(50);		-- Variable de Control
	DECLARE Var_FechaActualiza						DATETIME;			-- Cliente ID consultado de la tabla
	DECLARE Var_Contrasenia							VARCHAR(80);		-- Clave decodificada


	-- Declaracion de Constantes.
	DECLARE Var_SalidaSi							CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE Var_SalidaNo							CHAR(1);			-- Indica que NO se devuelve un mensaje de salida
	DECLARE Cadena_Vacia							CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia								DATE;				-- Fecha Vacia
	DECLARE Entero_Cero								INT(11);			-- Entero Cero
	DECLARE	Var_TipoActClave						INT(11);			-- Tipo de Actualizacion para Actualizar la Clave del cliente para los envios de estado de cuenta




	-- Asignacion de Constantes
	SET	Var_SalidaSi								:= 'S';				-- Indica que si se devuelve un mensaje de salida
	SET	Var_SalidaNo								:= 'N';				-- Indica que NO se devuelve un mensaje de salida
	SET Cadena_Vacia								:= '';				-- Cadena Vacia
	SET Fecha_Vacia									:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero									:= 0;				-- Entero Cero
	SET	Var_TipoActClave							:= 1;				-- Tipo de Actualizacion para Actualizar la Clave del cliente para los envios de estado de cuenta


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTACLAVEPDFPRO');
			SET Var_Control = 'sqlException';
		END;



		IF (Par_ClienteID = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Cliente esta vacio';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;

		SELECT		FechaActualiza
			INTO	Var_FechaActualiza
			FROM EDOCTACLAVEPDF
			WHERE	ClienteID = Par_ClienteID;


		SET	Var_FechaActualiza		:=	IFNULL(Var_FechaActualiza, Fecha_Vacia);


		IF (Var_FechaActualiza = Fecha_Vacia) THEN
			-- Si no encuentra una fecha de Actualizacion, es porque el cliente no esta registrado en la tabla, y se procede con el ALTA
			CALL EDOCTACLAVEPDFALT(	Par_ClienteID, 		Par_Contrasenia,		Var_SalidaNo, 			Par_NumErr,				Par_ErrMen,
									Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
									Aud_Sucursal, 		Aud_NumTransaccion );
			IF (Par_NumErr <> Entero_Cero) THEN
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;

		ELSE
			-- Si encuentra una fecha de Actualizacion, es porque el cliente ya esta previamente registrado en la tabla, se procede con el Pase a Historico y la Actualizacion
			CALL EDOCTACLAVEPDFACT(	Par_ClienteID, 		Par_Contrasenia,		Var_TipoActClave,		Var_SalidaNo, 			Par_NumErr,
									Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual, 		Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal, 			Aud_NumTransaccion	);

			IF (Par_NumErr <> Entero_Cero) THEN
					SET Var_Control := 'ClienteID';
					LEAVE ManejoErrores;
			END IF;

		END IF;




	END ManejoErrores; -- Fin del bloque manejo de errores



	IF (Par_Salida = Var_SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$