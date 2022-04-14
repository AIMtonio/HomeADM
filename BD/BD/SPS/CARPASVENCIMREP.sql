-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARPASVENCIMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARPASVENCIMREP`;
DELIMITER $$


CREATE PROCEDURE `CARPASVENCIMREP`(
    Par_FechaInicio     date,
    Par_FechaFin        date,
    Par_InstitutFondID  int,
    Par_TipoInteres     char(1),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)

TerminaStore: BEGIN


DECLARE pagoExigible    decimal(12,2);
DECLARE TotalCartera    decimal(12,2);
DECLARE TotalCapVigent  decimal(12,2);
DECLARE TotalCapVencido decimal(12,2);
DECLARE nombreUsuario   varchar(50);
DECLARE Var_Sentencia   varchar(15000);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Foranea     int;
DECLARE Con_PagareTfija int;
DECLARE Con_Saldos      int;
DECLARE Con_PagareImp   int;
DECLARE Con_PagoCred    int;
DECLARE EstatusPagado   char(1);
DECLARE CienPorciento   decimal(10,2);
DECLARE FechaSist       date;
DECLARE Var_PerFisica   char(1);
DECLARE SiCobraIVA      char(1);
DECLARE Tip_IntActual   char(1);
DECLARE Tip_IntProyec   char(1);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set EstatusPagado   := 'P';
Set CienPorciento   := 100.00;
Set Var_PerFisica   := 'F';
Set SiCobraIVA      := 'S';
Set Tip_IntActual   := 'S';
Set Tip_IntProyec   := 'P';

set FechaSist := (Select FechaSistema from PARAMETROSSIS);

set Var_Sentencia :=  'select Fon.CapitalizaInteres, time(now()) as HoraEmision,Inst.NombreInstitFon as NombreInstitucion, Fon.CreditoFondeoID, Lin.LineaFondeoID,
             Lin.DescripLinea as NombreLinea,
             Amo.AmortizacionID, Fon.Monto, Fon.FechaInicio, Fon.FechaVencimien,
            (Fon.SaldoCapVigente+Fon.SaldoCapAtrasad+Fon.SaldoInteresAtra+Fon.SaldoInteresPro+
             Fon.SaldoMoratorios + Fon.SaldoComFaltaPa + Fon.SaldoOtrasComis +
			 round((Fon.SaldoInteresAtra + Fon.SaldoInteresPro +
					Fon.SaldoMoratorios + Fon.SaldoComFaltaPa + Fon.SaldoOtrasComis )* (Fon.PorcentanjeIVA/100),2)) as SaldoTotal,
            Amo.FechaExigible,
            (Amo.SaldoCapVigente + Amo.SaldoCapAtrasad) as Capital, ';
set Var_Sentencia := concat(Var_Sentencia, 'CASE WHEN Amo.Estatus = "P" or "',
                            Par_TipoInteres, '" = "S" THEN ',
            ' (Amo.SaldoInteresAtra + Amo.SaldoInteresPro)
            ELSE
                Amo.Interes
            END as InteresGenerado,
            Amo.SaldoMoratorios as Moratorios,
            Amo.SaldoComFaltaPa as Comisiones,
            Amo.SaldoOtrasComis as Cargos,

            CASE WHEN Fon.PagaIVA = "N" then 0
                 WHEN Fon.PagaIVA = "S" and "', Par_TipoInteres, '" = "S" THEN
                    round((Amo.SaldoInteresAtra + Amo.SaldoInteresPro + Amo.SaldoMoratorios +
                           Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis) * (Fon.PorcentanjeIVA/100),2)
                 WHEN Fon.PagaIVA = "S" and "', Par_TipoInteres, '" != "S"  AND Amo.Estatus != "P" THEN
                    round((Amo.Interes + Amo.SaldoMoratorios +
                           Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis) * (Fon.PorcentanjeIVA/100),2)
                 ELSE 0
            END as IVA,

            (Amo.SaldoCapVigente + Amo.SaldoCapAtrasad +
             CASE WHEN Amo.Estatus = "P" or "',Par_TipoInteres, '" = "S" THEN
                (Amo.SaldoInteresAtra + Amo.SaldoInteresPro)
              ELSE
                Amo.Interes
              END +
              Amo.SaldoMoratorios + Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis) +
            CASE WHEN Fon.PagaIVA = "N" then 0
                 WHEN Fon.PagaIVA = "S" and "', Par_TipoInteres, '" = "S" THEN
                    round((round(Amo.SaldoInteresAtra + Amo.SaldoInteresPro,2) + Amo.SaldoMoratorios +
                           Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis) * (Fon.PorcentanjeIVA/100),2)
                 WHEN Fon.PagaIVA = "S" and "', Par_TipoInteres, '" != "S" AND Amo.Estatus != "P" THEN
                    round((Amo.Interes + Amo.SaldoMoratorios +
                           Amo.SaldoComFaltaPa + Amo.SaldoOtrasComis) * (Fon.PorcentanjeIVA/100),2)
                ELSE 0
            END -
            CASE WHEN Amo.Estatus = "P" then 0
                 WHEN Amo.Estatus != "P" and (Amo.SaldoInteresAtra + Amo.SaldoInteresPro) > 0 and "',
            Par_TipoInteres, '" = "S" THEN ',
                    ' round(((Amo.SaldoInteresAtra + Amo.SaldoInteresPro)/Amo.Interes)*Amo.Retencion,2)
                WHEN Amo.Estatus != "P" and (Amo.SaldoInteresAtra + Amo.SaldoInteresPro) <= 0 and "',
            Par_TipoInteres, '" = "S" THEN 0
            ELSE
                Amo.Retencion
            END as TotCuota,
            CASE WHEN Fon.CapitalizaInteres = "N" then
                round(ifnull((select SUM(Mop.Cantidad)
                            from CREDITOFONDMOVS Mop
                            where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                              and Mop.AmortizacionID = Amo.AmortizacionID
                              and Mop.NatMovimiento = "A"
                and Mop.Descripcion like "%PAGO%"
                group by Mop.AmortizacionID, Mop.CreditoFondeoID), 0), 2)
            WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
                ifnull(Amo.Interes,0) + ifnull(Amo.Capital, 0) + ifnull(Amo.IVAInteres, 0)
            ELSE 0
            END as MontoPago,

        CASE WHEN Fon.CapitalizaInteres = "N" then
           convert(ifnull((select max(Mop.FechaAplicacion)
                from CREDITOFONDMOVS Mop
                where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                  and Mop.AmortizacionID = Amo.AmortizacionID
                  and Mop.NatMovimiento = "A"
                  and Mop.Descripcion like "%PAGO%"
                  group by Mop.AmortizacionID, Mop.CreditoFondeoID), "1900-01-01"), char(10))

            WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
                convert(ifnull(Amo.FechaExigible, "1900-01-01"), char(10))
            ELSE
                "1900-01-01"
            END
            as FechaPago,

        CASE WHEN (Amo.FechaExigible < Par.FechaSistema and Amo.Estatus != "P")
             THEN
                datediff(Par.FechaSistema, Amo.FechaExigible)
             ELSE
                0
        END as DiasAtraso, Inst.InstitutFondID,time(now()) as HoraEmision, Fon.Folio,
        case when Fon.Estatus="N" then "VIGENTE"
             when Fon.Estatus="P" then "PAGADO"
        end as EstatusCredito,
        CASE WHEN Amo.Estatus = "P" then 0
             WHEN Amo.Estatus != "P" and (Amo.SaldoInteresAtra + Amo.SaldoInteresPro) > 0 and "',
        Par_TipoInteres, '" = "S" THEN ',
            ' round(((Amo.SaldoInteresAtra + Amo.SaldoInteresPro)/Amo.Interes)*Amo.Retencion,2)
             WHEN Amo.Estatus != "P" and (Amo.SaldoInteresAtra + Amo.SaldoInteresPro) <= 0 and "',
        Par_TipoInteres, '" = "S" THEN 0
            ELSE
                Amo.Retencion
            END as Retencion,
       CASE WHEN Fon.CapitalizaInteres = "N" then
                round(ifnull((select SUM(Mop.Cantidad)
                            from CREDITOFONDMOVS Mop
                            where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                              and Mop.AmortizacionID = Amo.AmortizacionID
                              and Mop.NatMovimiento = "A"
                              and Mop.TipoMovFonID in (1,2)
                              and Mop.Descripcion like "%PAGO%"
                               group by Mop.AmortizacionID, Mop.CreditoFondeoID), 0), 2)
            WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
                Amo.Capital
            ELSE 0
        END as CapitalPagado,
        CASE WHEN Fon.CapitalizaInteres = "N" then
                round(ifnull((select SUM(Mop.Cantidad)
                            from CREDITOFONDMOVS Mop
                            where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                              and Mop.AmortizacionID = Amo.AmortizacionID
                              and Mop.NatMovimiento = "A"
                              and Mop.TipoMovFonID in (10,11)
                              and Mop.Descripcion like "%PAGO%"
                               group by Mop.AmortizacionID, Mop.CreditoFondeoID), 0), 2)
           WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
                Amo.Interes
            ELSE 0
         END as InteresPagado,
        CASE WHEN Fon.CapitalizaInteres = "N" then
            round(ifnull((select SUM(Mop.Cantidad)
                        from CREDITOFONDMOVS Mop
                        where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                          and Mop.AmortizacionID = Amo.AmortizacionID
                          and Mop.NatMovimiento = "C"
                          and Mop.TipoMovFonID = 30
                          and Mop.Descripcion like "%PAGO%"
                           group by Mop.AmortizacionID, Mop.CreditoFondeoID), 0), 2)
        WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
            Amo.Retencion
        ELSE 0
        END as ISRRetenido,
        CASE WHEN Fon.CapitalizaInteres = "N" then
            round(ifnull((select SUM(Mop.Cantidad)
                        from CREDITOFONDMOVS Mop
                        where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                          and Mop.AmortizacionID = Amo.AmortizacionID
                          and Mop.NatMovimiento = "A"
                          and Mop.TipoMovFonID in (20,21,22)
                          and Mop.Descripcion like "%PAGO%"
                           group by Mop.AmortizacionID, Mop.CreditoFondeoID), 0), 2)
        WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
            Amo.IVAInteres
        ELSE 0
        END as IVAPagado,

        CASE WHEN Fon.CapitalizaInteres = "N" then
            round(ifnull((select SUM(Mop.Cantidad)
                        from CREDITOFONDMOVS Mop
                        where Mop.CreditoFondeoID   = Fon.CreditoFondeoID
                          and Mop.AmortizacionID = Amo.AmortizacionID
                          and Mop.NatMovimiento = "A"
                          and Mop.TipoMovFonID in (15,40)
                          and Mop.Descripcion like "%PAGO%"
                           group by Mop.AmortizacionID, Mop.CreditoFondeoID), 0), 2)
        WHEN Fon.CapitalizaInteres = "S" and Amo.FechaExigible < Par.FechaSistema then
            0
		ELSE 0
        END as MoraComPagado,
        
		case when Fon.Estatus != "P" OR Fon.MonedaID = 1 then 0.00
		when Fon.Estatus="P" then 
			ifnull((select his.TipCamDof 
				from `HIS-MONEDAS` as his where his.MonedaId = Fon.MonedaID and Amo.FechaExigible = his.FechaRegistro), 0.00)
		END AS ValorDivisa,
		( select mon.Descripcion from MONEDAS mon where mon.MonedaId = Fon.MonedaID) as NomMoneda
    from AMORTIZAFONDEO as Amo
    inner join  CREDITOFONDEO as Fon on Amo.CreditoFondeoID = Fon.CreditoFondeoID
    inner join  INSTITUTFONDEO as Inst on Fon.InstitutFondID = Inst.InstitutFondID');

    set Par_InstitutFondID := ifnull(Par_InstitutFondID,Entero_Cero);
    if(Par_InstitutFondID!=0)then
        set Var_Sentencia :=  CONCAT(Var_sentencia,' and Inst.InstitutFondID =',convert(Par_InstitutFondID,char));
    end if;

    set Var_Sentencia := 	CONCAT(Var_Sentencia,'  inner join  LINEAFONDEADOR as Lin on Fon.LineaFondeoID = Lin.LineaFondeoID ');

    set Var_Sentencia := CONCAT(Var_sentencia,' inner join PARAMETROSSIS as Par');

    set Var_Sentencia :=  CONCAT(Var_Sentencia,' where   Amo.FechaExigible >= ? and Amo.FechaExigible <= ? order by Inst.InstitutFondID, Fon.LineaFondeoID, Amo.CreditoFondeoID,Amo.AmortizacionID ;' );


	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STSALDOSCAPITALREP FROM @Sentencia;
      EXECUTE STSALDOSCAPITALREP USING @FechaInicio, @FechaFin;
      DEALLOCATE PREPARE STSALDOSCAPITALREP;

END TerminaStore$$
