-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMXCONTRAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBLIMXCONTRAACT`;DELIMITER $$

CREATE PROCEDURE `TARDEBLIMXCONTRAACT`(
	Par_TipoTarjetaDebID            int(11),
    Par_DisposicionesDia            int,
    Par_MontoMaxDia                 decimal(12,2),
    Par_MontoMaxMes                 decimal(12,2),
    Par_MontoMaxCompraDia           decimal(12,2),

    Par_MontoMaxComprasMensual      decimal(12,2),
    Par_BloqueoATM                  char(2),
    Par_BloqueoPOS                  char(2),
    Par_BloqueoCashback             char(2),
    Par_OperacionesMOTO             char(2),

	Par_NumConsultaMes				int(11),

	Aud_EmpresaID					int,
	Aud_Usuario						int,
	Aud_FechaActual					DateTime,
	Aud_DireccionIP					varchar(15),
	Aud_ProgramaID					varchar(100),
	Aud_Sucursal		   			int,
	Aud_NumTransaccion				bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE Decimal_cero    	decimal(12,2);

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set Decimal_cero     	:=0.00;


if not exists(select TipoTarjetaDebID
			from TARDEBLIMITXCONTRA
			where TipoTarjetaDebID= Par_TipoTarjetaDebID) then
	select '001' as NumErr,
		 'Tipo de Tarjeta de Debito no tiene Limites.' as ErrMen,
		 'tipoTarjetaDebID' as control;
	LEAVE TerminaStore;
end if;
if(ifnull(Par_DisposicionesDia, Cadena_Vacia) = Cadena_Vacia) then
               select '002' as NumErr,
                'Especifique el Número de Disposiones al Dia' as ErrMen,
                'numeroDia' as control,
                Entero_Cero as consecutivo;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MontoMaxDia, Cadena_Vacia) = Cadena_Vacia) then
            select '003' as NumErr,
                'Especifique el Monto Max. al Dia' as ErrMen,
                'montoDisDia' as control,
                Entero_Cero as consecutivo;

        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MontoMaxMes, Cadena_Vacia) = Cadena_Vacia) then
             select '004' as NumErr,
                'Especifique el Monto de Max del Mes' as ErrMen,
                'montoDisMes' as control,
                Entero_Cero as consecutivo;
            LEAVE TerminaStore;
    end if;

    if(ifnull(Par_MontoMaxCompraDia, Cadena_Vacia) = Cadena_Vacia) then
              select '005' as NumErr,
                'Especifique la Monto Max. de Compra al Dia' as ErrMen,
                'montoComDia' as control,
                Entero_Cero as consecutivo;
        LEAVE TerminaStore;
    end if;
if(ifnull(Par_MontoMaxComprasMensual,Cadena_Vacia) = Cadena_Vacia) then
               select '006' as NumErr,
                'Especifique el Monto Max. Compras Mensual' as ErrMen,
                'montoComMes' as control,
                Entero_Cero as consecutivo;
        LEAVE TerminaStore;
    end if;

    if(ifnull(Par_BloqueoATM , Cadena_Vacia) = Cadena_Vacia) then
                   select '007' as NumErr,
                'Especifique Bloqueo  de ATM' as ErrMen,
                'bloqueoATM' as control,
                Entero_Cero as consecutivo;

        LEAVE TerminaStore;
    end if;
  if(ifnull(Par_BloqueoPOS , Cadena_Vacia ) = Cadena_Vacia) then
            select '008' as NumErr,
                'Especifique Bloqueo  de POS' as ErrMen,
                'bloqueoPOS' as control,
                Entero_Cero as consecutivo;
          LEAVE TerminaStore;

    end if;

    if(ifnull(Par_BloqueoCashback , Cadena_Vacia) = Cadena_Vacia) then
             select '009' as NumErr,
                'Especifique el Bloqueo Cashback' as ErrMen,
                'bloqueoCash' as control,
                Entero_Cero as consecutivo;
         LEAVE TerminaStore;
    end if;

    if(ifnull(Par_OperacionesMOTO , Cadena_Vacia) = Cadena_Vacia) then
                 select '010' as NumErr,
                'Especifique Operaciones MOTO' as ErrMen,
                'operacionMoto' as control,
                Entero_Cero as consecutivo;

        LEAVE TerminaStore;
    end if;


UPDATE TARDEBLIMITXCONTRA SET

    NoDisposiDia    = Par_DisposicionesDia,
	NumConsultaMes	= Par_NumConsultaMes,
    DisposiDiaNac   = Par_MontoMaxDia,
    DisposiMesNac   = Par_MontoMaxMes,
    ComprasDiaNac   = Par_MontoMaxCompraDia,
    ComprasMesNac   = Par_MontoMaxComprasMensual,
    BloquearATM     = Par_BloqueoATM,
    BloquearPOS     = Par_BloqueoPOS,
    BloquearCashBack= Par_BloqueoCashback,
    AceptaOpeMoto   = Par_OperacionesMOTO,

	EmpresaID		= Aud_EmpresaID,
	Usuario			= Aud_Usuario,
	FechaActual 	= Aud_FechaActual,
	DireccionIP 	= Aud_DireccionIP,
	ProgramaID  	= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion
where TipoTarjetaDebID = Par_TipoTarjetaDebID;

select '000' as NumErr ,
	  'Limite Modificado Correctamente' as ErrMen,
	  'tipoTarjetaDebID' as control,
      Entero_Cero as consecutivo;
END TerminaStore$$