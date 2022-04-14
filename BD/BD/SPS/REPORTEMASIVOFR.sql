-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPORTEMASIVOFR
DELIMITER ;
DROP PROCEDURE IF EXISTS `REPORTEMASIVOFR`;DELIMITER $$

CREATE PROCEDURE `REPORTEMASIVOFR`(

   Par_Fecha			date,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_FecCorte    date;
DECLARE Var_FechaSis    date;

/* Declaracion de Constates */
DECLARE Fecha_Vacia date;
DECLARE Inst_FR     int;
DECLARE Rec_Fondeo  char(1);


/* Asignacion de Constantes */
Set Fecha_Vacia     := '1900-01-01';
Set Inst_FR         := 1;           -- Numero Asignado a FR
Set Rec_Fondeo      := 'F';         -- Recursos de Institucion de Fondeo;

select max(FechaCorte) into Var_FecCorte
    from SALDOSCREDITOS
    where FechaCorte <= Par_Fecha;

select FechaSistema into Var_FechaSis
    from PARAMETROSSIS;


-- if (Var_FecCorte != Fecha_Vacia and Par_Fecha!= Var_FechaSis) then

    SELECT  Sal.FechaCorte,-- ,Sal.FechaInicio,
    case
        when month(Sal.FechaInicio) < month(Par_Fecha)-- Par_Fecha
            then 1
        when  month(Sal.FechaInicio) = month(Par_Fecha)-- Par_Fecha
        then 0
    end as TipoOperacion, -- 1
    983764578912 as NumCliIntermediario,-- 2   QUEMADO
    928736746519098001 as NumeroLinea, -- 3    QUEMADO
    298734982374892734 as NumDisposicion,-- 4  QUEMADO
    Sal.ClienteID, -- 5
    Sal.CreditoID, -- 6
    Cli.NombreCompleto, --  7

    case
        when Cli.TipoPersona = 'M'
            then 2
        when Cli.TipoPersona = 'A'
        then 1
        when Cli.TipoPersona = 'F'
            then 0
        end as TipoPersona,-- 8

    case
        when Cli.TipoPersona <> 'M'
            then
                case
                    when Cli.Sexo = 'M'
                    then '1'
                    when Cli.Sexo = 'F'
                    then '0'
                end

            else '-1'
        end as Sexo, -- 9
    Cli.CURP, -- 10
    Cli.RFC,-- 11
    Dir.EstadoID,-- 12
    'PD1' as TipoProductor, -- 13 QUEMADO
    73 as FiguraJuridica, -- 14 QUEMADO
    12 as TipoCredito, -- 15 QUEMADO
    Cli.ActividadFR, -- 16
    Sal.DestinoCreID as DestinoCredito, -- 17
    '00' as TipoUnidad, -- 18
    1 as UnidHabilitar, -- 19
    -1 as RiegoTemporal, -- 20 [No Aplica]
    -1 as CicloAgricola, -- 21 [No Aplica]
    DATE_FORMAT(Sal.FechaInicio, '%d/%m/%Y') as FechaApertura, -- 22
    DATE_FORMAT(Sal.FechaVencimiento, '%d/%m/%Y') as FechaVencimiento, -- 22
    Sal.MontoCredito, -- 24
    case
        when Sal.MonedaID = 1
        then '0'
        when Sal.MonedaID = 2
        then '1'
        when Sal.MonedaID <> 1 and Sal.MonedaID <> 2
        then ''
    end as TipoMoneda, -- 25
    case
        when Sal.FrecuenciaCap = 'S' then 'SEMANAL'
        when Sal.FrecuenciaCap = 'C' then 'CATORCENAL'
        when Sal.FrecuenciaCap = 'Q' then 'QUINCENAL'
        when Sal.FrecuenciaCap = 'M' then 'MENSUAL'
        when Sal.FrecuenciaCap = 'P' then 'PERIODO'
        when Sal.FrecuenciaCap = 'B' then 'BIMESTRAL'
        when Sal.FrecuenciaCap = 'T' then 'TRIMESTRAL'
        when Sal.FrecuenciaCap = 'R' then 'TERAMESTRAL'
        when Sal.FrecuenciaCap = 'E' then 'SEMESTRAL'
        when Sal.FrecuenciaCap = 'A' then 'ANUAL'
    end as PeriodicidadPagos, -- 26


    case
        when Sal.EstatusCredito = 'V' then 1 -- Vigente
        when Sal.EstatusCredito = 'B' then 2 -- Vencido
        when Sal.EstatusCredito = 'P' then 3 -- Pagado(SAFI) Saldado(FR)
    end as EstatusCredito, -- 27
    case
        when Sal.EstatusCredito = 'B' then Sal.DiasAtraso -- Vencido
        else 0
    end as DiasAtraso, -- 28
    case
        when Sal.EstatusCredito = 'V' then  Sal.SalCapVigente -- Vencido
        else 0
    end as CapitalVigente, -- 29
    case
        when Sal.EstatusCredito = 'V' then
            (Sal.SalIntProvision + Sal.SalIntOrdinario+ Sal.SalIntNoConta)
        else 0
    end  as InteresesVigente,-- 30

    case
        when Sal.EstatusCredito = 'B' then
    (Sal.SalCapAtrasado + Sal.SalCapVencido  + Sal.SalCapVenNoExi)
    else 0
    end as CapitalVencido,-- 31

    case
        when Sal.EstatusCredito = 'B' then
    (Sal.SalIntAtrasado + Sal.SalIntVencido)
    else 0
    end as InteresesVencido,

    (Sal.SalCapVigente + Sal.SalCapVenNoExi + Sal.SalIntProvision + Sal.SalIntOrdinario + Sal.SalIntNoConta+ -- )TotalVigente
    Sal.SalCapAtrasado + Sal.SalCapVencido  + Sal.SalCapVenNoExi + Sal.SalIntAtrasado + Sal.SalIntVencido +
    Sal.SalMoratorios + Sal.SaldoMoraVencido + Sal.SaldoMoraCarVen + Sal.SalComFaltaPago +0.0)  -- TotalVencido
    as SaldoTotal, -- 33

    DATE_FORMAT(Par_Fecha, '%d/%m/%Y') as FechaSaldo,-- 34 [Par_Fecha]
    0 as TipoTasa, -- 35 QUEMADO [Fija]
    -1 as BaseReferencia, -- 36 QUEMADO [No aplica]
    0 as PuntsAdicionales, -- 37 QUEMADO
    Cre.TasaFija,-- 38
    Dir.MunicipioID,-- 39
    Sal.MontoCredito as MontoOtorgadoFR, -- 40
    -1 as ApoyoFONAGA, -- 41 QUEMADO
    '' as ProgEspeciales,-- 42  QUEMADO
    Sal.CreditoID as NumMinistracion --
    FROM SALDOSCREDITOS Sal
    inner join CLIENTES Cli on Cli.ClienteID = Sal.ClienteID
    inner join DIRECCLIENTE Dir on Cli.ClienteID = Dir.ClienteID
    inner join CREDITOS Cre on Sal.CreditoID = Cre.CreditoID
    where Sal.TipoFondeo        = Rec_Fondeo
      and Sal.InstitFondeoID    = Inst_FR
      and Sal.FechaCorte        = Var_FecCorte
    group by Sal.CreditoID, 		Sal.FechaInicio,		Sal.ClienteID, 			Dir.EstadoID, 			Sal.DestinoCreID,
			 Sal.FechaVencimiento,	Sal.MontoCredito,		Sal.MonedaID,			Sal.FrecuenciaCap,		Sal.EstatusCredito,
             Sal.DiasAtraso,		Sal.SalCapVigente,		Sal.SalIntProvision,	Sal.SalIntOrdinario,	Sal.SalIntNoConta,
             Sal.SalCapAtrasado,	Sal.SalCapVencido,		Sal.SalCapVenNoExi,		Sal.SalIntAtrasado,		Sal.SalIntVencido,
             Sal.SalMoratorios,		Sal.SaldoMoraVencido,	Sal.SaldoMoraCarVen,	Sal.SalComFaltaPago,	Dir.MunicipioID;
-- end if;
-- TODO incluir todo los Creditos que Inician Hoy, que no estan en la de Saldos

if (Par_Fecha = Var_FechaSis) then
    select 'vacio';
end if;


END TerminaStore$$