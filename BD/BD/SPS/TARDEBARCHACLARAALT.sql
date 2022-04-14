-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBARCHACLARAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBARCHACLARAALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBARCHACLARAALT`(
    Par_FolioID         varchar(22),
    Par_ReporteID       bigint(20),
    Par_TipoArchivo     varchar(200),
    Par_Recurso         varchar(250),
    Par_NombreArchivo		varchar(200),
    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(200),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN

DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(12,2);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE FechaSist       date;


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set Aud_FechaActual := CURRENT_TIMESTAMP();

set FechaSist := (Select FechaSistema from PARAMETROSSIS);

    if (ifnull(Par_FolioID, Cadena_Vacia) = Cadena_Vacia) then
        if(Par_Salida = SalidaSI)then
            SELECT '001' as NumErr,
                'Especifique el Folio' as ErrMen,
                'folioID' as control;
        else
            set Par_NumErr  := 1;
            set Par_ErrMen  := 'Especifique el Folio';
        end if;
        LEAVE TerminaStore;
    end if;
    if (ifnull(Par_TipoArchivo, Cadena_Vacia) = Cadena_Vacia) then
        if(Par_Salida = SalidaSI)then
            SELECT '002' as NumErr,
                'Seleccione un Archivo' as ErrMen,
                'tipoArchivo' as control;
        else
            set Par_NumErr  := 2;
            set Par_ErrMen  := 'Seleccione un Archivo';
        end if;
        LEAVE TerminaStore;
    end if;




    INSERT INTO TARDEBARCHACLARA (
        FolioID,    ReporteID,  TipoArchivo,    Recurso,        NombreArchivo,
        Fecha,      EmpresaID,  Usuario,        FechaActual,    DireccionIP,
        ProgramaID, Sucursal,   NumTransaccion)
    VALUES (
        Par_FolioID,    Par_ReporteID,      Par_TipoArchivo,    Par_Recurso,    Par_NombreArchivo,
        FechaSist,      Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

    set Par_NumErr  := 0;
    set Par_ErrMen  := 'Archivo adjuntado correctamente';

    if (Par_Salida = SalidaSI) then
        SELECT
            convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'folioID' as control;
    else
        set Par_NumErr  := 0;
        set Par_ErrMen  := 'Archivo adjuntado correctamente';
    end if;

END TerminaStore$$