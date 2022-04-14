-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMXCONTRAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBLIMXCONTRAALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBLIMXCONTRAALT`(
    Par_TipoTarjetaDebID            int(11),
	Par_ClienteID					int(11),
    Par_DisposicionesDia            int,
    Par_MontoMaxDia                 decimal(12,2),
    Par_MontoMaxMes                 decimal(12,2),

    Par_MontoMaxCompraDia           decimal(12,2),
    Par_MontoMaxComprasMensual      decimal(12,2),
    Par_BloqueoATM                  char(2),
    Par_BloqueoPOS                  char(2),
    Par_BloqueoCashback        			     char(2),

    Par_OperacionesMOTO             char(2),
	Par_NumConsultaMes				int(11),

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

-- declaracion de constantes
DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
DECLARE Decimal_cero    decimal(12,2);

-- asignacion de constantes
Set Entero_Cero     := 0;
Set Decimal_cero     :=0.00;
Set Cadena_Vacia    := '';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';



    if exists (SELECT TipoTarjetaDebID
                    FROM TIPOTARJETADEB
                    WHERE TipoTarjetaDebID = Par_TipoTarjetaDebID) then

    if(ifnull(Par_TipoTarjetaDebID, Entero_Cero) = Entero_Cero) then
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

 if(ifnull(Par_DisposicionesDia, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '002' as NumErr,
                'Especifique el Numero de Disposiones al Dia' as ErrMen,
                'numeroDia' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 2;
            set	Par_ErrMen :='Especifique el Numero de Disposiones al Dia';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MontoMaxDia, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '003' as NumErr,
                'Especifique el Monto Max. al Dia' as ErrMen,
                'montoDisDia' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 3;
            set	Par_ErrMen :='Especifique el Monto Max. al Dia';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MontoMaxMes, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '004' as NumErr,
                'Especifique el Motivo de Max del Mes' as ErrMen,
                'montoDisMes' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 4;
            set	Par_ErrMen :='Especifique el Motivo de Max del Mes';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MontoMaxCompraDia, Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '005' as NumErr,
                'Especifique la Monto Max. de Compra al Dia' as ErrMen,
                'montoComDia' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 5;
            set	Par_ErrMen :='Especifique la Monto Max. de Compra al Dia';
        end if;
        LEAVE TerminaStore;
    end if;
if(ifnull(Par_MontoMaxComprasMensual,Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '006' as NumErr,
                'Especifique el Monto Max. Compras Mensual' as ErrMen,
                'montoComMes' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 6;
            set	Par_ErrMen :='Especifique el Monto Max. Compras Mensual';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_BloqueoATM , Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '007' as NumErr,
                'Especifique Bloqueo  de ATM' as ErrMen,
                'bloqueoATM' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 7;
            set	Par_ErrMen :='Especifique Bloqueo  de ATM';
        end if;
        LEAVE TerminaStore;
    end if;
  if(ifnull(Par_BloqueoPOS , Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '008' as NumErr,
                'Especifique Bloqueo  de POS' as ErrMen,
                'BloqueoPOS' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 8;
            set	Par_ErrMen :='Especifique Bloqueo  de POS';
        end if;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_BloqueoCashback , Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '009' as NumErr,
                'Especifique el Bloqueo Cashback' as ErrMen,
                'bloqueoCash' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 9;
            set	Par_ErrMen :='Especifique el Bloqueo Cashback';
        end if;
        LEAVE TerminaStore;
    end if;


    if(ifnull(Par_OperacionesMOTO , Cadena_Vacia) = Cadena_Vacia) then
        if (Par_Salida = Salida_SI) then
            select '010' as NumErr,
                'Especifique Operaciones MOTO' as ErrMen,
                'operacionMoto' as control,
                Entero_Cero as consecutivo;
        else
            set	Par_NumErr := 10;
            set	Par_ErrMen :='Especifique Operaciones MOTO';
        end if;
        LEAVE TerminaStore;
    end if;

INSERT INTO `TARDEBLIMITXCONTRA`    VALUES(
	Par_TipoTarjetaDebID,		Par_ClienteID,				Par_DisposicionesDia,		Par_NumConsultaMes,
	Par_MontoMaxDia,			Par_MontoMaxMes,    		Par_MontoMaxCompraDia,		Par_MontoMaxComprasMensual,
	Par_BloqueoATM,				Par_BloqueoPOS,   			Par_BloqueoCashback,		Par_OperacionesMOTO,
	Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,
	Aud_ProgramaID,		     	Aud_Sucursal,			 	Aud_NumTransaccion);

if(Par_Salida =  Salida_SI) then
	select '00' as CodigoRespuesta,
			'Limite Agregado Correctamente.' as MensajeRespuesta,
			'tipoTarjetaDebID' as LimiteRegistrado,
			Entero_Cero as NumeroTransaccion;
else
	set Par_NumErr	:= 0;
	set Par_ErrMen	:= 'Limite Agregado Correctamente.';
end if;
LEAVE TerminaStore;
end if;

END TerminaStore$$