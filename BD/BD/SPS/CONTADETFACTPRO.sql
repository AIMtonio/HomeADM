-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTADETFACTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTADETFACTPRO`;DELIMITER $$

CREATE PROCEDURE `CONTADETFACTPRO`(
    Par_ProveedorID     int,
    Par_NoFactura       varchar(20),
    Par_TipoGasto       int,
    Par_Descripc        varchar(50),
    Par_Poliza          bigint,
    Par_Fecha           datetime,
    Par_Monto           decimal(14,2),
    Par_TipoRegis       char(1),
    Par_CenCosto		int,

    Par_Salida          char(1),
	inout Par_NumErr    int,
	inout Par_ErrMen    varchar(400),

    Par_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
)
TerminaStore: BEGIN


DECLARE Var_CueGasto    char(25);
DECLARE Var_Instrumento varchar(15);
DECLARE Mon_Base        int;
DECLARE Var_Cargos      decimal(14,2);
DECLARE Var_Abonos      decimal(14,2);
DECLARE Var_Referencia  varchar(50);
DECLARE Var_Control     varchar(100);


DECLARE Entero_Cero    int;
DECLARE Decimal_Cero   decimal(12,2);
DECLARE Cadena_Vacia   char(1);
DECLARE Fecha_Vacia    date;
DECLARE SalidaNO       char(1);
DECLARE SalidaSI       char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Salida_NO       char(1);
DECLARE Cuenta_Vacia    varchar(25);
DECLARE Procedimiento   varchar(20);
DECLARE Tipo_RegFact    char(1);
DECLARE Tipo_PagFact    char(1);
DECLARE Tipo_CanFact    char(1);
DECLARE TipoInstrumentoID	int(11);
DECLARE Var_NumCheque    int(11);
DECLARE Var_FolioUUID		varchar(100);
DECLARE Var_RFC			varchar(30);
DECLARE Var_TipoPersona	char(1);



Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Salida_NO       := 'N';
Set Cuenta_Vacia    := '0000000000000000000000000';
Set Procedimiento   := 'CONTADETFACTPRO';
Set Tipo_RegFact    := 'R';
Set Tipo_PagFact    := 'P';
Set Tipo_CanFact    := 'C';
Set TipoInstrumentoID	:= 6;




select CuentaCompleta into Var_CueGasto
    from TESOCATTIPGAS
    where TipoGastoID = Par_TipoGasto;

set Var_CueGasto = ifnull(Var_CueGasto, Cuenta_Vacia);

select MonedaBaseID into Mon_Base
    from PARAMETROSSIS;

 set Var_Instrumento := convert(Par_ProveedorID, char);


if (Par_NoFactura  != Cadena_Vacia) then
    set Var_Referencia  := Par_NoFactura;
else
 set Var_Referencia  := convert(Par_TipoGasto, char);

end if;

if (Par_Monto > Entero_Cero) then

    if (Par_TipoRegis = Tipo_RegFact) then
        set Var_Cargos  := Par_Monto;
        set Var_Abonos  := Decimal_Cero;
    elseif (Par_TipoRegis = Tipo_CanFact) then
        set Var_Cargos  := Decimal_Cero;
        set Var_Abonos  := Par_Monto;
    elseif (Par_TipoRegis = Tipo_PagFact) then
        set Var_Cargos  := Par_Monto;
        set Var_Abonos  := Decimal_Cero;

    end if;
select FolioUUID into Var_FolioUUID from FACTURAPROV where ProveedorID=Par_ProveedorID and NoFactura = Par_NoFactura;

select CASE TipoPersona WHEN 'M' THEN RFCpm else RFC END
  into Var_RFC
  from PROVEEDORES
 where ProveedorID = Par_ProveedorID;

    CALL DETALLEPOLIZAALT (
        Par_EmpresaID,      Par_Poliza,     Par_Fecha,      	Par_CenCosto,   Var_CueGasto,
        Var_Instrumento,    Mon_Base,       Var_Cargos,			Var_Abonos,     Par_Descripc,
        Var_Referencia,     Procedimiento,  TipoInstrumentoID,	Var_RFC,   Decimal_Cero,
		Var_FolioUUID,		Salida_NO,      Par_NumErr,     	Par_ErrMen, 	Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion);


end if;

if(Par_Salida = SalidaSI) then
    select '000' as NumErr,
            'Contabilidad Registrada' as ErrMen,
            'facturaProvID' as control,
             Par_Poliza as consecutivo;
end if;
if(Par_Salida = SalidaNO) then
    set 	Par_NumErr := 0;
    set	Par_ErrMen := 'Contabilidad Registrada';
end if;
END TerminaStore$$