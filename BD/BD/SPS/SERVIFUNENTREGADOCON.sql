-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNENTREGADOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNENTREGADOCON`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNENTREGADOCON`(
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
	select	ServiFunEntregadoID,	ServiFunFolioID,	ClienteID,		NombreCompleto,	Estatus,
			format(CantidadEntregado,2) as CantidadEntregado,		NombreRecibePago,	TipoIdentiID,	FolioIdentific,	FechaEntrega,
			CajaID,					SucursalID
	FROM SERVIFUNENTREGADO
		where ServiFunFolioID = Par_ServiFunFolioID;

end if;

END TerminaStore$$