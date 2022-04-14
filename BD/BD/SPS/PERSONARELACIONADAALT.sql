-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERSONARELACIONADAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERSONARELACIONADAALT`;DELIMITER $$

CREATE PROCEDURE `PERSONARELACIONADAALT`(
	/* SP PARA EL ALTA DE ACREDITADOSRELACIONADOS */
    Par_ClienteID 		INT(11),				-- ID del cliente
    Par_EmpleadoID		BIGINT(12),				-- ID del empleado
    Par_ClaveRelacionID	INT(11),				-- ID de la clave de relacion

    Par_Salida			CHAR(1),
    INOUT Par_NumErr	INT(11),
    INOUT Par_ErrMen	VARCHAR(150),

	Par_EmpresaID		INT(11),				-- Parametros de auditoria --
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN

	-- Declaracion de variables
    DECLARE Var_Control		VARCHAR(50);		-- Variable de control
    DECLARE Var_Consecutivo	VARCHAR(20);
    DECLARE Var_Clave		INT(11);
	DECLARE Var_TipoInstitucion  INT;		-- Tipo de Institucion

	-- Declaracion de constantes
    DECLARE Fecha_Vacia		DATE;
    DECLARE Entero_Cero		INT(11);
    DECLARE Entero_Uno		INT(11);
    DECLARE Cadena_Vacia	CHAR(1);
    DECLARE Salida_SI		CHAR(1);

    -- Asignacion de contantes
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET Cadena_Vacia		:= '';
    SET Salida_SI			:= 'S';

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PERSONARELACIONADAALT');
		SET Var_Control = 'SQLEXCEPTION' ;
	END;

		SELECT 	TipoRegulatorios
		INTO 	Var_TipoInstitucion
		FROM 	PARAMREGULATORIOS
        WHERE 	ParametrosID = 1;

		IF(Par_ClienteID = Entero_Cero AND Par_EmpleadoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Los Campos Socio y Empleado estan vacios';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
        END IF;

		IF(Par_ClienteID > Entero_Cero ) THEN
			 IF NOT EXISTS (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'No Existe el Socio';
				SET Var_Control	:= 'clienteID';
				LEAVE ManejoErrores;
			ELSE
				 IF EXISTS (SELECT ClienteID FROM PERSONARELACIONADA WHERE ClienteID = Par_ClienteID)THEN
					SET Par_NumErr := 3;
					SET Par_ErrMen := CONCAT('Ya Existe una Relacion con el Socio: ',Par_ClienteID);
					SET Var_Control	:= 'clienteID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
        END IF;

		IF(Par_EmpleadoID > Entero_Cero ) THEN
			IF NOT EXISTS (SELECT EmpleadoID FROM EMPLEADOS WHERE EmpleadoID = Par_EmpleadoID ) THEN
				SET Par_NumErr := 4;
				SET Par_ErrMen := 'No existe el Empleado';
				SET Var_Control	:= 'empleadoID';
				LEAVE ManejoErrores;
			ELSE
				IF EXISTS (SELECT EmpleadoID FROM PERSONARELACIONADA WHERE EmpleadoID = Par_EmpleadoID )THEN
					SET Par_NumErr := 5;
					SET Par_ErrMen := CONCAT('Ya Existe una Relacion con el Empleado: ',Par_EmpleadoID);
					SET Var_Control	:= 'empleadoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
        END IF;

        IF NOT EXISTS (SELECT ClaveRelacionID FROM CLAVERELACIONCNVB WHERE ClaveRelacionID = Par_ClaveRelacionID AND TipoInstitID = Var_TipoInstitucion )THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'No existe la Clave de Relacion';
			SET Var_Control	:= 'claveRelacionID';
			LEAVE ManejoErrores;
        END IF;

        SET Aud_FechaActual := NOW();

        INSERT INTO PERSONARELACIONADA
		(	`ClienteID`, 		`EmpleadoID`, 		`ClaveCNBV`,
			`EmpresaID`, 		`Usuario`,          `FechaActual`,		`DireccionIP`, 			`ProgramaID`,
            `Sucursal`, 		`NumTransaccion`
		)VALUES(
			Par_ClienteID,		Par_EmpleadoID,		Par_ClaveRelacionID,
            Par_EmpresaID,	    Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
            Aud_Sucursal,	    Aud_NumTransaccion
		);

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Acreditado(s) grabado(s) exitosamente';
		SET Var_Control	:= '';
		SET Var_Consecutivo:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$