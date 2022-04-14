-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POSICIONTESORERIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POSICIONTESORERIAPRO`;
DELIMITER $$


CREATE PROCEDURE `POSICIONTESORERIAPRO`(
    Par_Fecha           date,

    Par_Salida          char(1),
	inout	Par_NumErr	 	int,
	inout	Par_ErrMen	 	varchar(400),

    Par_EmpresaID			int,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)

TerminaStore: BEGIN

/* Declaracion de Constantes */
DECLARE FechaSiguiente  date;
DECLARE Fecha15Dias     date;
DECLARE Fecha30Dias     date;
DECLARE Fecha60Dias     date;

/* Declaracion de Constantes */
DECLARE Decimal_Cero        decimal(12,2);
DECLARE Entero_Cero         int;
DECLARE Cadena_Vacia        char(1);
DECLARE Salida_SI           char(1);
DECLARE Estatus_Vigente     char(1);
DECLARE Estatus_Vencido     char(1);
DECLARE Estatus_Atrasado    char(1);
DECLARE InvKubo_Vigente     char(1);
DECLARE InvKubo_Vencida     char(1);
DECLARE InvPlazo_Vigente    char(1);

DECLARE SiPagaIVA           char(1);
DECLARE NOPagaIVA           char(1);
DECLARE InsCredito          char(1);
DECLARE InsInvKubo          char(1);
DECLARE InsInvPlazo         char(1);


/* Asignacion de Constantes */
set Decimal_Cero    := 0.00;
set Entero_Cero     := 0.00;
set Cadena_Vacia    := '';
Set Salida_SI       := 'S';

set Estatus_Vigente	:= 'V';
set Estatus_Vencido	:= 'B';
set Estatus_Atrasado	:= 'A';

set InvKubo_Vigente	:= 'N';
set InvKubo_Vencida	:= 'V';

set InvPlazo_Vigente	:= 'N';

Set SiPagaIVA         := 'S';
Set NOPagaIVA         := 'N';
Set InsCredito        := 'C';
Set InsInvKubo        := 'I';
Set InsInvPlazo       := 'P';



set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;

    delete from POSICIONTESORERIA;

    -- Calculo de los Periodos
    set FechaSiguiente  = ADDDATE(Par_Fecha, 1);
    set Fecha15Dias     = ADDDATE(FechaSiguiente, 15);
    set Fecha30Dias     = ADDDATE(Fecha15Dias, 15);
    set Fecha60Dias     = ADDDATE(Fecha30Dias, 30);

    -- CARTERA
    -- Vencimientos del Dia y lo Exigible (Atrasado y Vencido)
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsCredito, Entero_Cero, Entero_Cero,
            sum(round(ifnull(Amo.SaldoCapVigente, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapAtrasa, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVencido, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVenNExi, Decimal_Cero), 2)),

            sum(round(ifnull(Amo.SaldoInteresOrd, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoInteresAtr, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoInteresVen, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoInteresPro, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoIntNoConta, Decimal_Cero), 2)),

            sum(round(ifnull(Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen, Decimal_Cero), 2)),

            sum(round(ifnull(Amo.SaldoComFaltaPa, Decimal_Cero),2) +
               round(ifnull(Amo.SaldoComServGar, Decimal_Cero),2) +
                round(ifnull(Amo.SaldoOtrasComis, Decimal_Cero), 2)),

            CASE
				WHEN Pro.CobraIVAInteres = NOPagaIVA or Cli.PagaIVA = NOPagaIVA
            THEN Decimal_Cero
				ELSE
                sum((round(ifnull(Amo.SaldoInteresOrd, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoInteresAtr, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoInteresVen, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoInteresPro, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoIntNoConta, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoMoratorios, Decimal_Cero), 2) +
					round(ifnull(Amo.SaldoMoraVencido, Decimal_Cero), 2) +
					round(ifnull(Amo.SaldoMoraCarVen, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoComFaltaPa, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoComServGar, Decimal_Cero), 2) +
                    round(ifnull(Amo.SaldoOtrasComis, Decimal_Cero), 2)) * Suc.IVA)
				END,
            Decimal_Cero,   Cre.EmpresaID,    Aud_Usuario,      Aud_FechaActual,
            Aud_DireccionIP,Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion

        from AMORTICREDITO Amo,
             CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli,
             SUCURSALES Suc
        where Amo.FechaExigible  <= FechaSiguiente
          and ( Amo.Estatus = Estatus_Vigente
          or    Amo.Estatus = Estatus_Vencido
          or    Amo.Estatus = Estatus_Atrasado )
          and   Amo.CreditoID = Cre.CreditoID
          and   Cre.ProductoCreditoID   = Pro.ProducCreditoID
          and   Cre.ClienteID   = Cli.ClienteID
          and   Cli.SucursalOrigen  = Suc.SucursalID
          group by Cli.SucursalOrigen, Pro.CobraIVAInteres, Cli.PagaIVA, Cre.EmpresaID;

    -- Vencimientos del 1 a 15 Dias
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsCredito, 1, 15,
           sum(round(ifnull(Amo.SaldoCapVigente, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapAtrasa, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVencido, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVenNExi, Decimal_Cero), 2)),

            sum(round(ifnull(Amo.Interes, Decimal_Cero), 2)),

            Decimal_Cero,   Decimal_Cero,

            CASE
				WHEN Pro.CobraIVAInteres = NOPagaIVA or Cli.PagaIVA = NOPagaIVA
            THEN Decimal_Cero
				ELSE
                sum((round(ifnull(Amo.Interes, Decimal_Cero), 2)) * Suc.IVA)
				END,
            Decimal_Cero,   Cre.EmpresaID,    Aud_Usuario,      Aud_FechaActual,
            Aud_DireccionIP,Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion

        from AMORTICREDITO Amo,
             CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli,
             SUCURSALES Suc
        where Amo.FechaExigible  > FechaSiguiente
          and Amo.FechaExigible  <= Fecha15Dias
          and ( Amo.Estatus = Estatus_Vigente
          or    Amo.Estatus = Estatus_Vencido
          or    Amo.Estatus = Estatus_Atrasado )
          and   Amo.CreditoID = Cre.CreditoID
          and   Cre.ProductoCreditoID   = Pro.ProducCreditoID
          and   Cre.ClienteID   = Cli.ClienteID
          and   Cli.SucursalOrigen  = Suc.SucursalID
          group by Cli.SucursalOrigen, Pro.CobraIVAInteres, Cli.PagaIVA, Cre.EmpresaID;

    -- Vencimientos del 15 a 30 Dias
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsCredito, 15, 30,
           sum(round(ifnull(Amo.SaldoCapVigente, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapAtrasa, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVencido, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVenNExi, Decimal_Cero), 2)),

            sum(round(ifnull(Amo.Interes, Decimal_Cero), 2)),

            Decimal_Cero,   Decimal_Cero,

            CASE
				WHEN Pro.CobraIVAInteres = NOPagaIVA or Cli.PagaIVA = NOPagaIVA
            THEN Decimal_Cero
				ELSE
                sum((round(ifnull(Amo.Interes, Decimal_Cero), 2)) * Suc.IVA)
				END,
            Decimal_Cero,   Cre.EmpresaID,    Aud_Usuario,      Aud_FechaActual,
            Aud_DireccionIP,Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion

        from AMORTICREDITO Amo,
             CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli,
             SUCURSALES Suc
        where Amo.FechaExigible  > Fecha15Dias
          and Amo.FechaExigible  <= Fecha30Dias
          and ( Amo.Estatus = Estatus_Vigente
          or    Amo.Estatus = Estatus_Vencido
          or    Amo.Estatus = Estatus_Atrasado )
          and   Amo.CreditoID = Cre.CreditoID
          and   Cre.ProductoCreditoID   = Pro.ProducCreditoID
          and   Cre.ClienteID   = Cli.ClienteID
          and   Cli.SucursalOrigen  = Suc.SucursalID
          group by Cli.SucursalOrigen, Pro.CobraIVAInteres, Cli.PagaIVA, Cre.EmpresaID;

    -- Vencimientos del 30 a 60 Dias
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsCredito, 30, 60,
           sum(round(ifnull(Amo.SaldoCapVigente, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapAtrasa, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVencido, Decimal_Cero), 2) +
                round(ifnull(Amo.SaldoCapVenNExi, Decimal_Cero), 2)),

            sum(round(ifnull(Amo.Interes, Decimal_Cero), 2)),

            Decimal_Cero,   Decimal_Cero,

            CASE
				WHEN Pro.CobraIVAInteres = NOPagaIVA or Cli.PagaIVA = NOPagaIVA
            THEN Decimal_Cero
				ELSE
                sum((round(ifnull(Amo.Interes, Decimal_Cero), 2)) * Suc.IVA)
				END,
            Decimal_Cero,   Cre.EmpresaID,    Aud_Usuario,      Aud_FechaActual,
            Aud_DireccionIP,Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion

        from AMORTICREDITO Amo,
             CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli,
             SUCURSALES Suc
        where Amo.FechaExigible  > Fecha30Dias
          and Amo.FechaExigible  <= Fecha60Dias
          and ( Amo.Estatus = Estatus_Vigente
          or    Amo.Estatus = Estatus_Vencido
          or    Amo.Estatus = Estatus_Atrasado )
          and   Amo.CreditoID = Cre.CreditoID
          and   Cre.ProductoCreditoID   = Pro.ProducCreditoID
          and   Cre.ClienteID   = Cli.ClienteID
          and   Cli.SucursalOrigen  = Suc.SucursalID
          group by Cli.SucursalOrigen, Pro.CobraIVAInteres, Cli.PagaIVA, Cre.EmpresaID;

    -- Inversiones a Plazo PRLV (Inversion Tradicional)
    -- Vencimientos del Dia
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsInvPlazo,        Entero_Cero,    Entero_Cero,
            Monto,              InteresGenerado,    Decimal_Cero,   Decimal_Cero,
            Decimal_Cero,       Decimal_Cero,       Inv.EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion
        from INVERSIONES Inv,
             CLIENTES Cli
        where Inv.FechaVencimiento  = FechaSiguiente
          and Inv.Estatus           = InvPlazo_Vigente
          and Inv.ClienteID         = Cli.ClienteID;

    -- Inversiones a Plazo PRLV (Inversion Tradicional)
    -- Vencimientos de 1 a 15 Dias
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsInvPlazo,        1,              15,
            Monto,              InteresGenerado,    Decimal_Cero,   Decimal_Cero,
            Decimal_Cero,       Decimal_Cero,       Inv.EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion
        from INVERSIONES Inv,
             CLIENTES Cli
        where Inv.FechaVencimiento  > FechaSiguiente
          and Inv.FechaVencimiento  <= Fecha15Dias
          and Inv.Estatus           = InvPlazo_Vigente
          and Inv.ClienteID         = Cli.ClienteID;

    -- Inversiones a Plazo PRLV (Inversion Tradicional)
    -- Vencimientos de 15 a 30 Dias
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsInvPlazo,        15,              30,
            Monto,              InteresGenerado,    Decimal_Cero,   Decimal_Cero,
            Decimal_Cero,       Decimal_Cero,       Inv.EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion
        from INVERSIONES Inv,
             CLIENTES Cli
        where Inv.FechaVencimiento  > Fecha15Dias
          and Inv.FechaVencimiento  <= Fecha30Dias
          and Inv.Estatus           = InvPlazo_Vigente
          and Inv.ClienteID         = Cli.ClienteID;

    -- Inversiones a Plazo PRLV (Inversion Tradicional)
    -- Vencimientos de 30 a 60 Dias
    INSERT INTO `POSICIONTESORERIA`	(
		`SucursalID`,					`TipoInstrumento`,					`PlazoInf`,						`PlazoSup`,					`Capital`,
		`Interes`,						`Moratorios`,						`Comisiones`,					`IVA`,						`Retencion`,
		`EmpresaID`,					`Usuario`,							`FechaActual`,					`DireccionIP`,				`ProgramaID`,
		`Sucursal`,						`NumTransaccion`)
    select  Cli.SucursalOrigen, InsInvPlazo,        30,              60,
            Monto,              InteresGenerado,    Decimal_Cero,   Decimal_Cero,
            Decimal_Cero,       Decimal_Cero,       Inv.EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion
        from INVERSIONES Inv,
             CLIENTES Cli
        where Inv.FechaVencimiento  > Fecha30Dias
          and Inv.FechaVencimiento  <= Fecha60Dias
          and Inv.Estatus           = InvPlazo_Vigente
          and Inv.ClienteID         = Cli.ClienteID;

    set	Par_NumErr := 0;
    set	Par_ErrMen := 'Posicion Tesoreria Generada.';

 if (Par_Salida = Salida_SI) then
    select  convert(Par_NumErr, char(10)) as NumErr,
            Par_ErrMen as ErrMen;
end if;


END TerminaStore$$
