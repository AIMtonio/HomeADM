-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGB261200003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGB261200003REP`;DELIMITER $$

CREATE PROCEDURE `REGB261200003REP`(
	/* Genera el regulatorio B2612 para Sofipo */
	Par_Anio           		INT,				# Año del Reporte
	Par_Mes					INT,				# Mes del Reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Tipo de Reporte 1- Excel, 2- CSV

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
-- Variables
DECLARE Var_Periodo VARCHAR(8);
DECLARE Var_ClaveEntidad VARCHAR(10);

-- Constantes
DECLARE Rep_Excel		INT;
DECLARE Rep_Csv			INT;
DECLARE NumReporte		VARCHAR(4);
DECLARE Entero_Uno 		INT;
DECLARE Entero_Cero		INT;
DECLARE Cadena_Vacia 	VARCHAR(2);

SET NumReporte		:= '2612';	-- Clave del reporte
SET Rep_Excel 		:= 1 ;		-- Tipo Reporte Excel
SET Rep_Csv	  		:= 2;		-- Tipo Reporte CSV
SET Entero_Uno 		:= 1;
SET Entero_Cero		:= 0;
SET Cadena_Vacia 	:= '';

SET Var_Periodo	:= CONCAT(Par_Anio,CASE WHEN Par_Mes < 10 THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END);

SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

DROP TABLE IF EXISTS TMPREGULATORIOB2612;

CREATE TEMPORARY TABLE TMPREGULATORIOB2612(
	NumSecuencia 		INT PRIMARY KEY,
	IdenComisionista	VARCHAR(24),
	RFCCOmisionista		VARCHAR(13),
	TipoMovimiento		SMALLINT,
	ClaveModulo			VARCHAR(22),
	LocalidadModulo		VARCHAR(12),
	CausaBajaModulo		SMALLINT,
	Municipio			INT,
	Estado				INT
);


IF Par_NumRep = Rep_Excel THEN
	SELECT Var_Periodo AS Periodo,	Var_ClaveEntidad AS ClaveEntidad,		NumReporte,			NumSecuencia,		IdenComisionista,
			RFCCOmisionista,		TipoMovimiento,							ClaveModulo,		LocalidadModulo,	CausaBajaModulo,
			Municipio,				Estado
	FROM TMPREGULATORIOB2612;
END IF;

IF Par_NumRep = Rep_Csv THEN
	SELECT CONCAT(
			NumReporte, ';',
			NumSecuencia, ';',
			IdenComisionista, ';',
			RFCCOmisionista, ';',
			TipoMovimiento, ';',
			ClaveModulo, ';',
			LocalidadModulo, ';',
			CausaBajaModulo, ';',
			Municipio, ';',
			Estado
		   ) AS Valor
	FROM TMPREGULATORIOB2612;
END IF;
DROP TABLE IF EXISTS TMPREGULATORIOB2612;

END TerminaStore$$