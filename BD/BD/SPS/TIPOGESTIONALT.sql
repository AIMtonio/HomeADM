-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOGESTIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOGESTIONALT`;DELIMITER $$

CREATE PROCEDURE `TIPOGESTIONALT`(
	Par_Descripcion		VARCHAR(150),
	Par_TipoAsigna		CHAR(1),
	Par_Estatus			CHAR(1),

	Par_Salida			CHAR(1),
    inout Par_NumErr	INT(11),
    inout Par_ErrMen	VARCHAR(150),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN



	DECLARE Var_Control 		VARCHAR(50);
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_TipoGestionID	INT(11);



	DECLARE Entero_Cero 		INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI			CHAR(1);



	SET Entero_Cero 	:= 0;
	SET Cadena_Vacia	:= '';
	SET Salida_SI		:= 'S';

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
		concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-TIPOGESTORESALT');
		SET Var_Control = 'sqlException' ;
	END;


	IF( ifnull(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr 		:= '01';
		SET Par_ErrMen 		:= 'Especifique la Descripcion';
		SET Var_Control		:= 'descripcion';
		SET Var_Consecutivo	:= Par_Descripcion;
		LEAVE ManejoErrores;
	END IF;

	IF( ifnull(Par_TipoAsigna, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr 		:= '02';
		SET Par_ErrMen 		:= 'Especifique el Tipo de Asignacion';
		SET Var_Control		:= 'tipoAsigna';
		SET Var_Consecutivo	:= Par_TipoAsigna;
		LEAVE ManejoErrores;
	END IF;

	IF( ifnull(Par_Estatus, Cadena_Vacia) = Cadena_Vacia )THEN
		SET Par_NumErr 		:= '03';
		SET Par_ErrMen 		:= 'Especifique el Estatus';
		SET Var_Control		:= 'estatus';
		SET Var_Consecutivo	:= Par_Estatus;
		LEAVE ManejoErrores;
	END IF;

	CALL FOLIOSAPLICAACT('TIPOGESTION', Var_TipoGestionID);
	SET Aud_FechaActual = now();

	INSERT INTO `TIPOGESTION`(
		`TipoGestionID`,	`Descripcion`,	`TipoAsigna`,	`Estatus`,     `EmpresaID`,
		`Usuario`,			`FechaActual`,	`DireccionIP`,	`ProgramaID`,	`Sucursal`,
		`NumTransaccion`)
	VALUES(
		Var_TipoGestionID,	Par_Descripcion,	Par_TipoAsigna,		Par_Estatus,	Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion	);

	SET Par_NumErr 		:= '000';
	SET Par_ErrMen 		:= CONCAT('Tipo de Gestion Agregado Exitosamente: ', CAST(Var_TipoGestionID AS CHAR));
	SET Var_Control		:= 'tipoGestionID';
	SET Var_Consecutivo	:= Var_TipoGestionID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$