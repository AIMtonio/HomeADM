-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCARGAMOVSVAL`;
DELIMITER $$


CREATE PROCEDURE `PLDCARGAMOVSVAL`(
	-- SP que se encarga de validar que los movimientos no contengan algun campo vacio
	OUT	Par_NumErr	INT(11),				-- Numero de error
	OUT Par_Mensaje	VARCHAR(400),			-- Mensaje de error
	OUT Par_Control	VARCHAR(10)				-- Control
)

TerminaStore: BEGIN
	DECLARE Cadena_Vacia CHAR(1);			-- Cadena Vacia
	DECLARE VAR_1		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna CuentaAhoIDClie
	DECLARE VAR_2		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna ClienteID
	DECLARE VAR_3		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna Fecha
	DECLARE VAR_4		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna NatMovimiento
	DECLARE VAR_5		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna CantidadMov
	DECLARE VAR_6		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna DescripMov
	DECLARE VAR_7		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna ReferenciaMov
	DECLARE VAR_8		VARCHAR(400);		-- Variable para almacenar la informacion de la Columna TipoMovAhoID
	DECLARE ErrMen		VARCHAR(400);		-- Variable para almacenar el memsaje de error

	SET Cadena_Vacia	:='';

	SELECT CONCAT('La Columna CuentaAhoIDClie tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_1
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE CuentaAhoIDClie IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna ClienteID tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_2
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE ClienteID IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna Fecha tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
			INTO VAR_3
			FROM
				(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
				FROM TMPPLDCARGAMOVSDET
				WHERE Fecha IS NULL
				GROUP BY CargaID
				ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna NatMovimiento tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_4
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE NatMovimiento IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna CantidadMov tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_5
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE CantidadMov IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna DescripMov tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_6
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE DescripMov IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna ReferenciaMov tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_7
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE ReferenciaMov IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

	SELECT CONCAT('La Columna TipoMovAhoID tiene ', Resultado.TotalNulos, ' NULL los cuales se encuetran en los NumRegistros: ', Resultado.NumRegistros, ' de la CargaID ', Resultado.CargaID) AS Mensaje
		INTO VAR_8
		FROM
			(SELECT CargaID, COUNT(*) as TotalNulos, GROUP_CONCAT(NumRegistros) as NumRegistros
			FROM TMPPLDCARGAMOVSDET
			WHERE TipoMovAhoID IS NULL
			GROUP BY CargaID
			ORDER BY CargaID ASC) AS Resultado;

    SET VAR_1		:= IFNULL(VAR_1,Cadena_Vacia);
    SET VAR_2		:= IFNULL(VAR_2,Cadena_Vacia);
    SET VAR_3		:= IFNULL(VAR_3,Cadena_Vacia);
    SET VAR_4		:= IFNULL(VAR_4,Cadena_Vacia);

    SET VAR_5		:= IFNULL(VAR_5,Cadena_Vacia);
    SET VAR_6		:= IFNULL(VAR_6,Cadena_Vacia);
    SET VAR_7		:= IFNULL(VAR_7,Cadena_Vacia);
    SET VAR_8		:= IFNULL(VAR_8,Cadena_Vacia);

    SET ErrMen		:= CONCAT(VAR_1,VAR_2,VAR_3,VAR_4,VAR_5,VAR_6,VAR_7,VAR_8);

	IF(ErrMen != Cadena_Vacia ) THEN
		SET Par_NumErr	:= 	1;
		SET Par_Mensaje	:=	ErrMen;
		SET Par_Control	:=	'DETIENE';
	END IF;

	IF(ErrMen = Cadena_Vacia ) THEN
		SET Par_NumErr	:= 	0;
		SET Par_Mensaje	:=	'No se detectaron registros vacios';
		SET Par_Control	:=	'CONTINUA';
	END IF;


END TerminaStore$$