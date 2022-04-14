-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAOPCIONESROL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAOPCIONESROL`;DELIMITER $$

CREATE PROCEDURE `CARGAOPCIONESROL`(
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
TerminaStore : BEGIN

DECLARE Var_EmpresaID	INT(11);
DECLARE Var_Sentencia	VARCHAR(65535);
DECLARE VarControl 		VARCHAR(100);

DECLARE SalidaSi		CHAR(1);
DECLARE EnteroCero		INT(11);




SET	SalidaSi	:=	'S';
SET EnteroCero	:=	0;

ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
				Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CARGAOPCIONESROL');
			SET VarControl = 'sqlException' ;
		END;

	SELECT	CompaniaID
	INTO	Var_EmpresaID
		FROM COMPANIA
        WHERE OrigenDatos = Par_OrigenDatos;

	SET	Var_EmpresaID	:=	ifnull(Var_EmpresaID,EnteroCero);

	IF (Var_EmpresaID = EnteroCero) THEN
		SET	Par_NumErr	:=	1;
        SET Par_ErrMen	:=	'La Compañia no se Encuentra Registrada.';
        LEAVE ManejoErrores;
    END IF;

    SET Var_Sentencia	:=	CONCAT('INSERT INTO OPCIONESROL(
											Empresa,			RolID,				OpcionMenuID,			EmpresaID,			Usuario,
											FechaActual,		DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion)
									SELECT ',Var_EmpresaID,',	origen.RolID,		origen.OpcionMenuID,	origen.EmpresaID,	origen.Usuario,
											origen.FechaActual,	origen.DireccionIP,	origen.ProgramaID,		origen.Sucursal,	origen.NumTransaccion
										FROM ',Par_OrigenDatos,'.OPCIONESROL as origen;');
	SET @Sentencia	:=	Var_Sentencia;

	PREPARE STCARGAOPCIONESROL FROM @Sentencia;

    EXECUTE STCARGAOPCIONESROL;

    SET	Par_NumErr	:=	0;
    SET Par_ErrMen	:=	'Carga de Opciones Rol Terminada Exitosamente.';

END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen;
    END IF;

END TerminaStore$$