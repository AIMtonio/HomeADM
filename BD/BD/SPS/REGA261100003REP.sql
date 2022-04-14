-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA261100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA261100003REP`;DELIMITER $$

CREATE PROCEDURE `REGA261100003REP`(
	/* Genera el regulatorio A2611 para Sofipo */
	Par_Anio           		INT,				# Año del reporte
	Par_Mes					INT,				# Mes del Reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Tipo Reporte 1-Excel. 2 - CSV


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

SET NumReporte		:= '2611'; -- Clave del reporte
SET Rep_Excel 		:= 1 ;     -- Tipo de reporte Excel
SET Rep_Csv	  		:= 2;	   -- Tipo de reporte CSV
SET Entero_Uno 		:= 1;
SET Entero_Cero		:= 0;
SET Cadena_Vacia 	:= '';

SET Var_Periodo	:= CONCAT(Par_Anio,CASE WHEN Par_Mes < 10 THEN CONCAT(Entero_Cero,Par_Mes) ELSE Par_Mes END);

SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

DROP TABLE IF EXISTS TMPREGULATORIOA2611;
CREATE TEMPORARY TABLE TMPREGULATORIOA2611(
	NumSecuencia 		INT PRIMARY KEY,
	OperacionConAdmin	VARCHAR(2),
	IdenAdministrador	VARCHAR(24),
	RFCAdministrador	VARCHAR(13),
	TipoMovimiento		SMALLINT,
	IdenComisionista	VARCHAR(24),
	NombreComisionista	VARCHAR(100),
	RFCCOmisionista		VARCHAR(13),
	PersJuridicaComi	SMALLINT,
	OperaContratadas	VARCHAR(5),
	CausaBaja			SMALLINT
);


IF Par_NumRep = Rep_Excel THEN
	SELECT Var_Periodo AS Periodo,	Var_ClaveEntidad AS ClaveEntidad,	NumReporte,			NumSecuencia,		OperacionConAdmin,
	IdenAdministrador,	 	 		RFCAdministrador,					TipoMovimiento,		IdenComisionista,	NombreComisionista,
	RFCCOmisionista,				PersJuridicaComi,					OperaContratadas,	CausaBaja
	FROM TMPREGULATORIOA2611;
END IF;

IF Par_NumRep = Rep_Csv THEN
	SELECT CONCAT(
			NumReporte, 		';',
			NumSecuencia, 		';',
			OperacionConAdmin, 	';',
			IdenAdministrador, 	';',
			RFCAdministrador, 	';',
			TipoMovimiento, 	';',
			IdenComisionista, 	';',
			NombreComisionista, ';',
			RFCCOmisionista, 	';',
			PersJuridicaComi, 	';',
			OperaContratadas, 	';',
			CausaBaja
		   ) AS Valor
	FROM TMPREGULATORIOA2611;
END IF;
DROP TABLE IF EXISTS TMPREGULATORIOA2611;

END TerminaStore$$