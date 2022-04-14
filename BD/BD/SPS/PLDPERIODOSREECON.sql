-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERIODOSREECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERIODOSREECON`;DELIMITER $$

CREATE PROCEDURE `PLDPERIODOSREECON`(
	Par_PeriodoReeID	INT(11),
	Par_NumCon			TINYINT UNSIGNED,
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

DECLARE Var_FechaServidor DATE;

DECLARE	Ano_Sis			INT;
DECLARE	Mes_Sis			INT;
DECLARE	Ano_SisAnt		INT;
DECLARE	FechaIni		CHAR(10);
DECLARE	FechaFin		CHAR(10);

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	PeriodoOc_Dic	INT;
DECLARE	mesDiciembre	INT;

SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Con_Principal		:= 1;
SET	PeriodoOc_Dic		:= 4;
SET	mesDiciembre		:= 12;

SET Var_FechaServidor 	:= DATE(NOW());

IF(Par_NumCon = Con_Principal)THEN
	SET Mes_Sis		:= (SELECT MONTH(FechaSistema) FROM PARAMETROSSIS);
	SET Ano_Sis		:= (SELECT YEAR(FechaSistema) FROM PARAMETROSSIS);
	SET Ano_SisAnt	:= (SELECT YEAR(FechaSistema)-1 FROM PARAMETROSSIS);
	SET FechaIni	:= (SELECT MesDiaInicio FROM PLDPERIODOSREEL
						WHERE PeriodoReeID=Par_PeriodoReeID);

	SET FechaFin	:= (SELECT MesDiaFin FROM PLDPERIODOSREEL
						WHERE PeriodoReeID=Par_PeriodoReeID);

	IF(Par_PeriodoReeID=PeriodoOc_Dic)THEN
		IF(mesDiciembre!=Mes_Sis)THEN
			SELECT CONVERT(CONCAT(Ano_SisAnt,FechaIni),DATE) FechaInicio,CONVERT(CONCAT(Ano_SisAnt,FechaFin),DATE)FechaFinal;
        ELSEIF(mesDiciembre=Mes_Sis)THEN
			SELECT CONVERT(CONCAT(Ano_Sis,FechaIni),DATE) FechaInicio,CONVERT(CONCAT(Ano_Sis,FechaFin),DATE)FechaFinal;
        END IF;
	ELSE
		SELECT CONVERT(CONCAT(Ano_Sis,FechaIni),DATE) FechaInicio,CONVERT(CONCAT(Ano_Sis,FechaFin),DATE) FechaFinal;
	END IF;

END IF;

END TerminaStore$$