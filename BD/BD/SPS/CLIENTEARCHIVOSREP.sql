-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEARCHIVOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEARCHIVOSREP`;DELIMITER $$

CREATE PROCEDURE `CLIENTEARCHIVOSREP`(
	Par_ClienteID		int,
	Par_ProspectoID		int,
	Par_NumRep			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Rep_CliArc	int;
DECLARE	Entero_Cero	int;


Set Rep_CliArc		:= 1;
Set	Entero_Cero		:= 0;

if(Par_NumRep = Rep_CliArc) then
	select	ClienteID,			TipoDocumento,	TI.Descripcion,	Consecutivo,		Observacion,
			Recurso
		from		CLIENTEARCHIVOS,
					TIPOSDOCUMENTOS TI
		where		ClienteID = ifnull(Par_ClienteID,Entero_Cero )
		and  ProspectoID = ifnull(Par_ProspectoID ,Entero_Cero )
		and  TipoDocumento = TI.TipoDocumentoID ;
end if;

END TerminaStore$$