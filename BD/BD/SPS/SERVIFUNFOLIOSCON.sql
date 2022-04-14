-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNFOLIOSCON`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNFOLIOSCON`(
	Par_ServiFunFolioID		int(11),
	Par_NumCon				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)


	)
TerminaStore:BEGIN




DECLARE Con_Principal	int;

set Con_Principal		:=1;


if(Con_Principal = Par_NumCon)then
	select ServiFunFolioID,		ClienteID,			TipoServicio,		FechaRegistro,		Estatus,
			DifunClienteID, 	DifunPrimerNombre,	DifunSegundoNombre, DifunTercerNombre,	DifunApePaterno,
			DifunApeMaterno, 	DifunFechaNacim,	DifunParentesco,	TramClienteID,		TramPrimerNombre,
			TramSegundoNombre,	TramTercerNombre,	TramApePaterno,		TramApeMaterno,		TramFechaNacim,
			TramParentesco,		NoCertificadoDefun,	FechaCertifDefun,	UsuarioAutoriza,	FechaAutoriza,
			UsuarioRechaza,		FechaRechazo,		MotivoRechazo,		MontoApoyo, DifunNombreComp
	from SERVIFUNFOLIOS
	where ServiFunFolioID = Par_ServiFunFolioID;
end if;

END TerminaStore$$