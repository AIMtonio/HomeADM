-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTACONTACAJAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTACONTACAJAVAL`;DELIMITER $$

CREATE PROCEDURE `CUENTACONTACAJAVAL`(
    Par_SucursalID          int(11),
    Par_CajaID              int(11),
    Par_Salida              char(1),
    inout Par_NumErr        int(11),
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint      )
TerminaStore: BEGIN

DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int(11);
DECLARE For_CueMayor    varchar(3);
DECLARE For_Moneda      varchar(3);
DECLARE For_Tipo        varchar(3);
DECLARE For_TipoCaja    varchar(3);
DECLARE For_Cajero      varchar(3);
DECLARE For_Sucursal    varchar(3);
DECLARE ConceptoMonIDiv int(5);
DECLARE MonedaPesos     int(5);
DECLARE Salida_NO       char(1);
DECLARE SubCtaXCaja     varchar(3);
DECLARE ConceptoMonAper int(5);
DECLARE AportaSocial    int(5);
DECLARE SeguroVidaAyu   int(5);
DECLARE PagoOportuni    int(5);
DECLARE CancelaSocioMen int(5);
DECLARE InstitCajasAho  int(5);
DECLARE Cadena_Si       char(1);
DECLARE NumCtas         int(5);

DECLARE Var_Nomenclatura    varchar(60);
DECLARE Var_CuentaMa        varchar(25);
DECLARE Var_SubCuentaMon    varchar(15);
DECLARE Var_Billetes        varchar(15);
DECLARE Var_Monedas         varchar(15);
DECLARE Var_SubCuentaSuc    varchar(15);
DECLARE Var_SubCuentaTipoCa varchar(15);
DECLARE Var_SubCuentaCaja   varchar(15);
DECLARE Var_TipoCaja        varchar(2);
DECLARE Var_NomenclaturaMon varchar(60);
DECLARE Var_Control         varchar(150);
DECLARE Var_Numero          int(11);
DECLARE Var_ControlParam    int(11);
DECLARE Var_Cuenta          varchar(12);
DECLARE Var_NomenclaturaCR  varchar(30);
DECLARE Var_InstitucionID   int(11);
DECLARE Var_TipoInstitID    int(11);
DECLARE Var_CtaContaSob     varchar(25);
DECLARE Var_CtaContaFalt    varchar(25);
DECLARE Var_CtaContDocSBCD  varchar(45);
DECLARE Var_CtaContDocSBCA  varchar(45);
DECLARE Var_CuentaCompleta      varchar(30);
DECLARE Var_CuentaMayor     varchar(12);
DECLARE Var_Temp            int(11);
DECLARE Var_AfectaContaSBC  char(1);
DECLARE Var_Contador        int(5);
DECLARE Var_CtaContaSRVFUN  varchar(25);
DECLARE Var_HaberExSocios   varchar(25);
DECLARE Var_CCServifun      varchar(30);
DECLARE Var_CtaContaApoyoEsc    varchar(25);


set Cadena_Vacia    := '';
set Entero_Cero     := 0;
set For_CueMayor    := '&CM';
set For_Moneda      := '&TM';
set For_Tipo        := '&TP';
set For_TipoCaja    := '&TC';
set For_Cajero      := '&CA';
set For_Sucursal    := '&SU';
set ConceptoMonIDiv := 1;
set MonedaPesos     := 1;
set Salida_NO       := 'N';
set SubCtaXCaja         := '&CA';
set ConceptoMonAper     := 1;
set AportaSocial        := 1;
set SeguroVidaAyu       := 2;
set PagoOportuni        := 4;
set CancelaSocioMen     := 8;
set InstitCajasAho      := 6;
set Cadena_Si           := 'S';
set Salida_NO           := 'N';
set NumCtas             := 4;

ManejoErrores: begin

DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := '999';
            SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-CUENTACONTACAJAVAL');
            SET Var_Control := 'sqlException' ;
        END;

select Nomenclatura into Var_Nomenclatura
    from CUENTASMAYORMON
    where ConceptoMonID = ConceptoMonIDiv;
    set Var_Nomenclatura :=ifnull(Var_Nomenclatura,Cadena_Vacia);

select TipoCaja into Var_TipoCaja
    from CAJASVENTANILLA
    where SucursalID = Par_SucursalID
    and CajaID = Par_CajaID;
    set Var_TipoCaja := ifnull(Var_TipoCaja,Cadena_Vacia);


    select InstitucionID,CtaContaSobrante, CtaContaFaltante, CtaContaDocSBCD, CtaContaDocSBCA, AfectaContaRecSBC
            into Var_InstitucionID,Var_CtaContaSob, Var_CtaContaFalt, Var_CtaContDocSBCD, Var_CtaContDocSBCA, Var_AfectaContaSBC
        from PARAMETROSSIS;

    set Var_CtaContaSob := ifnull(Var_CtaContaSob, Cadena_Vacia);
    set Var_CtaContaFalt := ifnull(Var_CtaContaFalt, Cadena_Vacia);
    set Var_CtaContDocSBCD := ifnull(Var_CtaContDocSBCD, Cadena_Vacia);
    set Var_CtaContDocSBCA := ifnull(Var_CtaContDocSBCA, Cadena_Vacia);
    set  Var_InstitucionID := ifnull(Var_InstitucionID,Entero_Cero);

    select TipoInstitID into Var_TipoInstitID
            from INSTITUCIONES
            where InstitucionID = Var_InstitucionID;
    set Var_TipoInstitID := ifnull(Var_TipoInstitID,Entero_Cero);


    select locate(SubCtaXCaja,Nomenclatura) into Var_Numero
        from CUENTASMAYORMON
        where ConceptoMonID = ConceptoMonAper;


    if(Var_Numero > Entero_Cero) then
        if not exists(select CajaID
            from SUBCTACAJERODIV
            where CajaID = Par_CajaID
            and ConceptoMonID = ConceptoMonAper) then

            set Par_NumErr  :=01;
            set Par_ErrMen  :="La Guia Contable No Esta Parametrizada para la Caja Seleccionada";
            set Var_Control :='cajaID';
            leave ManejoErrores;
        end if;
     end if;


if locate(For_CueMayor, Var_Nomenclatura) > Entero_Cero then
    select ctam.Cuenta into Var_CuentaMa
        from CUENTASMAYORMON ctam
        where ctam.ConceptoMonID = ConceptoMonIDiv;
    set Var_CuentaMa := ifnull(Var_CuentaMa, Cadena_Vacia);

    if(Var_CuentaMa != Cadena_Vacia)then
        set Var_Nomenclatura := replace(replace(Var_Nomenclatura,For_CueMayor, Var_CuentaMa ), '-',Cadena_Vacia);
    end if;
end if;

if locate(For_Moneda, Var_Nomenclatura) then
    select SubCuenta into Var_SubCuentaMon
        from SUBCTAMONEDADIV
        where MonedaID = MonedaPesos
        and ConceptoMonID = ConceptoMonIDiv;
    set Var_SubCuentaMon := ifnull(Var_SubCuentaMon,Cadena_Vacia);
    if(Var_SubCuentaMon != Cadena_Vacia)then
        set Var_Nomenclatura := replace(Var_Nomenclatura, For_Moneda, Var_SubCuentaMon);
    end if;

end if;

if locate(For_Sucursal, Var_Nomenclatura) then
    select SubCuenta into Var_SubCuentaSuc
        from SUBCTASUCURSDIV
        where SucursalID =  Par_SucursalID
        and ConceptoMonID = ConceptoMonIDiv;
    set Var_SubCuentaSuc := ifnull(Var_SubCuentaSuc, Cadena_Vacia);
    if(Var_SubCuentaSuc != Cadena_Vacia) then
        set Var_Nomenclatura := replace(Var_Nomenclatura, For_Sucursal, Var_SubCuentaSuc);
    end if;
end if;

if locate(For_TipoCaja, Var_Nomenclatura)then
    if( Var_TipoCaja != Cadena_Vacia) then
        select SubCuenta into Var_SubCuentaTipoCa
            from SUBCTATIPCAJADIV
            where TipoCaja = Var_TipoCaja
            and ConceptoMonID = ConceptoMonIDiv;
        set Var_SubCuentaTipoCa := ifnull(Var_SubCuentaTipoCa, Cadena_Vacia);
    end if;
    if(Var_SubCuentaTipoCa != Cadena_Vacia)then
        set Var_Nomenclatura := replace(Var_Nomenclatura, For_TipoCaja, Var_SubCuentaTipoCa);
    end if;
end if;

if locate(For_Cajero, Var_Nomenclatura) then
    select SubCuenta    into Var_SubCuentaCaja
        from SUBCTACAJERODIV
        where CajaID = Par_CajaID
        and ConceptoMonID = ConceptoMonIDiv;
    set Var_SubCuentaCaja := ifnull(Var_SubCuentaCaja, Cadena_Vacia);
    if(Var_SubCuentaCaja != Cadena_Vacia) then
        set Var_Nomenclatura := replace(Var_Nomenclatura, For_Cajero, Var_SubCuentaCaja);
    end if;
end if;
set Var_NomenclaturaMon := Var_Nomenclatura;

if locate(For_Tipo, Var_Nomenclatura) then
    select Billetes, Monedas  into Var_Billetes, Var_Monedas
        from SUBCTATIPODIV
        where ConceptoMonID = ConceptoMonIDiv;
    set Var_Billetes := ifnull(Var_Billetes, Cadena_Vacia);
    set Var_Monedas  := ifnull(Var_Monedas, Cadena_Vacia);

    if(Var_Billetes != Cadena_Vacia)then
        set Var_Nomenclatura := replace(Var_Nomenclatura, For_Tipo, Var_Billetes);
    end if;
    if(Var_Monedas !=  Cadena_Vacia) then
        set Var_NomenclaturaMon := replace(Var_NomenclaturaMon, For_Tipo, Var_Monedas);
    end if;
        if not exists (select CuentaCompleta
                        from CUENTASCONTABLES
                        where CuentaCompleta = Var_Nomenclatura) then
                    set Par_NumErr  :=02;
                    set Par_ErrMen  :="La Cuenta Contable Parametrizada Para la Caja no Existe";
                    set Var_Control :='cajaID';
                    leave ManejoErrores;
        end if;

        if not exists (select CuentaCompleta
                        from CUENTASCONTABLES
                        where CuentaCompleta = Var_NomenclaturaMon) then
                    set Par_NumErr  :=03;
                    set Par_ErrMen  :="La Cuenta Contable Parametrizada Para la Caja no Existe";
                    set Var_Control :='cajaID';
                    leave ManejoErrores;
        end if;
else
    if not exists(select CuentaCompleta
                    from CUENTASCONTABLES
                    where CuentaCompleta = Var_Nomenclatura) then
                    set Par_NumErr  :=04;
                    set Par_ErrMen  :="La Cuenta Contable Parametrizada Para la Caja no Existe";
                    set Var_Control :='cajaID';
                    leave ManejoErrores;

    end if;
end if;



    if(Var_TipoInstitID = InstitCajasAho) then


            select Nomenclatura, Cuenta  into Var_CuentaCompleta, Var_CuentaMayor
                from CUENTASMAYORCAJA
                where ConceptoCajaID = AportaSocial;
            set Var_CuentaCompleta := ifnull(Var_CuentaCompleta, Cadena_Vacia);
            set Var_CuentaMayor := ifnull(Var_CuentaMayor, Cadena_Vacia);


            if(Var_CuentaCompleta != Cadena_Vacia)then
                if locate(For_CueMayor, Var_CuentaCompleta) then
                    if(Var_CuentaMayor != Cadena_Vacia) then
                        set Var_CuentaCompleta := replace(replace(Var_CuentaCompleta, For_CueMayor, Var_CuentaMayor),'-',Cadena_Vacia);
                    end if;
                end if;

                if not exists(select CuentaCompleta
                                from CUENTASCONTABLES
                                where CuentaCompleta = Var_CuentaCompleta)then
                        set Par_NumErr  :=05;
                        set Par_ErrMen  :="La Cuenta Contable Parametrizada Para la Aportacion Social no Existe";
                        set Var_Control :='cajaID';
                        leave ManejoErrores;
                end if;
            end if;


            select Nomenclatura, Cuenta  into Var_CuentaCompleta, Var_CuentaMayor
                from CUENTASMAYORCAJA
                where ConceptoCajaID = SeguroVidaAyu;
            set Var_CuentaCompleta := ifnull(Var_CuentaCompleta, Cadena_Vacia);
            set Var_CuentaMayor := ifnull(Var_CuentaMayor, Cadena_Vacia);
            if(Var_CuentaCompleta != Cadena_Vacia)then
                if locate(For_CueMayor, Var_CuentaCompleta) then
                    if(Var_CuentaMayor != Cadena_Vacia) then
                        set Var_CuentaCompleta := replace(replace(Var_CuentaCompleta, For_CueMayor, Var_CuentaMayor),'-',Cadena_Vacia);
                    end if;
                end if;
                if not exists(select CuentaCompleta
                                from CUENTASCONTABLES
                                where CuentaCompleta = Var_CuentaCompleta)then
                        set Par_NumErr  :=06;
                        set Par_ErrMen  :="La Cuenta Contable Parametrizada  Para el Seguro de Vida Ayuda no Existe";
                        set Var_Control :='cajaID';
                        leave ManejoErrores;
                end if;
            end if;


            select Nomenclatura, Cuenta  into Var_CuentaCompleta, Var_CuentaMayor
                from CUENTASMAYORCAJA
                where ConceptoCajaID = PagoOportuni;
            set Var_CuentaCompleta := ifnull(Var_CuentaCompleta, Cadena_Vacia);
            set Var_CuentaMayor := ifnull(Var_CuentaMayor, Cadena_Vacia);

            if(Var_CuentaCompleta != Cadena_Vacia)then
                if locate(For_CueMayor, Var_CuentaCompleta) then
                    if(Var_CuentaMayor != Cadena_Vacia) then
                        set Var_CuentaCompleta := replace(replace(Var_CuentaCompleta, For_CueMayor, Var_CuentaMayor),'-',Cadena_Vacia);
                    end if;
                end if;
                if not exists(select CuentaCompleta
                                from CUENTASCONTABLES
                                where CuentaCompleta = Var_CuentaCompleta)then
                        set Par_NumErr  :=07;
                        set Par_ErrMen  :="La Cuenta Contable Parametrizada Para el Pago de Programa Oportunidades no Existe";
                        set Var_Control :='cajaID';
                        leave ManejoErrores;
                end if;
            end if;


            select Nomenclatura, Cuenta  into Var_CuentaCompleta, Var_CuentaMayor
                from CUENTASMAYORCAJA
                where ConceptoCajaID = CancelaSocioMen;
            set Var_CuentaCompleta := ifnull(Var_CuentaCompleta, Cadena_Vacia);
            set Var_CuentaMayor := ifnull(Var_CuentaMayor, Cadena_Vacia);

            if(Var_CuentaCompleta != Cadena_Vacia)then
                if locate(For_CueMayor, Var_CuentaCompleta) then
                    if(Var_CuentaMayor != Cadena_Vacia) then
                        set Var_CuentaCompleta := replace(replace(Var_CuentaCompleta, For_CueMayor, Var_CuentaMayor),'-',Cadena_Vacia);
                    end if;
                end if;
                if not exists(select CuentaCompleta
                                from CUENTASCONTABLES
                                where CuentaCompleta = Var_CuentaCompleta)then
                        set Par_NumErr  :=08;
                        set Par_ErrMen  :="La Cuenta Contable Parametrizada Para la Cancelacion de Socios Menores no Existe";
                        set Var_Control :='cajaID';
                        leave ManejoErrores;
                end if;
            end if;


        If(Var_AfectaContaSBC = Cadena_Si)then
            if(Var_CtaContDocSBCD = Cadena_Vacia) then
                set Par_NumErr  :=09;
                set Par_ErrMen  :="La Cuenta Contable para la RecepciÃ³n de Cheques SBC no  Esta Parametrizada";
                set Var_Control :='cajaID';
                leave ManejoErrores;
            end if;
            if not exists(select CuentaCompleta
                from CUENTASCONTABLES
                where CuentaCompleta = Var_CtaContDocSBCD)then
                set Par_NumErr  :=10;
                set Par_ErrMen  :="La Cuenta Contable Parametrizada para la RecepciÃ³n de Cheques SBC no  Existe";
                set Var_Control :='cajaID';
                leave ManejoErrores;
            end if;

            if(Var_CtaContDocSBCA = Cadena_Vacia) then
                set Par_NumErr  :=11;
                set Par_ErrMen  :="La Cuenta Contable para la RecepciÃ³n de Cheques SBC no  Esta Parametrizada";
                set Var_Control :='cajaID';
                leave ManejoErrores;
            end if;
            if not exists(select CuentaCompleta
                from CUENTASCONTABLES
                where CuentaCompleta = Var_CtaContDocSBCA)then
                set Par_NumErr  :=12;
                set Par_ErrMen  :="La Cuenta Contable Parametrizada para la RecepciÃ³n de Cheques SBC no  Existe";
                set Var_Control :='cajaID';
                leave ManejoErrores;
            end if;
        end if;

    end if;


    if exists(select CtaContaCom, CtaContaIVACom
                from CATALOGOSERV
                where CobraComision =Cadena_Si
                and (CtaContaCom = Cadena_Vacia
                or CtaContaIVACom = Cadena_Vacia)) then
                set Par_NumErr  :=13;
                set Par_ErrMen  :="No Existe la Parametrizacion Contable Para el Pago de Servicios";
                set Var_Control :='cajaID';
                leave ManejoErrores;
    end if;


    if exists( select CtaContableMN, CtaContableME, CtaContaMNTrans, CtaContaMETrans
                from  CATCAJEROSATM
                where (CtaContableMN = Cadena_Vacia
                        or CtaContableMN = Cadena_Vacia
                        or CtaContableME = Cadena_Vacia
                        or CtaContaMNTrans = Cadena_Vacia
                        or CtaContaMETrans = Cadena_Vacia))then
                set Par_NumErr  :=14;
                set Par_ErrMen  :="No Existe la Parametrizacion Contable de los Cajeros ATM";
                set Var_Control :='cajaID';
                leave ManejoErrores;
    end if;

    if exists( select CtaContable, CentroCosto
                from TIPOSANTGASTOS
                where (CtaContable = Cadena_Vacia
                or CentroCosto = Cadena_Vacia)) then
                set Par_NumErr  :=15;
                set Par_ErrMen  :="No Existe la Parametrizacion Contable de Gastos y Anticipos";
                set Var_Control :='cajaID';
                leave ManejoErrores;
    end if;

    if(Var_CtaContaSob != Cadena_Vacia)then
        if not exists(select CuentaCompleta
            from CUENTASCONTABLES
            where CuentaCompleta = Var_CtaContaSob)then
            set Par_NumErr  :=17;
            set Par_ErrMen  :="La Cuenta Contable Para Sobrantes en Ventanilla no Existe";
            set Var_Control :='cajaID';
            leave ManejoErrores;
        end if;
    end if;

    if(Var_CtaContaFalt != Cadena_Vacia)then
        if not exists(select CuentaCompleta
            from CUENTASCONTABLES
            where CuentaCompleta = Var_CtaContaFalt)then
            set Par_NumErr  :=19;
            set Par_ErrMen  :="La Cuenta Contable Para Faltantes en Ventanilla no Existe";
            set Var_Control :='cajaID';
            leave ManejoErrores;
        end if;
    end if;

    select CtaContaSRVFUN,      HaberExSocios, CtaContaApoyoEsc
    into Var_CtaContaSRVFUN, Var_HaberExSocios, Var_CtaContaApoyoEsc
        from PARAMETROSCAJA
        where  EmpresaID = Par_EmpresaID;

    set Var_CtaContaSRVFUN      := ifnull(Var_CtaContaSRVFUN,Cadena_Vacia );
    set Var_HaberExSocios       := ifnull(Var_HaberExSocios,Cadena_Vacia);
    set Var_CtaContaApoyoEsc    := ifnull(Var_CtaContaApoyoEsc, Cadena_Vacia);

    if(Var_CtaContaSRVFUN != Cadena_Vacia)then
        if not exists(select CuentaCompleta
            from CUENTASCONTABLES
            where CuentaCompleta = Var_CtaContaSRVFUN)then
            set Par_NumErr  :=20;
            set Par_ErrMen  :="La Cuenta Contable Parametrizada Para Servifun no Existe";
            set Var_Control :='cajaID';
            leave ManejoErrores;
        end if;
    end if;

    if(Var_HaberExSocios != Cadena_Vacia)then
        if not exists(select CuentaCompleta
            from CUENTASCONTABLES
            where CuentaCompleta = Var_HaberExSocios)then
            set Par_NumErr  :=21;
            set Par_ErrMen  :="La Cuenta Contable Parametrizada Para los Haberes de ExSocios no Existe";
            set Var_Control :='cajaID';
            leave ManejoErrores;
        end if;
    end if;

    if(Var_CtaContaApoyoEsc != Cadena_Vacia)then
        if not exists(select CuentaCompleta
            from CUENTASCONTABLES
            where CuentaCompleta = Var_CtaContaApoyoEsc)then
            set Par_NumErr  :=22;
            set Par_ErrMen  :="La Cuenta Contable Parametrizada Para el Pago de Apoyo Escolar no Existe";
            set Var_Control :='cajaID';
            leave ManejoErrores;
        end if;
    end if;




END ManejoErrores;

 if (Par_Salida = Cadena_Si) THEN
    SELECT  convert(Par_NumErr, char(3)) AS NumErr,
            Par_ErrMen           AS ErrMen,
            Var_Control          AS control,
            Entero_Cero  AS consecutivo;
 end if;
END TerminaStore$$