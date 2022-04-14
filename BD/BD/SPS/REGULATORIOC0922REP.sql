-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOC0922REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOC0922REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOC0922REP`(
-- SP QUE LISTA LOS REGISTROS DE UNA FECHA DEL REGULATORIO  C0922

    Par_Anio			INT,				-- Ano del reporte
    Par_Mes				INT,				-- Mes del reporte
	Par_NumRep		    TINYINT UNSIGNED,	-- Numero de reporte 1 Excel , 2 csv


	Aud_Empresa		    INT(11),			-- Auditoria
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Auditoria
	Aud_Sucursal		INT,				-- Auditoria
	Aud_NumTransaccion	BIGINT				-- Auditoria
	)
TerminaStore: BEGIN

DECLARE Var_Fecha				INT;       -- Variable almacenar el valor de fecha de DATE a INTEGER
DECLARE Var_Periodo				VARCHAR(10);	-- Periodo del reporte
DECLARE Var_ClaveEntidad		VARCHAR(10);	-- Clave de la entidad
DECLARE Var_ClaveFederacion		VARCHAR(10);	-- Clave de la federacion
DECLARE Nivel_Entidad			VARCHAR(10);	-- Nivel de la entidad

DECLARE Principal 		INT;		-- Reporte principal
DECLARE Rep_Excel     	INT;		-- reporte en excel
DECLARE Rep_CSV      	INT;		-- reporte en csv
DECLARE Param_ID      	INT;		-- Parametros de regulatorios
DECLARE Entero_Cero   	INT;		-- Entero cero
DECLARE Cadena_Vacia	CHAR;		-- cadena vacia
DECLARE ReporteID		VARCHAR(4);	-- Numero de reporte


SET Rep_Excel		:= 1;
SET Param_ID		:= 1;
SET Rep_CSV         := 2;
SET Cadena_Vacia	:= '';
SET ReporteID		:= '922';
SET Var_Periodo		:= CONCAT(Par_Anio,CASE WHEN Par_Mes > 10 THEN 0 ELSE '' END,Par_Mes);
SET Entero_Cero		:= 0;

SELECT ClaveEntidad, ClaveFederacion
    INTO Var_ClaveEntidad, Var_ClaveFederacion
	FROM PARAMREGULATORIOS
	WHERE ParametrosID = Param_ID;

SELECT 	Cat.CodigoOpcion
INTO 	Nivel_Entidad
FROM 	CATNIVELENTIDADREG Cat,PARAMREGULATORIOS Par
WHERE 	Cat.NivelPrudencialID = Par.NivelPrudencial
AND     Cat.NivelOperacionID = Par.NivelOperaciones
AND 	Par.ParametrosID = Param_ID;

IF(Par_NumRep = Rep_Excel) THEN
	SELECT 	Var_Periodo AS Periodo,				Var_ClaveEntidad AS ClaveEntidad,
			Nivel_Entidad AS NivelEntidad, 		Var_ClaveFederacion AS ClaveFederacion,
            ReporteID AS Reporte,				RegistroID AS Secuencia,
            ClasfContable, 						Nombre,
			Puesto, 							TipoPercepcion,
            Descripcion, 						Dato
	FROM REGISTROREGC0922
	WHERE Anio = Par_Anio
	AND Mes = Par_Mes
    ORDER BY ReporteID ASC;
END IF;

IF(Par_NumRep = Rep_CSV) THEN
	SELECT CONCAT(
     ReporteID, ';',
     RegistroID, ';',
     ClasfContable, ';',
     Nombre, ';',
     Puesto, ';',
     TipoPercepcion,';',
     Descripcion,';',
     ROUND(Dato,Entero_Cero)
    ) AS Valor
    FROM REGISTROREGC0922
	WHERE Anio = Par_Anio
	AND Mes = Par_Mes
    ORDER BY ReporteID ASC;
END IF;


END TerminaStore$$