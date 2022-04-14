-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACLAVEPDFACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACLAVEPDFACT`;DELIMITER $$

CREATE PROCEDURE `EDOCTACLAVEPDFACT`(
	-- STORED PROCEDURE PARA ACTUALIZAR LA TABLA EDOCTACLAVEPDF CON LA NUEVA CLAVE USADA EN EL ENVIO DE ESTADOS DE CUENTA POR CORREO
	Par_ClienteID			INT(11),				-- ID de Cliente
	Par_Contrasenia			VARCHAR(80),			-- Clave encriptada del cliente para el estado de cuenta que se enviara por correo
	Par_TipoAct				INT(11),				-- Indica El tipo de Actualizacion que se realizara

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
	DECLARE Var_Control							VARCHAR(50);		-- Variable de Control
	DECLARE Var_ContraseniaDec					VARCHAR(80);		-- Clave decodificada
	DECLARE Var_ValidaContrasenia				VARCHAR(100);		-- Clave decodificada
	DECLARE	Var_ContraseniaAnt					VARCHAR(80);		-- Clave previa a la actualizacion
	DECLARE	Var_FechaActualiza					DATETIME;			-- Fecha de la ultima actualizacion
	DECLARE	Var_FechaPaseHis					DATETIME;			-- Fecha en la que se esta realizando el Pase a Hisotirco
	DECLARE	Var_UsuarioPaseHis					INT(11);			-- Usuario que esta realizando el Pase a Historico
	DECLARE	Var_EmpresaID						INT(11);			-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico
	DECLARE	Var_Usuario							INT(11);			-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico
	DECLARE	Var_FechaActual						DATETIME;			-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico
	DECLARE	Var_DireccionIP						VARCHAR(15);		-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico
	DECLARE	Var_ProgramaID						VARCHAR(50);		-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico
	DECLARE	Var_Sucursal						INT(11);			-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico
	DECLARE	Var_NumTransaccion					BIGINT(20);			-- Parametros de Auditoria recuperado antes de actualizar para ser respaldado en el historico


	-- Declaracion de Constantes.
	DECLARE Var_SalidaSi						CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE Var_SalidaNo						CHAR(1);			-- Indica que No se devuelve un mensaje de salida
	DECLARE Cadena_Vacia						CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia							DATE;				-- Fecha Vacia
	DECLARE Entero_Cero							INT(11);			-- Entero Cero
	DECLARE Var_Exito							CHAR(5);			-- Texto de Exito para la Validacion de  la clave


	-- Tipos de Actualizaciones
	DECLARE	Var_ActContrasenia					INT(11);			-- Tipo de Actualizacion para Actualizar la clave del cliente para los envios de estado de cuenta

	-- Asignacion de Constantes
	SET	Var_SalidaSi							:= 'S';				-- El SP si genera una salida
	SET	Var_SalidaNo							:= 'N';				-- El SP NO genera una salida
	SET Cadena_Vacia							:= '';				-- Cadena Vacia
	SET Fecha_Vacia								:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero								:= 0;				-- Entero Cero
	SET	Var_Exito								:= 'EXITO';			-- Texto de Exito para la Validacion de  la clave


	-- Tipos de Actualizacion exitentes
	SET	Var_ActContrasenia						:= 1;				-- Tipo de Actualizacion para Actualizar la clave del cliente para los envios de estado de cuenta



	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTACLAVEPDFACT');
			SET Var_Control = 'sqlException';
		END;


		IF (Par_ClienteID = Entero_Cero) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Numero de Cliente esta vacio';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;



		IF (Par_TipoAct = Entero_Cero) THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'El Tipo de Actualizacion no se especifico o esta vacio.';
			SET Var_Control := 'Par_TipoAct';
			LEAVE ManejoErrores;
		END IF;



		-- Tipo de Actualizacion para Actualizar la clave del cliente para los envios de estado de cuenta
		IF (Par_TipoAct = Var_ActContrasenia) THEN

			-- Se recuperan tados para validar la existencia del cliente y estos mismos datos se usaran para el pase a historico
			SELECT		Contrasenia,				FechaActualiza,				EmpresaID,				Usuario,				FechaActual,
						DireccionIP,				ProgramaID,					Sucursal,				NumTransaccion
				INTO	Var_ContraseniaAnt,			Var_FechaActualiza,			Var_EmpresaID,			Var_Usuario,			Var_FechaActual,
						Var_DireccionIP,			Var_ProgramaID,				Var_Sucursal,			Var_NumTransaccion
				FROM EDOCTACLAVEPDF
				WHERE	ClienteID = Par_ClienteID;



			SET	Var_FechaActualiza		:=	IFNULL(Var_FechaActualiza, Fecha_Vacia);

			IF (Var_FechaActualiza = Fecha_Vacia) THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= CONCAT('El Cliente [', CAST(Par_ClienteID AS CHAR) ,'] no esta registrado previamente con una clave');
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_ContraseniaDec		:= (SELECT FROM_BASE64(Par_Contrasenia) );
			SET	Var_ContraseniaDec		:= (IFNULL(Var_ContraseniaDec, Cadena_Vacia) );

			SET	Var_ValidaContrasenia := FNVALIDACONTRASENIA(Var_ContraseniaDec);

			IF (Var_ValidaContrasenia <> Var_Exito) THEN
					SET	Par_NumErr 	:= 004;
					SET	Par_ErrMen	:= Var_ValidaContrasenia;
					SET Var_Control := 'ClienteID';
					LEAVE ManejoErrores;
			END IF;

			-- Se obtiene la fecha de la base de datos para determinar el dia y la hora en el que se esta realizando el pase a historico
			SET	Var_FechaPaseHis	:= NOW();

			-- Se realiza el paso a historico de la clave antes de actualizarla
			CALL EDOCTAHISCLAVEPDFALT(	Par_ClienteID, 			Var_ContraseniaAnt,			Var_FechaActualiza,			Var_FechaPaseHis,			Aud_Usuario,
										Var_SalidaNo, 			Par_NumErr,					Par_ErrMen,					Var_EmpresaID,				Var_Usuario,
										Var_FechaActual,		Var_DireccionIP,			Var_ProgramaID,				Var_Sucursal,				Var_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
					SET Var_Control := 'ClienteID';
					LEAVE ManejoErrores;
			END IF;


			UPDATE EDOCTACLAVEPDF SET
				Contrasenia		= Par_Contrasenia,
				FechaActualiza 	= Aud_FechaActual,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	ClienteID = Par_ClienteID;



			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'Clave actualizada con Exito';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;



	END ManejoErrores; -- Fin del bloque manejo de errores



	IF (Par_Salida = Var_SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$