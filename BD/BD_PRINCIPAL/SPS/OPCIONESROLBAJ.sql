-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROLBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESROLBAJ`;
DELIMITER $$


CREATE PROCEDURE `OPCIONESROLBAJ`(
	Par_RolID			INT(11),
	Par_OpcionMenuID	VARCHAR(50),
    Par_OrigenDatos		VARCHAR(50),
	Par_TipoBaja		INT(11),
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

DECLARE Var_Control			VARCHAR(50);
DECLARE Var_Consecutivo		INT(11);
DECLARE	Var_EmpresaID		INT(11);
DECLARE VarControl 		VARCHAR(100);

DECLARE	Estatus_Activo		CHAR(1);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE Var_BajaDefinitiva 	INT(11);
DECLARE Var_SalidaSI		CHAR(1);



SET	Estatus_Activo		:=	'A';
SET	Cadena_Vacia		:=	'';
SET	Fecha_Vacia			:=	'1900-01-01';
SET	Entero_Cero			:=	0;
SET Var_BajaDefinitiva 	:=	1;
SET	Var_SalidaSI		:=	'S';
ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
				Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-OPCIONESROLBAJ');
			SET VarControl = 'sqlException' ;
		END;

	IF(Par_tipoBaja = Var_BajaDefinitiva )THEN

		SELECT	CompaniaID
        INTO	Var_EmpresaID
			FROM	COMPANIA
            WHERE	OrigenDatos = Par_OrigenDatos;

		SET	Var_EmpresaID	:=	IFNULL(Var_EmpresaID,Entero_Cero);

        IF(Var_EmpresaID = Entero_Cero) THEN
			SET Par_NumErr		:=	0;
            SET Par_ErrMen		:=	'La Compañia no se Encuentra Registrada.';
            SET	Var_Control		:=	'rolID';
            SET	Var_Consecutivo	:=	Par_RolID;
            LEAVE ManejoErrores;
        END IF;

		DELETE FROM OPCIONESROL WHERE RolID = Par_RolID AND Empresa = Var_EmpresaID;

        SET	Par_NumErr		:=	0;
        SET	Par_ErrMen		:=	CONCAT('Rol Eliminado Exitosamente: ',Par_RolID);
        SET	Var_Control		:=	'rolID';
        SET	Var_Consecutivo	:=	Par_RolID;

	END IF;

END ManejoErrores;
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS	NumErr,
				Par_ErrMen		AS	ErrMen,
				Var_Control		AS	Control,
                Var_Consecutivo	AS	Consecutivo;
    END IF;
END TerminaStore$$
