-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGACONFIGURACION
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGACONFIGURACION`;DELIMITER $$

CREATE PROCEDURE `CARGACONFIGURACION`(
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

DECLARE Var_OrigenDatos		VARCHAR(50);
DECLARE Var_Sentencia		VARCHAR(65535);
DECLARE Var_Prefijo			VARCHAR(3);
DECLARE Var_EmpresaID		INT(1);
DECLARE VarControl			VARCHAR(100);


DECLARE SalidaSi			CHAR(1);

DECLARE CURSORORIGENES CURSOR FOR
    select OrigenDatos,	Prefijo, CompaniaID
        from COMPANIA;


SET SalidaSi	:=	'S';

ManejoErrores : BEGIN

    SELECT	OrigenDatos
    INTO	Var_OrigenDatos
		FROM COMPANIA
        limit 1;
	SET	Var_Sentencia	:=	CONCAT('INSERT INTO MENUSAPLICACION(
											MenuID,			EmpresaID,			Descripcion,		Desplegado,			Orden,
                                            Usuario,		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
                                            NumTransaccion)
									SELECT	origen.MenuID,	origen.EmpresaID,	origen.Descripcion,	origen.Desplegado,	origen.Orden,
											origen.Usuario,	origen.FechaActual,	origen.DireccionIP,	origen.ProgramaID,	origen.Sucursal,
                                            origen.NumTransaccion
										FROM ',Var_OrigenDatos,'.MENUSAPLICACION AS origen;');


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
										FROM ',Var_OrigenDatos,'.GRUPOSMENU AS origen;');


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
										FROM ',Var_OrigenDatos,'.OPCIONESMENU AS origen;');


	SET @Sentencia	:=	Var_Sentencia;

	PREPARE STCARGAMENUS FROM @Sentencia;

    EXECUTE STCARGAMENUS;

    OPEN CURSORORIGENES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH	CURSORORIGENES
            INTO	Var_OrigenDatos,	Var_Prefijo,	Var_EmpresaID;

            SET	Var_Sentencia	:=	CONCAT('UPDATE ',Var_OrigenDatos,'.ROLES
												set Descripcion = CONCAT("',Var_Prefijo,'",Descripcion);');

			SET @Sentencia	:=	Var_Sentencia;

			PREPARE STMODROLES FROM @Sentencia;

			EXECUTE STMODROLES;

			SET	Var_Sentencia	:=	CONCAT('UPDATE ',Var_OrigenDatos,'.USUARIOS
												set Clave = CONCAT("',Var_Prefijo,'",Clave);');

			SET @Sentencia	:=	Var_Sentencia;

			PREPARE STMODUSUARIOS FROM @Sentencia;

			EXECUTE STMODUSUARIOS;

            SET	Var_Sentencia	:=	CONCAT('INSERT INTO ROLES(
											RolID,				EmpresaID,			NombreRol,			Descripcion,		Usuario,
											FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
									SELECT	origen.RolID,		',Var_EmpresaID,',	origen.NombreRol,	origen.Descripcion,	origen.Usuario,
											origen.FechaActual,	origen.DireccionIP,	origen.ProgramaID,	origen.Sucursal,	origen.NumTransaccion
										FROM ',Var_OrigenDatos,'.ROLES as origen;');

			SET @Sentencia	:=	Var_Sentencia;

			PREPARE STCARGAROLES FROM @Sentencia;

			EXECUTE STCARGAROLES;

            SET Var_Sentencia	:=	CONCAT('INSERT INTO OPCIONESROL(
											Empresa,			RolID,				OpcionMenuID,			EmpresaID,			Usuario,
											FechaActual,		DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion)
									SELECT ',Var_EmpresaID,',	origen.RolID,		origen.OpcionMenuID,	origen.EmpresaID,	origen.Usuario,
											origen.FechaActual,	origen.DireccionIP,	origen.ProgramaID,		origen.Sucursal,	origen.NumTransaccion
										FROM ',Var_OrigenDatos,'.OPCIONESROL as origen;');

			SET @Sentencia	:=	Var_Sentencia;

			PREPARE STCARGAOPCIONESROL FROM @Sentencia;

			EXECUTE STCARGAOPCIONESROL;

			End LOOP;
		END;
    CLOSE CURSORORIGENES;

    SET Par_NumErr	:=	0;
    SET Par_ErrMen	:=	'Configuracion Terminada Exitosamente.';

END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen;
    END IF;
END TerminaStored$$