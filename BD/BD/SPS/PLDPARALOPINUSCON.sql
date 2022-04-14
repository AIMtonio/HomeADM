
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPARALOPINUSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPARALOPINUSCON`;

DELIMITER $$
CREATE PROCEDURE `PLDPARALOPINUSCON`(
/*CONSULTA PARA LOS PARAMETROS DE ALERTAS DE OP INUSUALES*/
	Par_TipoPersona			CHAR(1),
	Par_NivelRiesgo			CHAR(1),
	Par_FolioID				INT(11),
	Par_NumCon				TINYINT UNSIGNED,
	Aud_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Con_Principal		INT;
DECLARE	Con_Foranea			INT;
DECLARE Con_FolioVigente	INT(11);
DECLARE Est_Vigente			CHAR(1);

-- Asignacion de constantes
SET	Con_Principal			:= 1;		-- Cosulta principal
SET	Con_Foranea				:= 2;		-- consulta forÃ¡nea
SET Con_FolioVigente		:= 3;		-- Consulta con folio vigente
SET Est_Vigente				:="V";		-- Estaus Viqente

IF(Par_NumCon = Con_Principal) THEN
	SELECT
		FolioID,		FechaVigencia,		TipoInstruMonID,	VarPTrans,		VarPagos,
		VarPlazo,		LiquidAnticipad,	Estatus,			VarNumDep,		VarNumRet,
		TipoPersona,	NivelRiesgo,		PorcAmoAnt,			PorcLiqAnt,		PorcDiasLiqAnt
	FROM(
		SELECT
			FolioID,		FechaVigencia,		TipoInstruMonID,	VarPTrans,		VarPagos,
			VarPlazo,		LiquidAnticipad,	Estatus,			VarNumDep,		VarNumRet,
			TipoPersona,	NivelRiesgo,		PorcAmoAnt,			PorcLiqAnt,		PorcDiasLiqAnt
		FROM PLDHISPARALEOPINUS
		UNION ALL
		SELECT
			FolioID,		FechaVigencia,		TipoInstruMonID,	VarPTrans,		VarPagos,
			VarPlazo,		LiquidAnticipad,	Estatus,			VarNumDep,		VarNumRet,
			TipoPersona,	NivelRiesgo,		PorcAmoAnt,			PorcLiqAnt,		PorcDiasLiqAnt
		FROM PLDPARALEOPINUS) AS UNI
	WHERE FolioID = Par_FolioID;
END IF;

IF Par_NumCon = Con_FolioVigente THEN
	SELECT
		FolioID,		FechaVigencia,		TipoInstruMonID,	VarPTrans,		VarPagos,
		VarPlazo,		LiquidAnticipad,	Estatus,			VarNumDep,		VarNumRet,
		TipoPersona,	NivelRiesgo,		PorcAmoAnt,			PorcLiqAnt,		PorcDiasLiqAnt
	FROM PLDPARALEOPINUS
	WHERE TipoPersona = Par_TipoPersona
		AND NivelRiesgo = Par_NivelRiesgo
		AND Estatus = Est_Vigente;
END IF;

END TerminaStore$$

