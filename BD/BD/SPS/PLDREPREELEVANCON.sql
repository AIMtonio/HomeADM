-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDREPREELEVANCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDREPREELEVANCON`;
DELIMITER $$

CREATE PROCEDURE `PLDREPREELEVANCON`(
	Par_FechaInicial	VARCHAR(10),
	Par_FechaFinal		VARCHAR(10),
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
			)
TerminaStore: BEGIN


DECLARE	ClaveEnt		VARCHAR(20);
DECLARE	FechaNomb		CHAR(20);
DECLARE	Organo_Sup		VARCHAR(10);
DECLARE Var_NombreRep	VARCHAR(45);
DECLARE Var_TipoRepXMLPLD VARCHAR(50);

DECLARE	TipoReporte		INT(11);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	Con_Foranea		INT;
DECLARE	Con_NombArch	INT;
DECLARE	Con_Arch		INT;
DECLARE	Con_GenArch		INT;
DECLARE Punto			CHAR(1);
DECLARE EstatusVigente	CHAR(1);
DECLARE FechaI			DATE;
DECLARE	FechaF			DATE;
DECLARE TipoRepSITI		CHAR(1);
DECLARE TipoRepXML		CHAR(1);

SET	TipoReporte		:= 1;
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Con_Principal	:= 1;
SET	Con_NombArch	:= 3;
SET	Con_Arch		:= 4;
SET	Con_GenArch		:= 5;
SET	Punto			:= '.';
SET	EstatusVigente	:= 'V';
SET TipoRepSITI		:= '1';
SET TipoRepXML		:= '2';

SET FechaNomb 	:= (DATE_FORMAT(Par_FechaFinal,'%y%m'));
SET	ClaveEnt	:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
SET	Organo_Sup	:= (SELECT ClaveOrgSupervisorExt FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

SET FechaI := (SELECT CONVERT (Par_FechaInicial,DATE));
SET FechaF := (SELECT CONVERT (Par_FechaFinal,DATE));



IF(Par_NumCon = Con_NombArch) THEN
	SET Var_TipoRepXMLPLD := LEFT(FNPARAMGENERALES('TipoRepXMLPLD'),50);
	SET Var_NombreRep := CONVERT(CONCAT(TipoReporte,ClaveEnt,FechaNomb),CHAR(30));

	IF(Var_TipoRepXMLPLD = TipoRepXML)THEN
		UPDATE REPORTESXML SET NombreArchivo = Var_NombreRep WHERE ReporteID = 3;
	END IF;

	SET Var_NombreRep := CONVERT(CONCAT(Var_NombreRep,Punto,Organo_Sup),CHAR(30));
	SELECT Var_NombreRep AS NombreArchivo;
END IF;



IF(Par_NumCon = Con_Arch) THEN
	IF(EXISTS(SELECT PeriodoInicio
				FROM `PLDHIS-REELEVAN`
				  WHERE PeriodoInicio>=FechaI AND PeriodoFin<=FechaF)) THEN

		SELECT CONCAT("datos")AS Leyenda;
	END IF;
END IF;



IF(Par_NumCon = Con_GenArch) THEN
	IF(NOT EXISTS(SELECT Fecha
					FROM PLDOPEREELEVANT
						WHERE Fecha>=FechaI AND Fecha<=FechaF)) THEN
		SELECT CONCAT("Sin datos")AS Leyenda;
	END IF;
END IF;

END TerminaStore$$