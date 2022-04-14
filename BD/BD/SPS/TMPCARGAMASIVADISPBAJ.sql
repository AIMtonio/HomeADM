DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCARGAMASIVADISPBAJ`;

DELIMITER $$
CREATE PROCEDURE `TMPCARGAMASIVADISPBAJ`(
	Par_Salida 				CHAR(1),    
    INOUT	Par_NumErr	 	INT(11),
    INOUT	Par_ErrMen	 	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),	
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);
	
	-- Delcaracion de Constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE SalidaSi		CHAR(1);

	-- Seteo de valores
	SET Entero_Cero		:= 0;
	SET SalidaSi		:= 'S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
   		BEGIN
        	SET Par_NumErr = 999;
        	SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-TMPCARGAMASIVADISPBAJ');
        	SET Var_Control  := 'SQLEXCEPTION';
    	END;


    	DELETE FROM TMPCARGAMASIVADISP
    	WHERE NumTransaccion = Aud_NumTransaccion;

   		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Registro Realizada Exitosamente.');
		SET Var_Control := 'institucionID';
			
	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$