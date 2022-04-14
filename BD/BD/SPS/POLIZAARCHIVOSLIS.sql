-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAARCHIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `POLIZAARCHIVOSLIS`(
	Par_PolizaArchivosID	int(11),
	Par_PolizaID			int(20),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		Bigint(20)

	)
TerminaStore:BEGIN

DECLARE	Entero_Cero			int;
DECLARE	Lis_Principal 		int;
DECLARE	Lis_PorPoliza		int;


Set	Entero_Cero			:= 0;
Set	Lis_PorPoliza		:= 2;
set Lis_Principal		:= 1;


if(Par_NumLis = Lis_Principal) then
	select PolizaArchivosID,		PolizaID,		ArchivoPolID,		TipoDocumento,		Observacion,
			Recurso
		from POLIZAARCHIVOS
		where  PolizaArchivosID = Par_PolizaArchivosID
		limit 0, 15;
end if;


if(Par_NumLis = Lis_PorPoliza) then
	select 	PolizaArchivosID,		PolizaID,		ArchivoPolID,		TipoDocumento,		Observacion,
				Recurso
		from POLIZAARCHIVOS
		where  PolizaID = ifnull(Par_PolizaID,Entero_Cero);
end if;

END TerminaStore$$