-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUADREOPECONTAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUADREOPECONTAREP`;DELIMITER $$

CREATE PROCEDURE `CUADREOPECONTAREP`(
    Par_Fecha           DATE,
    Par_TipoReporte     INT,
    Par_NivDetalle      CHAR(1),
    Par_UsuarioID       INT
        )
BEGIN


DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaFinal      DATE;

DECLARE Comercial_CapVigente        DECIMAL(14,2);
DECLARE Comercial_IntVigente        DECIMAL(14,2);
DECLARE Comercial_IntAtrasado       DECIMAL(14,2);
DECLARE Comercial_IntMoraVigente    DECIMAL(14,2);
DECLARE Comercial_CapVencido        DECIMAL(14,2);
DECLARE Comercial_IntVencido        DECIMAL(14,2);
DECLARE Comercial_IntMoraVencido    DECIMAL(14,2);
DECLARE Comercial_IntCtaOrden       DECIMAL(14,2);
DECLARE Comercial_IntMoraCtaOrden   DECIMAL(14,2);
DECLARE Consumo_CapVigente          DECIMAL(14,2);
DECLARE Consumo_IntVigente          DECIMAL(14,2);
DECLARE Consumo_IntAtrasado         DECIMAL(14,2);
DECLARE Consumo_IntMoraVigente      DECIMAL(14,2);
DECLARE Consumo_CapVencido          DECIMAL(14,2);
DECLARE Consumo_IntVencido          DECIMAL(14,2);
DECLARE Consumo_IntMoraVencido      DECIMAL(14,2);
DECLARE Consumo_IntCtaOrden         DECIMAL(14,2);
DECLARE Consumo_IntMoraCtaOrden     DECIMAL(14,2);
DECLARE Vivienda_CapVigente         DECIMAL(14,2);
DECLARE Vivienda_IntVigente         DECIMAL(14,2);
DECLARE Vivienda_CapVencido         DECIMAL(14,2);
DECLARE Vivienda_IntVencido         DECIMAL(14,2);
DECLARE Vivienda_IntMoraVencido     DECIMAL(14,2);
DECLARE Vivienda_IntCtaOrden        DECIMAL(14,2);
DECLARE Vivienda_IntMoraCtaOrden    DECIMAL(14,2);

DECLARE Conta_SaldoInversion        DECIMAL(14,2);
DECLARE Conta_InversionGarantia     DECIMAL(14,2);
DECLARE AhorroVista_SinGravamen     DECIMAL(14,2);
DECLARE AhorroVista_ConGravamen     DECIMAL(14,2);
DECLARE Depositos_SinGravamen       DECIMAL(14,2);
DECLARE Depositos_ConGravamen       DECIMAL(14,2);
DECLARE Menores                     DECIMAL(14,2);
DECLARE var_Resultado               DECIMAL(14,2);

DECLARE Tipo_CuentasAhorro  INT;
DECLARE Tipo_Inversiones    INT;
DECLARE Tipo_InvEnGarantia  INT;
DECLARE Tipo_SaldosCartera  INT;
DECLARE Tipo_PartesSociales INT;
DECLARE Tipo_ContaCartera   INT;
DECLARE Tipo_ContaAhorro    INT;
DECLARE Tipo_ContaInversion INT;
DECLARE Tipo_ContaInvGarant INT;

DECLARE Cons_BloqGarLiq     INT;

DECLARE Var_FechaSistema            DATE;
DECLARE var_SalTotalInvOpera        DECIMAL(14,2);
DECLARE var_SalTotalInvConta        DECIMAL(14,2);
DECLARE var_Operativo_InvGarantia   DECIMAL(14,2);
DECLARE var_Conta_InvGarantia       DECIMAL(14,2);
DECLARE var_Ope_SinGravamen         DECIMAL(14,2);
DECLARE Var_Conta_SinGravamen       DECIMAL(14,2);
DECLARE var_Ope_ConGravamen         DECIMAL(14,2);
DECLARE var_Conta_ConGravamen       DECIMAL(14,2);
DECLARE Entero_Cero                 INT(1);
DECLARE Var_SaldoContableAporta     DECIMAL(14,2);
DECLARE Var_SaldoOperatiAporta      DECIMAL(14,2);

SET Tipo_CuentasAhorro  := 1;
SET Tipo_Inversiones    := 2;
SET Tipo_InvEnGarantia  := 3;
SET Tipo_SaldosCartera  := 4;
SET Tipo_PartesSociales := 5;

SET Tipo_ContaCartera   := 20;
SET Tipo_ContaAhorro    := 21;
SET Tipo_ContaInversion := 22;
SET Tipo_ContaInvGarant := 23;



SET Cons_BloqGarLiq      = 8;
SET Entero_Cero         := 0;

SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);


IF(Par_TipoReporte = Tipo_SaldosCartera) THEN

    IF(Par_NivDetalle = 'D') THEN

        SELECT  Sal.CreditoID, Sal.ClienteID, Suc.SucursalID, Suc.NombreSucurs, Sal.DiasAtraso,
              Sal.ProductoCreditoID, Pro.Descripcion,
              Des.Clasificacion, Des.SubClasifID, Cla.TipoClasificacion, Cla.DescripClasifica,
              Sal.SalCapVigente, Sal.SalCapAtrasado, Sal.SalCapVencido, Sal.SalCapVenNoExi,
              Sal.SalIntProvision, Sal.SalIntAtrasado,
              Sal.SalIntVencido, Sal.SalIntNoConta, Sal.SalMoratorios,
              Sal.SaldoMoraVencido, Sal.SaldoMoraCarVen

        FROM SALDOSCREDITOS Sal,
             PRODUCTOSCREDITO Pro,
             DESTINOSCREDITO Des,
             CLASIFICCREDITO Cla,
            CLIENTES Cli,
            SUCURSALES Suc

        WHERE FechaCorte = Par_Fecha
          AND Sal.ProductoCreditoID = Pro.ProducCreditoID
          AND Sal.DestinoCreID     = Des.DestinoCreID
          AND Des.SubClasifID = Cla.ClasificacionID
          AND Sal.ClienteID = Cli.ClienteID
          AND Cli.SucursalOrigen = Suc.SucursalID
        ORDER BY Clasificacion, SubClasifID, Suc.SucursalID;
    ELSE

        DROP  TABLE IF EXISTS tmp_CREDITOTOTALES;

        CREATE  TABLE tmp_CREDITOTOTALES(
            Clasificacion           CHAR(1),
            Ope_CapitalVig          DECIMAL(14,2),
            Con_CapitalVig          DECIMAL(14,2),

            Ope_CapVencido          DECIMAL(14,2),
            Con_CapVencido          DECIMAL(14,2),

            Ope_InteresVig          DECIMAL(14,2),
            Con_InteresVig          DECIMAL(14,2),

            Ope_InteresAtrasado     DECIMAL(14,2),
            Con_InteresAtrasado     DECIMAL(14,2),

            Ope_InteresVencido      DECIMAL(14,2),
            Con_InteresVencido      DECIMAL(14,2),

            Ope_InteresCtaOrden     DECIMAL(14,2),
            Con_InteresCtaOrden     DECIMAL(14,2),

            Ope_Moratorios          DECIMAL(14,2),
            Con_Moratorios          DECIMAL(14,2),

            Ope_MoratorioVencido    DECIMAL(14,2),
            Con_MoratorioVencido    DECIMAL(14,2),

            Ope_MoratorioCtasOrden  DECIMAL(14,2),
            Con_MoratorioCtasOrden  DECIMAL(14,2)   );



        INSERT INTO tmp_CREDITOTOTALES
            SELECT  Des.Clasificacion, SUM(Sal.SalCapVigente + Sal.SalCapAtrasado) AS CapitalVig, 0,
                    SUM(Sal.SalCapVencido + Sal.SalCapVenNoExi) AS CapitalVencido, 0,
                    SUM(Sal.SalIntProvision) AS InteresVig, 0,
                    SUM(Sal.SalIntAtrasado) AS InteresAtrasado, 0,
                    SUM(Sal.SalIntVencido) AS InteresVencido, 0,
                    SUM(Sal.SalIntNoConta)  AS InteresCtaOrden, 0,
                    SUM(Sal.SalMoratorios)  AS Moratorios, 0,
                    SUM(Sal.SaldoMoraVencido)   AS MoratorioVencido, 0,
                    SUM(Sal.SaldoMoraCarVen) AS MoratorioCtasOrden, 0

            FROM SALDOSCREDITOS Sal,
                 DESTINOSCREDITO Des

            WHERE FechaCorte = Par_Fecha
              AND Sal.DestinoCreID     = Des.DestinoCreID
            GROUP BY Des.Clasificacion;


    SELECT SUM(CASE WHEN CuentaCompleta LIKE '1301010101010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010202%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010203%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010203%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010101010001%' THEN Abonos - Cargos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020101010001%' THEN Abonos - Cargos ELSE 0 END ),


           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010100%'
                      OR CuentaCompleta LIKE '1301020700010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010201%'
                      OR CuentaCompleta LIKE '1301020700010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010202%'
                      OR CuentaCompleta LIKE '1301020700010202%' THEN Cargos - Abonos ELSE 0 END ),

           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010203%'
                     OR  CuentaCompleta LIKE '1301020700010203%' THEN Cargos - Abonos ELSE 0 END ),

           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010100%'
                      OR CuentaCompleta LIKE '1302020700010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010201%'
                      OR CuentaCompleta LIKE '1302020700010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010203%'
                      OR CuentaCompleta LIKE '1302020700010203%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010201020001%'
                      OR CuentaCompleta LIKE '6208010201070001%' THEN Abonos - Cargos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020201020001%'
                      OR CuentaCompleta LIKE '6208020201070001%' THEN Abonos - Cargos ELSE 0 END ),

           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010203%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010301010001%' THEN Abonos - Cargos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020301010001%' THEN Abonos - Cargos ELSE 0 END ) INTO

            Comercial_CapVigente,   Comercial_IntVigente,       Comercial_IntAtrasado,  Comercial_IntMoraVigente,   Comercial_CapVencido,
            Comercial_IntVencido,   Comercial_IntMoraVencido,   Comercial_IntCtaOrden,  Comercial_IntMoraCtaOrden,

            Consumo_CapVigente,     Consumo_IntVigente,         Consumo_IntAtrasado,    Consumo_IntMoraVigente,     Consumo_CapVencido,
            Consumo_IntVencido,     Consumo_IntMoraVencido,     Consumo_IntCtaOrden,    Consumo_IntMoraCtaOrden,

            Vivienda_CapVigente,    Vivienda_IntVigente,        Vivienda_CapVencido,    Vivienda_IntVencido,        Vivienda_IntMoraVencido,
            Vivienda_IntCtaOrden,   Vivienda_IntMoraCtaOrden

        FROM DETALLEPOLIZA
        WHERE Fecha <= Par_Fecha
          AND ( CuentaCompleta LIKE '1301%'
           OR   CuentaCompleta LIKE '1302%'
           OR   CuentaCompleta LIKE '6208%');

        UPDATE tmp_CREDITOTOTALES SET
            Con_CapitalVig          = IFNULL(Comercial_CapVigente, 0),
            Con_CapVencido          = IFNULL(Comercial_CapVencido, 0),
            Con_InteresVig          = IFNULL(Comercial_IntVigente, 0),
            Con_InteresAtrasado     = IFNULL(Comercial_IntAtrasado, 0),
            Con_InteresVencido      = IFNULL(Comercial_IntVencido, 0),
            Con_InteresCtaOrden     = IFNULL(Comercial_IntCtaOrden, 0),
            Con_Moratorios          = IFNULL(Comercial_IntMoraVigente, 0),
            Con_MoratorioVencido    = IFNULL(Comercial_IntMoraVencido, 0),
            Con_MoratorioCtasOrden  = IFNULL(Comercial_IntMoraCtaOrden, 0)
            WHERE Clasificacion = 'C';

        UPDATE tmp_CREDITOTOTALES SET
            Con_CapitalVig          = IFNULL(Vivienda_CapVigente, 0),
            Con_CapVencido          = IFNULL(Vivienda_CapVencido, 0),
            Con_InteresVig          = IFNULL(Vivienda_IntVigente, 0),
            Con_InteresVencido      = IFNULL(Vivienda_IntVencido, 0),
            Con_InteresCtaOrden     = IFNULL(Vivienda_IntCtaOrden, 0),
            Con_MoratorioVencido    = IFNULL(Vivienda_IntMoraVencido, 0),
            Con_MoratorioCtasOrden  = IFNULL(Vivienda_IntMoraCtaOrden, 0)

            WHERE Clasificacion = 'H';

        UPDATE tmp_CREDITOTOTALES SET
            Con_CapitalVig          = IFNULL(Consumo_CapVigente, 0),
            Con_CapVencido          = IFNULL(Consumo_CapVencido, 0),
            Con_InteresVig          = IFNULL(Consumo_IntVigente, 0),
            Con_InteresAtrasado     = IFNULL(Consumo_IntAtrasado, 0),
            Con_InteresVencido      = IFNULL(Consumo_IntVencido, 0),
            Con_InteresCtaOrden     = IFNULL(Consumo_IntCtaOrden, 0),
            Con_Moratorios          = IFNULL(Consumo_IntMoraVigente, 0),
            Con_MoratorioVencido    = IFNULL(Consumo_IntMoraVencido, 0),
            Con_MoratorioCtasOrden  = IFNULL(Consumo_IntMoraCtaOrden, 0)

            WHERE Clasificacion = 'O';

    SET     var_Resultado := (SELECT
                    (SUM(   Ope_CapitalVig+     Ope_CapVencido+     Ope_InteresVig+ Ope_InteresAtrasado+
                            Ope_InteresVencido+ Ope_InteresCtaOrden+Ope_Moratorios+ Ope_MoratorioVencido+
                            Ope_MoratorioCtasOrden))-
                    (SUM(   Con_CapitalVig+     Con_CapVencido+     Con_InteresVig+ Con_InteresAtrasado+
                            Con_InteresVencido+ Con_InteresCtaOrden+Con_Moratorios+ Con_MoratorioVencido+
                            Con_MoratorioCtasOrden)) AS Resultado
                                FROM tmp_CREDITOTOTALES );

        IF (var_Resultado <> 0) THEN
            SET var_Resultado :=1;

            INSERT INTO temp_DesCuadre VALUE
            (4,var_Resultado,Par_Fecha,'CARTERA');

        ELSE
            SET var_Resultado :=0;
            INSERT INTO temp_DesCuadre VALUE
            (4,var_Resultado,Par_Fecha,'CARTERA');
        END IF;

        SET var_Resultado :=    (SELECT COUNT(Amo.CreditoID)
                                FROM AMORTICREDITO Amo,
                                        CREDITOS Cre
                                WHERE Amo.Estatus = 'P'
                                    AND (Amo.SaldoCapVencido + Amo.SaldoCapVenNExi + Amo.SaldoCapVigente + Amo.SaldoCapAtrasa) > 0
                                    AND Amo.CreditoID = Cre.CreditoID
                                    ORDER BY FechaLiquida);

        IF (var_Resultado <> 0) THEN
            SET var_Resultado :=1;

            INSERT INTO temp_DesCuadre VALUE
            (5,var_Resultado,Par_Fecha,'CARTERA');

        ELSE
            SET var_Resultado :=0;
            INSERT INTO temp_DesCuadre VALUE
            (5,var_Resultado,Par_Fecha,'CARTERA');
        END IF;

        DROP TABLE tmp_CREDITOTOTALES;

    END IF;
END IF;

IF(Par_TipoReporte = Tipo_Inversiones) THEN

    IF(Par_NivDetalle = 'D') THEN

        SELECT Inv.InversionID, Inv.CuentaAhoID, Inv.ClienteID,  Suc.SucursalID, Suc.NombreSucurs,
              Inv.FechaInicio, Inv.FechaVencimiento, Inv.Monto, Inv.Tasa,
                CASE WHEN Inv.Estatus = 'N' THEN 'Vigente'
                     WHEN Inv.Estatus = 'P' THEN 'Pagada'
                     WHEN Inv.Estatus = 'C' THEN 'Pagada Antes Vencimiento'
                END AS Estatus,
                Inv.FechaVenAnt AS FechaVencimAnticipado
        FROM INVERSIONES Inv,
             CLIENTES Cli,
             SUCURSALES Suc
        WHERE Inv.FechaInicio <= Par_Fecha
          AND (Inv.Estatus = 'N'
           OR   ( Inv.Estatus = 'P'
            AND Inv.FechaVencimiento != '1900-01-01'
            AND Inv.FechaVencimiento > Par_Fecha)
          OR   ( Inv.Estatus = 'C'
            AND Inv.FechaVenAnt != '1900-01-01'
            AND Inv.FechaVenAnt > Par_Fecha) )
          AND Inv.ClienteID = Cli.ClienteID
          AND Cli.SucursalOrigen = Suc.SucursalID
        ORDER BY Suc.SucursalID, InversionID;

    ELSE


        SELECT SUM(CASE WHEN CuentaCompleta LIKE '2102020101010000%' OR
                         CuentaCompleta LIKE '2102020201010000%' THEN Abonos - Cargos ELSE 0 END ) INTO Conta_SaldoInversion

            FROM DETALLEPOLIZA
            WHERE Fecha <= Par_Fecha
              AND ( CuentaCompleta LIKE '2102020%');

        SELECT SUM(Inv.Monto) AS Operativo_TotalInvPlazo,
               Conta_SaldoInversion AS Conta_TotalInvPlazo  INTO var_SalTotalInvOpera,var_SalTotalInvConta
        FROM INVERSIONES Inv,
             CLIENTES Cli,
             SUCURSALES Suc
        WHERE Inv.FechaInicio <= Par_Fecha
          AND (Inv.Estatus = 'N'
           OR   ( Inv.Estatus = 'P'
            AND Inv.FechaVencimiento != '1900-01-01'
            AND Inv.FechaVencimiento > Par_Fecha)
          OR   ( Inv.Estatus = 'C'
            AND Inv.FechaVenAnt != '1900-01-01'
            AND Inv.FechaVenAnt > Par_Fecha) )
          AND Inv.ClienteID = Cli.ClienteID
          AND Cli.SucursalOrigen = Suc.SucursalID;

        IF(IFNULL(var_SalTotalInvOpera,Entero_Cero) <> IFNULL(var_SalTotalInvConta,Entero_Cero)) THEN
            SET var_Resultado := 1;
            INSERT INTO temp_DesCuadre VALUE
            (2,var_Resultado,Par_Fecha,'INVERSIONES');
        ELSE
            SET var_Resultado := 0;
            INSERT INTO temp_DesCuadre VALUE
            (2,var_Resultado,Par_Fecha,'INVERSIONES');
        END IF;
    END IF;

END IF;


IF(Par_TipoReporte = Tipo_InvEnGarantia) THEN

    DROP  TABLE IF EXISTS tmp_CREDITOINVGAR;

    CREATE TABLE tmp_CREDITOINVGAR (
        CreditoID           BIGINT(12),
        InversionID         BIGINT,
        SucursalID          INT,
        NombreSucursal      VARCHAR(500),
        FechaAsignaGar      DATE,
        MontoEnGar          DECIMAL(12,2)   );

    INSERT INTO tmp_CREDITOINVGAR
        SELECT Gar.CreditoID, Gar.InversionID, Suc.SucursalID, Suc.NombreSucurs,
               Gar.FechaAsignaGar, Gar.MontoEnGar
            FROM CREDITOINVGAR Gar,
                 CREDITOS Cre,
                 CLIENTES Cli,
                 SUCURSALES Suc
            WHERE FechaAsignaGar <= Par_Fecha
              AND Gar.CreditoID = Cre.CreditoID
              AND Cre.ClienteID = Cli.ClienteID
              AND Cli.SucursalOrigen = Suc.SucursalID;


    INSERT INTO tmp_CREDITOINVGAR
        SELECT Gar.CreditoID, Gar.InversionID, Suc.SucursalID, Suc.NombreSucurs,
               Gar.FechaAsignaGar, Gar.MontoEnGar
            FROM HISCREDITOINVGAR Gar,
                 CREDITOS Cre,
                 CLIENTES Cli,
                 SUCURSALES Suc
            WHERE Gar.Fecha > Par_Fecha
              AND Gar.FechaAsignaGar <= Par_Fecha
              AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
              AND Gar.CreditoID = Cre.CreditoID
              AND Cre.ClienteID = Cli.ClienteID
              AND Cli.SucursalOrigen = Suc.SucursalID;

    IF(Par_NivDetalle = 'D') THEN
        SELECT CreditoID,   InversionID,    SucursalID, NombreSucursal,
                FechaAsignaGar, MontoEnGar
            FROM tmp_CREDITOINVGAR
            ORDER BY SucursalID, InversionID;
    ELSE

        SELECT SUM(CASE WHEN CuentaCompleta LIKE '2102020201010000%' THEN Abonos - Cargos ELSE 0 END ) INTO Conta_InversionGarantia

            FROM DETALLEPOLIZA
            WHERE Fecha <= Par_Fecha
              AND ( CuentaCompleta LIKE '2102020201010000%');

        SELECT SUM(MontoEnGar) AS Operativo_InvGarantia,
               Conta_InversionGarantia AS Conta_InvGarantia  INTO var_Operativo_InvGarantia,var_Conta_InvGarantia
            FROM tmp_CREDITOINVGAR;

        IF(IFNULL(var_Operativo_InvGarantia,Entero_Cero) <> IFNULL(var_Conta_InvGarantia,Entero_Cero)) THEN
                SET var_Resultado := 1;

                INSERT INTO temp_DesCuadre VALUE
                (3,var_Resultado,Par_Fecha,'INVERSION EN GARANTIA');
            ELSE
                SET var_Resultado := 0;

                INSERT INTO temp_DesCuadre VALUE
                (3,var_Resultado,Par_Fecha,'INVERSION EN GARANTIA');
        END IF;

    END IF;




END IF;

IF(Par_TipoReporte = Tipo_CuentasAhorro) THEN


    SET Var_FechaInicio     = '1900-01-01';
    SET Var_FechaFinal      = Par_Fecha;

    SET Var_FechaInicio = DATE(CONCAT(CAST(YEAR( Var_FechaFinal) AS CHAR), "-", CAST(MONTH( Var_FechaFinal) AS CHAR), "-01"));



    DROP TABLE IF EXISTS tmp_SaldosBloqueo;
    CREATE TEMPORARY TABLE tmp_SaldosBloqueo (Cuenta    BIGINT(12),
                                              Saldo     DECIMAL(18,2),
                                              PRIMARY KEY(Cuenta));

    INSERT INTO tmp_SaldosBloqueo
    SELECT CuentaAhoID, SUM(CASE WHEN NatMovimiento = 'B' THEN  MontoBloq ELSE MontoBloq *-1 END) AS Saldo
    FROM BLOQUEOS
    WHERE DATE(FechaMov) <= Var_FechaFinal
    AND TiposBloqID = Cons_BloqGarLiq
    GROUP BY CuentaAhoID
    ;

    DROP TABLE IF EXISTS tmp_SaldosMovimientos;
    CREATE TEMPORARY TABLE tmp_SaldosMovimientos (  Cuenta          BIGINT(12),
                                                    SaldoMov        DECIMAL(18,2),
                                                    PRIMARY KEY(Cuenta));


    INSERT INTO tmp_SaldosMovimientos
    SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
    FROM CUENTASAHOMOV Mov
    WHERE Mov.Fecha >= Var_FechaInicio
      AND Mov.Fecha <= Var_FechaFinal
    GROUP BY Mov.CuentaAhoID;

    DROP TABLE IF EXISTS tmp_SaldosDeCuentas;

    CREATE  TABLE tmp_SaldosDeCuentas (
        Cuenta          BIGINT(12),
        NumTipCuenta    INT,
        TipoCuenta      VARCHAR(30),
        NumSucursal     INT,
        NombreSucurs    VARCHAR(30),
        SaldoIniMes     DECIMAL(18,2),
        SaldoDispon     DECIMAL(18,2),
        SaldoGarLiq     DECIMAL(18,2),
        SaldoTotal      DECIMAL(18,2),
        PRIMARY KEY(Cuenta) );


    INSERT INTO tmp_SaldosDeCuentas
    SELECT  Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
            Cue.SaldoIniMes,    Cue.SaldoIniMes AS SaldoDispon, 0.00 AS SaldoGarLiq, 0.00 AS SaldoTotal
    FROM CUENTASAHO Cue
    WHERE (Cue.Estatus IN ('A', 'B')
    OR (Cue.Estatus = 'C' AND Cue.FechaCan  >= Var_FechaInicio ) )
    AND Cue.TipoCuentaID <> 1
    ;



    UPDATE tmp_SaldosDeCuentas Cue
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cue.NumSucursal
    SET Cue.NombreSucurs = Suc.NombreSucurs;


    UPDATE tmp_SaldosDeCuentas Cue
        INNER JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID = Cue.NumTipCuenta
    SET Cue.TipoCuenta = Tip.Descripcion;


    UPDATE tmp_SaldosDeCuentas Cue
        INNER JOIN tmp_SaldosBloqueo Tmp ON Cue.Cuenta = Tmp.Cuenta
    SET Cue.SaldoGarLiq = Tmp.Saldo,
        Cue.SaldoDispon = Cue.SaldoDispon - Tmp.Saldo;



    UPDATE tmp_SaldosDeCuentas Cue
        INNER JOIN tmp_SaldosMovimientos Tmp ON Cue.Cuenta = Tmp.Cuenta
    SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;


    UPDATE tmp_SaldosDeCuentas
    SET SaldoTotal = SaldoDispon + SaldoGarLiq;

    IF(Par_NivDetalle = 'D') THEN
        SELECT  *
            FROM tmp_SaldosDeCuentas;
    ELSE

        DROP  TABLE IF EXISTS tmp_ContaSaldosDeCuentas;

        CREATE TABLE tmp_ContaSaldosDeCuentas(
            NumTipCuenta        INT,
            TipoCuenta          VARCHAR(200),
            Ope_SinGravamen     DECIMAL(14,2),
            Conta_SinGravamen   DECIMAL(14,2),
            Ope_ConGravamen     DECIMAL(14,2),
            Conta_ConGravamen   DECIMAL(14,2)   );

        INSERT INTO tmp_ContaSaldosDeCuentas
            SELECT  NumTipCuenta, MAX(TipoCuenta), SUM(SaldoDispon), 0, SUM(SaldoGarLiq), 0
                FROM tmp_SaldosDeCuentas
                GROUP BY NumTipCuenta;

        SELECT SUM(CASE WHEN CuentaCompleta LIKE '2101010201010100%' THEN Abonos - Cargos ELSE 0 END ),
               SUM(CASE WHEN CuentaCompleta LIKE '2101010202010100%' THEN Abonos - Cargos ELSE 0 END ),
               SUM(CASE WHEN CuentaCompleta LIKE '2101020201010100%' THEN Abonos - Cargos ELSE 0 END ),
               SUM(CASE WHEN CuentaCompleta LIKE '2101020202010100%' THEN Abonos - Cargos ELSE 0 END ),
               SUM(CASE WHEN CuentaCompleta LIKE '2101020201020100%' THEN Abonos - Cargos ELSE 0 END )

            INTO AhorroVista_SinGravamen, AhorroVista_ConGravamen, Depositos_SinGravamen, Depositos_ConGravamen, Menores

            FROM DETALLEPOLIZA
            WHERE Fecha <= Par_Fecha
              AND ( CuentaCompleta LIKE '2101%');

        UPDATE tmp_ContaSaldosDeCuentas SET
            Conta_SinGravamen   = IFNULL(AhorroVista_SinGravamen, 0),
            Conta_ConGravamen   = IFNULL(AhorroVista_ConGravamen, 0)

            WHERE NumTipCuenta = 4;

        UPDATE tmp_ContaSaldosDeCuentas SET
            Conta_SinGravamen   = IFNULL(Depositos_SinGravamen, 0),
            Conta_ConGravamen   = IFNULL(Depositos_ConGravamen, 0)

            WHERE NumTipCuenta = 2;

        UPDATE tmp_ContaSaldosDeCuentas SET
            Conta_SinGravamen   = IFNULL(Menores, 0),
            Conta_ConGravamen   = 0

            WHERE NumTipCuenta = 3;


        SELECT SUM(Ope_SinGravamen),
               SUM(Conta_SinGravamen),
               SUM(Ope_ConGravamen),
               SUM(Conta_ConGravamen)
                INTO var_Ope_SinGravamen,Var_Conta_SinGravamen,var_Ope_ConGravamen,var_Conta_ConGravamen
            FROM tmp_ContaSaldosDeCuentas;

        IF(IFNULL(var_Ope_SinGravamen,Entero_Cero) <> IFNULL(Var_Conta_SinGravamen,Entero_Cero) OR
            IFNULL(var_Ope_ConGravamen,Entero_Cero) <> IFNULL(var_Conta_ConGravamen,Entero_Cero)) THEN
                    SET var_Resultado := 1;
                    INSERT INTO temp_DesCuadre VALUE
                    (1,var_Resultado,Par_Fecha,'AHORRO');
            ELSE
                    SET var_Resultado := 0;
                    INSERT INTO temp_DesCuadre VALUE
                    (1,var_Resultado,Par_Fecha,'AHORRO');
        END IF;



    END IF;



END IF;


IF(Par_TipoReporte = Tipo_ContaAhorro) THEN
    SELECT SUM(CASE WHEN CuentaCompleta LIKE '2101010201010100%' THEN Abonos - Cargos ELSE 0 END ) AS AhorroVista_SinGravamen,
           SUM(CASE WHEN CuentaCompleta LIKE '2101010202010100%' THEN Abonos - Cargos ELSE 0 END ) AS AhorroVista_ConGravamen,
           SUM(CASE WHEN CuentaCompleta LIKE '2101020201010100%' THEN Abonos - Cargos ELSE 0 END ) AS Depositos_SinGravamen,
           SUM(CASE WHEN CuentaCompleta LIKE '2101020202010100%' THEN Abonos - Cargos ELSE 0 END ) AS Depositos_ConGravamen,
           SUM(CASE WHEN CuentaCompleta LIKE '2101020201020100%' THEN Abonos - Cargos ELSE 0 END ) AS Menores

        FROM DETALLEPOLIZA
        WHERE Fecha <= Par_Fecha
          AND ( CuentaCompleta LIKE '2101%');

END IF;

IF(Par_TipoReporte = Tipo_ContaInversion) THEN
    SELECT SUM(CASE WHEN CuentaCompleta LIKE '2102020101010000%' OR
                         CuentaCompleta LIKE '2102020201010000%' THEN Abonos - Cargos ELSE 0 END ) AS SaldoInversion

        FROM DETALLEPOLIZA
        WHERE Fecha <= Par_Fecha
          AND ( CuentaCompleta LIKE '2102020%');
END IF;

IF(Par_TipoReporte = Tipo_ContaInvGarant) THEN
    SELECT SUM(CASE WHEN CuentaCompleta LIKE '2102020201010000%' THEN Abonos - Cargos ELSE 0 END ) AS SaldoInversionGarantia

        FROM DETALLEPOLIZA
        WHERE Fecha <= Par_Fecha
          AND ( CuentaCompleta LIKE '2102020201010000%');
END IF;

IF(Par_TipoReporte = Tipo_ContaCartera) THEN



    SELECT SUM(CASE WHEN CuentaCompleta LIKE '1301010101010100%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_CapVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010201%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_IntVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010202%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_IntAtrasado,
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010203%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_IntMoraVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010100%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_CapVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010201%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_IntVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010203%' THEN Cargos - Abonos ELSE 0 END ) AS Comercial_IntMoraVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '6208010101010001%' THEN Abonos - Cargos ELSE 0 END ) AS Comercial_IntCtaOrden,
           SUM(CASE WHEN CuentaCompleta LIKE '6208020101010001%' THEN Abonos - Cargos ELSE 0 END ) AS Comercial_IntMoraCtaOrden,


           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010100%'
                      OR CuentaCompleta LIKE '1301020700010100%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_CapVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010201%'
                      OR CuentaCompleta LIKE '1301020700010201%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_IntVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010202%'
                      OR CuentaCompleta LIKE '1301020700010202%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_IntAtrasado,

           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010203%'
                     OR  CuentaCompleta LIKE '1301020700010203%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_IntMoraVigente,

           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010100%'
                      OR CuentaCompleta LIKE '1302020700010100%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_CapVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010201%'
                      OR CuentaCompleta LIKE '1302020700010201%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_IntVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010203%'
                      OR CuentaCompleta LIKE '1302020700010203%' THEN Cargos - Abonos ELSE 0 END ) AS Consumo_IntMoraVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '6208010201020001%'
                      OR CuentaCompleta LIKE '6208010201070001%' THEN Abonos - Cargos ELSE 0 END ) AS Consumo_IntCtaOrden,
           SUM(CASE WHEN CuentaCompleta LIKE '6208020201020001%'
                      OR CuentaCompleta LIKE '6208020201070001%' THEN Abonos - Cargos ELSE 0 END ) AS Consumo_IntMoraCtaOrden,

           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010100%' THEN Cargos - Abonos ELSE 0 END ) AS Vivienda_CapVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010201%' THEN Cargos - Abonos ELSE 0 END ) AS Vivienda_IntVigente,
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010100%' THEN Cargos - Abonos ELSE 0 END ) AS Vivienda_CapVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010201%' THEN Cargos - Abonos ELSE 0 END ) AS Vivienda_IntVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010203%' THEN Cargos - Abonos ELSE 0 END ) AS Vivienda_IntMoraVencido,
           SUM(CASE WHEN CuentaCompleta LIKE '6208010301010001%' THEN Abonos - Cargos ELSE 0 END ) AS Vivienda_IntCtaOrden,
           SUM(CASE WHEN CuentaCompleta LIKE '6208020301010001%' THEN Abonos - Cargos ELSE 0 END ) AS Vivienda_IntMoraCtaOrden

        FROM DETALLEPOLIZA
        WHERE Fecha <= Par_Fecha
          AND ( CuentaCompleta LIKE '1301%'
           OR   CuentaCompleta LIKE '1302%'
           OR   CuentaCompleta LIKE '6208%');


END IF;

IF(Par_TipoReporte = Tipo_PartesSociales) THEN

SELECT SUM(Abonos)-SUM(Cargos) AS SaldoContable
        INTO Var_SaldoContableAporta
    FROM DETALLEPOLIZA WHERE
CuentaCompleta='310101000000000000' AND Fecha <= Par_Fecha;

DROP  TABLE IF EXISTS tmp_MovAportSocial;

CREATE TABLE tmp_MovAportSocial
    SELECT Mov.ClienteID, SUM(CASE WHEN Mov.Tipo = 'D' THEN Mov.Monto ELSE Mov.Monto * -1 END) AS Monto
        FROM microfin.APORTACIONSOCIO Apo
            INNER JOIN microfin.APORTASOCIOMOV Mov ON Mov.ClienteID = Apo.ClienteID
        WHERE Apo.FechaRegistro <= Par_Fecha

            AND Mov.Fecha > Par_Fecha
            GROUP BY Mov.ClienteID;

CREATE INDEX idx_MovAportSoc_Cliente ON tmp_MovAportSocial (ClienteID);


DROP TABLE IF EXISTS tmp_SaldosAportSocial;

CREATE TABLE tmp_SaldosAportSocial
    SELECT Apo.ClienteID, (IFNULL(Apo.Saldo, 0.0) + IFNULL(Mov.Monto, 0.00)) AS AportacionSocial
        FROM microfin.APORTACIONSOCIO Apo
            LEFT JOIN tmp_MovAportSocial Mov ON Apo.ClienteID = Mov.ClienteID
        WHERE Apo.FechaRegistro <= Par_Fecha;
CREATE INDEX idx_tmp_SaldosAportSocial_Cliente ON tmp_SaldosAportSocial (ClienteID);


SELECT SUM(AportacionSocial) AS SalOpeAportacionSocial
        INTO Var_SaldoOperatiAporta
 FROM tmp_SaldosAportSocial;



    IF(Var_SaldoOperatiAporta <> Var_SaldoContable) THEN
            SET var_Resultado := 1;

            INSERT INTO temp_DesCuadre VALUE
            (6,var_Resultado,Par_Fecha,'APORTACION SOCIAL');
        ELSE
            SET var_Resultado := 0;
            INSERT INTO temp_DesCuadre VALUE
            (6,var_Resultado,Par_Fecha,'APORTACION SOCIAL');
    END IF;


    IF(Par_NivDetalle = 'D') THEN
        SELECT  Par_Fecha, a.*
            FROM tmp_SaldosAportSocial a;
    ELSE
        SELECT Var_SaldoOperatiAporta AS SalOpeAportacionSocial, Var_SaldoContableAporta AS SalConAportacionSocial;
    END IF;


    DROP TABLE IF EXISTS tmp_MovAportSocial;

END IF;


END$$