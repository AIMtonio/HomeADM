-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDOCUMENTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSDOCUMENTOSCON`;DELIMITER $$

CREATE PROCEDURE `TIPOSDOCUMENTOSCON`(


	Par_TipoDocumentoID	int,
	Par_NumCon			tinyint unsigned,

	Par_Salida          char(1),
    inout	Par_NumErr 	int,
    inout	Par_ErrMen 	varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN


DECLARE	Con_Descripcion		int;
DECLARE Con_DocsGarantia	int;
DECLARE TipoGarantia		char(1);
DECLARE Con_Principal		int(11);

Set	Con_Descripcion		:= 1;
Set Con_DocsGarantia	:= 2;
Set Con_Principal		:= 3;
Set TipoGarantia		:= 'G';



if(Par_NumCon = Con_Descripcion) then
	select	Descripcion
		from TIPOSDOCUMENTOS
		where  TipoDocumentoID = Par_TipoDocumentoID;
end if;

if(Par_NumCon = Con_DocsGarantia) then
	select TipoDocumentoID, Descripcion from TIPOSDOCUMENTOS
	where RequeridoEn like concat("%", TipoGarantia, "%");
end if;

if Par_NumCon = Con_Principal then
	select TipoDocumentoID,Descripcion,RequeridoEn,Estatus
		from TIPOSDOCUMENTOS
		where TipoDocumentoID = Par_TipoDocumentoID;
end if;

END TerminaStore$$