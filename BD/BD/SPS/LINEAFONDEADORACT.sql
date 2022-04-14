-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADORACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEAFONDEADORACT`;DELIMITER $$

CREATE PROCEDURE `LINEAFONDEADORACT`(

    Par_LineaFondeoID		   int(11),
    Par_InstitutFondID		int(11),
    Par_FechaInicLinea      date,
    Par_FechaFinLinea       date,
    Par_FechaMaxVenci       date,
    Par_MontoAumentar       decimal(12,2),


    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN


DECLARE Var_FechInicLinea             date;
DECLARE Var_FechaFinLinea             date;
DECLARE Var_FechaMaxVenci             date;
DECLARE Var_MontoOtorgado            decimal(12,2);
DECLARE Var_SaldoLinea               decimal(12,2);
DECLARE Var_sumaMontoAumentar        decimal(12,2);
DECLARE Var_sumaSaladoLinea          decimal(12,2);
DECLARE Var_Descripcion	            varchar(100);
DECLARE Var_PolizaID	               bigint;

DECLARE monedaPesos		   int(11);
DECLARE Var_CtaOrdCar	      int(11);
DECLARE Var_CtaOrdAbo	      int(11);
DECLARE Par_Consecutivo	   bigint;


DECLARE Act_CondiLinea  int;
DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Var_SI          char(1);
DECLARE Var_NO          char(1);
DECLARE Var_ConcepCon   int(11);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
DECLARE FechaActual     date;
DECLARE Var_AfectaConta char(1);
DECLARE Tip_Fondeo      char(1);


Set Entero_Cero         := 0;
Set Cadena_Vacia        := '';
set Act_CondiLinea      := 1;
set Var_MontoOtorgado   := 0.0;
set Var_SaldoLinea      := 0.0;
Set Var_PolizaID        := 0;
Set Var_Descripcion     := 'INCREMENTO DE LÍNEA DE FONDEO';

set monedaPesos         := 1;
set Var_CtaOrdCar       := 11;
set Var_CtaOrdAbo       := 12;
Set Var_SI              := 'S';
Set Var_NO              := 'N';
Set Var_ConcepCon       := 24;
set Nat_Cargo           := 'C';
set Nat_Abono           := 'A';
set Salida_SI           := 'S';
set Salida_NO           := 'N';
Set Tip_Fondeo          := 'F';
Set Par_Consecutivo     := 0;


Set FechaActual		           := (SELECT FechaSistema FROM PARAMETROSSIS where EmpresaID=1);


select  FechInicLinea,		   FechaFinLinea,	      FechaMaxVenci,          AfectacionConta
    into   Var_FechInicLinea,		Var_FechaFinLinea,  	Var_FechaMaxVenci,      Var_AfectaConta
    from 	LINEAFONDEADOR
    where LineaFondeoID     = Par_LineaFondeoID
      and InstitutFondID    = Par_InstitutFondID;


if (Par_FechaInicLinea < Var_FechInicLinea) then
    if(Par_Salida = Salida_SI )then
        SELECT '001' as NumErr,
            concat("La Fecha Inicio: ",cast(Par_FechaInicLinea as char), " no puede ser menor a la anterior. Verifique la Fecha Inicio.")  as ErrMen,
            'fechInicLinea' as control,
            Par_LineaFondeoID as consecutivo;
    else
        set Par_NumErr	:= 1;
        set Par_ErrMen := concat("La Fecha Inicio: ",cast(Par_FechaInicLinea as char), " no puede ser menor a la anterior. Verifique la Fecha Inicio.");

    end if;
    LEAVE TerminaStore;
end if;

if (Par_FechaFinLinea < Var_FechaFinLinea) then
    if(Par_Salida = Salida_SI )then
        SELECT '002' as NumErr,
            concat("La Fecha Fin: ",cast(Par_FechaFinLinea as char), " no puede ser menor a la anterior. Verifique la Fecha Fin.")  as ErrMen,
            'fechaFinLinea' as control,
            Par_LineaFondeoID as consecutivo;
    else
        set Par_NumErr	:= 2;
        set Par_ErrMen := concat("La Fecha Fin: ",cast(Par_FechaFinLinea as char), " no puede ser menor a la anterior. Verifique la Fecha Fin.");

    end if;
    LEAVE TerminaStore;
end if;

if (Par_FechaMaxVenci < Var_FechaMaxVenci) then
    if(Par_Salida = Salida_SI )then
        SELECT '003' as NumErr,
            concat("La Fecha Vencimiento: ",cast(Par_FechaMaxVenci as char), " no puede ser menor a la anterior. Verifique la Fecha Vencimiento.")  as ErrMen,
            'fechaMaxVenci' as control,
            Par_LineaFondeoID as consecutivo;
    else
        set Par_NumErr	:= 3;
        set Par_ErrMen := concat("La Fecha Vencimiento: ",cast(Par_FechaInicLinea as char), " no puede ser menor a la anterior. Verifique la Fecha Vencimiento.");

    end if;
    LEAVE TerminaStore;
end if;

if (Par_FechaFinLinea <= Par_FechaInicLinea  ) then
    if(Par_Salida = Salida_SI )then
        SELECT '004' as NumErr,
            concat("La Fecha Inicio: ",cast(Par_FechaInicLinea as char), " es mayor a Fecha Fin. Verifique la Fecha Fin.")  as ErrMen,
            'fechaFincLinea' as control,
            Par_LineaFondeoID as consecutivo;
    else
        set Par_NumErr	:= 4;
        set Par_ErrMen := concat("La Fecha Inicio: ",cast(Par_FechaInicLinea as char), " es mayor a Fecha Fin. Verifique la Fecha Fin.");

    end if;
    LEAVE TerminaStore;
end if;

if (Par_FechaMaxVenci < Par_FechaFinLinea  ) then
    if(Par_Salida = Salida_SI )then
        SELECT '005' as NumErr,
            concat("La Fecha Fin: ",cast(Par_FechaFinLinea as char), " es mayor a la Fecha Vencimiento")  as ErrMen,
            'fechaInicLinea' as control,
            Par_LineaFondeoID as consecutivo;
    else
        set Par_NumErr	:= 5;
        set Par_ErrMen := concat("La Fecha Fin: ",cast(Par_FechaFinLinea as char), " es mayor a la Fecha Vencimiento");

    end if;
    LEAVE TerminaStore;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

update	LINEAFONDEADOR set

    FechInicLinea = Par_FechaInicLinea,
    FechaFinLinea  =  Par_FechaFinLinea,
    FechaMaxVenci  = Par_FechaMaxVenci,
    MontoOtorgado  = MontoOtorgado+Par_MontoAumentar,
    SaldoLinea     =  SaldoLinea+Par_MontoAumentar,

    EmpresaID		= 	Par_EmpresaID,
    Usuario			= 	Aud_Usuario,
    FechaActual 	= 	Aud_FechaActual,
    DireccionIP 	= 	Aud_DireccionIP,
    ProgramaID  	= 	Aud_ProgramaID,
    Sucursal		= 	Aud_Sucursal,
    NumTransaccion	= 	Aud_NumTransaccion
    where LineaFondeoID     = 	Par_LineaFondeoID
      and InstitutFondID    = Par_InstitutFondID;


if(Par_MontoAumentar > Entero_Cero and Var_AfectaConta = Var_SI) then

    call CONTAFONDEOPRO(
        monedaPesos,        Par_LineaFondeoID,  Par_InstitutFondID,     Entero_cero,
        Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,           Entero_Cero,
        Cadena_Vacia,       Var_CtaOrdCar,      Var_Descripcion,        FechaActual,
        FechaActual,        FechaActual,        Par_MontoAumentar,
        convert(Par_LineaFondeoID,char),    convert(Par_LineaFondeoID,char),
        Var_SI,             Var_ConcepCon,      Nat_Cargo,              Nat_Cargo,
        Nat_Cargo,          Nat_Cargo,          Var_NO,                 Cadena_Vacia,
        Var_NO,             Entero_Cero,        Entero_Cero,            Var_SI,
        Tip_Fondeo,         Salida_NO,          Var_PolizaID,           Par_Consecutivo,
        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion  );

    if(Par_NumErr != Entero_Cero) then
        if (Par_Salida = Par_SalidaSI) then
            select 	Par_NumErr as NumErr,
                    Par_ErrMen as ErrMen,
                    'creditoFondeoID' as control,
                    0 as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;

    call CONTAFONDEOPRO(
        monedaPesos,        Par_LineaFondeoID,  Par_InstitutFondID, Entero_cero,
        Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,       Entero_Cero,
        Cadena_Vacia,       Var_CtaOrdAbo,      Var_Descripcion,    FechaActual,
        FechaActual,        FechaActual,        Par_MontoAumentar,
        convert(Par_LineaFondeoID,char),    convert(Par_LineaFondeoID,char),
        Var_NO,             Var_ConcepCon,      Nat_Abono,          Nat_Abono,
        Nat_Abono,          Nat_Abono,          Var_NO,             Cadena_Vacia,
        Var_NO,             Entero_Cero,        Entero_Cero,        Var_SI,
        Tip_Fondeo,         Salida_NO,          Var_PolizaID,       Par_Consecutivo,
        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion  );

    if(Par_NumErr != Entero_Cero) then
        if (Par_Salida = Par_SalidaSI) then
                select 	Par_NumErr as NumErr,
                        Par_ErrMen as ErrMen,
                        'creditoFondeoID' as control,
                        0 as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;
end if;

if (Par_Salida = Salida_SI) then
    select 	'000' as NumErr,
            concat("Condiciones de línea de Fondeo Modificadas ")  as ErrMen,
            'InstitutFondID' as control,
            Par_LineaFondeoID as Consecutivo,
            Var_PolizaID;
else
    Set Par_NumErr:=	0;
    Set Par_ErrMen:=	concat("Linea de Fondeo Agregada: ", convert(Par_LineaFondeoID, CHAR));
 end if;

END TerminaStore$$