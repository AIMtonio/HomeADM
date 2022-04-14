-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONEMPLEADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONEMPLEADOALT`;DELIMITER $$

CREATE PROCEDURE `RELACIONEMPLEADOALT`(
# =====================================================================================
# ----- SP PARA DARA DE ALTA LAS RELACIONES DE LOS EMPLEADOS -----------------
# =====================================================================================
	Par_EmpleadoID     		BIGINT(20),		-- Clave del Empleado

    Par_RelacionadoID   	INT(11),		-- Clave del Relacionado
    Par_NombreCliente		VARCHAR(200),	-- Nombre del Relacionado
	Par_CURP				CHAR(18),		-- CURP del Relacionado
    Par_RFC					VARCHAR(13),	-- RFC del Relacionado
    Par_PuestoID	     	INT(11),		-- Clave del Puesto

    Par_Parentesco      	INT(11), 		-- Parentesco
    Par_TipoRelacion    	INT(11),		-- Tipo de Relacion

	Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

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

	-- Declaracion de Variables

    DECLARE Var_Control     VARCHAR(200);
    DECLARE	Var_Consecutivo	INT(11);

	-- Declaracion de constantes
	DECLARE  Entero_Cero	INT(11);
	DECLARE  SalidaSI		CHAR(1);
	DECLARE  SalidaNO		CHAR(1);
	DECLARE  Cadena_Vacia	CHAR(1);
	DECLARE  Var_Relacion	INT(11);
    DECLARE	 Cons_Si		CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET SalidaSI			:='S';
	SET SalidaNO			:='N';
	SET Cadena_Vacia		:= '';
	SET Cons_Si				:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
								' esto le ocasiona. Ref: SP-RELACIONEMPLEADOALT');
				SET Var_Control := 'SQLEXCEPTION';
			END;

	IF(IFNULL(Par_EmpleadoID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := 'El Empleado esta Vacio.';
		SET Var_Control := 'empleadoID';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;


    IF(IFNULL(Par_Parentesco, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 003;
		SET Par_ErrMen  := 'El Parentesco esta Vacio.';
		SET Var_Control := 'parentescoID';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	SET Var_Relacion := (SELECT IFNULL(MAX(RelacionEmpID),Entero_Cero) + 1
								FROM RELACIONEMPLEADO);

	INSERT INTO `RELACIONEMPLEADO`
        (`RelacionEmpID`,  	`EmpleadoID`,		`RelacionadoID`,	`NombreRelacionado`,	`CURP`,
        `RFC`,       		`PuestoID`,			`ParentescoID`,		`TipoRelacion`,    		`EmpresaID`,
        `Usuario`,	    	`FechaActual`,		`DireccionIP`,		`ProgramaID`,      		`Sucursal`,
        `NumTransaccion`)
    VALUES(
         Var_Relacion, 		Par_EmpleadoID, 	Par_RelacionadoID,	Par_NombreCliente,		Par_CURP,
         Par_RFC,         	Par_PuestoID,		Par_Parentesco, 	Par_TipoRelacion,   	Aud_EmpresaID,
         Aud_Usuario,       Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     	Aud_Sucursal,
         Aud_NumTransaccion);

	SET Par_NumErr      := 000;
	SET Par_ErrMen      := 'Informacion Actualizada';
	SET Var_Control     := 'empleadoID';
	SET Var_Consecutivo := Par_EmpleadoID;

END ManejoErrores;

	IF (Par_Salida = Cons_Si) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS Control,
				Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$