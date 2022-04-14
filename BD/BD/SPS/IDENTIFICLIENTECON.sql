-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICLIENTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICLIENTECON`;DELIMITER $$

CREATE PROCEDURE `IDENTIFICLIENTECON`(

  Par_ClienteID   int,
  Par_IdentifiID    int,
  Par_TipoIdentiID  int,
  Par_NumCon      tinyint unsigned,
  Par_EmpresaID   int,

  Aud_Usuario     int,
  Aud_FechaActual   DateTime,
  Aud_DireccionIP   varchar(15),
  Aud_ProgramaID    varchar(50),
  Aud_Sucursal    int,
  Aud_NumTransaccion  bigint
)
TerminaStore: BEGIN


DECLARE Cadena_Vacia  char(1);
DECLARE Fecha_Vacia   date;
DECLARE Entero_Cero   int;
DECLARE Con_Principal int;
DECLARE Con_Foranea   int;
DECLARE Con_Oficial   int;
DECLARE Var_Oficial   char(1);
DECLARE  Con_verOficial int;
DECLARE  Var_noOficial char(1);
DECLARE  Descrip varchar(45);
DECLARE  IdentID int(11);
DECLARE  Con_TieneIdent int;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_Principal   := 1;
Set Con_Foranea     := 2;
Set Con_Oficial     := 3;
Set Con_TieneIdent    := 4;
Set Var_Oficial     := 'S';
set Var_noOficial   := 'N';

if(Par_NumCon = Con_Principal) then
  select  ClienteID,  IdentificID,    TipoIdentiID,
      Descripcion,  Oficial,      NumIdentific,
      ifnull(FecExIden,Fecha_Vacia) as FecExIden,
      ifnull(FecVenIden, Fecha_Vacia) as FecVenIden
  from    IDENTIFICLIENTE
  where   ClienteID = Par_ClienteID
  and   IdentificID = Par_IdentifiID;
end if;

if(Par_NumCon = Con_Foranea) then
  select  IdentificID,    TipoIdentiID
  from    IDENTIFICLIENTE
  where   ClienteID = Par_ClienteID
  and   IdentificID = Par_IdentifiID;
end if;

if(Par_NumCon = Con_Oficial) then
  select  IdentificID, TipoIdentiID, ClienteID, Oficial,
    NumIdentific,ifnull(FecExIden,Fecha_Vacia) as FecExIden,
      ifnull(FecVenIden, Fecha_Vacia) as FecVenIden
  from    IDENTIFICLIENTE
  where   ClienteID = Par_ClienteID
  and   Oficial = Var_Oficial
  limit 0,1;
end if;


if(Par_NumCon = Con_TieneIdent)then
  select  ClienteID,  IdentificID,  TipoIdentiID, NumIdentific
  from    IDENTIFICLIENTE
  where ClienteID = Par_ClienteID
  and   TipoIdentiID = Par_TipoIdentiID;
end if;


END TerminaStore$$