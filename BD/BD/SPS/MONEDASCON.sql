-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONEDASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONEDASCON`;DELIMITER $$

CREATE PROCEDURE `MONEDASCON`(
    Par_MonedaId            int,
    Par_NumCon          tinyint unsigned,

    Aud_EmpresaID           int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion  bigint
    )
TerminaStore: BEGIN

DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Principal       int;
DECLARE Con_Foranea     int;
DECLARE  Con_DivPcpal   int;


Set Cadena_Vacia            := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Con_Principal           := 1;
Set Con_Foranea         := 2;
Set Con_DivPcpal        := 3;



        if(Par_NumCon = Con_Principal) then
            select  `MonedaID`,     `EmpresaID`,    `Descripcion`,  `DescriCorta`,  `Simbolo`
            from         MONEDAS
            where    MonedaId = Par_MonedaId;
        end if;

        if(Par_NumCon = Con_Foranea) then
            select  `MonedaID`,     `Descripcion`
            from     MONEDAS
            where    MonedaId = Par_MonedaId;
        end if;

        if(Par_NumCon = Con_DivPcpal) then
            select  MonedaId,       Descripcion,        DescriCorta,        Simbolo,        TipCamComVen,
                    TipCamVenVen,   TipCamComInt,   TipCamVenInt,   TipoMoneda,         TipCamFixCom,
                    TipCamFixVen,   TipCamDof,      EqCNBVUIF,      EqBuroCred,     MonedaCNBV
            from    MONEDAS
            where   MonedaId = Par_MonedaId;
        end if;

END TerminaStore$$