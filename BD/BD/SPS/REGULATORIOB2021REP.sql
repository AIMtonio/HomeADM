-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOB2021REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOB2021REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOB2021REP`(

	Par_Anio           		INT,
	Par_Mes					INT,
	Par_NumRep				TINYINT UNSIGNED,

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN


DECLARE Var_FechaSistema			DATE;
DECLARE Var_FechaInicio				DATE;
DECLARE Var_FechaFin				DATE;
DECLARE Var_ReporteID				VARCHAR(10);
DECLARE Var_ClaveEntidad			VARCHAR(300);


DECLARE Rep_Excel				INT(1);
DECLARE Rep_Csv					INT(1);
DECLARE Entero_Cero				INT(2);
DECLARE Decimal_Cero			DECIMAL(2,2);
DECLARE Str_Tabulador			VARCHAR(20);
DECLARE ValorFijo1				CHAR(10);
DECLARE Estatus_Activo			CHAR(1);
DECLARE Estatus_Inactivo		CHAR(1);
DECLARE Salida_NO				CHAR(1);
DECLARE Var_No					CHAR(1);


SET Rep_Excel			:= 1;
SET Rep_Csv				:= 2;
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0000;
SET Str_Tabulador   	:= '     ';
SET ValorFijo1			:= '3';
SET Estatus_Activo		:= 'A';
SET Estatus_Inactivo	:= 'I';
SET Salida_NO			:= 'N';
SET Var_No				:= 'N';


SET Var_ReporteID		:= 'B2021';
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);



DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOB2021;
CREATE TEMPORARY TABLE TMPREGULATORIOB2021(
	TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
    ConceptoID      INT(11),
	NumClientes		INT(11),
    Saldo			DECIMAL(14,4),
	ClaveEntidad	VARCHAR(300),
	ValorFijo1		CHAR(10)
);



INSERT INTO TMPREGULATORIOB2021 (ConceptoID,   		ClaveEntidad,			ValorFijo1)
SELECT 							 ConceptoID,		Var_ClaveEntidad,		ValorFijo1
		FROM CONCEPTOSREGREP
		WHERE ReporteID = Var_ReporteID;


UPDATE TMPREGULATORIOB2021 SET NumClientes = (SELECT COUNT(ClienteID)
												FROM CLIENTES
												WHERE FechaAlta <= Var_FechaFin
													AND (Estatus = Estatus_Activo
															OR
														(Estatus = Estatus_Inactivo AND FechaBaja > Var_FechaFin))
													AND EsMenorEdad = Var_No  )
WHERE ConceptoID = 22;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 1
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 23;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 4
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 24;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 19
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 25;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 7
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 26;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 14
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 27;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 34
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 28;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 31
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 29;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 41
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 30;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 22
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 31;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 44
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 32;


UPDATE TMPREGULATORIOB2021	SET	Saldo = (SELECT Indicador
											FROM ESTADISTICOINDICA
											WHERE ConEstadisIndID = 49
												AND Anio = Par_Anio
												AND Mes = Par_Mes)
	WHERE ConceptoID = 33;




IF(Par_NumRep = Rep_Excel) THEN
	SELECT Tmp.TmpID,		Con.Descripcion, 		Tmp.ClaveEntidad,		Tmp.ValorFijo1,
			IFNULL(Tmp.NumClientes, Entero_Cero) AS NumClientes,
		    IFNULL(Saldo , Decimal_Cero)		 AS Saldo
		FROM TMPREGULATORIOB2021 Tmp,
			 CONCEPTOSREGREP Con
	WHERE Tmp.ConceptoID = Con.ConceptoID AND Con.ReporteID=Var_ReporteID;

END IF;

IF(Par_NumRep = Rep_Csv) THEN
	SELECT
		CONCAT(Tmp.TmpID,';', IFNULL(Tmp.ClaveEntidad,''),';', Tmp.ValorFijo1,';', Tmp.TmpID,';',
					IFNULL(Tmp.NumClientes, Entero_Cero),';',
					IFNULL(Saldo , Decimal_Cero)) AS Valor
		FROM TMPREGULATORIOB2021 Tmp,
			 CONCEPTOSREGREP Con
	WHERE Tmp.ConceptoID = Con.ConceptoID AND Con.ReporteID=Var_ReporteID;
END IF;


DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOB2021;

END TerminaStore$$