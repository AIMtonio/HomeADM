-- SP BANTIPOSCUENTASBAJ
DELIMITER ;

DROP PROCEDURE IF EXISTS BANTIPOSCUENTASBAJ;

DELIMITER $$

CREATE PROCEDURE BANTIPOSCUENTASBAJ (
	Par_Salida         	 	CHAR(1),			-- Indica si el SP genera o no una salida
	INOUT Par_NumErr		INT(11),			-- Parametro de salida con el numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de salida con el mensage de error

	Par_EmpresaID			INT(11),			-- Auditoria
	Aud_Usuario				INT(11),			-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT(11),			-- Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Auditoria
)

TerminaStore: BEGIN
	
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Entero_Cero     INT(11);
	DECLARE SalidaSI        CHAR(1);
	DECLARE Var_Control     VARCHAR(50);
	DECLARE Var_Consecutivo		INT(11);
	
	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';			-- Cadena Vacia
	SET Entero_Cero     := 0;			-- Entero en Ceros
	SET SalidaSI        := 'S';			-- Salida SI
	
	DELETE FROM BANTIPOSCUENTAS;
	SET Par_NumErr  		:= 000;
		SET Par_ErrMen  	:= 'Se elimino Exitosamente el tipo de cuenta';
		SET Var_Control 	:= 'TipoCuentaID';
		SET Var_Consecutivo	:= Entero_Cero;
		
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
