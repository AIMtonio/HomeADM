-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROLESALT`;DELIMITER $$

CREATE PROCEDURE `ROLESALT`(

	Par_RolID			INT(11),
	Par_NombreRol		VARCHAR(60),
	Par_Descripcion		VARCHAR(100),
	Par_OrigenDatos		VARCHAR(50),
	Par_Salida			CHAR(1),

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_Consecutivo	INT(2);
	DECLARE Var_EmpresaID	INT(11);
	DECLARE VarControl 		VARCHAR(100);

	DECLARE	Estatus_Activo	CHAR(1);
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE SalidaSi		CHAR(1);



	SET	Estatus_Activo	:= 'A';
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	SalidaSi		:=	'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
					Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ROLESALT');
				SET VarControl = 'sqlException' ;
			END;



		IF(IFNULL(Par_NombreRol,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:=	1;
			SET Par_ErrMen		:=	'El Nombre Esta Vacio.';
			SET Var_Control		:=	'nombreRol';
			SET Var_Consecutivo	:=	0;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:=	2;
			set Par_ErrMen		:=	'La Descripcion Esta Vacia.';
			set Var_Control		:=	'descripcion';
			set Var_Consecutivo	:=	0;
			LEAVE ManejoErrores;
		END IF;

		SELECT	CompaniaID
		INTO	Var_EmpresaID
			FROM COMPANIA
			WHERE OrigenDatos = Par_OrigenDatos;

		SET Var_EmpresaID	:=	IFNULL(Var_EmpresaID,Entero_Cero);

		IF (Var_EmpresaID = Entero_Cero) THEN
			SET Par_NumErr		:=	3;
			SET Par_ErrMen		:=	'La Compania no se Encuentran';
			SET Var_Control		:=	'nombreRol';
			SET Var_Consecutivo	:=	0;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO ROLES VALUES	(
			Par_RolID,			Var_EmpresaID,		Par_NombreRol,	Par_Descripcion,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT('Rol Agregado Exitosamente: ',CONVERT(Par_RolID, unsigned));
		SET Var_Control		:=	'rolID';
		SET Var_Consecutivo	:=Par_RolID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr		AS NumErr,
			Par_ErrMen		AS ErrMen,
			Var_Control		AS control,
			Var_Consecutivo	AS consecutivo;

	END IF;

END TerminaStore$$