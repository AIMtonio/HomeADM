-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASFIRMACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASFIRMACON`;DELIMITER $$

CREATE PROCEDURE `CUENTASFIRMACON`(
	Par_CuentaAhoID			bigint(12),
	Par_PersonaID			int(11),
	Par_NumCon				tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
			)
TerminaStore: BEGIN

DECLARE	Con_Principal		int;
DECLARE Con_FirmantesAut 	int;
DECLARE Estatus_Vigente		char(1);

Set	Con_Principal			:= 1;
set Con_FirmantesAut		:= 2;
Set Estatus_Vigente			:= 'V';

	if(Par_NumCon = Con_Principal) then
		select	CF.CuentaFirmaID, 	CF.CuentaAhoID,		CF.PersonaID,		CF.NombreCompleto,
				CF.Tipo, 			CF.InstrucEspecial
		from  CUENTASAHO CA,
			CUENTASFIRMA CF
		where  CA.CuentaAhoID 	= Par_CuentaAhoID
		and	 CA.CuentaAhoID	= CF.CuentaAhoID;
	end if;

	if (Par_NumCon=Con_FirmantesAut) then




select	CF.CuentaFirmaID,CF.PersonaID,	CF.NombreCompleto,CP.ClienteID,ifnull(CP.EsFirmante,"N")
			from  CUENTASAHO CA,
				CUENTASFIRMA CF
				INNER JOIN  CUENTASPERSONA CP on CP.CuentaAhoID=CF.CuentaAhoID and CP.PersonaID=CF.PersonaID and CP.EstatusRelacion = Estatus_Vigente
			where  CA.CuentaAhoID 		= Par_CuentaAhoID
			and  CF.CuentaFirmaID		= Par_PersonaID
			and	 CA.CuentaAhoID			= CF.CuentaAhoID;
	end if;

END TerminaStore$$