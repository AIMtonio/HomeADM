-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOCALIDADREPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOCALIDADREPUBLIS`;
DELIMITER $$

CREATE PROCEDURE `LOCALIDADREPUBLIS`(
    -- Lista de localidades --
	Par_EstadoID		INT(11),			-- Clave de Estado
	Par_MunicipioID		INT(11),			-- Clave de municipio
	Par_NombreLocalidad	VARCHAR(50), 		-- Nombre de la localidad
	Par_NumLis			TINYINT UNSIGNED, 	-- Numero de lista
	Par_EmpresaID		INT, 				-- Auditoria

	Aud_Usuario			INT, 				-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Auditoria
	Aud_Sucursal		INT,				-- Auditoria
	Aud_NumTransaccion	BIGINT				-- Auditoria

	)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Constante Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Constante Entero Cero
	DECLARE	Lis_Principal		INT(11);			-- Lista Principal
	DECLARE Lis_Regulatorio		INT(11);			-- Devuelve la Localidad CNBV para Regulatorios(A1713)
	DECLARE Lis_RegSofipo		INT(11);			-- Devuelve la Localidad CNBV para Regulatorios(A1713) - Tipo Sofipo
	DECLARE Lis_LocalidadWS		INT(11);			-- Lista de la localidas para el WS

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	Lis_Principal			:= 1;				-- Lista Principal
	SET	Lis_Regulatorio			:= 2;				-- Devuelve la Localidad CNBV para Regulatorios(A1713)
	SET	Lis_RegSofipo			:= 3;				-- Devuelve la Localidad CNBV para Regulatorios(A1713) - Tipo Sofipo
	SET Lis_LocalidadWS			:= 4;				-- Lista de la Informacion de las localidades para el WS

	-- 1.- Lista Principal
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	LocalidadID,	NombreLocalidad
		FROM LOCALIDADREPUB
		WHERE EstadoID = Par_EstadoID
		AND	 MunicipioID = Par_MunicipioID
		AND	 NombreLocalidad LIKE CONCAT("%", Par_NombreLocalidad, "%")
		LIMIT 0, 15;
	END IF;

	-- 2.- Lista LocalidadCNBV para regulatorios (A1713)
	IF(Par_NumLis = Lis_Regulatorio) THEN
		SELECT	ColoniaCNBV AS LocalidadCNBV ,CONCAT(TipoAsenta," ",Asentamiento) AS NombreLocalidad
		FROM COLONIASREPUB
		WHERE EstadoID = Par_EstadoID
		AND	 MunicipioID = Par_MunicipioID
		AND	 Asentamiento LIKE CONCAT("%", Par_NombreLocalidad, "%")
		LIMIT 0, 15;
	END IF;

	-- 3.- Lista LocalidadCNBV para regulatorios (A1713) -- Sofipo
	IF(Par_NumLis = Lis_RegSofipo) THEN
		SELECT	LocalidadCNBV ,	NombreLocalidad
		FROM LOCALIDADREPUB
		WHERE EstadoID = Par_EstadoID
		AND	 MunicipioID = Par_MunicipioID
		AND	 NombreLocalidad LIKE CONCAT("%", Par_NombreLocalidad, "%")
		LIMIT 0, 15;
	END IF;

	-- 4.- Lista de la Informacion de las localidades para el WS
	IF(Par_NumLis = Lis_LocalidadWS) THEN
		SELECT	EstadoID,			MunicipioID,		LocalidadID,		NombreLocalidad,	NombreLocalidad2,
				NumHabitantes,		NumHabitantesHom,	NumHabitantesMuj,	EsMarginada,		LocalidadCNBV,
				ClaveRiesgo
		FROM LOCALIDADREPUB
		WHERE EstadoID = Par_EstadoID
		AND	 MunicipioID = Par_MunicipioID;
	END IF;

END TerminaStore$$