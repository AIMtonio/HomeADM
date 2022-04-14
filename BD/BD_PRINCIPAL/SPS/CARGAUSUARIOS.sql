-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAUSUARIOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAUSUARIOS`;DELIMITER $$

CREATE PROCEDURE `CARGAUSUARIOS`(

	Par_OrigenDatos		VARCHAR(50),
    Par_RutaReportes	VARCHAR(100),
    Par_RutaImgReportes	VARCHAR(100),
    Par_LogoCtePantalla	VARCHAR(100),
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
TerminaStored : BEGIN

DECLARE Var_Sentencia	VARCHAR(65535);
DECLARE	Var_EmpresaID	INT(11);
DECLARE VarControl 		VARCHAR(100);

DECLARE Var_SalidaSI	CHAR(1);
DECLARE Entero_Cero		INT(1);


SET	Var_SalidaSI	:=	'S';
SET Entero_Cero		:=	0;

ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operación.
				Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CARGAUSUARIOS');
			SET VarControl = 'sqlException' ;
		END;

	SELECT	CompaniaID
	INTO	Var_EmpresaID
		FROM COMPANIA
        WHERE OrigenDatos = Par_OrigenDatos;

	SET	Var_EmpresaID	:=	ifnull(Var_EmpresaID,Entero_Cero);

	IF (Var_EmpresaID = Entero_Cero) THEN
		SET	Par_NumErr	:=	1;
        SET Par_ErrMen	:=	'La Compañia no se Encuentra Registrada.';
        LEAVE ManejoErrores;
    END IF;

    SET	Var_Sentencia	:=	CONCAT('INSERT INTO USUARIOS(
											Clave,			RolID,				Estatus,			LoginsFallidos,			EstatusSesion,
                                            Semilla,		OrigenDatos,		RutaReportes,		RutaImgReportes,		LogoCtePantalla,
                                            EmpresaID,		Usuario,			FechaActual,		DireccionIP,			ProgramaID,
                                            Sucursal,		NumTransaccion)
									SELECT	usu.Clave,		usu.RolID,			usu.Estatus,		usu.LoginsFallidos,		usu.EstatusSesion,
											usu.Clave,		"',Par_OrigenDatos,'","',Par_RutaReportes,'","',Par_RutaImgReportes,'","',Par_LogoCtePantalla,
                                            '",usu.EmpresaID,	usu.Usuario,		usu.FechaActual,	usu.DireccionIP,		usu.ProgramaID,
                                            usu.Sucursal,	usu.NumTransaccion
										FROM ',Par_OrigenDatos,'.USUARIOS as usu;');

	SET @Sentencia	:=	Var_Sentencia;

	PREPARE STCARGAUSUARIOS FROM @Sentencia;

    EXECUTE STCARGAUSUARIOS;

    SET	Par_NumErr	:=	0;
    SET Par_ErrMen	:=	'Carga de Usuarios Terminada Exitosamente.';

END ManejoErrores;

    IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen;
    END IF;

END TerminaStored$$