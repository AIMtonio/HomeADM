-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESROLALT`;DELIMITER $$

CREATE PROCEDURE `OPCIONESROLALT`(
	Par_RolID			INT(11),
	Par_OpcionMenuID	VARCHAR(50),
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

DECLARE Var_EmpresaID		INT(11);
DECLARE Var_OpcionMenuID	INT(11);
DECLARE Var_Control			VARCHAR(50);
DECLARE Var_Consecutivo		INT(11);
DECLARE VarControl 		VARCHAR(100);

DECLARE	Est_Activo			CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE Var_SalidaSI		CHAR(1);



SET	Est_Activo		:=	'A';
SET	Entero_Cero		:=	0;
SET	Var_SalidaSI	:=	'S';

ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
				Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-OPCIONESROLALT');
			SET VarControl = 'sqlException' ;
		END;

    SELECT	CompaniaID
    INTO	Var_EmpresaID
		FROM	COMPANIA
		WHERE	OrigenDatos = Par_OrigenDatos;

    SET	Var_EmpresaID := IFNULL(Var_EmpresaID,Entero_Cero);

    IF(Var_EmpresaID = Entero_Cero) THEN
		SET Par_NumErr		:=	0;
        SET Par_ErrMen		:=	'La Compania no se Encuentra Registrada.';
        SET	Var_Control		:=	'rolID';
        SET Var_Consecutivo	:=	0;
    END IF;

    SELECT	OpcionMenuID
    INTO	Var_OpcionMenuID
		FROM OPCIONESROL
		WHERE RolID = Par_RolID AND OpcionMenuID = Par_OpcionMenuID and Empresa = Var_EmpresaID;

	SET	Var_OpcionMenuID :=	IFNULL(Var_OpcionMenuID,Entero_Cero);

    IF(Var_OpcionMenuID = Entero_Cero) THEN

		INSERT INTO	OPCIONESROL(
				Empresa,			RolID,				OpcionMenuID,		EmpresaID,		Usuario,
                FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
		VALUES(	Var_EmpresaID,		Par_RolID,			Par_OpcionMenuID,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET	Par_NumErr		:=	0;
		SET	Par_ErrMen		:=	CONCAT('Opciones Agregadas al Rol: ',Par_RolID,'.');
		SET Var_Control		:=	'rolID';
		SET Var_Consecutivo	:=	0;

    END IF;


END ManejoErrores;
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS	NumErr,
				Par_ErrMen		AS	ErrMen,
				Var_Control		AS	Control,
                Var_Consecutivo	AS	Consecutivo;
    END IF;
END TerminaStore$$