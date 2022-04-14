-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOREQGASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOREQGASALT`;DELIMITER $$

CREATE PROCEDURE `TESOREQGASALT`(
    Par_SucursalID      int,
    Par_UsuarioID       integer,
    Par_TipoGastoID     int,
    Par_Descripcion     varchar(150),
    Par_Monto           decimal(12,2),
    Par_TipoPago        char(2),
    Par_NumCtaInstit    varchar(20),
    Par_CentroCostID    int,
    Par_FechaAlta       Date,
    Par_FechaSolicit    Date,
    Par_CuentaAhoID     bigint,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
	  Aud_ProgramaID      varchar(50),
	  Aud_Sucursal		    int,
	  Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

DECLARE  NumRequisicion int;
DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE  Par_UsuarioAuto     integer;
DECLARE  Par_UsuarioProc     integer;

Set	Estatus_Activo	:= 'N';
Set	Cadena_Vacia	    := '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
set Par_UsuarioAuto := 0;
set Par_UsuarioProc :=0;
Set NumRequisicion:= 0;

Set NumRequisicion := (select ifnull(Max(RequisicionID),Entero_Cero) + 1 from TESOREQGAS);

if(ifnull(NumRequisicion,Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Numero de Requisicion esta Vacio.' as ErrMen,
		 'requisicionID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_SucursalID,Entero_Cero)) = Entero_Cero then
	select '002' as NumErr,
		 'El Numero de Sucursal esta Vacio.' as ErrMen,
		 'sucursalID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_UsuarioID,Entero_Cero)) = Entero_Cero then
	select '003' as NumErr,
		 'El Numero de Usuario esta Vacio.' as ErrMen,
		 'UsuarioID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoGastoID,Entero_Cero)) = Entero_Cero then
	select '004' as NumErr,
		 'El Numero de Tipo de Gasto esta Vacio.' as ErrMen,
		 'tipoGastosID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '005' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Monto, Entero_Cero)) = Entero_Cero then
	select '006' as NumErr,
		 'El Monto esta Vacio.' as ErrMen,
		 'monto' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CentroCostID, Entero_Cero)) = Entero_Cero then
	select '007' as NumErr,
		 'El Centro de Costos esta Vacio.' as ErrMen,
		 'centroCostos' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_FechaAlta, Fecha_Vacia)) = Fecha_Vacia then
	select '008' as NumErr,
		 'La Fecha de Alta esta Vacia.' as ErrMen,
		 'fechaAlta' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_FechaSolicit, Fecha_Vacia)) = Fecha_Vacia then
	select '009' as NumErr,
		 'La Fecha Solicitada esta Vacia.' as ErrMen,
		 'fechaSolicitada' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CuentaAhoID, Entero_Cero)) = Entero_Cero then
	select '010' as NumErr,
		 'El Cuenta de Ahorro esta Vacio.' as ErrMen,
		 'cuentaAhorro' as control;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();


insert into TESOREQGAS values
            (NumRequisicion,    Par_SucursalID,   Par_UsuarioID,  Par_TipoGastoID,    Par_Descripcion,
             Par_Monto,         Par_TipoPago ,    Par_NumCtaInstit , Par_CentroCostID, Par_FechaAlta,  Par_FechaSolicit,   Par_CuentaAhoID,
             Par_UsuarioAuto,   Par_UsuarioProc,  Estatus_Activo, Aud_EmpresaID,      Aud_Usuario,
             Aud_FechaActual,	  Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,	      Aud_NumTransaccion);


select '000' as NumErr,
	  concat("Requisicion de Gastos Agregado: ", convert(NumRequisicion, CHAR))  as ErrMen,
	  'requisicionID	' as control;

END TerminaStore$$