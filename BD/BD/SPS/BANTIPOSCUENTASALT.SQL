-- SP BANTIPOSCUENTASALT
DELIMITER ;

DROP PROCEDURE IF EXISTS BANTIPOSCUENTASALT;

DELIMITER $$

CREATE PROCEDURE BANTIPOSCUENTASALT (
	Par_TipoCuentaID		INT(11),			-- Llave primaria de tipo de cuentas
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

	-- Declaracion de Variables
	DECLARE Var_Control         VARCHAR(50);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Entero_Cero     INT(11);
	DECLARE SalidaSI        CHAR(1);


	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';			-- Cadena Vacia
	SET Entero_Cero     := 0;			-- Entero en Ceros
	SET SalidaSI        := 'S';			-- Salida SI
	


	ManejoErrores: BEGIN


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('Estimado Usuario(a), Ha ocurrido una falla en el sistema,',
									'estamos trabajando para resolverla. Disculpe las molestias que ',
									'esto le ocasiona. Ref: BANTIPOSCUENTASALT');
					SET Var_Control = 'sqlException' ;
		END;
		
	SET Var_Consecutivo := Entero_Cero;

	-- Inicializaciones
	SET Par_TipoCuentaID := IFNULL(Par_TipoCuentaID, Entero_Cero);

	
	IF(Par_TipoCuentaID > Entero_Cero) THEN
		IF EXISTS(SELECT TipoCuentaID FROM BANTIPOSCUENTAS WHERE TipoCuentaID = Par_TipoCuentaID) THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El tipo de cuenta ya se encuentra Registrada';
			SET Var_Control := 'TipoCuentaID';
			LEAVE ManejoErrores;
		END IF;
		
	END IF; 
	
	-- Obtiene Fecha de Base de Datos
	SET Aud_FechaActual := NOW();


	 
	INSERT INTO BANTIPOSCUENTAS(
		TipoCuentaID,		EmpresaID,			Usuario,		FechaActual,		DireccionIP,
		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES(
		Par_TipoCuentaID,	Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Tipo de cuenta Agregado Exitosamente';
		SET Var_Control := 'TipoCuentaID';
		SET Entero_Cero := Par_TipoCuentaID;

		END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
