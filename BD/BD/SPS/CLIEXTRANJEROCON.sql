-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIEXTRANJEROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIEXTRANJEROCON`;DELIMITER $$

CREATE PROCEDURE `CLIEXTRANJEROCON`(
    Par_ClienteID       int(11),
    Par_NumCon          tinyint unsigned,

    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
    )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Principal   int;
DECLARE Con_Foranea     int;


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Con_Principal       := 1;
Set Con_Foranea         := 2;

if(Par_NumCon = Con_Principal) then
   Select   ClienteID,      Inmigrado,      DocumentoLegal,     MotivoEstancia,     FechaVencimien,
            Entidad,        Localidad,      Colonia,            Calle,              NumeroCasa,
            NumeroIntCasa,  Adi_CoPoEx,     PaisRFC
    from CLIEXTRANJERO
    where ClienteID = Par_ClienteID;
end if;


if(Par_NumCon = Con_Foranea) then
    Select ClienteID,DocumentoLegal
    from CLIEXTRANJERO
    where ClienteID = Par_ClienteID;
end if;

END TerminaStore$$