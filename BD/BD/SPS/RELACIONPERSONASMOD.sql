-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONPERSONASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONPERSONASMOD`;DELIMITER $$

CREATE PROCEDURE `RELACIONPERSONASMOD`(
	/* SP PARA MODIFICAR PERSONAS RELACIONADAS A LA EMPRESA */
	Par_EmpleadoID     	BIGINT(20),			-- Clave del Empleado
	Par_NombreEmpleado	VARCHAR(200),		-- Nombre de la Persona Relacionada
	Par_CURPRelacionado	CHAR(18),			-- CURP de la Persona Relacionada
	Par_RFCRelacionado	VARCHAR(45),		-- RFC del Relacionado
	Par_PuestoIDEmp		INT(11),			-- Puesto del Relacionado
	Par_PorcAcciones	DECIMAL(18,2),		-- Porcentaje de Acciones
	Par_Salida			CHAR(1),			-- Parametro de Salida S:SI  N:NO
	INOUT Par_NumErr	INT(11),			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(150),		-- Mensaje de Error

	-- Parametros de auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
    DECLARE Var_Control			VARCHAR(50);		-- Variable de control
    DECLARE Var_Consecutivo		VARCHAR(20);
    DECLARE Var_Clave			INT(11);
	DECLARE Var_TipoInstitucion INT;		-- Tipo de Institucion
    DECLARE Var_NumRegistros	INT(11);

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
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-RELACIONPERSONASMOD');
		SET Var_Control = 'SQLEXCEPTION' ;
	END;

    # SE CONSULTA SI EL ID DE LA PERSONA RELACIONADA YA EXISTE EN LA TABLA PARA NO INSERTARLO DE NUEVO
	SET Var_NumRegistros := (SELECT COUNT(PersonaID) FROM RELACIONPERSONAS WHERE PersonaID = Par_EmpleadoID );
    SET Var_NumRegistros := IFNULL(Var_NumRegistros, Entero_Cero);


	IF(Par_NombreEmpleado = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Nombre esta Vacio';
			SET Var_Control	:= 'nombreEmpleado';
			LEAVE ManejoErrores;
	END IF;

    IF(Par_CURPRelacionado = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La CURP esta Vacia';
			SET Var_Control	:= 'CURPEmpleado';
			LEAVE ManejoErrores;
	END IF;

    IF(Par_RFCRelacionado = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El RFC esta Vacio';
			SET Var_Control	:= 'RFCEmpleado';
			LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := NOW();

	IF(Var_NumRegistros > Entero_Cero) THEN
		UPDATE RELACIONPERSONAS
        SET	NombrePersona	= Par_NombreEmpleado,
            CURP			= Par_CURPRelacionado,
            RFC				= Par_RFCRelacionado,
            PuestoID		= Par_PuestoIDEmp,
            PorcAcciones	= Par_PorcAcciones,
            EmpresaID		= Aud_EmpresaID,
            Usuario			= Aud_Usuario,
            FechaActual		= Aud_FechaActual,
            DireccionIP 	= Aud_DireccionIP,
            ProgramaID 		= Aud_ProgramaID,
            Sucursal 		= Aud_Sucursal,
            NumTransaccion 	= Aud_NumTransaccion
            WHERE PersonaID = Par_EmpleadoID;

	 END IF;

	SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= 'Persona grabada exitosamente';
	SET Var_Control	:= '';
	SET Var_Consecutivo:= Par_EmpleadoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr	AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo	AS Consecutivo;
	END IF;


END TerminaStore$$