-- SP SERVICIOSADICIONALESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSADICIONALESMOD;

DELIMITER $$
CREATE PROCEDURE SERVICIOSADICIONALESMOD(
	Par_ServicioID		INT(11),
	Par_Descripcion		VARCHAR(100),
	Par_ValidaDocs		CHAR(1),
	Par_TipoDocumento	INT(11),
	Par_Salida			CHAR(1),		-- Salida en Pantalla
	/* Parametros de Entrada/Salida */
	INOUT Par_NumErr	INT(11),		-- Numero  de Error o Exito
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error o Exito
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

	-- Decalracion de Variables
	DECLARE Var_Control			VARCHAR(200);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;
	DECLARE Fecha_Vacia			DATE;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Var_CadenaSI		CHAR(1);			-- Cadena Si

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;    			-- Entero Cero
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET SalidaSI				:= 'S';				-- Salida Si
	SET Var_CadenaSI	:= 'S';				-- Cadena S (SI)

	-- Asignacion de Variables
	SET Var_Consecutivo 		:= Par_ServicioID;

		-- *** Manejo de excepciones ***
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SERVICIOSADICIONALESMOD');
				SET Var_Control :='SQLEXCEPTION';
			END;

		/* Verificar que DESCRIPCION no esté vacío */
		IF(IFNULL(Par_Descripcion,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 02;
			SET Par_ErrMen 	:= 'La descripción está vacía';
			SET Var_Control	:= 'Descripcion';
			LEAVE ManejoErrores;
		END IF;

		/* Verificar que VALIDADOCS no esté vacío */
		IF(IFNULL(Par_ValidaDocs,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 03;
			SET Par_ErrMen 	:= 'La validación de documentos está vacía';
			SET Var_Control	:= 'ValidaDocs';
			LEAVE ManejoErrores;
		END IF;

		/* Verificar que TIPODOCUMENTO no esté vacío */
		IF Par_ValidaDocs = Var_CadenaSI THEN
			IF(IFNULL(Par_TipoDocumento,Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 	:= 04;
				SET Par_ErrMen 	:= 'El tipo de documentos está vacío';
				SET Var_Control	:= 'TipoDocumento';
				LEAVE ManejoErrores;
			END IF;

			IF (NOT EXISTS (SELECT TipoDocumentoID
								FROM  TIPOSDOCUMENTOS
								WHERE	TipoDocumentoID = Par_TipoDocumento)) THEN

				SET Par_NumErr := 03;
				SET Par_ErrMen := 'El tipo de documento no existe';
				SET Var_Control:= 'institNominaID';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Par_TipoDocumento := Entero_Cero;
		END IF;

		UPDATE SERVICIOSADICIONALES SET
				Descripcion		= Par_Descripcion,
				ValidaDocs		= Par_ValidaDocs,
				TipoDocumento	= Par_TipoDocumento
		WHERE ServicioID = Par_ServicioID;

		SET Par_NumErr 			:= 000;
		SET Par_ErrMen 			:= 'Proceso  Termino Exitosamente';
		SET Var_Control			:= 'servicioID';

	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr  	AS NumErr,
					Par_ErrMen  	AS ErrMen,
					Var_Control		AS Control,
					Var_Consecutivo AS Consecutivo;
		END IF;

END TerminaStore$$