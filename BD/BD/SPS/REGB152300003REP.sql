-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGB152300003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGB152300003REP`;DELIMITER $$

CREATE PROCEDURE `REGB152300003REP`(
	/* Genera el reporte regulatorio B1523 para Sofipos	*/
	Par_Anio           		INT,				--  Año del reporte
	Par_Mes					INT,				-- 	Mes del Reporte
	Par_NumRep				TINYINT UNSIGNED, 	--  1:Excel, 2:CSV

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
DECLARE Var_ClaveEntidad 	VARCHAR(6);

-- Constantes
DECLARE Rep_Excel			INT;
DECLARE Rep_Csv				INT;
DECLARE NumReporte			VARCHAR(4);
DECLARE Entero_Uno 			INT;
declare Entero_Cero			int;
declare Cadena_Vacia 		varchar(2);

set NumReporte		:= '1523';
set Rep_Excel 		:=1 ;
set Rep_Csv	  		:=2;
set Entero_Uno 		:= 1;
set Entero_Cero		:= 0;
set Cadena_Vacia 	:= '';

set Var_Periodo	:= concat(Par_Anio,case when Par_Mes < 10 THEN concat(Entero_Cero,Par_Mes) else Par_Mes end);

SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

DROP TABLE IF EXISTS TMPREGULATORIOB1523;

CREATE TEMPORARY TABLE TMPREGULATORIOB1523(
	Servicios		INT,
	PersJuridica	tinyint,
	TipoCliente		INT,
	NivelCuenta		INT,
	TipoOperacion 	INT,
	NumClientes		INT,
	NumOperaciones	INT,
	Importe			DECIMAL(21,2)
);


IF Par_NumRep = Rep_Excel THEN
	SELECT Var_Periodo as Periodo,	Var_ClaveEntidad as ClaveEntidad,		NumReporte,			Servicios,		PersJuridica,
			TipoCliente,			NivelCuenta,							TipoOperacion,		NumClientes,	NumOperaciones,
			Importe
	FROM TMPREGULATORIOB1523;
END IF;

IF Par_NumRep = Rep_Csv THEN
	SELECT CONCAT(
			Var_Periodo, ';',
			Var_ClaveEntidad, ';',
			NumReporte, ';',
			Servicios, ';',
            PersJuridica, ';',
            TipoCliente, ';',
            NivelCuenta	, ';',
            TipoOperacion, ';',
            NumClientes, ';',
            NumOperaciones, ';',
            Importe

		   ) AS Valor
	FROM TMPREGULATORIOB1523;
END IF;
DROP TABLE IF EXISTS TMPREGULATORIOB1523;

END TerminaStore$$