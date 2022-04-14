-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMIMGANTIPHISHINGACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMIMGANTIPHISHINGACT`;DELIMITER $$

CREATE PROCEDURE `BAMIMGANTIPHISHINGACT`(
-- SP para actulizar una imagen anthiphishing
	Par_ImagenPhishingID	INT,					-- ID de la imagen que se desea actualizar

	Par_NumAct				TINYINT UNSIGNED,		-- Numero de actualizacion
	Par_Salida				CHAR(1),				-- Se especifica si el SP genera o no una salida
	INOUT Par_NumErr		INT(11),					-- Parametro de salida con el numero de error
	INOUT Par_ErrMen   		VARCHAR(400),			-- Parametro de salida con el mensaje de error

	Par_EmpresaID			INT(11),					-- Auditoria
	Aud_Usuario				INT(11),					-- Auditoria
	Aud_FechaActual			DATETIME,				-- Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Auditoria
	Aud_Sucursal			INT,					-- Auditoria
	Aud_NumTransaccion		BIGINT					-- Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Control			VARCHAR(50);
-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Est_Activo		CHAR(1);
DECLARE	Est_Inactivo		CHAR(1);
DECLARE	Act_EstInactiva		INT;
DECLARE FechaSist			DATE;
DECLARE	SalidaSI			CHAR(1);
DECLARE	SalidaNO			CHAR(1);

-- Asignacion de constantes
SET	Cadena_Vacia			:= '';					-- Cadena vacia
SET	Fecha_Vacia				:= '1900-01-01';		-- Fecha vacia
SET	Entero_Cero				:= 0;					-- Entero cero
SET	Est_Activo				:= 'A';					-- Estatus activo
SET	Est_Inactivo			:= 'I';					-- Estatus inactivo
SET	SalidaSI				:= 'S';					-- El SP si genera una salida
SET	SalidaNO				:= 'N';					-- El SP no genera una salida
SET	Act_EstInactiva			:= 1;  	 				-- Tipo de actualizacion para dar de baja una imagen antphishing


ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
					BEGIN
						SET Par_NumErr = 999;
						SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMIMGANTIPHISHINGACT');
								SET Var_Control = 'SQLEXCEPTION' ;
					END;

	IF(IFNULL(Par_ImagenPhishingID,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El ID de la Imagen esta Vacio';
        SET Var_Control :='imgAntiphishingID';
		LEAVE ManejoErrores;
	END IF;


IF(Par_NumAct = Act_EstInactiva) THEN

	UPDATE BAMIMGANTIPHISHING SET
		Estatus		 	= Est_Inactivo,

		EmpresaID	 	= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE ImagenPhishingID = Par_ImagenPhishingID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Imagen Actualizada Exitosamente';
        SET Var_Control :='imgAntiphishingID';

END IF;

	IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_ImagenPhishingID AS consecutivo;
	END IF;

END ManejoErrores; -- END del handler manejo de errores
END TerminaStore$$