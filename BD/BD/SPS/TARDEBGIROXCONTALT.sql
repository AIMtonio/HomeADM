-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROXCONTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROXCONTALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROXCONTALT`(
    Par_TipoTarjetaID	char(16),
    Par_ClienteID     char(12),
    Par_GiroID			char(4),

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);


Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';

  if exists (SELECT TipoTarjetaDebID
                    FROM TIPOTARJETADEB
                    WHERE TipoTarjetaDebID = Par_TipoTarjetaID) then

        if(ifnull(Par_TipoTarjetaID, Cadena_Vacia) = Cadena_Vacia) then
            if (Par_Salida = Salida_SI) then
                select '001' as NumErr,
                    'Especifique el Tipo de Tarjeta' as ErrMen,
                    'tipoTarjetaDebID' as control,
                    Entero_Cero as consecutivo;
            else
                set	Par_NumErr := 1;
                set	Par_ErrMen :='Especifique el Tipo de Tarjeta';
            end if;
            LEAVE TerminaStore;
        end if;
        if(ifnull(Par_ClienteID, Cadena_Vacia) = Cadena_Vacia) then
            if (Par_Salida = Salida_SI) then
                select '002' as NumErr,
                    'Especifique el Cliente Corporativo' as ErrMen,
                    'coorporativo' as control,
                    coorporativo as consecutivo;
            else
                set	Par_NumErr := 2;
                set	Par_ErrMen :='Especifique el Cliente Corporativo';
            end if;
            LEAVE TerminaStore;
        end if;
        if(ifnull(Par_GiroID, Cadena_Vacia) = Cadena_Vacia) then
            if (Par_Salida = Salida_SI) then
                select '003' as NumErr,
                    'Especifique el N??mero del Giro' as ErrMen,
                    'giroID' as control,
                    Par_GiroID as consecutivo;
            else
                set	Par_NumErr := 3;
                set	Par_ErrMen :='Especifique el N??mero del Giro';
            end if;
            LEAVE TerminaStore;
        end if;

    INSERT INTO `TARDEBGIROTIPOCONT`
    VALUES(
        Par_TipoTarjetaID,		Par_ClienteID,   Par_GiroID	,	      	Aud_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,         Aud_Sucursal,
		Aud_NumTransaccion );

    if(Par_Salida =  Salida_SI) then
        SELECT '00' as CodigoRespuesta,
            'Giro(s) Agregado(s) Exitosamente.' as MensajeRespuesta,
            'tipoTarjetaDebID' as GiroRegistrado,
            Par_TipoTarjetaID as NumeroTransaccion;
    else
        Set Par_NumErr  := 0;
        Set Par_ErrMen  := 'Giros Agregados Correctamente.';
    end if;
	LEAVE TerminaStore;
end if;

END TerminaStore$$