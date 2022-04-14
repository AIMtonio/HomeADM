-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAMENUS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAMENUS`;DELIMITER $$

CREATE PROCEDURE `CARGAMENUS`(
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


DECLARE SalidaSi		CHAR(1);


DECLARE Var_Sentencia	VARCHAR(65535);
DECLARE VarControl 		VARCHAR(100);


SET	SalidaSi		:=	'S';

ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
				Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CARGAMENUS');
			SET VarControl = 'sqlException' ;
		END;

	SET	Var_Sentencia	:=	CONCAT('INSERT INTO MENUSAPLICACION(
											MenuID,			EmpresaID,			Descripcion,		Desplegado,			Orden,
                                            Usuario,		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
                                            NumTransaccion)
									SELECT	origen.MenuID,	origen.EmpresaID,	origen.Descripcion,	origen.Desplegado,	origen.Orden,
											origen.Usuario,	origen.FechaActual,	origen.DireccionIP,	origen.ProgramaID,	origen.Sucursal,
                                            origen.NumTransaccion
										FROM ',Par_OrigenDatos,'.MENUSAPLICACION AS origen;');


	SET @Sentencia	:=	Var_Sentencia;

	PREPARE STCARGAMENUS FROM @Sentencia;

    EXECUTE STCARGAMENUS;

	SET	Var_Sentencia	:=	CONCAT('INSERT INTO GRUPOSMENU(
											GrupoMenuID,			MenuID,					EmpresaID,			Descripcion,		Desplegado,
                                            Orden,					Usuario,				FechaActual,		DireccionIP,		ProgramaID,
                                            Sucursal,       		NumTransaccion)
									SELECT	origen.GrupoMenuID,		origen.MenuID,			origen.EmpresaID,	origen.Descripcion,	origen.Desplegado,
                                            origen.Orden,			origen.Usuario,			origen.FechaActual,	origen.DireccionIP,	origen.ProgramaID,
                                            origen.Sucursal,       	origen.NumTransaccion
										FROM ',Par_OrigenDatos,'.GRUPOSMENU AS origen;');


	SET @Sentencia	:=	Var_Sentencia;

	PREPARE STCARGAMENUS FROM @Sentencia;

    EXECUTE STCARGAMENUS;


    	SET	Var_Sentencia	:=	CONCAT('INSERT INTO OPCIONESMENU(
											OpcionMenuID,			GrupoMenuID,			EmpresaID,				Descripcion,		Desplegado,
                                            Recurso,                Orden,					RequiereCajero,			Usuario,			FechaActual,
                                            DireccionIP,			ProgramaID,				Sucursal,       		NumTransaccion)
									SELECT	origen.OpcionMenuID,	origen.GrupoMenuID,		origen.EmpresaID,		origen.Descripcion,	origen.Desplegado,
                                            origen.Recurso,         origen.Orden,			origen.RequiereCajero,	origen.Usuario,		origen.FechaActual,
                                            origen.DireccionIP,		origen.ProgramaID,		origen.Sucursal,       	origen.NumTransaccion
										FROM ',Par_OrigenDatos,'.OPCIONESMENU AS origen;');


	SET @Sentencia	:=	Var_Sentencia;

	PREPARE STCARGAMENUS FROM @Sentencia;

    EXECUTE STCARGAMENUS;

	SET Par_NumErr	:=	0;
    SET Par_ErrMen	:=	'Menus Cargados Exitosamente.';

END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen;
    END IF;

END TerminaStore$$