-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPREGSECRETASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPREGSECRETASMOD`;DELIMITER $$

CREATE PROCEDURE `BAMPREGSECRETASMOD`(

-- SP que modifica una pregunta del catalogo de preguntas secretas
	Par_PreguntaSecretaID	BIGINT(20),  				-- ID de la pregunta que se va a modificar
	Par_Redaccion			VARCHAR(200),				-- La redaccion de la pregunta

	Par_Salida          	CHAR(1),					-- Se especifica si el SP genera o no una salida
    INOUT Par_NumErr   		INT(11),					-- Parametro de salida, que indica el numero de error
    INOUT Par_ErrMen   		VARCHAR(400),				-- Pametro de salida que nos indica el mensaje de error

	Par_EmpresaID			INT(11),					-- Auditoria
	Aud_Usuario				INT(11),					-- Auditoria
	Aud_FechaActual			DATETIME, 					-- Auditoria
	Aud_DireccionIP			VARCHAR(15),				-- Auditoria
	Aud_ProgramaID			VARCHAR(50),				-- Auditoria
	Aud_Sucursal			INT(11),					-- Auditoria
	Aud_NumTransaccion		BIGINT(20)					-- Auditoria

	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control     VARCHAR(50);				-- Variable de Control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);					-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;						-- Fecha Vacia
	DECLARE	Entero_Cero		INT;						-- Entero 0
	DECLARE SalidaSI        CHAR(1);					-- Salida SI

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';							-- Cadena vacia
	SET	Fecha_Vacia		:= '1900-01-01';				-- Fecha vacia
	SET	Entero_Cero		:= 0;							-- Entero cero
	SET SalidaSI        := 'S';             			-- El Store SI genera una Salida

	ManejoErrores: BEGIN
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMPREGSECRETASMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

	IF NOT EXISTS(SELECT PreguntaSecretaID
				FROM BAMPREGSECRETAS
					WHERE PreguntaSecretaID = Par_PreguntaSecretaID) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'La Pregunta Secreta no Existe';
			SET Var_Control := 'preguntaSecretaID';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Redaccion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La Redaccion esta Vacia';
			SET Var_Control := 'redaccion';
			LEAVE ManejoErrores;
		END IF;

	SET Aud_FechaActual	:= NOW();

	UPDATE BAMPREGSECRETAS SET

		Redaccion		= Par_Redaccion,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
		WHERE PreguntaSecretaID = Par_PreguntaSecretaID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Pregunta Secreta Modificada Exitosamente';
			SET Var_Control := 'preguntaSecretaID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				IFNULL (Par_PreguntaSecretaID,Entero_Cero) AS consecutivo;
	END IF;

END TerminaStore$$