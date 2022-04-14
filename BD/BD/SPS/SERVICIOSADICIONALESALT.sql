-- SP SERVICIOSADICIONALESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSADICIONALESALT;

DELIMITER $$
CREATE PROCEDURE SERVICIOSADICIONALESALT(
	Par_Descripcion			VARCHAR(100),
	Par_ValidaDocs			VARCHAR(1),
	Par_TipoDocumento		INT(11),
    Par_Salida				CHAR(1),		-- Salida en Pantalla
	/* Parametros de Entrada/Salida */
	INOUT Par_NumErr		INT(11),		-- Numero  de Error o Exito
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error o Exito
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore : BEGIN

	/*DECLARACION DE CONSTANTES*/
	DECLARE Entero_Cero		INT(11);			# Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);			# Constante Cadena Vacía
	DECLARE SalidaSI		CHAR(1);
	DECLARE Con_Activo		CHAR(1);
	DECLARE Var_CadenaSI	CHAR(1);			-- Cadena Si

	/*Decalracion de Variables*/
	DECLARE Var_Control			VARCHAR(200);
	DECLARE Var_ServicioID		INT(11);

	/*ASIGNACION DE CONSTANTES*/
	SET Entero_Cero		:= 0;				-- Entero Cero
	SET Cadena_Vacia	:= '';				-- Cadena Vacia
	SET SalidaSI		:= 'S'; 			-- Constante Salida Si
	SET Con_Activo 		:= 'A';				-- Estatus Activo
	SET Var_CadenaSI	:= 'S';				-- Cadena S (SI)
		-- *** Manejo de excepciones ***
	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SERVICIOSADICIONALESALT');
				SET Var_Control :='SQLEXCEPTION';
			END;

		/* Verificar que DESCRIPCION no esté vacío */
		IF(IFNULL(Par_Descripcion,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := 'La descripción está vacía';
			SET Var_Control:= 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		/* Verificar que VALIDADOCS no esté vacío */
		IF(IFNULL(Par_ValidaDocs,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 03;
			SET Par_ErrMen := 'La validación de documentos está vacía';
			SET Var_Control:= 'validaDocs';
			LEAVE ManejoErrores;
		END IF;

		/* Verificar que TIPODOCUMENTO no esté vacío */
		IF Par_ValidaDocs = Var_CadenaSI THEN
			IF(IFNULL(Par_TipoDocumento,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr := 04;
				SET Par_ErrMen := 'El tipo de documentos está vacío';
				SET Var_Control:= 'tipoDocumento';
				LEAVE ManejoErrores;
			END IF;

			IF (NOT EXISTS (SELECT TipoDocumentoID
								FROM  TIPOSDOCUMENTOS
								WHERE TipoDocumentoID 	= Par_TipoDocumento)) THEN

				SET Par_NumErr := 05;
				SET Par_ErrMen := 'El tipo de documentos no existe';
				SET Var_Control:= 'tipoDocumento';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_TipoDocumento := Entero_Cero;
		END IF;

		/*Verific que no exista el producto a agregar*/
		SET Var_ServicioID := (SELECT IFNULL(MAX(ServicioID),Entero_Cero) + 1 FROM SERVICIOSADICIONALES);


		/* INSERT A SERVICIOSADICIONALES */
		INSERT INTO SERVICIOSADICIONALES(
			ServicioID, Descripcion, 	ValidaDocs, 	TipoDocumento, 	Estatus,
			EmpresaID, 	Usuario, 		FechaActual, 	DireccionIP, 	ProgramaID,
			Sucursal, 	NumTransaccion)
		VALUES(
			Var_ServicioID,		Par_Descripcion,	Par_ValidaDocs,		Par_TipoDocumento, 	Con_Activo,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Servicio Agregado Exitosamente';
		SET Var_Control := 'servicioID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  	AS NumErr,
				Par_ErrMen  	AS ErrMen,
				Var_Control		AS Control,
				Var_ServicioID	AS Consecutivo;
	END IF;
END TerminaStore$$