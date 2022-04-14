-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTECON`;
DELIMITER $$


CREATE PROCEDURE `EDOCTADATOSCTECON`(
	Par_FechaProceso 		varchar(15),
	Par_SucursalInicio		int(11),
	Par_SucursalFin			int(11),
    Par_Productos			VARCHAR(100),
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint
	)

TerminaStore:BEGIN



DECLARE Con_Principal		int(11);
DECLARE Con_Foranea			int(11);


set Con_Principal		:=1;
set Con_Foranea			:=2;

	if (Par_NumCon = Con_Principal)then
		SELECT Count(ClienteID) as NumRegistros
			FROM EDOCTADATOSCTE
				WHERE AnioMes = Par_FechaProceso
				AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;
	end if;
   
    if (Par_NumCon = Con_Foranea)then
		SET Par_Productos := REPLACE(Par_Productos,"'","");
		SELECT Count(ClienteID) as NumRegistros
			FROM EDOCTADATOSCTE
				WHERE AnioMes = Par_FechaProceso
				AND ProductoCredID IN (Par_Productos);
	end if;

END TerminaStore$$