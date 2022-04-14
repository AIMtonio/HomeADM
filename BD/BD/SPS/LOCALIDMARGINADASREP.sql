-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOCALIDMARGINADASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOCALIDMARGINADASREP`;DELIMITER $$

CREATE PROCEDURE `LOCALIDMARGINADASREP`(
    Par_EstadoID        	INT(11),	-- ID DEL ESTADO
    Par_MunicipioID     	INT(11),	-- ID DEL MUNICIPIO
    Par_LocalidadID     	INT(11),	-- ID DE LA LOCALIDAD
    Par_TipoRep				INT(11),	-- TIPO DE REPORTE A GENERAR
	/* Parametros de Auditoria */
    Par_EmpresaID			INT(11),

    Aud_Usuario				INT(11),
    Aud_FechaActual      	DATE,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
    -- Declaracion de Variables --
    DECLARE Var_Sentencia VARCHAR(60000);

    -- Declaracion de Constantes --
    DECLARE Entero_Cero INT;
    DECLARE Cadena_Vacia CHAR(1);
    DECLARE Marginada CHAR(1);

	-- Asignacion de constantes --
    SET Entero_Cero := 0;
    SET Cadena_Vacia := '';
    SET Marginada := 'S';

    SET Par_EstadoID 	:= IFNULL(Par_EstadoID,Entero_Cero);
    SET Par_MunicipioID := IFNULL(Par_MunicipioID,Entero_Cero);
    SET Par_LocalidadID := IFNULL(Par_LocalidadID,Entero_Cero);
    SET Par_TipoRep 	:= IFNULL(Par_TipoRep, Entero_Cero);

    SET Var_Sentencia	:='select Edo.EstadoID, Edo.Nombre as NombreEstado, Mun.MunicipioID, Mun.Nombre as NombreMunicipio, Loc.LocalidadID, Loc.NombreLocalidad, Loc.NumHabitantes, time(now()) as HoraEmision ';

    SET Var_Sentencia	:= CONCAT(Var_Sentencia,'  from ESTADOSREPUB Edo ');
    SET Var_Sentencia   := CONCAT(Var_Sentencia, ' inner join MUNICIPIOSREPUB Mun on Edo.EstadoID = Mun.EstadoID ');
    SET Var_Sentencia   := CONCAT(Var_Sentencia, ' inner join LOCALIDADREPUB Loc ON Edo.EstadoID = Loc.EstadoID and Mun.MunicipioID = Loc.MunicipioID ');
    SET Var_Sentencia   := CONCAT(Var_Sentencia,' where Loc.EsMarginada  =  "', Marginada,'"' );

    IF(Par_EstadoID != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and Edo.EstadoID = ' , Par_EstadoID);
    END IF;

    IF(Par_MunicipioID != Entero_Cero)THEN
        SET Var_sentencia := CONCAT(Var_Sentencia, ' and Mun.MunicipioID = ', Par_MunicipioID);
    END IF;

    IF(Par_LocalidadID != Entero_Cero)THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia,' and Loc.LocalidadID = ', Par_LocalidadID);
    END IF;

	SET Var_sentencia := CONCAT(Var_Sentencia, ' order by NombreEstado, NombreMunicipio, NombreLocalidad ');

	SET @Sentencia	:= Var_Sentencia;

	PREPARE STLOCMARGINADASREP FROM @Sentencia;
	EXECUTE STLOCMARGINADASREP;
	DEALLOCATE PREPARE STLOCMARGINADASREP;

END TerminaStore$$