-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSTANCIARETCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETCTECON`;DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCTECON`(
	-- Consulta de informacion para la generacion de Constancias de Retencion
	Par_AnioProceso 		INT(11),			-- Anio para generar Constancia Retencion
	Par_SucursalInicio		INT(11),			-- Sucursal de Inicio
	Par_SucursalFin			INT(11),			-- Sucursal de Fin
	Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria

)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal		INT(11);
    DECLARE Con_Foranea			INT(11);
    DECLARE Con_CteConsRet		INT(11);

	-- Asignacion de constantes
	SET Con_Principal			:= 1; 	 	-- Consulta Principal
	SET Con_Foranea				:= 2;		-- Consulta Foranea
    SET Con_CteConsRet			:= 3;		-- Consulta de Clientes para generar la Constancia de Retencion

    -- 1.- Consulta Principal
    IF(Par_NumCon = Con_Principal)THEN
		SELECT COUNT(ClienteID) AS NumRegistros
			FROM CONSTANCIARETCTE
				WHERE Anio = Par_AnioProceso
				AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;
	END IF;

	-- 2.- Consulta Foranea
    IF(Par_NumCon = Con_Foranea)THEN
		SELECT COUNT(ClienteID) AS NumRegistrosAnio
			FROM CONSTANCIARETCTE
				WHERE Anio = Par_AnioProceso;
	END IF;

    -- 3.- Consulta de Clientes para generar la Constancia de Retencion
    IF(Par_NumCon = Con_CteConsRet)THEN
		 SELECT Con.ClienteID,		Cli.SucursalOrigen,		Cli.NombreCompleto
			FROM CONSTANCIARETCTE Con,
				 CLIENTES Cli
			WHERE Con.ClienteID = Cli.ClienteID
            AND Con.ClienteID = Par_ClienteID
            AND Con.Anio = Par_AnioProceso;
	END IF;

END TerminaStore$$