-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARARESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARARESACT`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARARESACT`(

    Par_ReporteID          int(11),
    Par_TarjetaDebID       char(16),
    Par_UsuarioResolucion  varchar(10),
    Par_EstatusResult       char(1),
    Par_DetalleResolucion  varchar(2000),

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
DECLARE Estatus_Alta    char(1);
DECLARE FechaActual     date;


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set Aud_FechaActual := CURRENT_TIMESTAMP();
Set FechaActual		 := (SELECT FechaSistema FROM PARAMETROSSIS where EmpresaID=1);

Set Estatus_Alta    := 'A';

    if exists (SELECT ReporteID
                    FROM TARDEBACLARACION
                    WHERE  ReporteID = Par_ReporteID) then

        if (ifnull(Par_UsuarioResolucion, Cadena_Vacia) = Cadena_Vacia) then
            if(Par_Salida = SalidaSI)then
                SELECT '001' as NumErr,
                    'Especifique el Usuario de Resolución' as ErrMen,
                    'claveID' as control,
                    Par_UsuarioResolucion as consecutivo;
            else
                set Par_NumErr  := 1;
                set Par_ErrMen  := 'Especifique el Usuario de Resolución';
            end if;
            LEAVE TerminaStore;
        end if;
        if (ifnull(Par_EstatusResult, Cadena_Vacia) = Cadena_Vacia) then
            if(Par_Salida = SalidaSI)then
                SELECT '002' as NumErr,
                    'Especifique el Estatus de Resolución' as ErrMen,
                    'estatusResult' as control,
                    Par_EstatusResult as consecutivo;
            else
                set Par_NumErr  := 2;
                set Par_ErrMen  := 'Especifique el Estatus de Resolución';
            end if;
            LEAVE TerminaStore;
        end if;
        if (ifnull(Par_DetalleResolucion, Cadena_Vacia) = Cadena_Vacia) then
            if(Par_Salida = SalidaSI)then
                SELECT '003' as NumErr,
                    'Especifique el Detalle de  Resolucion' as ErrMen,
                    'resuelto' as control,
                    Par_DetalleResolucion as consecutivo;
            else
                set Par_NumErr  := 3;
                set Par_ErrMen  := 'Especifique el Detalle de  Resolucion';
            end if;
            LEAVE TerminaStore;
        end if;

        UPDATE TARDEBACLARACION SET
            Estatus             = Par_EstatusResult,
            UsuarioResolucion   = Par_UsuarioResolucion,
            FechaResolucion     = FechaActual,
            DetalleResolucion   = Par_DetalleResolucion,

            EmpresaID           = Aud_EmpresaID,
            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,
            NumTransaccion      = Aud_NumTransaccion
        WHERE ReporteID = Par_ReporteID
			AND TarjetaDebID = Par_TarjetaDebID;

        if (Par_Salida = SalidaSI) then
            SELECT
                '00' as NumErr,
                'Actualización realizada correctamente' as ErrMen,
                'reporteID' as control,
                Par_ReporteID as consecutivo;
        else
            set Par_NumErr  := 0;
            set Par_ErrMen  := 'Actualización realizada correctamente';
        end if;
       else
        if (Par_Salida = SalidaSI) then
            SELECT
                '04' as NumErr,
                'El Numero de Reporte no Existe' as ErrMen,
                'reporteID' as control,
               Par_ReporteID as consecutivo;
        else
            set Par_NumErr  := 4;
            set Par_ErrMen  := 'El Numero de Reporte no Existe';
        end if;

        LEAVE TerminaStore;
    end if;


END TerminaStore$$