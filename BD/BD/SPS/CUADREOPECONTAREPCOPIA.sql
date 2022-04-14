-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUADREOPECONTAREPCOPIA
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUADREOPECONTAREPCOPIA`;DELIMITER $$

CREATE PROCEDURE `CUADREOPECONTAREPCOPIA`(
    Par_Fecha           DATE,
    Par_TipoReporte     INT,
    Par_NivDetalle      CHAR(1),
    Par_UsuarioID       INT
        )
BEGIN


DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaFinal      DATE;
DECLARE Var_IniMesSistema   DATE;
DECLARE Var_FechaHistor     DATE;
DECLARE Var_FechConta       DATE;
DECLARE Var_FechaOpeCart    DATE;


DECLARE HisAhorroVista_SinGravamen  DECIMAL(16,2);
DECLARE HisAhorroVista_ConGravamen  DECIMAL(16,2);
DECLARE HisDepositos_SinGravamen    DECIMAL(16,2);
DECLARE HisDepositos_ConGravamen    DECIMAL(16,2);
DECLARE HisMenores                  DECIMAL(16,2);

DECLARE Var_HisContaInv             DECIMAL(16,2);

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
DECLARE Vivienda_IntAtrasado        DECIMAL(14,2);
DECLARE Vivienda_IntMoraVigente     DECIMAL(14,2);

DECLARE Conta_SaldoInversion        DECIMAL(14,2);
DECLARE Conta_InversionGarantia     DECIMAL(14,2);
DECLARE AhorroVista_SinGravamen     DECIMAL(14,2);
DECLARE AhorroVista_ConGravamen     DECIMAL(14,2);
DECLARE Depositos_SinGravamen       DECIMAL(14,2);
DECLARE Depositos_ConGravamen       DECIMAL(14,2);
DECLARE Menores                     DECIMAL(14,2);
DECLARE var_Resultado               DECIMAL(14,2);
DECLARE DescuaCartera               INT(11);

DECLARE Tipo_CuentasAhorro  INT;
DECLARE Tipo_Inversiones    INT;
DECLARE Tipo_InvEnGarantia  INT;
DECLARE Tipo_SaldosCartera  INT;
DECLARE Tipo_PartesSociales INT;
DECLARE Tipo_GtiaLiqEPRC    INT;

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


DECLARE HisComercial_CapVigente DECIMAL(14,2);
DECLARE HisComercial_IntVigente DECIMAL(14,2);
DECLARE HisComercial_IntAtrasado    DECIMAL(14,2);
DECLARE HisComercial_IntMoraVigente DECIMAL(14,2);
DECLARE HisComercial_CapVencido DECIMAL(14,2);
DECLARE HisComercial_IntVencido DECIMAL(14,2);
DECLARE HisComercial_IntMoraVencido DECIMAL(14,2);
DECLARE HisComercial_IntCtaOrden    DECIMAL(14,2);
DECLARE HisComercial_IntMoraCtaOrden    DECIMAL(14,2);
DECLARE HisConsumo_CapVigente   DECIMAL(14,2);
DECLARE HisConsumo_IntVigente   DECIMAL(14,2);
DECLARE HisConsumo_IntAtrasado  DECIMAL(14,2);
DECLARE HisConsumo_IntMoraVigente   DECIMAL(14,2);
DECLARE HisConsumo_CapVencido   DECIMAL(14,2);
DECLARE HisConsumo_IntVencido   DECIMAL(14,2);
DECLARE HisConsumo_IntMoraVencido   DECIMAL(14,2);
DECLARE HisConsumo_IntCtaOrden  DECIMAL(14,2);
DECLARE HisConsumo_IntMoraCtaOrden  DECIMAL(14,2);
DECLARE HisVivienda_CapVigente  DECIMAL(14,2);
DECLARE HisVivienda_IntVigente  DECIMAL(14,2);
DECLARE HisVivienda_CapVencido  DECIMAL(14,2);
DECLARE HisVivienda_IntVencido  DECIMAL(14,2);
DECLARE HisVivienda_IntMoraVencido  DECIMAL(14,2);
DECLARE HisVivienda_IntCtaOrden DECIMAL(14,2);
DECLARE HisVivienda_IntMoraCtaOrden DECIMAL(14,2);
DECLARE HisVivienda_IntAtrasado     DECIMAL(14,2);
DECLARE HisVivienda_IntMoraVigente      DECIMAL(14,2);
DECLARE UltimoEjercicioContCerrado  INT;
DECLARE UltimoPeriodoContCerrado    INT;
DECLARE UltimoHistoricoSaldosCre    DATE;




SET Tipo_CuentasAhorro  := 1;
SET Tipo_Inversiones    := 2;
SET Tipo_InvEnGarantia  := 3;
SET Tipo_SaldosCartera  := 4;
SET Tipo_PartesSociales := 5;
SET Tipo_GtiaLiqEPRC    := 6;

SET Tipo_ContaCartera   := 20;
SET Tipo_ContaAhorro    := 21;
SET Tipo_ContaInversion := 22;
SET Tipo_ContaInvGarant := 23;



SET Cons_BloqGarLiq      = 8;
SET Entero_Cero         := 0;

SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_IniMesSistema   :=  DATE(CONCAT(CAST(YEAR(Var_FechaSistema) AS CHAR), "-", CAST(MONTH( Var_FechaSistema) AS CHAR), "-01"));


DELETE FROM temp_DesCuadre
WHERE  consecutivo= Par_TipoReporte
AND  FechaSistema= Par_Fecha;

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



        SET UltimoHistoricoSaldosCre:=(SELECT MAX(FechaCorte) FROM SALDOSCREDITOS WHERE FechaCorte<=Par_Fecha);

        IF(UltimoHistoricoSaldosCre<Par_Fecha AND LAST_DAY(Par_Fecha)=Par_Fecha)THEN
            SET Var_FechaOpeCart:=UltimoHistoricoSaldosCre;
        ELSE
            SET Var_FechaOpeCart=Par_Fecha;
        END IF;


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

            WHERE FechaCorte = Var_FechaOpeCart
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
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010202%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010203%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010100%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010201%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010203%' THEN Cargos - Abonos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010301010001%' THEN Abonos - Cargos ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020301010001%' THEN Abonos - Cargos ELSE 0 END ) INTO

            Comercial_CapVigente,   Comercial_IntVigente,       Comercial_IntAtrasado,  Comercial_IntMoraVigente,   Comercial_CapVencido,
            Comercial_IntVencido,   Comercial_IntMoraVencido,   Comercial_IntCtaOrden,  Comercial_IntMoraCtaOrden,

            Consumo_CapVigente,     Consumo_IntVigente,         Consumo_IntAtrasado,    Consumo_IntMoraVigente,     Consumo_CapVencido,
            Consumo_IntVencido,     Consumo_IntMoraVencido,     Consumo_IntCtaOrden,    Consumo_IntMoraCtaOrden,

            Vivienda_CapVigente,    Vivienda_IntVigente,        Vivienda_IntAtrasado,   Vivienda_IntMoraVigente,    Vivienda_CapVencido,
            Vivienda_IntVencido,    Vivienda_IntMoraVencido,    Vivienda_IntCtaOrden,   Vivienda_IntMoraCtaOrden

        FROM DETALLEPOLIZA
        WHERE Fecha <= Par_Fecha
          AND ( CuentaCompleta LIKE '1301%'
           OR   CuentaCompleta LIKE '1302%'
           OR   CuentaCompleta LIKE '6208%');


        SELECT MAX(FechaCorte) INTO Var_FechConta
            FROM SALDOSCONTABLES
            WHERE FechaCorte <= Par_Fecha;

        SET Var_FechConta = IFNULL(Var_FechConta, '1900-01-01');


    SELECT SUM(CASE WHEN CuentaCompleta LIKE '1301010101010100%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010201%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010202%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301010101010203%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010100%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010201%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302010101010203%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010101010001%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020101010001%' THEN Sal.SaldoFinal ELSE 0 END ),


           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010100%'
                      OR CuentaCompleta LIKE '1301020700010100%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010201%'
                      OR CuentaCompleta LIKE '1301020700010201%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010202%'
                      OR CuentaCompleta LIKE '1301020700010202%' THEN Sal.SaldoFinal ELSE 0 END ),

           SUM(CASE WHEN CuentaCompleta LIKE '1301020200010203%'
                     OR  CuentaCompleta LIKE '1301020700010203%' THEN Sal.SaldoFinal ELSE 0 END ),

           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010100%'
                      OR CuentaCompleta LIKE '1302020700010100%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010201%'
                      OR CuentaCompleta LIKE '1302020700010201%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302020200010203%'
                      OR CuentaCompleta LIKE '1302020700010203%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010201020001%'
                      OR CuentaCompleta LIKE '6208010201070001%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020201020001%'
                      OR CuentaCompleta LIKE '6208020201070001%' THEN Sal.SaldoFinal ELSE 0 END ),

           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010100%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010201%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010202%' THEN SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1301030100010203%' THEN SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010100%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010201%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '1302030100010203%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208010301010001%' THEN Sal.SaldoFinal ELSE 0 END ),
           SUM(CASE WHEN CuentaCompleta LIKE '6208020301010001%' THEN Sal.SaldoFinal ELSE 0 END ) INTO

            HisComercial_CapVigente,    HisComercial_IntVigente,        HisComercial_IntAtrasado,   HisComercial_IntMoraVigente,    HisComercial_CapVencido,
            HisComercial_IntVencido,    HisComercial_IntMoraVencido,    HisComercial_IntCtaOrden,   HisComercial_IntMoraCtaOrden,

            HisConsumo_CapVigente,      HisConsumo_IntVigente,          HisConsumo_IntAtrasado,     HisConsumo_IntMoraVigente,      HisConsumo_CapVencido,
            HisConsumo_IntVencido,      HisConsumo_IntMoraVencido,      HisConsumo_IntCtaOrden,     HisConsumo_IntMoraCtaOrden,

            HisVivienda_CapVigente,     HisVivienda_IntVigente,         HisVivienda_IntAtrasado,    HisVivienda_IntMoraVigente, HisVivienda_CapVencido,
            HisVivienda_IntVencido,     HisVivienda_IntMoraVencido,     HisVivienda_IntCtaOrden,    HisVivienda_IntMoraCtaOrden

        FROM SALDOSCONTABLES Sal
        WHERE Sal.FechaCorte = Var_FechConta
          AND ( CuentaCompleta LIKE '1301%'
           OR   CuentaCompleta LIKE '1302%'
           OR   CuentaCompleta LIKE '6208%');


        UPDATE tmp_CREDITOTOTALES SET
            Con_CapitalVig          = IFNULL(Comercial_CapVigente, 0) + IFNULL(HisComercial_CapVigente, 0),
            Con_CapVencido          = IFNULL(Comercial_CapVencido, 0) + IFNULL(HisComercial_CapVencido, 0),
            Con_InteresVig          = IFNULL(Comercial_IntVigente, 0) + IFNULL(HisComercial_IntVigente, 0),
            Con_InteresAtrasado     = IFNULL(Comercial_IntAtrasado, 0) + IFNULL(HisComercial_IntAtrasado, 0),
            Con_InteresVencido      = IFNULL(Comercial_IntVencido, 0) + IFNULL(HisComercial_IntVencido, 0),
            Con_InteresCtaOrden     = IFNULL(Comercial_IntCtaOrden, 0) + IFNULL(HisComercial_IntCtaOrden, 0),
            Con_Moratorios          = IFNULL(Comercial_IntMoraVigente, 0) + IFNULL(HisComercial_IntMoraVigente, 0),
            Con_MoratorioVencido    = IFNULL(Comercial_IntMoraVencido, 0) + IFNULL(HisComercial_IntMoraVencido, 0),
            Con_MoratorioCtasOrden  = IFNULL(Comercial_IntMoraCtaOrden, 0) + IFNULL(HisComercial_IntMoraCtaOrden, 0)
            WHERE Clasificacion = 'C';

        UPDATE tmp_CREDITOTOTALES SET
            Con_CapitalVig          = IFNULL(Vivienda_CapVigente, 0) + IFNULL(HisVivienda_CapVigente, 0),
            Con_CapVencido          = IFNULL(Vivienda_CapVencido, 0) + IFNULL(HisVivienda_CapVencido, 0),
            Con_InteresVig          = IFNULL(Vivienda_IntVigente, 0) + IFNULL(HisVivienda_IntVigente, 0),
            Con_InteresAtrasado     = IFNULL(Vivienda_IntAtrasado, 0) + IFNULL(HisVivienda_IntAtrasado, 0),
            Con_InteresVencido      = IFNULL(Vivienda_IntVencido, 0) + IFNULL(HisVivienda_IntVencido, 0),
            Con_InteresCtaOrden     = IFNULL(Vivienda_IntCtaOrden, 0) + IFNULL(HisVivienda_IntCtaOrden, 0),
            Con_Moratorios          = IFNULL(Vivienda_IntMoraVigente, 0) + IFNULL(HisVivienda_IntMoraVigente, 0),
            Con_MoratorioVencido    = IFNULL(Vivienda_IntMoraVencido, 0) + IFNULL(HisVivienda_IntMoraVencido, 0),
            Con_MoratorioCtasOrden  = IFNULL(Vivienda_IntMoraCtaOrden, 0) + IFNULL(HisVivienda_IntMoraCtaOrden, 0)

            WHERE Clasificacion = 'H';

        UPDATE tmp_CREDITOTOTALES SET
            Con_CapitalVig          = IFNULL(Consumo_CapVigente, 0) + IFNULL(HisConsumo_CapVigente, 0),
            Con_CapVencido          = IFNULL(Consumo_CapVencido, 0) + IFNULL(HisConsumo_CapVencido, 0),
            Con_InteresVig          = IFNULL(Consumo_IntVigente, 0) + IFNULL(HisConsumo_IntVigente, 0),
            Con_InteresAtrasado     = IFNULL(Consumo_IntAtrasado, 0) + IFNULL(HisConsumo_IntAtrasado, 0),
            Con_InteresVencido      = IFNULL(Consumo_IntVencido, 0) + IFNULL(HisConsumo_IntVencido, 0),
            Con_InteresCtaOrden     = IFNULL(Consumo_IntCtaOrden, 0) + IFNULL(HisConsumo_IntCtaOrden, 0),
            Con_Moratorios          = IFNULL(Consumo_IntMoraVigente, 0) + IFNULL(HisConsumo_IntMoraVigente, 0),
            Con_MoratorioVencido    = IFNULL(Consumo_IntMoraVencido, 0) + IFNULL(HisConsumo_IntMoraVencido, 0),
            Con_MoratorioCtasOrden  = IFNULL(Consumo_IntMoraCtaOrden, 0) + IFNULL(HisConsumo_IntMoraCtaOrden, 0)

            WHERE Clasificacion = 'O';


    SET var_Resultado := (SELECT
                    (SUM(   Ope_CapitalVig+     Ope_CapVencido+     Ope_InteresVig+ Ope_InteresAtrasado+
                            Ope_InteresVencido+ Ope_InteresCtaOrden+Ope_Moratorios+ Ope_MoratorioVencido+
                            Ope_MoratorioCtasOrden))-
                    (SUM(   Con_CapitalVig+     Con_CapVencido+     Con_InteresVig+ Con_InteresAtrasado+
                            Con_InteresVencido+ Con_InteresCtaOrden+Con_Moratorios+ Con_MoratorioVencido+
                            Con_MoratorioCtasOrden)) AS Resultado
                                FROM tmp_CREDITOTOTALES );

    SET DescuaCartera :=  (SELECT COUNT(Amo.CreditoID)
                                FROM AMORTICREDITO Amo,
                                        CREDITOS Cre
                                WHERE Amo.Estatus = 'P'
                                    AND (Amo.SaldoCapVencido + Amo.SaldoCapVenNExi + Amo.SaldoCapVigente + Amo.SaldoCapAtrasa) > 0
                                    AND Amo.CreditoID = Cre.CreditoID
                                    ORDER BY FechaLiquida);

        IF (var_Resultado <> 0 OR DescuaCartera <> 0) THEN
            SET var_Resultado :=1;

            INSERT INTO temp_DesCuadre VALUE
            (4,var_Resultado,Par_Fecha,'CARTERA');

        ELSE
            SET var_Resultado :=0;
            INSERT INTO temp_DesCuadre VALUE
            (4,var_Resultado,Par_Fecha,'CARTERA');
        END IF;


        SELECT * FROM tmp_CREDITOTOTALES;


    END IF;
END IF;

IF(Par_TipoReporte = Tipo_Inversiones) THEN

    IF(Par_NivDetalle = 'D') THEN

        CREATE TABLE tmp_detalleInv
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


        SET Conta_SaldoInversion := IFNULL(Conta_SaldoInversion, 0);

        SELECT MAX(FechaCorte) INTO Var_FechConta
            FROM SALDOSCONTABLES
            WHERE FechaCorte <= Par_Fecha;

        SET Var_FechConta = IFNULL(Var_FechConta, '1900-01-01');

        SELECT SUM(CASE WHEN CuentaCompleta LIKE '2102020101010000%' OR
                              CuentaCompleta LIKE '2102020201010000%' THEN Sal.SaldoFinal ELSE 0 END ) INTO Var_HisContaInv
            FROM SALDOSCONTABLES Sal
            WHERE Sal.FechaCorte = Var_FechConta
              AND Sal.CuentaCompleta LIKE '2102020%';

        SET Conta_SaldoInversion := Conta_SaldoInversion + IFNULL(Var_HisContaInv,0);

        SELECT SUM(Inv.Monto) AS Operativo_TotalInvPlazo,
               Conta_SaldoInversion AS Conta_TotalInvPlazo  INTO var_SalTotalInvOpera,var_SalTotalInvConta
        FROM INVERSIONES Inv
        WHERE Inv.FechaInicio <= Par_Fecha
          AND (Inv.Estatus = 'N'
           OR   ( Inv.Estatus = 'P'
            AND Inv.FechaVencimiento != '1900-01-01'
            AND Inv.FechaVencimiento > Par_Fecha)
          OR   ( Inv.Estatus = 'C'
            AND Inv.FechaVenAnt != '1900-01-01'
            AND Inv.FechaVenAnt > Par_Fecha) );

        SELECT FORMAT(var_SalTotalInvOpera,2) AS Operativo, FORMAT(var_SalTotalInvConta,2) AS Contable,
                FORMAT(var_SalTotalInvOpera - var_SalTotalInvConta,2) AS OpeMenosContable;

        DROP TABLE IF EXISTS temp_SaldosInversiones;

        CREATE TABLE temp_SaldosInversiones(
        Operativo DECIMAL(14,2),
        Contable  DECIMAL(14,2),
        OpeMenosContable DECIMAL(14,2)
        );

        INSERT INTO temp_SaldosInversiones
        SELECT var_SalTotalInvOpera AS Operativo, var_SalTotalInvConta AS Contable,
                (var_SalTotalInvOpera - var_SalTotalInvConta) AS OpeMenosContable;

    END IF;

        IF((var_SalTotalInvOpera - var_SalTotalInvConta) <> 0.00 ) THEN
                        SET var_Resultado := 1;

                        INSERT INTO temp_DesCuadre VALUE
                        (2,var_Resultado,Par_Fecha,'INVERSIONES');
                    ELSE
                        SET var_Resultado := 0;
                        INSERT INTO temp_DesCuadre VALUE
                        (2,var_Resultado,Par_Fecha,'INVERSIONES');
        END IF;

END IF;



IF(Par_TipoReporte = Tipo_GtiaLiqEPRC) THEN
    DROP  TABLE IF EXISTS tmp_CREDITOGARANTIA;

    CREATE TABLE tmp_CREDITOGARANTIA (
        CreditoID           BIGINT(12),
        MontoEnGarCta       DECIMAL(14,2),
        MontoEnGarInv       DECIMAL(14,2),
        MontoTotGarantia    DECIMAL(14,2),
        GarantiaEPRC        DECIMAL(14,2),
        PRIMARY KEY(CreditoID)  );

    INSERT INTO tmp_CREDITOGARANTIA
        SELECT Referencia, SUM(CASE WHEN NatMovimiento = 'B' THEN  MontoBloq ELSE MontoBloq *-1 END),
               0, 0, 0
        FROM BLOQUEOS
        WHERE DATE(FechaMov) <= Par_Fecha
        AND TiposBloqID = Cons_BloqGarLiq
        GROUP BY Referencia;

    DROP  TABLE IF EXISTS tmp_INVGARCREDITO;

    CREATE TABLE tmp_INVGARCREDITO (
        CreditoID           BIGINT(12),
        MontoEnGar          DECIMAL(12,2),
        PRIMARY KEY(CreditoID));


    INSERT INTO tmp_INVGARCREDITO
        SELECT Gar.CreditoID, SUM(Gar.MontoEnGar)
            FROM CREDITOINVGAR Gar,
                 CREDITOS Cre
            WHERE FechaAsignaGar <= Par_Fecha
              AND Gar.CreditoID = Cre.CreditoID
            GROUP BY Gar.CreditoID;

    UPDATE tmp_CREDITOGARANTIA Prin, tmp_INVGARCREDITO Inv SET
        Prin.MontoEnGarInv = Inv.MontoEnGar
        WHERE Prin.CreditoID = Inv.CreditoID;

    DELETE FROM t1 USING tmp_INVGARCREDITO t1 INNER JOIN tmp_CREDITOGARANTIA t2 ON ( t1.CreditoID = t2.CreditoID );

    INSERT INTO tmp_CREDITOGARANTIA
        SELECT  CreditoID, 0, MontoEnGar,0, 0
            FROM tmp_INVGARCREDITO;

    DELETE FROM tmp_INVGARCREDITO;


    INSERT INTO tmp_INVGARCREDITO
        SELECT Gar.CreditoID, SUM(Gar.MontoEnGar)
            FROM HISCREDITOINVGAR Gar,
                 CREDITOS Cre
            WHERE Gar.Fecha > Par_Fecha
              AND Gar.FechaAsignaGar <= Par_Fecha
              AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
              AND Gar.CreditoID = Cre.CreditoID
            GROUP BY Gar.CreditoID;

    UPDATE tmp_CREDITOGARANTIA Prin, tmp_INVGARCREDITO Inv SET
        Prin.MontoEnGarInv = Prin.MontoEnGarInv + Inv.MontoEnGar
        WHERE Prin.CreditoID = Inv.CreditoID;

    DELETE FROM t1 USING tmp_INVGARCREDITO t1 INNER JOIN tmp_CREDITOGARANTIA t2 ON ( t1.CreditoID = t2.CreditoID );

    INSERT INTO tmp_CREDITOGARANTIA
        SELECT  CreditoID, 0, MontoEnGar,0, 0
            FROM tmp_INVGARCREDITO;

    DELETE FROM tmp_INVGARCREDITO;


    DROP  TABLE IF EXISTS tmp_EPRCGARANTIA;

    CREATE TABLE tmp_EPRCGARANTIA (
        CreditoID           BIGINT(12),
        EPRCMontoEnGar      DECIMAL(12,2),
        PRIMARY KEY(CreditoID));

    INSERT INTO tmp_EPRCGARANTIA
        SELECT  CreditoID, MontoGarantia
            FROM CALRESCREDITOS
            WHERE Fecha = Par_Fecha;

    UPDATE tmp_CREDITOGARANTIA Prin, tmp_EPRCGARANTIA Epr SET
        Prin.GarantiaEPRC = Epr.EPRCMontoEnGar
        WHERE Prin.CreditoID = Epr.CreditoID;

    DELETE FROM t1 USING tmp_EPRCGARANTIA t1 INNER JOIN tmp_CREDITOGARANTIA t2 ON ( t1.CreditoID = t2.CreditoID );

    INSERT INTO tmp_CREDITOGARANTIA
        SELECT  CreditoID, 0, 0,0, EPRCMontoEnGar
            FROM tmp_EPRCGARANTIA;

    DELETE FROM tmp_EPRCGARANTIA;

    SELECT SUM(MontoEnGarCta + MontoEnGarInv - GarantiaEPRC) AS TotalDiferencia
        FROM tmp_CREDITOGARANTIA;


    SELECT Gar.CreditoID, Cre.Estatus, Cre.FechaVencimien, Cre.FechTerminacion, Gar.MontoEnGarCta AS MtoGtiaCtaAhorro,
           Gar.MontoEnGarInv AS MtoGtiaInversion,
           (Gar.MontoEnGarCta + Gar.MontoEnGarInv) AS TotalGarantizado,
           Gar.GarantiaEPRC AS GarantiaEnEPRC,
           (Gar.MontoEnGarCta + Gar.MontoEnGarInv - Gar.GarantiaEPRC) Diferencia
        FROM tmp_CREDITOGARANTIA Gar,
             CREDITOS Cre
         WHERE ABS((MontoEnGarCta + MontoEnGarInv) - GarantiaEPRC) != 0
          AND Gar.CreditoID = Cre.CreditoID
        ORDER BY Cre.FechTerminacion;




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

        SET Conta_InversionGarantia := IFNULL(Conta_InversionGarantia, 0);

        SELECT MAX(FechaCorte) INTO Var_FechConta
            FROM SALDOSCONTABLES
            WHERE FechaCorte <= Par_Fecha;

        SET Var_FechConta = IFNULL(Var_FechConta, '1900-01-01');

        SELECT SUM(CASE WHEN CuentaCompleta LIKE '2102020201010000%' THEN Sal.SaldoFinal ELSE 0 END ) INTO Var_HisContaInv
            FROM SALDOSCONTABLES Sal
            WHERE Sal.FechaCorte = Var_FechConta
              AND Sal.CuentaCompleta LIKE '2102020201010000%';

        SET Conta_InversionGarantia := Conta_InversionGarantia + IFNULL(Var_HisContaInv,0);

        SELECT SUM(MontoEnGar) AS Operativo_InvGarantia,
               Conta_InversionGarantia AS Conta_InvGarantia  INTO var_Operativo_InvGarantia,var_Conta_InvGarantia
            FROM tmp_CREDITOINVGAR;

        DROP TABLE IF EXISTS temp_saldoInversionesGL;
        CREATE TABLE temp_saldoInversionesGL(
        SELECT var_Operativo_InvGarantia AS SaldoOperativoInvGarantia,var_Conta_InvGarantia AS SaldoContaInvGarantia);

        SELECT var_Operativo_InvGarantia,var_Conta_InvGarantia;

        IF((var_Operativo_InvGarantia-var_Conta_InvGarantia) <> 0.00 ) THEN
                        SET var_Resultado := 1;

                        INSERT INTO temp_DesCuadre VALUE
                        (3,var_Resultado,Par_Fecha,'INVERSIONES EN GARANTIA');
                    ELSE
                        SET var_Resultado := 0;
                        INSERT INTO temp_DesCuadre VALUE
                        (3,var_Resultado,Par_Fecha,'INVERSIONES EN GARANTIA');
        END IF;

    END IF;




END IF;
IF(Par_TipoReporte = Tipo_CuentasAhorro) THEN


    SET Var_FechaInicio     = '1900-01-01';
    SET Var_FechaFinal      = Par_Fecha;

    SET Var_FechaInicio = DATE(CONCAT(CAST(YEAR( Var_FechaFinal) AS CHAR), "-", CAST(MONTH( Var_FechaFinal) AS CHAR), "-01"));



    DROP TABLE IF EXISTS tmp_SaldosBloqueo;
    CREATE TEMPORARY TABLE tmp_SaldosBloqueo (Cuenta    BIGINT,
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
    CREATE TEMPORARY TABLE tmp_SaldosMovimientos (  Cuenta  BIGINT,
                                                    SaldoMov        DECIMAL(18,2),
                                                    PRIMARY KEY(Cuenta));

    DROP TABLE IF EXISTS tmp_SaldosMovimientosAct;
    CREATE TEMPORARY TABLE tmp_SaldosMovimientosAct (   Cuenta  BIGINT,
                                                    SaldoMov        DECIMAL(18,2),
                                                    PRIMARY KEY(Cuenta));
    IF(Var_FechaFinal < Var_IniMesSistema) THEN

        SELECT MAX(Fecha) INTO Var_FechaHistor
            FROM `HIS-CUENTASAHO`
            WHERE Fecha < Var_IniMesSistema
             AND MONTH( Fecha) = MONTH( Var_FechaFinal);

    END IF;


    SET Var_FechaHistor := IFNULL(Var_FechaHistor, '1900-01-01');



    IF(Var_FechaFinal < Var_IniMesSistema) THEN


        INSERT INTO tmp_SaldosMovimientos
            SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
                FROM `HIS-CUENAHOMOV` Mov
                WHERE Mov.Fecha >= Var_FechaInicio
                  AND Mov.Fecha <= Var_FechaFinal
                GROUP BY Mov.CuentaAhoID;



        INSERT INTO tmp_SaldosMovimientosAct
            SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
                FROM CUENTASAHOMOV Mov
                WHERE Mov.Fecha <= Var_FechaFinal

                  AND Mov.FechaActual <= DATE_ADD(Var_FechaFinal, INTERVAL 2 DAY)
                GROUP BY Mov.CuentaAhoID;

    ELSE


        INSERT INTO tmp_SaldosMovimientos
            SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
                FROM CUENTASAHOMOV Mov
                WHERE Mov.Fecha >= Var_FechaInicio
                  AND Mov.Fecha <= Var_FechaFinal
                GROUP BY Mov.CuentaAhoID;

    END IF;


    DROP TABLE IF EXISTS tmp_SaldosDeCuentas;

    CREATE  TABLE tmp_SaldosDeCuentas (
        Cuenta          BIGINT,
        NumTipCuenta    INT,
        TipoCuenta      VARCHAR(30),
        NumSucursal     INT,
        NombreSucurs    VARCHAR(30),
        SaldoIniMes     DECIMAL(18,2),
        SaldoDispon     DECIMAL(18,2),
        SaldoGarLiq     DECIMAL(18,2),
        SaldoTotal      DECIMAL(18,2),
        PRIMARY KEY(Cuenta) );



    IF(Var_FechaFinal < Var_IniMesSistema) THEN

        INSERT INTO tmp_SaldosDeCuentas
            SELECT  Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
                    Cue.SaldoIniMes,    Cue.SaldoIniMes AS SaldoDispon, 0.00 AS SaldoGarLiq, 0.00 AS SaldoTotal
                FROM `HIS-CUENTASAHO` Cue,
                      CUENTASAHO Act
                WHERE Cue.Fecha = Var_FechaHistor
                AND Cue.CuentaAhoID = Act.CuentaAhoID
                AND (Cue.Estatus IN ('A', 'B')
                OR (Cue.Estatus = 'C' AND Act.FechaCan  >= Var_FechaInicio ) )
                AND Cue.TipoCuentaID <> 1;
    ELSE

        INSERT INTO tmp_SaldosDeCuentas
            SELECT  Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
                    Cue.SaldoIniMes,    Cue.SaldoIniMes AS SaldoDispon, 0.00 AS SaldoGarLiq, 0.00 AS SaldoTotal
                FROM CUENTASAHO Cue
                WHERE (Cue.Estatus IN ('A', 'B')
                OR (Cue.Estatus = 'C' AND Cue.FechaCan  >= Var_FechaInicio ) )
                AND Cue.TipoCuentaID <> 1;
    END IF;


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

    UPDATE tmp_SaldosDeCuentas Cue
        INNER JOIN tmp_SaldosMovimientosAct Tmp ON Cue.Cuenta = Tmp.Cuenta
    SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;




    UPDATE tmp_SaldosDeCuentas
    SET SaldoTotal = SaldoDispon + SaldoGarLiq;

    IF(Par_NivDetalle = 'D') THEN
        SELECT  *
            FROM tmp_SaldosDeCuentas;
    ELSE

        SELECT MAX(FechaCorte) INTO Var_FechConta
            FROM SALDOSCONTABLES
            WHERE FechaCorte <= Var_FechaFinal;

        SET Var_FechConta = IFNULL(Var_FechConta, '1900-01-01');

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

        SET AhorroVista_SinGravamen := IFNULL(AhorroVista_SinGravamen,0);
        SET AhorroVista_ConGravamen := IFNULL(AhorroVista_ConGravamen,0);
        SET Depositos_SinGravamen   := IFNULL(Depositos_SinGravamen,0);
        SET Depositos_ConGravamen   := IFNULL(Depositos_ConGravamen,0);
        SET Menores := IFNULL(Menores,0);

        SELECT SUM(CASE WHEN Sal.CuentaCompleta LIKE '2101010201010100%' THEN Sal.SaldoFinal ELSE 0 END ),
               SUM(CASE WHEN Sal.CuentaCompleta LIKE '2101010202010100%' THEN Sal.SaldoFinal ELSE 0 END ),
               SUM(CASE WHEN Sal.CuentaCompleta LIKE '2101020201010100%' THEN Sal.SaldoFinal ELSE 0 END ),
               SUM(CASE WHEN Sal.CuentaCompleta LIKE '2101020202010100%' THEN Sal.SaldoFinal ELSE 0 END ),
               SUM(CASE WHEN Sal.CuentaCompleta LIKE '2101020201020100%' THEN Sal.SaldoFinal ELSE 0 END )

            INTO HisAhorroVista_SinGravamen, HisAhorroVista_ConGravamen, HisDepositos_SinGravamen, HisDepositos_ConGravamen, HisMenores
            FROM SALDOSCONTABLES Sal
            WHERE Sal.FechaCorte = Var_FechConta
              AND Sal.CuentaCompleta LIKE '2101%';


        SET HisAhorroVista_SinGravamen  := IFNULL(HisAhorroVista_SinGravamen, 0);
        SET HisAhorroVista_ConGravamen  := IFNULL(HisAhorroVista_ConGravamen,0);
        SET HisDepositos_SinGravamen    := IFNULL(HisDepositos_SinGravamen,0);
        SET HisDepositos_ConGravamen    := IFNULL(HisDepositos_ConGravamen,0);
        SET HisMenores  := IFNULL(HisMenores,0);

        SET AhorroVista_SinGravamen := AhorroVista_SinGravamen + HisAhorroVista_SinGravamen;
        SET AhorroVista_ConGravamen := AhorroVista_ConGravamen + HisAhorroVista_ConGravamen;
        SET Depositos_SinGravamen   := Depositos_SinGravamen + HisDepositos_SinGravamen;
        SET Depositos_ConGravamen   := Depositos_ConGravamen + HisDepositos_ConGravamen;
        SET Menores := Menores + HisMenores;

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


        SELECT *
            FROM tmp_ContaSaldosDeCuentas;




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

    SET UltimoEjercicioContCerrado  := (SELECT MAX(EjercicioID) FROM SALDOSCONTABLES);
    SET UltimoPeriodoContCerrado    := (SELECT MAX(PeriodoID) FROM SALDOSCONTABLES WHERE EjercicioID = UltimoEjercicioContCerrado);

    SELECT SUM(Abonos)-SUM(Cargos) AS SaldoContable
        INTO Var_SaldoContableAporta
    FROM DETALLEPOLIZA
    WHERE CuentaCompleta='310101000000000000' AND Fecha <= Par_Fecha;

    SET Var_SaldoContableAporta := (Var_SaldoContableAporta + (SELECT SUM(SaldoFinal)
                                                                FROM SALDOSCONTABLES
                                                                WHERE   EjercicioID = UltimoEjercicioContCerrado
                                                                  AND   PeriodoID = UltimoPeriodoContCerrado
                                                                  AND   CuentaCompleta='310101000000000000') );

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



    IF(Var_SaldoOperatiAporta <> Var_SaldoContableAporta) THEN
            SET var_Resultado := 1;

            INSERT INTO temp_DesCuadre VALUE
            (5,var_Resultado,Par_Fecha,'APORTACION SOCIAL');
        ELSE
            SET var_Resultado := 0;
            INSERT INTO temp_DesCuadre VALUE
            (5,var_Resultado,Par_Fecha,'APORTACION SOCIAL');
    END IF;


    IF(Par_NivDetalle = 'D') THEN
        SELECT  Par_Fecha, a.*
            FROM tmp_SaldosAportSocial a;
    ELSE

        DROP TABLE IF EXISTS tmp_SaldosAportSocialTotales;

        CREATE TABLE tmp_SaldosAportSocialTotales(
        SELECT Var_SaldoOperatiAporta AS SalOpeAportacionSocial, Var_SaldoContableAporta AS SalConAportacionSocial);

        SELECT * FROM tmp_SaldosAportSocialTotales;
    END IF;


    DROP TABLE IF EXISTS tmp_MovAportSocial;
    DROP TABLE IF EXISTS tmp_SaldosAportSocial;

END IF;
END$$