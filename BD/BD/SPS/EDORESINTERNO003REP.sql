-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO003REP`;DELIMITER $$

CREATE PROCEDURE `EDORESINTERNO003REP`(
    Par_Ejercicio       int,
    Par_Periodo         int,
    Par_Fecha           date,
    Par_TipoConsulta    char(1),
    Par_SaldosCero      char(1),
    Par_Cifras          char(1),

    Par_CCInicial        int,
    Par_CCFinal          int,

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
DECLARE Var_Ubicacion   char(1);
DECLARE Var_MostrarP    char(1);

DECLARE Var_Columna         varchar(20);
DECLARE Var_Monto           decimal(18,2);
DECLARE Var_Ingresos        decimal(18,2);
DECLARE Var_ResNeto         decimal(18,2);
DECLARE Var_ResOpera        decimal(18,2);
DECLARE Var_NombreTabla     varchar(40);
DECLARE Var_CreateTable     varchar(9000);
DECLARE Var_InsertTable     varchar(5000);
DECLARE Var_InsertValores   varchar(5000);
DECLARE Var_SelectTable     varchar(5000);
DECLARE Var_UpdateAbs       varchar(5000);
DECLARE Var_UpdateIng       varchar(5000);
DECLARE Var_UpdateResNet    varchar(5000);
DECLARE Var_UpdateResOpera  varchar(5000);
DECLARE Var_UpdateResOpeDis varchar(5000);
DECLARE Var_DropTable       varchar(5000);
DECLARE For_Ingresos        varchar(500);
DECLARE Des_Ingresos        varchar(200);
DECLARE Con_Ingresos        int;
DECLARE Des_ResNeto         varchar(200);
DECLARE Con_ResNeto         int;
DECLARE For_ResNeto         varchar(500);
DECLARE Des_ResOpera        varchar(200);
DECLARE Con_ResOpera        int;
DECLARE For_ResOpera        varchar(500);
DECLARE Var_CantCaracteres  int;

DECLARE Var_MinCenCos   int;
DECLARE Var_MaxCenCos   int;

DECLARE Var_IngPorInteres   decimal(18,2);
DECLARE Var_GasPorInteres   decimal(18,2);
DECLARE Var_EstimacionPrev  decimal(18,2);
DECLARE Var_GastAdmonProm   decimal(18,2);
DECLARE Var_ComCobradas     decimal(18,2);
DECLARE Var_OtrosIngEgresos decimal(18,2);
DECLARE Var_ComPagadas      decimal(18,2);
DECLARE Var_PartResulSubsi  decimal(18,2);

DECLARE Var_ResAntOpDis     decimal(18,2);


DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE VarDeudora      char(1);
DECLARE VarAcreedora    char(1);
DECLARE Tip_Encabezado  char(1);
DECLARE No_SaldoCeros   char(1);
DECLARE Cifras_Pesos    char(1);
DECLARE Cifras_Miles    char(1);
DECLARE Por_Peridodo    char(1);
DECLARE Por_Fecha       char(1);
DECLARE Datos_Director  char(1);
DECLARE Ubi_Actual      char(1);
DECLARE Ubi_Histor      char(1);
DECLARE Tif_EdoResul    int;
DECLARE Var_UltPeriodoCie   int;
DECLARE Var_UltEjercicioCie int;
DECLARE Est_Cerrado     char(1);
DECLARE NumCliente		int;

DECLARE cur_Balance cursor for
    select CuentaContable,  SaldoDeudor
        from TMPBALANZACONTA
        where NumeroTransaccion = Aud_NumTransaccion
        order by CuentaContable;



Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
set VarDeudora      := 'D';
set VarAcreedora    := 'A';
set Tip_Encabezado  := 'E';
set No_SaldoCeros   := 'N';
set Cifras_Pesos    := 'P';
set Cifras_Miles    := 'M';
set Por_Peridodo    := 'P';
set Por_Fecha       := 'D';
set Datos_Director  := 'F';
set Ubi_Actual      := 'A';
set Ubi_Histor      := 'H';
set Tif_EdoResul    := 2;
set Est_Cerrado     := 'C';
set Var_MostrarP    := (select ValorParametro from PARAMGENERALES where LlaveParametro like "MostrarPoderAdRep");
set Var_MostrarP    := ifnull(Var_MostrarP, 'N');
set Con_Ingresos    := 207;
set Con_ResNeto     := 211;
set Con_ResOpera    := 212;
set NumCliente		:= 3;

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
select CuentaContable, Desplegado  into For_Ingresos, Des_Ingresos
    from CONCEPESTADOSFIN
    where EstadoFinanID = 2
      and ConceptoFinanID = Con_Ingresos
		and NumClien = NumCliente;

set For_Ingresos   := ifnull(For_Ingresos, Cadena_Vacia);
set Des_Ingresos   := ifnull(Des_Ingresos, Cadena_Vacia);



select CuentaContable, Desplegado  into For_ResNeto, Des_ResNeto
    from CONCEPESTADOSFIN
    where EstadoFinanID = 2
      and ConceptoFinanID = Con_ResNeto
		and NumClien = NumCliente;

set For_ResNeto   := ifnull(For_ResNeto, Cadena_Vacia);
set Des_ResNeto   := ifnull(Des_ResNeto, Cadena_Vacia);

select CuentaContable, Desplegado  into For_ResOpera, Des_ResOpera
    from CONCEPESTADOSFIN
    where EstadoFinanID = 2
      and ConceptoFinanID = Con_ResOpera
		and NumClien = NumCliente;

set For_ResOpera   := ifnull(For_ResOpera, Cadena_Vacia);
set Des_ResOpera   := ifnull(Des_ResOpera, Cadena_Vacia);



set Par_CCInicial   := ifnull(Par_CCInicial, Entero_Cero);
set Par_CCFinal     := ifnull(Par_CCFinal, Entero_Cero);



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

select min(CentroCostoID), max(CentroCostoID) into Var_MinCenCos, Var_MaxCenCos
    from CENTROCOSTOS;

if(Par_CCInicial = Entero_Cero or Par_CCFinal = Entero_Cero) then
    set Par_CCInicial   := Var_MinCenCos;
    set Par_CCFinal     := Var_MaxCenCos;
end if;


if (Par_TipoConsulta = Datos_Director) then
    SELECT NombreRepresentante, JefeContabilidad FROM PARAMETROSSIS LIMIT 1;

ELSE IF (Par_TipoConsulta = Por_Fecha) then

            select max(FechaCorte) into Var_FechaSaldos
                from  SALDOSCONTABLES
                where FechaCorte <= Par_Fecha;

            set Var_FechaSaldos = ifnull(Var_FechaSaldos, Fecha_Vacia);

            if (Var_FechaSaldos = Fecha_Vacia) then
                    insert into TMPCONTABLEBALANCE
                    select Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
                            Entero_Cero, Entero_Cero,
                            (Cue.Naturaleza),
                            CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                                    sum(round(ifnull(Pol.Cargos, Entero_Cero), 2))-
                                    sum(round(ifnull(Pol.Abonos, Entero_Cero), 2))
                                     ELSE
                                  Entero_Cero
                            END,
                            CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                    sum(round(ifnull(Pol.Abonos, Entero_Cero), 2))-
                                    sum(round(ifnull(Pol.Cargos, Entero_Cero), 2))
                                     ELSE
                                  Entero_Cero
                            END,
                            Entero_Cero, Entero_Cero

                            from CUENTASCONTABLES Cue,
                                 DETALLEPOLIZA as Pol
                            where Cue.CuentaCompleta = Pol.CuentaCompleta
                              and Pol.Fecha         <= Par_Fecha
                              and Pol.CentroCostoID >= Par_CCInicial
                              and Pol.CentroCostoID <= Par_CCFinal
                            group by Cue.CuentaCompleta;

                    INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                    select
                        Aud_NumTransaccion,     Fin.NombreCampo,            Cadena_Vacia,       Entero_Cero,            Entero_Cero,
                        Entero_Cero,            Entero_Cero,
                                                                           CASE WHEN (Cue.Naturaleza) = VarDeudora
                                                                                THEN
                                                                                   sum(round(ifnull(Pol.SaldoDeudor, Entero_Cero), 2)) -
                                                                                   sum(round(ifnull(Pol.SaldoAcreedor, Entero_Cero), 2))
                                                                                ELSE
                                                                                   sum(round(ifnull(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                                                                                   sum(round(ifnull(Pol.SaldoDeudor, Entero_Cero), 2))
                                                                           END,
                        Entero_Cero,            Fin.Desplegado,             Cadena_Vacia,       Cadena_Vacia
                        FROM CONCEPESTADOSFIN Fin
                    LEFT OUTER JOIN CUENTASCONTABLES Cue on Cue.CuentaCompleta like Fin.CuentaContable

                    LEFT OUTER JOIN TMPCONTABLEBALANCE as Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                                       and Pol.NumeroTransaccion    = Aud_NumTransaccion)

                    where Fin.EstadoFinanID = Tif_EdoResul
                      and Fin.EsCalculado = 'N'
						and NumClien = NumCliente
                        group by Fin.ConceptoFinanID;


                     if(For_Ingresos != Cadena_Vacia) then
                        call `EVALFORMULACONTAPRO`(
                            For_Ingresos,      Ubi_Actual,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                            Var_UltPeriodoCie,  Par_Fecha,      Var_Ingresos,       Par_CCInicial,      Par_CCFinal,
                            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,       Aud_NumTransaccion);


                    end if;


                    if(For_ResNeto != Cadena_Vacia) then
                        call `EVALFORMULACONTAPRO`(
                            For_ResNeto,        Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                            Var_UltPeriodoCie,  Par_Fecha,      Var_ResNeto,        Par_CCInicial,      Par_CCFinal,
                            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,       Aud_NumTransaccion);


                    end if;

                    if(For_ResOpera != Cadena_Vacia) then
                        call `EVALFORMULACONTAPRO`(
                            For_ResOpera,       Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                            Var_UltPeriodoCie,  Par_Fecha,      Var_ResOpera,       Par_CCInicial,      Par_CCFinal,
                            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,       Aud_NumTransaccion);


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
                                            sum(round(ifnull(Pol.Cargos, Entero_Cero), 2))-
                                            sum(round(ifnull(Pol.Abonos, Entero_Cero), 2))
                                         ELSE
                                            Entero_Cero
                                        END,
                                    CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                            sum(round(ifnull(Pol.Abonos, Entero_Cero), 2))-
                                            sum(round(ifnull(Pol.Cargos, Entero_Cero), 2))
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


                                    set Var_Ubicacion   := Ubi_Actual;



                                     if(For_Ingresos != Cadena_Vacia) then
                                        call `EVALFORMULACONTAPRO`(
                                            For_Ingresos,      Ubi_Actual,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                                            Var_UltPeriodoCie,  Par_Fecha,      Var_Ingresos,   Par_CCInicial,      Par_CCFinal,
                                            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                            Aud_Sucursal,       Aud_NumTransaccion);

                                    end if;

                                    if(For_ResNeto != Cadena_Vacia) then
                                        call `EVALFORMULACONTAPRO`(
                                            For_ResNeto,        Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                                            Var_UltPeriodoCie,  Par_Fecha,      Var_ResNeto,        Par_CCInicial,      Par_CCFinal,
                                            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                            Aud_Sucursal,       Aud_NumTransaccion);

                                    end if;

                                    if(For_ResOpera != Cadena_Vacia) then
                                    call `EVALFORMULACONTAPRO`(
                                            For_ResOpera,       Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                                            Var_UltPeriodoCie,  Par_Fecha,      Var_ResOpera,       Par_CCInicial,      Par_CCFinal,
                                            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                            Aud_Sucursal,       Aud_NumTransaccion);

                                    end if;

                        else

                                insert into TMPCONTABLEBALANCE
                                select  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                                    Entero_Cero, Entero_Cero,
                                    (Cue.Naturaleza),
                                    CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                                            sum(round(ifnull(Pol.Cargos, Entero_Cero), 2))-
                                            sum(round(ifnull(Pol.Abonos, Entero_Cero), 2))
                                         ELSE
                                            Entero_Cero
                                        END,
                                    CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                            sum(round(ifnull(Pol.Abonos, Entero_Cero), 2))-
                                            sum(round(ifnull(Pol.Cargos, Entero_Cero), 2))
                                         ELSE
                                            Entero_Cero
                                    END,
                                    Entero_Cero,    Entero_Cero
                                    from  CUENTASCONTABLES Cue
                                left outer join `HIS-DETALLEPOL` as Pol on (Cue.CuentaCompleta = Pol.CuentaCompleta
                                                                        and Pol.Fecha >=    Var_FecIniPer
                                                                        and Pol.Fecha <=    Par_Fecha
                                                                        and Pol.CentroCostoID >= Par_CCInicial
                                                                        and Pol.CentroCostoID <= Par_CCFinal )
                                group by Cue.CuentaCompleta;

                                set Var_Ubicacion   := Ubi_Histor;

                                if(For_Ingresos != Cadena_Vacia) then
                                    call `EVALFORMULACONTAPRO`(
                                        For_Ingresos,      Var_Ubicacion,   Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                                        Var_UltPeriodoCie,  Var_FecIniPer,  Var_Ingresos,   Par_CCInicial,      Par_CCFinal,
                                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                        Aud_Sucursal,       Aud_NumTransaccion);
                                end if;

                                if(For_ResNeto != Cadena_Vacia) then
                                    call `EVALFORMULACONTAPRO`(
                                        For_ResNeto,        Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                                        Var_UltPeriodoCie,  Var_FecIniPer,  Var_ResNeto,        Par_CCInicial,      Par_CCFinal,
                                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                        Aud_Sucursal,       Aud_NumTransaccion);
                                end if;

                                if(For_ResOpera != Cadena_Vacia) then
                                    call `EVALFORMULACONTAPRO`(
                                        For_ResOpera,       Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                                        Var_UltPeriodoCie,  Var_FecIniPer,  Var_ResOpera,       Par_CCInicial,      Par_CCFinal,
                                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                        Aud_Sucursal,       Aud_NumTransaccion);
                                end if;

                    end if;


                    if(Var_FechaSaldos != Par_Fecha) then
                        drop temporary table if exists TMPSALDOSCONTABLES;
                        create temporary table if not exists TMPSALDOSCONTABLES(
                                                                    CuentaCompleta  VARCHAR(25),
                                                                    FechaCorte      DATE,
                                                                    SaldoFinal      DECIMAL(16,4));
                        insert into TMPSALDOSCONTABLES (CuentaCompleta,     FechaCorte,     SaldoFinal)
                        select                          CuentaCompleta,     FechaCorte,     sum(SaldoFinal)
                                    from SALDOSCONTABLES
                                        where FechaCorte    = Var_FechaSaldos
                                         and CentroCosto >= Par_CCInicial
                                         and CentroCosto <= Par_CCFinal
                                            group by CuentaCompleta;


                        update TMPCONTABLEBALANCE Tmp, TMPSALDOSCONTABLES Sal
                        set
                            Tmp.SaldoInicialDeu =  CASE WHEN Naturaleza = VarDeudora  THEN
                                                        Sal.SaldoFinal
                                                    ELSE
                                                        Entero_Cero
                                                END,
                            Tmp.SaldoInicialAcr = CASE WHEN Naturaleza = VarAcreedora  THEN
                                                         Sal.SaldoFinal
                                                    ELSE
                                                        Entero_Cero
                                                END
                        where Tmp.NumeroTransaccion = Aud_NumTransaccion
                          and Sal.CuentaCompleta = Tmp.CuentaContable
                          and Sal.FechaCorte    = Var_FechaSaldos;

                end if;


                INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                    select Aud_NumTransaccion, max(Fin.NombreCampo),        Cadena_Vacia,       Entero_Cero,            Entero_Cero,
                        Entero_Cero,            Entero_Cero,
                                                                            (CASE WHEN max(Pol.Naturaleza) = VarDeudora
                                                                                 THEN
                                                                                ifnull(sum(Pol.SaldoInicialDeu), Entero_Cero) -
                                                                                ifnull(sum(Pol.SaldoInicialAcr), Entero_Cero) +
                                                                                sum(round(ifnull(Pol.SaldoDeudor, Entero_Cero), 2)) -
                                                                                sum(round(ifnull(Pol.SaldoAcreedor, Entero_Cero), 2))
                                                                                 ELSE
                                                                                ifnull(sum(Pol.SaldoInicialAcr), Entero_Cero) -
                                                                                ifnull(sum(Pol.SaldoInicialDeu), Entero_Cero) +
                                                                                sum(round(ifnull(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                                                                                sum(round(ifnull(Pol.SaldoDeudor, Entero_Cero), 2))
                                                                            END ),
                        Entero_Cero,            max(Fin.Descripcion),   Cadena_Vacia,       Cadena_Vacia
                        FROM CONCEPESTADOSFIN Fin
                     LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta like Fin.CuentaContable)

                        LEFT OUTER JOIN TMPCONTABLEBALANCE as Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                                            and Pol.Fecha = Var_FechaSistema
                                                            and Pol.NumeroTransaccion   = Aud_NumTransaccion)
                    where Fin.EstadoFinanID = Tif_EdoResul
                      and Fin.EsCalculado = 'N'
						and NumClien = NumCliente
                        group by Fin.ConceptoFinanID;

                if(For_Ingresos != Cadena_Vacia) then
                    call `EVALFORMULACONTAPRO`(
                        For_Ingresos,      Var_Ubicacion,   Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Var_FecIniPer,  Var_Ingresos,   Par_CCInicial,      Par_CCFinal,
                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                end if;

                if(For_ResNeto != Cadena_Vacia) then
                    call `EVALFORMULACONTAPRO`(
                        For_ResNeto,        Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Var_FecIniPer,  Var_ResNeto,        Par_CCInicial,      Par_CCFinal,
                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                end if;

                if(For_ResOpera != Cadena_Vacia) then
                    call `EVALFORMULACONTAPRO`(
                        For_ResOpera,       Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Var_FecIniPer,  Var_ResOpera,       Par_CCInicial,      Par_CCFinal,
                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                end if;


            end if;


        elseif(Par_TipoConsulta = Por_Peridodo) then

                insert into TMPCONTABLEBALANCE
                select  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                        Entero_Cero, Entero_Cero,
                        (Cue.Naturaleza),
                        CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                            sum(round(ifnull(Sal.SaldoFinal, Entero_Cero), 2))
                             ELSE
                            Entero_Cero
                        END,
                        CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                            sum(round(ifnull(Sal.SaldoFinal, Entero_Cero), 2))
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
                select  Aud_NumTransaccion,     Fin.NombreCampo,            Cadena_Vacia,       Entero_Cero,            Entero_Cero,
                        Entero_Cero,            Entero_Cero,
                                                                            CASE WHEN (Cue.Naturaleza) = VarDeudora
                                                                                 THEN
                                                                                    sum(round(ifnull(Pol.SaldoDeudor, Entero_Cero), 2)) -
                                                                                    sum(round(ifnull(Pol.SaldoAcreedor, Entero_Cero), 2))
                                                                                 ELSE
                                                                                    sum(round(ifnull(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                                                                                    sum(round(ifnull(Pol.SaldoDeudor, Entero_Cero), 2))
                                                                             END,
                         Entero_Cero,           Fin.Descripcion,    Cadena_Vacia,               Cadena_Vacia
                    FROM CONCEPESTADOSFIN Fin
                    LEFT OUTER JOIN CUENTASCONTABLES Cue on Cue.CuentaCompleta like Fin.CuentaContable
                        LEFT OUTER JOIN TMPCONTABLEBALANCE as Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                                        and Pol.Fecha = Var_FechaSistema
                                                        and Pol.NumeroTransaccion   = Aud_NumTransaccion)

                    where Fin.EstadoFinanID = Tif_EdoResul
                      and Fin.EsCalculado = 'N'
						and NumClien = NumCliente
                    group by Fin.ConceptoFinanID;


            if(For_Ingresos != Cadena_Vacia) then
                CALL EVALFORMULAREGPRO(Var_Ingresos,    For_Ingresos,   'H',    'F',    Var_FecConsulta);


            end if;

            if(For_ResNeto != Cadena_Vacia) then
                CALL EVALFORMULAREGPRO(Var_ResNeto, For_ResNeto,    'H',    'F',    Var_FecConsulta);
            end if;

            if(For_ResOpera != Cadena_Vacia) then
                CALL EVALFORMULAREGPRO(Var_ResOpera,For_ResOpera,   'H',    'F',    Var_FecConsulta);
            end if;

        end if;

        update TMPBALANZACONTA set

            SaldoDeudor     = (SaldoDeudor)
        where NumeroTransaccion = Aud_NumTransaccion;


                INSERT INTO TMPBALANZACONTA
                        (`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
                        `Cargos`,               `Abonos`,                   `SaldoDeudor`,
                        `SaldoAcreedor`,        `DescripcionCuenta`,        `CuentaMayor`,      `CentroCosto`)
                select  Aud_NumTransaccion,     'ResAntOpDis',              Cadena_Vacia,       Entero_Cero,            Entero_Cero,
                        Entero_Cero,            Entero_Cero,                Entero_Cero,
                        Entero_Cero,    'ResAntOpDis' ,                     Cadena_Vacia,       Cadena_Vacia;


         set Var_IngPorInteres  := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='IngPorInteres'and NumeroTransaccion =  Aud_NumTransaccion);
         set Var_GasPorInteres  := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='GasPorInteres'and NumeroTransaccion =  Aud_NumTransaccion);
         set Var_EstimacionPrev := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='EstimacionPrev'and NumeroTransaccion =  Aud_NumTransaccion);
         set Var_GastAdmonProm  := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='GastAdmonProm'and NumeroTransaccion =  Aud_NumTransaccion);
         set Var_ComCobradas    := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='ComCobradas'and NumeroTransaccion =  Aud_NumTransaccion);
         set Var_OtrosIngEgresos:= Var_Ingresos;
         set Var_ComPagadas     := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='ComPagadas'and NumeroTransaccion =  Aud_NumTransaccion);
         set Var_PartResulSubsi := (select SaldoDeudor from TMPBALANZACONTA
                                    where CuentaContable='PartResulSubsi'and NumeroTransaccion =  Aud_NumTransaccion);



        set Var_ResAntOpDis:=ifnull(Var_ResOpera,Entero_Cero) - ifnull(Var_PartResulSubsi,Entero_Cero);



        if(Par_Cifras = Cifras_Miles) then

            update TMPBALANZACONTA set

                SaldoDeudor     = round(SaldoDeudor/1000.00, 2)
                where NumeroTransaccion = Aud_NumTransaccion;

            set Var_Ingresos    := round(Var_Ingresos/1000.00, 2);
            set Var_ResNeto     := round(Var_ResNeto/1000.00,2);
            set Var_ResOpera    := round(Var_ResOpera/1000.00,2);
            set Var_ResAntOpDis := round(Var_ResAntOpDis/1000.00,2);


        end if;


        Set Var_NombreTabla     := concat(" tmp_", cast(ifnull(Aud_NumTransaccion, Entero_Cero) as char), " ");

        Set Var_CreateTable     := concat( " create temporary table ", Var_NombreTabla,
                                           " (");

        Set Var_InsertTable     := concat(" Insert into ", Var_NombreTabla, " (");

        Set Var_InsertValores   := ' values( ';

        Set Var_SelectTable     := concat(" Select * From ", Var_NombreTabla, "; ");

        Set Var_UpdateAbs       := concat(" update  ", Var_NombreTabla, " set
                                            ComCobradas     := abs(ComCobradas),
                                            ComPagadas      := abs(ComPagadas),
                                            EstimacionPrev  := abs(EstimacionPrev),
                                            GasPorInteres   := abs(GasPorInteres),
                                            GastAdmonProm   := abs(GastAdmonProm),
                                            IngPorInteres   := abs(IngPorInteres),
                                            OperaDiscon     := abs(OperaDiscon),
                                            PartResulSubsi  := abs(PartResulSubsi),
                                            ResulIntermediacion:=(ResulIntermediacion*-1),
                                            ResulPosMone    := abs(ResulPosMone);");



        set @Var_Ingresos := Var_Ingresos;
        Set Var_UpdateIng       := concat("  update  ", Var_NombreTabla, " set
                                            OtrosIngEgresos := @Var_Ingresos; ");


        set @Var_ResNeto    := Var_ResNeto;
        Set Var_UpdateResNet:= concat("  update  ", Var_NombreTabla, " set
                                            ResultadoNeto   := @Var_ResNeto; ");

        set @Var_ResOpera     := Var_ResOpera;
        Set Var_UpdateResOpera:= concat("  update  ", Var_NombreTabla, " set
                                            ResultadoOpera  := @Var_ResOpera; ");

        set @Var_ResAntOpDis      := Var_ResAntOpDis;
        set Var_UpdateResOpeDis := concat(" update  ", Var_NombreTabla, " set
                                            ResAntOpDis :=  @Var_ResAntOpDis  ; ");








        Set Var_DropTable       := concat(" drop table if exists ", Var_NombreTabla, "; ");


        if ifnull(Aud_NumTransaccion, Entero_Cero) > Entero_Cero then

                Open  cur_Balance;
                        BEGIN
                            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                            Loop
                                Fetch cur_Balance  Into     Var_Columna, Var_Monto;

                                Set Var_CantCaracteres  :=  CHAR_LENGTH(Var_CreateTable) ;

                                Set Var_CreateTable := concat(Var_CreateTable, case when Var_CantCaracteres > 40 then " ," else " " end, Var_Columna, " decimal(18,2)");


                                Set Var_InsertTable := concat(Var_InsertTable, case when Var_CantCaracteres > 40 then " ," else " " end, Var_Columna);

                                Set Var_InsertValores   := concat(Var_InsertValores,  case when Var_CantCaracteres > 40 then " ," else " " end, cast(Var_Monto as char));


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


                SET @Sentencia  = (Var_UpdateAbs);
                PREPARE ActualizarValores FROM @Sentencia;
                EXECUTE  ActualizarValores;
                DEALLOCATE PREPARE ActualizarValores;


                SET @Sentencia  = (Var_UpdateIng);
                PREPARE ActualizarValores FROM @Sentencia;
                EXECUTE  ActualizarValores;
                DEALLOCATE PREPARE ActualizarValores;


                SET @Sentencia  = (Var_UpdateResNet);
                PREPARE ActualizarValores FROM @Sentencia;
                EXECUTE  ActualizarValores;
                DEALLOCATE PREPARE ActualizarValores;


                SET @Sentencia  = (Var_UpdateResOpera);
                PREPARE ActualizarValores FROM @Sentencia;
                EXECUTE  ActualizarValores;
                DEALLOCATE PREPARE ActualizarValores;

                SET @Sentencia  = (Var_UpdateResOpeDis);
                PREPARE ActualizarValores FROM @Sentencia;
                EXECUTE  ActualizarValores;
                DEALLOCATE PREPARE ActualizarValores;




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
end if;

END TerminaStore$$