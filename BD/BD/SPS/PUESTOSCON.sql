-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSCON`;
DELIMITER $$

CREATE PROCEDURE `PUESTOSCON`(
	Par_ClavePuestoID		CHAR(20),			-- Clave del puesto 
	Par_NumCon				TINYINT UNSIGNED,	-- Tipo de consulta

	Aud_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(11)			-- Parametro de Auditoria
)TerminaStore: BEGIN

	-- Declaracion de constante
	DECLARE Con_Principal		INT(11);		-- Consulta Principal
	DECLARE Con_Foranea			INT(11);		-- Consulta Foranea
	DECLARE Con_InfPuestUsua	INT(11);		-- Numero de consulta la informacion del puesto del usuario
	DECLARE Est_Vigente			CHAR(1);		-- Estatus Vigente

	-- Asignacion de Constante
	SET Con_Principal			:= 1;			-- Consulta Principal
	SET Con_Foranea				:= 2;			-- Consulta Foranea
	SET Con_InfPuestUsua		:= 3;			-- Numero de consulta la informacion del puesto del usuario
	SET Est_Vigente				:= 'V';			-- Estatus Vigente

	-- Consulta Principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	ClavePuestoID,		Descripcion,	AtiendeSuc,		AreaID,		CategoriaID,
				EsGestor,			EsSupervisor
			FROM PUESTOS
			WHERE ClavePuestoID = Par_ClavePuestoID
			AND Estatus = Est_Vigente;
	END IF;

	-- Consulta Foranea
	IF(Par_NumCon = Con_Foranea) THEN
		SELECT AtiendeSuc
			FROM PUESTOS
			WHERE ClavePuestoID = Par_ClavePuestoID
			AND Estatus = Est_Vigente;
	END IF;

	-- Numero de consulta la informacion del puesto del usuario
	IF(Par_NumCon = Con_InfPuestUsua) THEN
		SELECT	PUE.ClavePuestoID,						PUE.Descripcion,		PUE.AtiendeSuc,		PUE.AreaID,		PUE.CategoriaID,
				CAT.Descripcion AS DesCategoria,		PUE.EsGestor,			PUE.EsSupervisor
			FROM PUESTOS PUE
			LEFT JOIN CATEGORIAPTO CAT ON CAT.CategoriaID = PUE.CategoriaID
			WHERE PUE.ClavePuestoID = Par_ClavePuestoID
			AND PUE.Estatus = Est_Vigente;
	END IF;

END TerminaStore$$