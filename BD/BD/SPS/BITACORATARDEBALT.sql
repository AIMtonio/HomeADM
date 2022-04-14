-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATARDEBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORATARDEBALT`;DELIMITER $$

CREATE PROCEDURE `BITACORATARDEBALT`(
    Par_TarjetaDebID    char(16),
    Par_TipoEvenTDID    int(11),
    Par_MotivoBloqID    int(11),
    Par_Descripcion     varchar(300),
    Par_Fecha           datetime,
    Par_NombreCliente   varchar(150),

    Par_Salida          char(1),
    inout Par_NumErr    int(11),
    inout Par_ErrMen    varchar(400),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN


DECLARE Entero_Cero     int(11);
DECLARE Cadena_Vacia    char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);


Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';

    if(ifnull(Par_TarjetaDebID, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '001' as NumErr,
                'Especifique el Numero de Tarjeta' as ErrMen,
                'numTarjeta' as control,
                0 as consecutivo;
        else
            set	Par_NumErr := 1;
            set	Par_ErrMen :='Especifique el Numero de Tarjeta';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_TipoEvenTDID, Entero_Cero ) = Entero_Cero) then
        if (Par_Salida = Salida_SI) then
            select '002' as NumErr,
                'Especifique el Tipo de Evento' as ErrMen,
                Cadena_Vacia as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 2;
            set	Par_ErrMen := 'Especifique el Tipo de Evento';
        end if;
        LEAVE TerminaStore;
    end if;

    INSERT INTO `BITACORATARDEB`
        VALUES(
        Par_TarjetaDebID,   Par_TipoEvenTDID,   Par_MotivoBloqID,   Par_Descripcion,    Par_Fecha,
        Par_NombreCliente,  Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

    if (Par_Salida = Salida_SI) then
        select '00' as NumErr,
            'Operacion Realizada Exitosamente' as ErrMen,
            Cadena_Vacia as control,
            Entero_Cero as consecutivo;
    else
        set	Par_NumErr := 0;
        set	Par_ErrMen :='Operacion Realizada Exitosamente';
    end if;
END TerminaStore$$