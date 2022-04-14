-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA261000006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA261000006REP`;DELIMITER $$

CREATE PROCEDURE `REGA261000006REP`(
	/* Genera el regulatorio A2610 para Socap */
	Par_Anio           		INT,				# Año del Reporte
	Par_Mes					INT,				# Mes del Reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Numero de Reporte 1 - Excel  2 - CSV


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
DECLARE Var_Periodo 		VARCHAR(8);
DECLARE Var_ClaveEntidad 	VARCHAR(10);

-- Constantes
DECLARE Rep_Excel		INT;
DECLARE Rep_Csv			INT;
DECLARE NumReporte		VARCHAR(4);
DECLARE Entero_Uno 		INT;
DECLARE Entero_Cero		INT;
DECLARE Cadena_Vacia 	VARCHAR(2);

SET NumReporte			:= '2610';		-- Clave del reporte
SET Rep_Excel 			:=1 ;
SET Rep_Csv	  			:=2;
SET Entero_Uno 			:= 1;
SET Entero_Cero			:= 0;
SET Cadena_Vacia 		:= '';

SET Var_Periodo	:= CONCAT(Par_Anio,CASE WHEN Par_Mes < 10 THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END);

SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

DROP TABLE IF EXISTS TMPREGULATORIOA2610;

CREATE TEMPORARY TABLE TMPREGULATORIOA2610(
	NumSecuencia 		INT PRIMARY KEY,
	TipoMovimiento 		SMALLINT,
	Identificador 		VARCHAR(24),
	NombreAdmin			VARCHAR(100),
	RFCAdministrador	VARCHAR(13),
	PersJuridica		SMALLINT,
	CausaBaja			SMALLINT
);


IF Par_NumRep = Rep_Excel THEN
	SELECT Var_Periodo AS Periodo,	Var_ClaveEntidad AS ClaveEntidad,		NumReporte AS Subreporte ,			NumSecuencia,		TipoMovimiento,
		   Identificador,	 		NombreAdmin,							RFCAdministrador,	PersJuridica,		CausaBaja
	FROM TMPREGULATORIOA2610;
END IF;

IF Par_NumRep = Rep_Csv THEN
	SELECT CONCAT(
			NumReporte, 	';',
			NumSecuencia, 	';',
			TipoMovimiento, ';',
		    Identificador, 	';',
		    NombreAdmin, 	';',
		    RFCAdministrador, ';',
		    PersJuridica, 	';',
		    CausaBaja
		   ) AS Valor
	FROM TMPREGULATORIOA2610;
END IF;
DROP TABLE IF EXISTS TMPREGULATORIOA2610;

END TerminaStore$$