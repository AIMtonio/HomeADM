-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOREQGASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOREQGASMOD`;DELIMITER $$

CREATE PROCEDURE `TESOREQGASMOD`(
    Par_RequisicionID   int,
    Par_TipoGastoID     int,
    Par_Descripcion     varchar(150),
    Par_Monto           decimal(12,2),
    Par_TipoPago        char(2),
    Par_NumCtaInstit    varchar(20),
    Par_CentroCostID    int,
    Par_FechaSolicit    Date,
    Par_CuentaAhoID     bigint(12),

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
	  Aud_ProgramaID      varchar(50),
	  Aud_Sucursal		    int,
	  Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(not exists(select RequisicionID
                    from TESOREQGAS
                    where RequisicionID = Par_RequisicionID)) then

      select '001' as NumErr,
            'La Requisicion no existe.' as ErrMen,
            'requisicionID' as control;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoGastoID,Entero_Cero)) = Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Tipo de Gasto esta Vacio.' as ErrMen,
		 'tipoGastosID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Monto, Entero_Cero)) = Entero_Cero then
	select '004' as NumErr,
		 'El Monto esta Vacio.' as ErrMen,
		 'monto' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CentroCostID, Entero_Cero)) = Entero_Cero then
	select '005' as NumErr,
		 'El Centro de Costos esta Vacio.' as ErrMen,
		 'centroCostos' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_FechaSolicit, Fecha_Vacia)) = Fecha_Vacia then
	select '006' as NumErr,
		 'La Fecha Solicitada esta Vacia.' as ErrMen,
		 'fechaSolicitada' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero then
	select '007' as NumErr,
		 'El Cuenta de Ahorro esta Vacio.' as ErrMen,
		 'cuentaAhorro' as control;
	LEAVE TerminaStore;
end if;

update TESOREQGAS set
    TipoGastoID     =   Par_TipoGastoID,
    Descripcion     =   Par_Descripcion,
    Monto           =   Par_Monto,
    CentroCostoID   =   Par_CentroCostID,
    FechaSolicitada =   Par_FechaSolicit,
    CuentaAhoID     =   Par_CuentaAhoID,
    TipoPago        =   Par_TipoPago,
    NumCtaInstit    =   Par_NumCtaInstit,
    EmpresaID       =   Aud_EmpresaID,
    Usuario         =   Aud_Usuario,
    FechaActual     =   Aud_FechaActual,
    DireccionIP     =   Aud_DireccionIP,
	  ProgramaID      =   Aud_ProgramaID,
	  Sucursal        =   Aud_Sucursal,
	  NumTransaccion   =   Aud_NumTransaccion
where  RequisicionID = Par_RequisicionID;

select '000' as NumErr ,
	  'Requisicion Gastos Modificado' as ErrMen,
	  'requisicionID' as control;

END TerminaStore$$