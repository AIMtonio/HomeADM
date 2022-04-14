-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROLESMOD`;DELIMITER $$

CREATE PROCEDURE `ROLESMOD`(

	Par_RolID			INT(11),
	Par_NombreRol		VARCHAR(60),
	Par_Descripcion		VARCHAR(100),
	Par_OrigenDatos		VARCHAR(45),
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

DECLARE Var_EmpresaID	INT(11);
DECLARE Var_RolID		INT(11);
DECLARE Var_Control		VARCHAR(50);
DECLARE Var_Consecutivo	INT(11);
DECLARE VarControl 		VARCHAR(100);

DECLARE	Estatus_Activo	CHAR(1);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE SalidaSi		CHAR(1);



SET	Estatus_Activo	:=	'A';
SET	Cadena_Vacia	:=	'';
SET	Fecha_Vacia		:=	'1900-01-01';
SET	Entero_Cero		:=	0;
SET	SalidaSi		:=	'S';
ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
				Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ROLESMOD');
			SET VarControl = 'sqlException' ;
		END;

	SET Aud_FechaActual	:= NOW();

    SELECT	CompaniaID
	INTO	Var_EmpresaID
		FROM	COMPANIA
        WHERE OrigenDatos = Par_OrigenDatos;

	SET Var_EmpresaID :=	IFNULL(Var_EmpresaID,Entero_Cero);

    SELECT	RolID
    INTO	Var_RolID
		FROM ROLES
        WHERE EmpresaID = Var_EmpresaID AND RolID = Par_RolID;

    SET	Var_RolID 		:= IFNULL(Var_RolID,Entero_Cero);
    SET Par_NombreRol 	:= IFNULL(Par_NombreRol,Cadena_Vacia);
    SET Par_Descripcion := IFNULL(Par_Descripcion,Cadena_Vacia);

    IF(Var_EmpresaID = Entero_Cero) THEN
		SET	Par_NumErr		:=	1;
        SET Par_ErrMen		:=	'La Compania no se Encuentra Registrada.';
        SET Var_Control		:=	'';
        SET Var_Consecutivo	:=	0;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_RolID = Entero_Cero) THEN
		SET Par_NumErr		:=	2;
        SET Par_ErrMen		:=	'EL Rol no Existe.';
        SET Var_Control		:=	'rolID';
        SET Var_Consecutivo	:=	0;
        LEAVE ManejoErrores;
    END IF;

	IF(Par_NombreRol = Cadena_Vacia) THEN
		SET Par_NumErr		:=	3;
        SET Par_ErrMen		:=	'El Nombre esta Vacio.';
        SET Var_Control		:=	'nombreRol';
        SET Var_Consecutivo	:=	0;
        LEAVE ManejoErrores;
    END IF;

    IF(Par_Descripcion = Cadena_Vacia) THEN
		SET	Par_NumErr		:=	4;
        SET	Par_ErrMen		:=	'La Descripcion esta Vacia.';
        SET Var_Control		:=	'descripcion';
        SET Var_Consecutivo	:=	0;
        LEAVE ManejoErrores;
	END IF;

	UPDATE ROLES SET
		NombreRol		= Par_NombreRol,
		Descripcion		= Par_Descripcion,
		EmpresaID		= Var_EmpresaID,

		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	WHERE RolID = Par_RolID AND EmpresaID=Var_EmpresaID;

    SET	Par_NumErr		:=	0;
    SET Par_ErrMen		:=	CONCAT('Rol Modificado Exitosamente:',Par_RolID);
    SET Var_Control		:=	'rolID';
    SET Var_Consecutivo	:=	Par_RolID;

END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$