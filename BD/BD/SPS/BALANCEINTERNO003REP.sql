-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEINTERNO003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEINTERNO003REP`;DELIMITER $$

CREATE PROCEDURE `BALANCEINTERNO003REP`(

  Par_Ejercicio       int,
    Par_Periodo         int,
    Par_Fecha           date,
    Par_TipoConsulta    char(1),
    Par_SaldosCero      char(1),

    Par_Cifras          char(1),
    Par_CCInicial       int,
    Par_CCFinal         int,
    Par_EmpresaID       int,
    Aud_Usuario         int,

    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
)
TerminaStore: BEGIN


DECLARE Var_FecConsulta date;
DECLARE Var_FechaSistema    date;
DECLARE Var_FechaSaldos date;
DECLARE Var_EjeCon      int;
DECLARE Var_PerCon      int;
DECLARE Var_FecIniPer   date;
DECLARE Var_FecFinPer   date;
DECLARE Var_EjercicioVig    int;
DECLARE Var_PeriodoVig  int;
DECLARE For_ResulNeto   varchar(500);
DECLARE Par_AcumuladoCta    decimal(14,2);
DECLARE Var_TotalPasivo     decimal(14,2);
DECLARE Var_CapitalGanado   decimal(14,2);
DECLARE Var_TotPasCapCont   decimal(14,2);
DECLARE Des_ResulNeto       varchar(200);
DECLARE Des_TotPasCapCont   varchar(200);
DECLARE Var_Ubicacion       char(1);

DECLARE For_EfeRegSOCAP     varchar(500);
DECLARE For_CapResActNo     varchar(500);
DECLARE For_CapResVal       varchar(500);
DECLARE For_CapResEjeAnt    varchar(500);
DECLARE For_FondoRes        varchar(500);
DECLARE For_CerApoOrd       varchar(500);
DECLARE For_TotPasCapCont   varchar(500);

DECLARE Var_Columna             varchar(20);
DECLARE Var_Monto               decimal(18,2);
DECLARE Var_NombreTabla     varchar(40);
DECLARE Var_CreateTable     varchar(9000);
DECLARE Var_InsertTable     varchar(5000);
DECLARE Var_InsertValores   varchar(5000);
DECLARE Var_SelectTable     varchar(5000);
DECLARE Var_DropTable       varchar(5000);
DECLARE Var_CantCaracteres  int;
DECLARE Var_UltPeriodoCie   int;
DECLARE Var_UltEjercicioCie int;

DECLARE Var_MinCenCos   int;
DECLARE Var_MaxCenCos   int;


DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Est_Cerrado     char(1);
DECLARE Fecha_Vacia     date;
DECLARE VarDeudora      char(1);
DECLARE VarAcreedora    char(1);
DECLARE Tip_Encabezado  char(1);
DECLARE No_SaldoCeros   char(1);
DECLARE Cifras_Pesos    char(1);
DECLARE Cifras_Miles    char(1);
DECLARE Por_Peridodo    char(1);
DECLARE Por_Fecha       char(1);
DECLARE Ubi_Actual      char(1);
DECLARE Ubi_Histor      char(1);
DECLARE Var_MostrarP    char(1);
DECLARE Tif_Balance     int;
DECLARE Con_ResulNeto   int;

DECLARE Con_EfeRegSOCAP int;
DECLARE Con_CapResActNo int;
DECLARE Con_CapResVal   int;
DECLARE Con_CapResEjeAn int;
DECLARE Con_FondoRes    int;
DECLARE Con_CerApoOrd   int;
DECLARE Con_TotPasCapCont int;
DECLARE NumCliente		int;

DECLARE cur_Balance cursor for
    select CuentaContable,  SaldoDeudor
        from TMPBALANZACONTA
        where NumeroTransaccion = Aud_NumTransaccion
        order by CuentaContable;



Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
set Est_Cerrado     := 'C';
set VarDeudora      := 'D';
set VarAcreedora    := 'A';
set Tip_Encabezado  := 'E';
set No_SaldoCeros   := 'N';
set Cifras_Pesos    := 'P';
set Cifras_Miles    := 'M';
set Por_Peridodo    := 'P';
set Por_Fecha       := 'D';
set Ubi_Actual      := 'A';
set Ubi_Histor      := 'H';
set Tif_Balance     := 1;
set Con_ResulNeto   := 48;

set Con_EfeRegSOCAP := 66;
set Con_CapResActNo := 46;
set Con_CapResVal   := 45;
set Con_CapResEjeAn := 44;
set Con_FondoRes    := 43;
set Con_CerApoOrd   := 62;
set Con_TotPasCapCont:= 74;



set Var_MostrarP    := (select ValorParametro from PARAMGENERALES where LlaveParametro like "MostrarPoderAdRep");
set Var_MostrarP    := ifnull(Var_MostrarP, 'N');
set NumCliente      := 3;

if( Par_Periodo > Entero_Cero ) then
    set Par_TipoConsulta := Por_Peridodo;
end if;

select FechaSistema,        EjercicioVigente, PeriodoVigente into
       Var_FechaSistema,    Var_EjercicioVig, Var_PeriodoVig
    from PARAMETROSSIS;

set Par_Fecha           = ifnull(Par_Fecha, Fecha_Vacia);
set Var_EjercicioVig    = ifnull(Var_EjercicioVig, Entero_Cero);
set Var_PeriodoVig      = ifnull(Var_PeriodoVig, Entero_Cero);

call TRANSACCIONESPRO(Aud_NumTransaccion);

if(Par_Fecha    != Fecha_Vacia) then
    set Var_FecConsulta = Par_Fecha;
else
    select  Fin into Var_FecConsulta
        from PERIODOCONTABLE
        where EjercicioID   = Par_Ejercicio
          and PeriodoID     = Par_Periodo;
end if;

set Par_CCInicial   := ifnull(Par_CCInicial, Entero_Cero);
set Par_CCFinal     := ifnull(Par_CCFinal, Entero_Cero);


select min(CentroCostoID), max(CentroCostoID) into Var_MinCenCos, Var_MaxCenCos
    from CENTROCOSTOS;

if(Par_CCInicial = Entero_Cero or Par_CCFinal = Entero_Cero) then
    set Par_CCInicial   := Var_MinCenCos;
    set Par_CCFinal     := Var_MaxCenCos;
end if;


select CuentaContable, Desplegado  into For_ResulNeto, Des_ResulNeto
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_ResulNeto
		and NumClien = NumCliente;
set For_ResulNeto   := ifnull(For_ResulNeto, Cadena_Vacia);
set Des_ResulNeto   := ifnull(Des_ResulNeto, Cadena_Vacia);

select CuentaContable  into For_EfeRegSOCAP
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_EfeRegSOCAP
		and NumClien = NumCliente;
set For_EfeRegSOCAP   := ifnull(For_EfeRegSOCAP, Cadena_Vacia);

select CuentaContable  into For_CapResActNo
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_CapResActNo
		and NumClien = NumCliente;
set For_CapResActNo   := ifnull(For_CapResActNo, Cadena_Vacia);

select CuentaContable  into For_CapResVal
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_CapResVal
		and NumClien = NumCliente;
set For_CapResVal   := ifnull(For_CapResVal, Cadena_Vacia);

select CuentaContable  into For_CapResEjeAnt
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_CapResEjeAn
		and NumClien = NumCliente;
set For_CapResEjeAnt   := ifnull(For_CapResEjeAnt, Cadena_Vacia);

select CuentaContable  into For_FondoRes
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_FondoRes
		and NumClien = NumCliente;
set For_FondoRes   := ifnull(For_FondoRes, Cadena_Vacia);

select CuentaContable  into For_CerApoOrd
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_CerApoOrd
		and NumClien = NumCliente;
set For_CerApoOrd   := ifnull(For_CerApoOrd, Cadena_Vacia);


select CuentaContable  into For_TotPasCapCont
    from CONCEPESTADOSFIN
    where EstadoFinanID = Tif_Balance
      and ConceptoFinanID = Con_TotPasCapCont
		and NumClien = NumCliente;
set For_TotPasCapCont   := ifnull(For_TotPasCapCont, Cadena_Vacia);



select  max(EjercicioID) into Var_UltEjercicioCie
    from PERIODOCONTABLE Per
    where Per.Fin   < Var_FecConsulta
      and Per.Estatus = Est_Cerrado;

set Var_UltEjercicioCie    := ifnull(Var_UltEjercicioCie, Entero_Cero);

if(Var_UltEjercicioCie != Entero_Cero) then
    select  max(PeriodoID) into Var_UltPeriodoCie
        from PERIODOCONTABLE Per
        where Per.EjercicioID   = Var_UltEjercicioCie
          and Per.Estatus = Est_Cerrado
          and Per.Fin   < Var_FecConsulta;
end if;

set Var_UltPeriodoCie    := ifnull(Var_UltPeriodoCie, Entero_Cero);

delete from TMPCONTABLEBALANCE where NumeroTransaccion = Aud_NumTransaccion;

if (Par_TipoConsulta = Por_Fecha) then

    select max(FechaCorte) into Var_FechaSaldos
        from  SALDOSCONTABLES
        where FechaCorte < Par_Fecha;

    set Var_FechaSaldos = ifnull(Var_FechaSaldos, Fecha_Vacia);

    if (Var_FechaSaldos = Fecha_Vacia) then

        insert into TMPCONTABLEBALANCE
            select Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
                    Entero_Cero, Entero_Cero,
                    (Cue.Naturaleza),
                    CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                            sum((ifnull(Pol.Cargos, Entero_Cero)))-
                            sum((ifnull(Pol.Abonos, Entero_Cero)))
                             ELSE
                          Entero_Cero
                    END,
                    CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                            sum((ifnull(Pol.Abonos, Entero_Cero)))-
                            sum((ifnull(Pol.Cargos, Entero_Cero)))
                             ELSE
                          Entero_Cero
                    END,
                    Entero_Cero, Entero_Cero

                    from CUENTASCONTABLES Cue,
                         DETALLEPOLIZA as Pol
                    where Cue.CuentaCompleta = Pol.CuentaCompleta
                      and Pol.Fecha             <= Par_Fecha
                      and Pol.CentroCostoID >= Par_CCInicial
                      and Pol.CentroCostoID <= Par_CCFinal
                    group by Cue.CuentaCompleta;

        INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            select  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
                   Entero_Cero, Entero_Cero,
                   CASE WHEN (Cue.Naturaleza) = VarDeudora
                        THEN
                           sum((ifnull(Pol.SaldoDeudor, Entero_Cero))) -
                           sum((ifnull(Pol.SaldoAcreedor, Entero_Cero)))
                        ELSE
                           sum((ifnull(Pol.SaldoAcreedor, Entero_Cero))) -
                           sum((ifnull(Pol.SaldoDeudor, Entero_Cero)))
                   END,
                   Entero_Cero,
                   Fin.Desplegado, Cadena_Vacia, Cadena_Vacia
                FROM CONCEPESTADOSFIN Fin
            LEFT OUTER JOIN CUENTASCONTABLES Cue on Cue.CuentaCompleta like Fin.CuentaContable

            LEFT OUTER JOIN TMPCONTABLEBALANCE as Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                               and Pol.NumeroTransaccion    = Aud_NumTransaccion)

            where Fin.EstadoFinanID = Tif_Balance
              and Fin.EsCalculado = 'N'
				and NumClien = NumCliente
                group by Fin.ConceptoFinanID;


        if(For_ResulNeto != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_ResulNeto,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                values(
                Aud_NumTransaccion, "CapResNeto",       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_EfeRegSOCAP != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_EfeRegSOCAP,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                 values(
                Aud_NumTransaccion, "CapEfeRegSOCAP",   Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResActNo != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CapResActNo,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResTenActivosNo",       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResVal != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CapResVal,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResValTitDispVen",  Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResEjeAnt != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CapResEjeAnt,   Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResultadoEjeAnt",   Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_FondoRes != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_FondoRes,       Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapFondoReserva",  Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CerApoOrd != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CerApoOrd,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CertifAporOrd",    Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;


        if(For_TotPasCapCont != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_TotPasCapCont,  Ubi_Actual,     Por_Fecha,      Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "TotPasCapCont",    Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;



    else

        select  EjercicioID, PeriodoID, Inicio, Fin into
              Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
            from PERIODOCONTABLE
            where Inicio    <= Par_Fecha
              and Fin   >= Par_Fecha;

        set Var_EjeCon = ifnull(Var_EjeCon, Entero_Cero);
        set Var_PerCon = ifnull(Var_PerCon, Entero_Cero);
        set Var_FecIniPer = ifnull(Var_FecIniPer, Fecha_Vacia);
        set Var_FecFinPer = ifnull(Var_FecFinPer, Fecha_Vacia);

        if (Var_EjeCon = Entero_Cero) then
            select  max(EjercicioID), max(PeriodoID), max(Inicio), max(Fin) into
                    Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
                from PERIODOCONTABLE
                where Fin   <= Par_Fecha;
        end if;

        if (Var_EjeCon = Var_EjercicioVig and Var_PerCon >= Var_PeriodoVig) then
            insert into TMPCONTABLEBALANCE
                select  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                        Entero_Cero, Entero_Cero,
                        (Cue.Naturaleza),
                        CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                                sum((ifnull(Pol.Cargos, Entero_Cero)))-
                                sum((ifnull(Pol.Abonos, Entero_Cero)))
                             ELSE
                                Entero_Cero
                            END,
                        CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                sum((ifnull(Pol.Abonos, Entero_Cero)))-
                                sum((ifnull(Pol.Cargos, Entero_Cero)))
                             ELSE
                                Entero_Cero
                        END,
                        Entero_Cero,    Entero_Cero
                        from CUENTASCONTABLES Cue
                        left outer join DETALLEPOLIZA as Pol on (Cue.CuentaCompleta = Pol.CuentaCompleta
                                                             and Pol.Fecha <= Par_Fecha
                                                             and Pol.CentroCostoID >= Par_CCInicial
                                                             and Pol.CentroCostoID <= Par_CCFinal )
                        group by Cue.CuentaCompleta;

        update  TMPCONTABLEBALANCE  TMP,
                CUENTASCONTABLES    Cue set
            TMP.Naturaleza = Cue.Naturaleza
        where Cue.CuentaCompleta = TMP.CuentaContable
          and TMP.NumeroTransaccion = Aud_NumTransaccion;

            set Var_Ubicacion   := Ubi_Actual;

        else
            insert into TMPCONTABLEBALANCE
                select  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                    Entero_Cero, Entero_Cero,
                    (Cue.Naturaleza),
                    CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                        sum((ifnull(Pol.Cargos, Entero_Cero)))-
                        sum((ifnull(Pol.Abonos, Entero_Cero)))
                         ELSE
                      Entero_Cero
                        END,
                  CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                        sum((ifnull(Pol.Abonos, Entero_Cero)))-
                        sum((ifnull(Pol.Cargos, Entero_Cero)))
                         ELSE
                      Entero_Cero
                    END,
                    Entero_Cero,Entero_Cero
                    from  CUENTASCONTABLES Cue
                left outer join `HIS-DETALLEPOL` as Pol on (Cue.CuentaCompleta = Pol.CuentaCompleta
                                                        and Pol.Fecha >=    Var_FecIniPer
                                                        and Pol.Fecha <=    Par_Fecha
                                                        and Pol.CentroCostoID >= Par_CCInicial
                                                        and Pol.CentroCostoID <= Par_CCFinal)
                group by Cue.CuentaCompleta;

        set Var_Ubicacion   := Ubi_Histor;

        end if;


        delete from TMPSALDOCONTABLE where NumeroTransaccion  = Aud_NumTransaccion;
        insert into TMPSALDOCONTABLE
        select  Aud_NumTransaccion, Sal.CuentaCompleta, sum(CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
                                        Sal.SaldoFinal
                                    ELSE
                                        Entero_Cero
                                END) as SaldoInicialDeudor,
                sum(CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
                                        Sal.SaldoFinal
                                    ELSE
                                        Entero_Cero
                                END) as SaldoInicialAcreedor

            from    TMPCONTABLEBALANCE Tmp,
                    SALDOSCONTABLES Sal
             where Tmp.NumeroTransaccion = Aud_NumTransaccion
              and Sal.FechaCorte    = Var_FechaSaldos
              and Sal.CuentaCompleta = Tmp.CuentaContable
              and Sal.CentroCosto >= Par_CCInicial
              and Sal.CentroCosto <= Par_CCFinal
            group by Sal.CuentaCompleta ;


            update TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal set
                Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
                Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
            where Tmp.NumeroTransaccion = Aud_NumTransaccion
              and Tmp.NumeroTransaccion = Sal.NumeroTransaccion
              and Sal.CuentaContable    = Tmp.CuentaContable;


        delete from TMPSALDOCONTABLE where NumeroTransaccion  = Aud_NumTransaccion;

        INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            select  Aud_NumTransaccion, max(Fin.NombreCampo),   Cadena_Vacia, Entero_Cero,  Entero_Cero,
                Entero_Cero, Entero_Cero,
                    (CASE WHEN (Pol.Naturaleza) = VarDeudora
                         THEN
                        ifnull(sum(Pol.SaldoInicialDeu), Entero_Cero) -
                        ifnull(sum(Pol.SaldoInicialAcr), Entero_Cero) +
                        sum((ifnull(Pol.SaldoDeudor, Entero_Cero))) -
                        sum((ifnull(Pol.SaldoAcreedor, Entero_Cero)))
                         ELSE
                        ifnull(sum(Pol.SaldoInicialAcr), Entero_Cero) -
                        ifnull(sum(Pol.SaldoInicialDeu), Entero_Cero) +
                        sum((ifnull(Pol.SaldoAcreedor, Entero_Cero))) -
                        sum((ifnull(Pol.SaldoDeudor, Entero_Cero)))
                    END ),
                Entero_Cero,
                max(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
                FROM CONCEPESTADOSFIN Fin

            LEFT OUTER JOIN CUENTASCONTABLES Cue on Cue.CuentaCompleta like Fin.CuentaContable

                LEFT OUTER JOIN TMPCONTABLEBALANCE as Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                                    and Pol.Fecha = Var_FechaSistema
                                                    and Pol.NumeroTransaccion   = Aud_NumTransaccion)

            where Fin.EstadoFinanID = Tif_Balance
              and Fin.EsCalculado = 'N'
				and NumClien = NumCliente
                    group by Fin.ConceptoFinanID;


        if(For_ResulNeto != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_ResulNeto,      Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);



            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResNeto",       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_EfeRegSOCAP != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_EfeRegSOCAP,    Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapEfeRegSOCAP",   Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResActNo != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CapResActNo,    Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResTenActivosNo",       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResVal != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CapResVal,      Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
             values(
                Aud_NumTransaccion, "CapResValTitDispVen",  Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResEjeAnt != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CapResEjeAnt,   Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResultadoEjeAnt",   Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_FondoRes != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_FondoRes,       Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                values(
                Aud_NumTransaccion, "CapFondoReserva",  Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;
        if(For_CerApoOrd != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_CerApoOrd,      Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CertifAporOrd",    Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;


        if(For_TotPasCapCont != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_TotPasCapCont,  Ubi_Actual,     Por_Fecha,      Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                values(
                Aud_NumTransaccion, "TotPasCapCont",    Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;



    end if;


elseif(Par_TipoConsulta = Por_Peridodo) then

    insert into TMPCONTABLEBALANCE
        select  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                Entero_Cero, Entero_Cero,
                (Cue.Naturaleza),
                CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                    sum((ifnull(Sal.SaldoFinal, Entero_Cero)))
                     ELSE
                    Entero_Cero
                END,
                CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                    sum((ifnull(Sal.SaldoFinal, Entero_Cero)))
                    ELSE
                    Entero_Cero
                END,
                Entero_Cero,Entero_Cero

                from CUENTASCONTABLES Cue,
                     SALDOSCONTABLES as Sal
                where Sal.EjercicioID       = Par_Ejercicio
                  and Sal.PeriodoID     = Par_Periodo
                  and Cue.CuentaCompleta = Sal.CuentaCompleta
                  and Sal.CentroCosto >= Par_CCInicial
                  and Sal.CentroCosto <= Par_CCFinal
                group by Cue.CuentaCompleta;


    INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
        select  Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia,
                Entero_Cero,        Entero_Cero,        Entero_Cero,
                Entero_Cero,
                CASE WHEN (Cue.Naturaleza) = VarDeudora
                     THEN
                        sum((ifnull(Pol.SaldoDeudor, Entero_Cero))) -
                        sum((ifnull(Pol.SaldoAcreedor, Entero_Cero)))
                     ELSE
                        sum((ifnull(Pol.SaldoAcreedor, Entero_Cero))) -
                        sum((ifnull(Pol.SaldoDeudor, Entero_Cero)))
                 END,
                 Entero_Cero,
                 Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
            FROM CONCEPESTADOSFIN Fin
            LEFT OUTER JOIN CUENTASCONTABLES Cue on Cue.CuentaCompleta like Fin.CuentaContable

                LEFT OUTER JOIN TMPCONTABLEBALANCE as Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                                and Pol.Fecha = Var_FechaSistema
                                                and Pol.NumeroTransaccion   = Aud_NumTransaccion)

            where Fin.EstadoFinanID = Tif_Balance
              and Fin.EsCalculado = 'N'
				and NumClien = NumCliente
            group by Fin.ConceptoFinanID;

        select  Fin into Var_FecConsulta
                    from PERIODOCONTABLE
                    where EjercicioID   = Par_Ejercicio
                      and PeriodoID     = Par_Periodo;
        if(For_ResulNeto != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_ResulNeto,  'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                values(
                Aud_NumTransaccion, "CapResNeto",       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;


        if(For_EfeRegSOCAP != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_EfeRegSOCAP,    'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapEfeRegSOCAP",   Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResActNo != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_CapResActNo,    'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResTenActivosNo",       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResVal != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_CapResVal,  'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResValTitDispVen",  Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CapResEjeAnt != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_CapResEjeAnt,   'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapResultadoEjeAnt",   Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_FondoRes != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_FondoRes,   'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CapFondoReserva",  Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;

        if(For_CerApoOrd != Cadena_Vacia) then
            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,    For_CerApoOrd,  'H',    'F',    Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
            values(
                Aud_NumTransaccion, "CertifAporOrd",    Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,            Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;



        if(For_TotPasCapCont != Cadena_Vacia) then
            call `EVALFORMULACONTAPRO`(
                For_TotPasCapCont,  Ubi_Actual,     Por_Fecha,      Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                values(
                Aud_NumTransaccion, "TotPasCapCont",    Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                Entero_Cero,        Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
                Cadena_Vacia, Cadena_Vacia);
        end if;


end if;

update TMPBALANZACONTA set
        SaldoDeudor     = (SaldoDeudor)
        where NumeroTransaccion = Aud_NumTransaccion;


Set Var_CapitalGanado   := (
                            select SUM(SaldoDeudor)
                            from TMPBALANZACONTA
                            where  (CuentaContable like"CapFondoReserva" or CuentaContable like"CapResultadoEjeAnt" or
                                CuentaContable like'CapResValTitDispVen' or CuentaContable like'CapResValTitDispVen' or
                                CuentaContable like'CapResNeto' )
                            and NumeroTransaccion = Aud_NumTransaccion
                            );

update  TMPBALANZACONTA set
    SaldoDeudor = Var_CapitalGanado
where CuentaContable like "CapitalGanado"
 and NumeroTransaccion = Aud_NumTransaccion;


set Var_TotPasCapCont:= (
                            select SUM(SaldoDeudor)
                            from TMPBALANZACONTA
                            where  (CuentaContable like"PasTotalPasivo" or CuentaContable like"CapitalGanado" or
                                CuentaContable like'CapContribuido' )
                            and NumeroTransaccion = Aud_NumTransaccion
                            );
update  TMPBALANZACONTA set
    SaldoDeudor = Var_TotPasCapCont
where CuentaContable like "TotPasCapCont"
and NumeroTransaccion = Aud_NumTransaccion;





if(Par_Cifras = Cifras_Miles) then

    update TMPBALANZACONTA set
        SaldoDeudor     = round(SaldoDeudor/1000.00, 2)
        where NumeroTransaccion = Aud_NumTransaccion;

end if;


Set Var_NombreTabla     := concat(" tmp_", cast(ifnull(Aud_NumTransaccion, Entero_Cero) as char), " ");

Set Var_CreateTable     := concat( " create temporary table ", Var_NombreTabla,
                                   " (");

Set Var_InsertTable     := concat(" Insert into ", Var_NombreTabla, " (");

Set Var_InsertValores   := ' values( ';

Set Var_SelectTable     := concat(" Select *  From ", Var_NombreTabla, " ; ");

Set Var_DropTable       := concat(" drop table if exists ", Var_NombreTabla, "; ");

if ifnull(Aud_NumTransaccion, Entero_Cero) > Entero_Cero then

        Open  cur_Balance;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    Loop
                        Fetch cur_Balance  Into     Var_Columna, Var_Monto;
                        Set Var_CantCaracteres  := CHAR_LENGTH(Var_CreateTable);

                        Set Var_CreateTable := concat(Var_CreateTable, case when Var_CantCaracteres > 40 then " ," else " " end, Var_Columna, " decimal(18,2)");


                        Set Var_InsertTable := concat(Var_InsertTable, case when Var_CantCaracteres > 40 then " ," else " " end, Var_Columna);

                        Set Var_InsertValores   := concat(Var_InsertValores,  case when Var_CantCaracteres > 40 then " ," else " " end, cast(ifnull(Var_Monto, 0.0) as char));


                    End Loop;
                END;
        Close cur_Balance;


        Set Var_CreateTable     := concat(Var_CreateTable, ',MostrarPoderAdRep char(1)', "); ");
        Set Var_InsertTable     := concat(Var_InsertTable, ',MostrarPoderAdRep');
        Set Var_InsertTable     := concat(Var_InsertTable, ") ", Var_InsertValores, ",'",Var_MostrarP,"');  ");


        SET @Sentencia  = (Var_CreateTable);
        PREPARE Tabla FROM @Sentencia;
        EXECUTE  Tabla;
        DEALLOCATE PREPARE Tabla;

        SET @Sentencia  = (Var_InsertTable);
        PREPARE InsertarValores FROM @Sentencia;
        EXECUTE  InsertarValores;
        DEALLOCATE PREPARE InsertarValores;


        SET @Sentencia  = (Var_SelectTable);
        PREPARE SelectTable FROM @Sentencia;
        EXECUTE  SelectTable;
        DEALLOCATE PREPARE SelectTable;



        SET @Sentencia  = concat( Var_DropTable);
        PREPARE DropTable FROM @Sentencia;
        EXECUTE  DropTable;
        DEALLOCATE PREPARE DropTable;

end if;

delete from TMPCONTABLEBALANCE
    where NumeroTransaccion = Aud_NumTransaccion;

delete from TMPBALANZACONTA
    where NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$