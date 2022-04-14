-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCAMPANIASCON`;
DELIMITER $$


CREATE PROCEDURE `SMSCAMPANIASCON`(
# ========================================================
# ---------- SP PARA CONSULTAR LAS CAMPANIAS SMS----------
# ========================================================
	Par_CampaniaID		INT(11),
    Par_MsgRecepcion	VARCHAR(50),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN


	-- Declaracion de Constantes
	DECLARE	Con_Principal	INT(11);
	DECLARE	Con_Foranea		INT(11);
	DECLARE Con_PrinSalCamp INT(11);
    DECLARE Con_PrinJar 	INT(11);
	DECLARE Cla_Salida      CHAR(1);
	DECLARE	Categoria		CHAR(1);
	DECLARE	Cla_Interactiva CHAR(1);
	DECLARE Cla_Entrada		CHAR(1);

	-- Asignacion de Constantes
	SET	Con_Principal		:= 1;		-- Consulta Principal
	SET	Con_Foranea			:= 2;		-- Consulta Foranea
	SET Con_PrinSalCamp 	:= 4;		-- Consulta Principal(Clasificacion Salida , Categoria Campaña)
	SET Con_PrinJar 		:= 5;		-- Consulta Principal para el JAR
	SET Cla_Salida			:='S'; 		-- clasificacion=Salida
	SET Categoria			:='C'; 		-- Categoria=Campaña
	SET Cla_Interactiva		:='I'; 		-- clasificacion=Interaciva
	SET Cla_Entrada			:='E'; 		-- clasificacion=Entrada

	IF(Par_NumCon = Con_Principal) THEN
		SELECT		CampaniaID,		Nombre,			Clasificacion,		Categoria,		Tipo,
					Estatus,		FechaLimiteRes, MsgRecepcion, 		PlantillaID
			FROM	SMSCAMPANIAS
			WHERE  	CampaniaID	= Par_CampaniaID;
	END IF;

	-- 4 consulta solo campanias de clasificacion salida y categoria campaña
	IF(Par_NumCon = Con_PrinSalCamp) THEN
		SELECT		CampaniaID,		Nombre,			Clasificacion,		Categoria,		Tipo,
					Estatus,		FechaLimiteRes, MsgRecepcion, 		PlantillaID
			FROM	SMSCAMPANIAS
			WHERE  	CampaniaID		= Par_CampaniaID
			AND		Clasificacion  != Cla_Entrada
			AND		Categoria		= Categoria;
	END IF;

	IF (Par_NumCon = Con_Foranea) THEN
		SELECT 		CampaniaID, Nombre, Estatus
			FROM	SMSCAMPANIAS
			WHERE 	CampaniaID	= Par_CampaniaID;
	END IF;

    IF(Par_NumCon = Con_PrinJar) THEN
		SELECT	CampaniaID,	PL.Descripcion
			FROM 	SMSCAMPANIAS CM
			INNER JOIN SMSPLANTILLA PL ON PL.PlantillaID = CM.PlantillaID
			WHERE	MsgRecepcion	= Par_MsgRecepcion;
	END IF;


END TerminaStore$$
