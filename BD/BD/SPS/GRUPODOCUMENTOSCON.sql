-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPODOCUMENTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPODOCUMENTOSCON`;DELIMITER $$

CREATE PROCEDURE `GRUPODOCUMENTOSCON`(
    Par_GrupoDocumentoID		int,
    Par_NumCon          		tinyint unsigned,

    Aud_EmpresaID       		int(11),
    Aud_Usuario         		int(11),
    Aud_FechaActual     		DateTime,
    Aud_DireccionIP     		varchar(15),
    Aud_ProgramaID      		varchar(50),
    Aud_Sucursal        		int(11),
    Aud_NumTransaccion  		bigint

)
TerminaStore: BEGIN

DECLARE Cadena_Vacia    		char(1);
DECLARE Fecha_Vacia     		date;
DECLARE Entero_Cero     		int(11);
DECLARE Con_Principal   		int(11);
DECLARE ConstanteSI				char(1);
DECLARE ConstanteNO				char(1);


Set Cadena_Vacia    			:= '';
Set Fecha_Vacia     			:= '1900-01-01';
Set Entero_Cero     			:= 0;
Set Con_Principal   			:= 1;
set ConstanteSI					:='S';
set ConstanteNO					:='N';

if(Par_NumCon = Con_Principal) then
	select distinct  G.GrupoDocumentoID,G.Descripcion,G.RequeridoEn,G.TipoPersona,
		   case  when ifnull(C.GrupoDocumentoID,Entero_Cero)>Entero_Cero then ConstanteSI else ConstanteNO end as EnUso
			from GRUPODOCUMENTOS G
			left join CHECLIST C on C.GrupoDocumentoID=G.GrupoDocumentoID
			where G.GrupoDocumentoID=Par_GrupoDocumentoID;
end if;
END TerminaStore$$