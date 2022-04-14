-- SP TIPOEMPLEADOSCONVENIOALT

DELIMITER ;

DROP PROCEDURE IF EXISTS TIPOEMPLEADOSCONVENIOALT;

DELIMITER $$

CREATE PROCEDURE TIPOEMPLEADOSCONVENIOALT (
# ===============================================================
# ------ STORE PARA EL REGISTRO DE TIPO EMPLEADOS CONVENIO ------
# ===============================================================
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,			-- Numero de Convenio Nomina
	Par_TipoEmpleadoID		INT(11),			-- Numero de Tipo de Empleado
	Par_SinTratamiento		DECIMAL(12,2),		-- Valor Porcentaje sin Tratamiento
	Par_ConTratamiento		DECIMAL(12,2),		-- Valor Porcentaje con Tratamiento
    Par_EstatusCheck		CHAR(1),			-- Valor Estatus seleccionado.-S / no seleccionado.-N

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
	DECLARE Var_TipoEmpleadoConvID	BIGINT(12);			-- Consecutivo siguiente al ultimo ID de la tabla TIPOEMPLEADOSCONVENIO
	DECLARE Var_InstitNominaID		INT(11);			-- Variable que almacena el Numero de Institucion de Nomina ya registrada
    
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Entero_Uno				INT(1);				-- Entero Uno
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante para fecha vacia

    DECLARE SalidaSI				CHAR(1);			-- Salida Si
	DECLARE SalidaNO				CHAR(1);			-- Salida No

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Entero_Uno					:= 1;				-- Entero Uno
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

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOEMPLEADOSCONVENIOALT');
			SET Var_Control = 'sqlException';
		END;

        IF (Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El Numero de Empresa de Nomina esta Vacio.';
			SET Var_Control := 'institNominaID';
			LEAVE ManejoErrores;
		END IF;
	
        IF (Par_ConvenioNominaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'El Numero de Convenio de Nomina esta Vacio.';
			SET Var_Control := 'convenioNominaID';
			LEAVE ManejoErrores;
		END IF;
        
        IF (Par_TipoEmpleadoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'El Tipo de Empleado esta Vacio.';
			SET Var_Control := 'tipoEmpleadoID';
			LEAVE ManejoErrores;
		END IF;

        SELECT InstitNominaID
        INTO Var_InstitNominaID
        FROM TIPOEMPLEADOSCONVENIO 
        WHERE InstitNominaID = Par_InstitNominaID 
        AND ConvenioNominaID = Par_ConvenioNominaID
        AND TipoEmpleadoID = Par_TipoEmpleadoID;
        
		SET Var_InstitNominaID := IFNULL(Var_InstitNominaID, Entero_Cero);

        -- Si no existe en la tabla TIPOEMPLEADOSCONVENIO se registra
        IF(Var_InstitNominaID = Entero_Cero)THEN

			-- Se obtiene el valor consecutivo para el registro en la tabla TIPOEMPLEADOSCONVENIO
			SET Var_TipoEmpleadoConvID := (SELECT IFNULL(MAX(TipoEmpleadoConvID),Entero_Cero)+1 FROM TIPOEMPLEADOSCONVENIO);

			SET Aud_FechaActual := NOW();

			INSERT INTO TIPOEMPLEADOSCONVENIO (
				TipoEmpleadoConvID,     InstitNominaID,     ConvenioNominaID,		TipoEmpleadoID, 		SinTratamiento,
				ConTratamiento,			EstatusCheck,		EmpresaID,				Usuario,				FechaActual,        
                DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion)
			VALUES (
				Var_TipoEmpleadoConvID, Par_InstitNominaID, Par_ConvenioNominaID,	Par_TipoEmpleadoID,		Par_SinTratamiento,
				Par_ConTratamiento,		Par_EstatusCheck,	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,    
                Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
		END IF;
        
         -- Si existe en la tabla TIPOEMPLEADOSCONVENIO se actualiza
        IF(Var_InstitNominaID != Entero_Cero)THEN
			UPDATE TIPOEMPLEADOSCONVENIO
            SET SinTratamiento 	= Par_SinTratamiento,
				ConTratamiento 	= Par_ConTratamiento,
                EstatusCheck	= Par_EstatusCheck,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= NOW(),
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE InstitNominaID = Par_InstitNominaID 
			AND ConvenioNominaID = Par_ConvenioNominaID
			AND TipoEmpleadoID = Par_TipoEmpleadoID;
        END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Tpo Empleado Convenio Agregado Exitosamente.';
		SET Var_Control	:= 'institNominaID';

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Par_InstitNominaID		AS Consecutivo;
                
	END IF;
-- Fin del SP
END TerminaStore$$