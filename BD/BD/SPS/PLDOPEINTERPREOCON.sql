-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINTERPREOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINTERPREOCON`;
DELIMITER $$

CREATE PROCEDURE `PLDOPEINTERPREOCON`(

	Par_OpeInterPreoID		INT,
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
			)
TerminaStore: BEGIN


DECLARE ClaveEntCas			INT(7);
DECLARE ClaveOrgSup			CHAR(3);
DECLARE FechaNombre			INT;
DECLARE Var_FechaSistema	DATE;
DECLARE Var_NombreRep		VARCHAR(45);
DECLARE Var_TipoRepXMLPLD	VARCHAR(50);

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	Con_Foranea		INT;
DECLARE Con_NombArch	INT;
DECLARE	Punto			CHAR(1);
DECLARE TipoReporte		CHAR(1);
DECLARE EstatusVigente	CHAR(1);
DECLARE TipoRepSITI		CHAR(1);
DECLARE TipoRepXML		CHAR(1);

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Con_Principal	:= 1;
SET	Con_NombArch	:= 2;
SET	Punto			:= '.';
SET	TipoReporte		:= '3';
SET	EstatusVigente	:= 'V';
SET TipoRepSITI		:= '1';
SET TipoRepXML		:= '2';

IF(Par_NumCon = Con_Principal) THEN
	SELECT	OpeInterPreoID, 	CatProcedIntID, 	CatMotivPreoID, 	FechaDeteccion,		CategoriaID,
			SucursalID, 		ClavePersonaInv,	NomPersonaInv,		CteInvolucrado, 	Frecuencia,
			DesFrecuencia,  	DesOperacion,		Estatus,			ComentarioOC,		FechaCierre,
			Fecha
	FROM 	PLDOPEINTERPREO
	WHERE 	OpeInterPreoID = Par_OpeInterPreoID;
END IF;


IF(Par_NumCon = Con_NombArch) THEN
	SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS);
	SET FechaNombre 	 :=(DATE_FORMAT(Var_FechaSistema,'%y%m%d'));
	SET	ClaveEntCas		 :=(SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET	ClaveOrgSup		 :=(SELECT ClaveOrgSupervisorExt FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

	SET Var_TipoRepXMLPLD := LEFT(FNPARAMGENERALES('TipoRepXMLPLD'),50);
	SET Var_NombreRep := CONVERT(CONCAT(TipoReporte,ClaveEntCas,FechaNombre),CHAR(30));

	IF(Var_TipoRepXMLPLD = TipoRepXML)THEN
		UPDATE REPORTESXML SET NombreArchivo = Var_NombreRep WHERE ReporteID = 2;
	END IF;

	SET Var_NombreRep := CONVERT(CONCAT(Var_NombreRep,Punto,ClaveOrgSup),CHAR(30));
	SELECT Var_NombreRep AS nombreArchivo;
END IF;

END TerminaStore$$