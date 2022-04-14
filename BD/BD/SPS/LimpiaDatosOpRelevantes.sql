-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LimpiaDatosOpRelevantes
DELIMITER ;
DROP PROCEDURE IF EXISTS `LimpiaDatosOpRelevantes`;DELIMITER $$

CREATE PROCEDURE `LimpiaDatosOpRelevantes`(

	Par_FechaGeneracion 	DATE
	)
TerminaStore: BEGIN

DECLARE Var_Periodo 		CHAR(10);
DECLARE Var_PeriodoFin		DATE;
DECLARE Var_PeriodoInicio	DATE;
DECLARE Var_Contador		INT;
DECLARE Var_ContadorH		INT;
DECLARE Var_ContadorT		INT;
DECLARE	Entero_Cero			INT;
DECLARE	TipRep				INT;

SELECT PeriodoInicio, 		PeriodoFin
  INTO Var_PeriodoInicio,	Var_PeriodoFin
	FROM `PLDHIS-REELEVAN`
	WHERE PeriodoInicio <= Par_FechaGeneracion
		AND  PeriodoFin >= Par_FechaGeneracion
    LIMIT 1;

SET	Entero_Cero		:=0;
SET	TipRep			:=1;
SET	Var_Contador	:=0;
SET	Var_ContadorH	:=0;
SET	Var_ContadorT	:=0;
SET Var_Periodo :=  (DATE_FORMAT(Var_PeriodoFin,'%Y%m'));

SELECT COUNT(*)
  INTO Var_ContadorH
	FROM `PLDHIS-REELEVAN`
		WHERE PeriodoInicio <= Par_FechaGeneracion
			AND  PeriodoFin >= Par_FechaGeneracion;

SELECT COUNT(*)
  INTO Var_Contador
	FROM PLDCNBVOPEREELE
		WHERE PeriodoReporte 	= Var_Periodo
			AND tipoReporte		= TipRep;

SET Var_ContadorT = Var_Contador + Var_ContadorH;



IF(IFNULL(Var_ContadorT,Entero_Cero)>Entero_Cero)THEN
	DELETE FROM `PLDHIS-REELEVAN`
		WHERE PeriodoInicio <= Par_FechaGeneracion
			AND  PeriodoFin >= Par_FechaGeneracion;

	DELETE FROM PLDCNBVOPEREELE
		WHERE PeriodoReporte 	= Var_Periodo
			AND tipoReporte		= TipRep;

	SELECT 'Registros Eliminados Exitosamente' Mensaje;
ELSE
	SELECT 'No hay Registros a Eliminar' Mensaje;
END IF;

END TerminaStore$$