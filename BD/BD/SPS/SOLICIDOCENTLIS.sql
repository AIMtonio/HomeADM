-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCENTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCENTLIS`;DELIMITER $$

CREATE PROCEDURE `SOLICIDOCENTLIS`(
	Par_Solicitud  BIGINT(20),
	Par_NumLis		tinyint unsigned
	)
TerminaStore: BEGIN

DECLARE     Con_Cadena_Vacia        char(1);
DECLARE     Con_Fecha_Vacia         datetime;
DECLARE     Con_Entero_Cero         int(11);
DECLARE     Con_Str_SI              char(1);
DECLARE     Con_Str_NO              char(1);
DECLARE     Lis_Principal           char(1);
DECLARE     Lis_SolDocEnt           char(1);
DECLARE     Lis_SolDocNoEnt         char(1);

Set	Con_Cadena_Vacia    := '';
Set	Con_Fecha_Vacia     := '1900-01-01';
Set	Con_Entero_Cero     := 0;
Set	Con_Str_SI          := 'S';
Set	Con_Str_NO          := 'N';
Set	Lis_Principal       := 1;
Set   Lis_SolDocEnt       := 2;
Set   Lis_SolDocNoEnt     := 3;



if(Par_NumLis = Lis_Principal) then

   SELECT   SolicitudCreditoID,     Sol.ProducCreditoID,    Sol.ClasificaTipDocID,     ClasificaDesc,  DocRecibido,
            Sol.TipoDocumentoID,    Doc.Descripcion,        Comentarios
   FROM SOLICIDOCENT Sol,
        CLASIFICATIPDOC Cla,
        TIPOSDOCUMENTOS Doc
   where SolicitudCreditoID = Par_Solicitud
     and Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
     and Sol.TipoDocumentoID = Doc.TipoDocumentoID;
end if;



if(Par_NumLis = Lis_SolDocEnt) then
   SELECT   SolicitudCreditoID,     Sol.ProducCreditoID,    Sol.ClasificaTipDocID,     ClasificaDesc,  DocRecibido,
            Sol.TipoDocumentoID,    Doc.Descripcion,        Comentarios
   FROM SOLICIDOCENT Sol,
        CLASIFICATIPDOC Cla,
        TIPOSDOCUMENTOS Doc
   where SolicitudCreditoID = Par_Solicitud
     and DocRecibido = Con_Str_NO
     and Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
     and Sol.TipoDocumentoID = Doc.TipoDocumentoID;
end if;


if(Par_NumLis = Lis_SolDocNoEnt) then
   SELECT   SolicitudCreditoID,     Sol.ProducCreditoID,    Sol.ClasificaTipDocID,     ClasificaDesc,  DocRecibido,
            Sol.TipoDocumentoID,    Doc.Descripcion,        Comentarios
   FROM SOLICIDOCENT Sol,
        CLASIFICATIPDOC Cla,
        TIPOSDOCUMENTOS Doc
   where SolicitudCreditoID = Par_Solicitud
     and DocRecibido = Con_Str_SI
     and Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
     and Sol.TipoDocumentoID = Doc.TipoDocumentoID;
end if;

END TerminaStore$$