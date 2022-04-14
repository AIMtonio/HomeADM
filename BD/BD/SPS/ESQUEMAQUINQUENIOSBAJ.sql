-- SP ESQUEMAQUINQUENIOSBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS ESQUEMAQUINQUENIOSBAJ;

DELIMITER $$

CREATE PROCEDURE `ESQUEMAQUINQUENIOSBAJ`(
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,	-- Numero de Convenio Nomina
    
	Par_Salida				CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante para fecha vacia
    DECLARE SalidaSI				CHAR(1);			-- Salida Si

    DECLARE SalidaNO				CHAR(1);			-- Salida No

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
    SET SalidaSI					:= 'S';				-- Salida Si

    SET SalidaNO					:= 'N';				-- Salida No

	-- Valores por default
	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);


ManejoErrores:BEGIN
	
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr	= 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ESQUEMAQUINQUENIOSBAJ');
		SET Var_Control	= 'SQLEXCEPTION';
	END;


	IF(IFNULL(Par_InstitNominaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr	:= 001;
		SET Par_ErrMen	:= 'El Numero de la Empresa Nomina se encuentra Vacio.';
		SET Var_Control	:= 'institNominaID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ConvenioNominaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr	:= 002;
		SET Par_ErrMen	:= 'El Numero de Convenio se encuentra Vacio.';
		SET Var_Control	:= 'convenioNominaID';
		LEAVE ManejoErrores;
	END IF;

	DELETE FROM ESQUEMAQUINQUENIOS  WHERE InstitNominaID = Par_InstitNominaID AND ConvenioNominaID = Par_ConvenioNominaID;

	SET Par_NumErr	:= 	Entero_Cero;
	SET Par_ErrMen	:= 'Esquema de Quinquenios Eliminado Exitosamente.';
	SET Var_Control	:= 'institNominaID';

END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Par_InstitNominaID		AS Consecutivo;
			
	END IF;


END TerminaStore$$