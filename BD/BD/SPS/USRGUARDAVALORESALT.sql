-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USRGUARDAVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS USRGUARDAVALORESALT;

DELIMITER $$
CREATE PROCEDURE `USRGUARDAVALORESALT`(
	-- Store Procedure: De alta los parametros del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_ParamGuardaValoresID	INT(11),		-- ID de Tabla PARAMGUARDAVALORES
	Par_PuestoFacultado			VARCHAR(10),	-- ID o Clave del Puesto
	Par_UsuarioFacultadoID		INT(11),		-- ID de Usuario

	Par_Salida					CHAR(1), 		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr			INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Parametro de salida mensaje de error

	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Par_UsrGuardaValoresID		INT(11);		-- Numero de Pametro
	DECLARE Var_UsuarioID				INT(11);		-- Numero de Usuario
	DECLARE Var_Usuario					INT(11);		-- Numero de Usuario
	DECLARE Var_ClavePuesto 			INT(11);		-- Numero de Clave de Puesto
	DECLARE Var_ClavePuestoID			VARCHAR(10);	-- Nombre o Clave del Puesto
	DECLARE Var_Control					VARCHAR(100);	-- Variable de Retorno en Pantalla

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI					CHAR(1);		-- Constante de Salida SI
	DECLARE	Entero_Cero					INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno					INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero				DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-USRGUARDAVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		IF( IFNULL(Par_ParamGuardaValoresID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Numero Unico de Guarda Valores esta vacio';
			SET Var_Control := 'paramGuardaValoresID';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_PuestoFacultado, Cadena_Vacia) = Cadena_Vacia AND IFNULL(Par_UsuarioFacultadoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'Ingrese un Puesto Facultado o un Usuario Facultado';
			SET Var_Control := 'puestoFacultado';
			LEAVE ManejoErrores;
		END IF;


		IF( IFNULL(Par_PuestoFacultado, Cadena_Vacia) <> Cadena_Vacia ) THEN

			SELECT IFNULL(ClavePuestoID, Cadena_Vacia)
			INTO Var_ClavePuestoID
			FROM PUESTOS
			WHERE ClavePuestoID = Par_PuestoFacultado;

			IF( Var_ClavePuestoID = Cadena_Vacia) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Puesto Facultado no existe';
				SET Var_Control := 'puestoFacultado';
				LEAVE ManejoErrores;
			END IF;

			SELECT IFNULL(COUNT(PuestoFacultado), Entero_Cero)
			INTO Var_ClavePuesto
			FROM USRGUARDAVALORES
			WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID
			  AND PuestoFacultado = Par_PuestoFacultado;

			IF( Var_ClavePuesto > Entero_Cero ) THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'El Puesto Facultado ya existe en la configuracion de Guarda Valores';
				SET Var_Control := 'documentoID';
				LEAVE ManejoErrores;
			END IF;

		ELSE

			SET Par_PuestoFacultado			:= Cadena_Vacia;

		END IF;

		IF( IFNULL(Par_UsuarioFacultadoID, Entero_Cero) <> Entero_Cero ) THEN

			SELECT IFNULL(UsuarioID, Entero_Cero),	IFNULL(ClavePuestoID, Cadena_Vacia)
			INTO Var_UsuarioID,						Var_ClavePuestoID
			FROM USUARIOS
			WHERE UsuarioID = Par_UsuarioFacultadoID;

			IF( Var_UsuarioID = Entero_Cero) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Usuario Facultado esta vacio';
				SET Var_Control := 'usuarioFacultadoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT IFNULL(COUNT(UsuarioFacultadoID), Entero_Cero)
			INTO Var_Usuario
			FROM USRGUARDAVALORES
			WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID
			  AND UsuarioFacultadoID = Par_UsuarioFacultadoID;

			IF( Var_Usuario > Entero_Cero ) THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'El Usuario Facultado ya existe en la configuracion de Guarda Valores';
				SET Var_Control := 'documentoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT IFNULL(COUNT(PuestoFacultado), Entero_Cero)
			INTO Var_ClavePuesto
			FROM USRGUARDAVALORES
			WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID
			  AND PuestoFacultado = Var_ClavePuestoID;

			IF( Var_ClavePuesto > Entero_Cero ) THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := 'El Puesto del Usuario Facultado ya existe en la configuracion de Guarda Valores';
				SET Var_Control := 'documentoID';
				LEAVE ManejoErrores;
			END IF;

		ELSE

			SET Par_UsuarioFacultadoID		:= Entero_Cero;

		END IF;

		-- Agregar validacion para verificar si el puesto o usuario existen
		SET Aud_FechaActual := NOW();

		SELECT IFNULL(MAX(UsrGuardaValoresID), Entero_Cero) + Entero_Uno
		INTO Par_UsrGuardaValoresID
		FROM USRGUARDAVALORES;

		INSERT INTO USRGUARDAVALORES (
			UsrGuardaValoresID,			ParamGuardaValoresID,		PuestoFacultado,		UsuarioFacultadoID,		EmpresaID,
			Usuario,					FechaActual,				DireccionIP,			ProgramaID,				Sucursal,
			NumTransaccion)
		VALUES(
			Par_UsrGuardaValoresID,		Par_ParamGuardaValoresID,	Par_PuestoFacultado,	Par_UsuarioFacultadoID,	Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Parametro de Facultado Agregado Exitosamente.';
		SET Var_Control:= 'paramGuardaValoresID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI)THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Par_UsrGuardaValoresID AS consecutivo;
	END IF;

END TerminaStore$$
