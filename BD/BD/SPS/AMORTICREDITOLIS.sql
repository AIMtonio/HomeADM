-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOLIS`;

DELIMITER $$
CREATE PROCEDURE `AMORTICREDITOLIS`(
/*SP para listar las amortizaciones de credito*/
  Par_CreditoID     BIGINT(12),
  Par_NumCon        TINYINT UNSIGNED,
  /* Parametros de Auditoria */
  Par_EmpresaID     INT(11),
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,

  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_PagaIVA       CHAR(1);
DECLARE Var_IVA           DECIMAL(12,2);
DECLARE Var_PagaIVAInt    CHAR(1);
DECLARE Var_PagaIVAMor    CHAR(1);
DECLARE Var_IVAMora       DECIMAL(12,2);
DECLARE Var_TotalCap    DECIMAL(14,2);
DECLARE Var_TotalInt    DECIMAL(14,2);
DECLARE Var_TotalIva    DECIMAL(14,2);
DECLARE Var_TipoCredito   CHAR(1);
DECLARE Var_FechaRegistro   DATE;
DECLARE Var_TipoCalInteres  INT(11);
# SEGUROS
DECLARE Var_CobraSeguroCuota    CHAR(1);
DECLARE Var_CobraIVASeguroCuota   CHAR(1);
DECLARE Var_TotalMontoSeguroCuota   DECIMAL(12,2);
DECLARE Var_TotalIVASeguroCuota   DECIMAL(12,2);
DECLARE Var_TotalOtrasComisiones  DECIMAL(12,2);
DECLARE Var_TotalIVAOtrasComisiones DECIMAL(12,2);
#WS CREDICLUB
DECLARE Var_FechaIniAmor    DATE;
DECLARE Var_FechaUltAmor    DATE;
DECLARE Var_MaxMontoCuota   DECIMAL(14,2);
DECLARE Var_ClienteID     INT;

DECLARE Var_CobraAccesoriosGen  CHAR(1);          -- Valor del Cobro de Accesorios
DECLARE Var_IVASucursal     DECIMAL(12,2);        -- IVA de la Sucursal


-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE SIPagaIVA     CHAR(1);
DECLARE NOPagaIVA     CHAR(1);
DECLARE Con_Saldos      INT;
DECLARE Con_SaldosCont    INT;
DECLARE Con_CalOrig     INT;
DECLARE Con_CalWSCRCB   INT;      -- Calendario para WS Crediclub
DECLARE Reestructura    CHAR(1);
DECLARE EstDesembolso   CHAR(1);
DECLARE For_TasaFija    INT;
DECLARE Int_SalInsol    INT;
DECLARE Int_SalGlobal   INT;
DECLARE Llave_CobraAccesorios VARCHAR(100);   -- Llave para consulta el valor de Cobro de Accesorios
DECLARE Var_IVANotaCargo	DECIMAL(14,2);		-- Variable para el porcentaje que se cobra por nota de cargo

-- Asignacion de Constantes
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Decimal_Cero      := 0.00;
SET SIPagaIVA           := 'S';
SET NOPagaIVA           := 'N';
SET Con_Saldos          := 2;       -- Tipo de Lista para los Saldos
SET Con_CalOrig         := 3;       -- Tipo de Lista para el pagare
SET Con_SaldosCont        := 5;       -- Tipo de Lista para el credito contigente
SET Reestructura      := 'R';
SET EstDesembolso     := 'D';
SET For_TasaFija      := 1;       -- Formula de Calculo de Interes: Tasa Fija
SET Int_SalInsol        := 1;       -- Calculo de Interes Sobre Saldos Insolutos
SET Int_SalGlobal       := 2;       -- Calculo de Interes Sobre Saldos Globales (Monto Original)
SET Con_CalWSCRCB     := 4;       -- Calendario para WebService Crediclub
SET Llave_CobraAccesorios := 'CobraAccesorios'; -- Descripción Cobro de Accesorios
SET Var_IVANotaCargo := Entero_Cero;

SELECT FechaRegistro  INTO Var_FechaRegistro
  FROM REESTRUCCREDITO Res,
    CREDITOS Cre
  WHERE Res.CreditoOrigenID= Par_CreditoID
    AND Res.CreditoDestinoID = Par_CreditoID
    AND Cre.CreditoID = Res.CreditoDestinoID
    AND Res.EstatusReest = EstDesembolso
    AND Res.Origen= Reestructura;

IF(Con_Saldos = Par_NumCon) THEN
  SELECT  Cli.PagaIVA,    Suc.IVA,      Pro.CobraIVAInteres,  Pro.CobraIVAMora, Suc.IVA,
      Cre.TipoCredito,  Cre.TipoCalInteres, Cre.CobraSeguroCuota, Cre.CobraIVASeguroCuota
    INTO  Var_PagaIVA,    Var_IVA,      Var_PagaIVAInt,     Var_PagaIVAMor,   Var_IVAMora,
      Var_TipoCredito,  Var_TipoCalInteres, Var_CobraSeguroCuota, Var_CobraIVASeguroCuota
    FROM CREDITOS Cre,
       CLIENTES Cli,
       SUCURSALES Suc,
       PRODUCTOSCREDITO Pro
    WHERE Cre.CreditoID = Par_CreditoID
      AND Cre.ClienteID = Cli.ClienteID
      AND Cli.SucursalOrigen = Suc.SucursalID
      AND Pro.ProducCreditoID = Cre.ProductoCreditoID;



  SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
  SET Var_IVASucursal     := Var_IVA;

  SET Var_PagaIVA       := IFNULL(Var_PagaIVA, SIPagaIVA);
  SET Var_PagaIVAInt      := IFNULL(Var_PagaIVAInt, SIPagaIVA);
  SET Var_PagaIVAMor      := IFNULL(Var_PagaIVAMor, SIPagaIVA);
  SET Var_TipoCalInteres    := IFNULL(Var_TipoCalInteres, Int_SalInsol);
  SET Var_IVA         := IFNULL(Var_IVA, Entero_Cero);
  SET Var_IVAMora       := IFNULL(Var_IVAMora, Entero_Cero);
  SET Var_CobraAccesoriosGen   := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);
  SET Var_IVANotaCargo := Var_IVASucursal;

  IF(Var_PagaIVA = NOPagaIVA ) THEN
    SET Var_IVA := Entero_Cero;
    SET Var_IVAMora := Entero_Cero;
  ELSE
    IF (Var_PagaIVAInt = NOPagaIVA) THEN
      SET Var_IVA := Entero_Cero;
    END IF;

    IF (Var_PagaIVAMor = NOPagaIVA) THEN
      SET Var_IVAMora := Entero_Cero;
    END IF;
  END IF;


  IF(Var_TipoCredito != Reestructura) THEN
    SELECT   SUM(Capital),SUM(Interes), SUM(IVAInteres),  SUM(MontoSeguroCuota),  SUM(IVASeguroCuota),
        SUM(MontoOtrasComisiones),  SUM(MontoIVAOtrasComisiones)
        INTO Var_TotalCap,Var_TotalInt,Var_TotalIva,  Var_TotalMontoSeguroCuota,  Var_TotalIVASeguroCuota,
                Var_TotalOtrasComisiones, Var_TotalIVAOtrasComisiones
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID;
    ELSE
    SELECT SUM(Amo.Capital),    SUM(Amo.Interes), SUM(Amo.IVAInteres),  SUM(Amo.MontoSeguroCuota),  SUM(Amo.IVASeguroCuota),
      SUM(Amo.MontoOtrasComisiones),  SUM(Amo.MontoIVAOtrasComisiones)
      INTO Var_TotalCap,      Var_TotalInt,   Var_TotalIva,     Var_TotalMontoSeguroCuota,    Var_TotalIVASeguroCuota,
            Var_TotalOtrasComisiones, Var_TotalIVAOtrasComisiones
      FROM SOLICITUDCREDITO Sol
        INNER JOIN CREDITOS Cre
          ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Sol.Estatus= EstDesembolso
          AND Sol.TipoCredito= Reestructura
        INNER JOIN REESTRUCCREDITO Res
          ON Res.CreditoOrigenID = Cre.CreditoID
          AND Res.CreditoDestinoID = Cre.CreditoID
          AND Cre.TipoCredito = Reestructura
        INNER JOIN AMORTICREDITO Amo
          ON Amo.CreditoID = Cre.CreditoID
        WHERE Amo.CreditoID = Par_CreditoID
          AND (Amo.FechaLiquida > Var_FechaRegistro
          OR Amo.FechaLiquida = Fecha_Vacia);
  END IF;


    SELECT AmortizacionID,  FechaInicio,        FechaVencim,        FechaExigible,
      Estatus,            Capital,            Interes,            IVAInteres,
      SaldoCapital,       SaldoCapVigente,    SaldoCapAtrasa,     SaldoCapVencido,
      SaldoCapVenNExi,
      ROUND(SaldoInteresPro,2) AS SaldoInteresPro,
      ROUND(SaldoInteresAtr,2) AS SaldoInteresAtr,
      ROUND(SaldoInteresVen,2) AS SaldoInteresVen,
      ROUND(SaldoIntNoConta,2) AS SaldoIntNoConta,

      CASE Var_TipoCalInteres
      WHEN Int_SalInsol THEN
      ROUND(SaldoInteresPro * Var_IVA, 2) +
      ROUND(SaldoInteresAtr * Var_IVA, 2) +
      ROUND(SaldoInteresVen * Var_IVA, 2) +
      ROUND(SaldoIntNoConta * Var_IVA, 2)
      WHEN Int_SalGlobal THEN
      ROUND(IF((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2))=Interes,
      /* THEN */ IVAInteres,
      /* ELSE */ ((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2)) * Var_IVA)), 2)
      END AS SaldoIVAInteres,

      (SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) AS SaldoMoratorios,

      ROUND(SaldoMoratorios * Var_IVAMora, 2) +
      ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
      ROUND(SaldoMoraCarVen * Var_IVAMora, 2) AS SaldoIVAMora,

      SaldoComFaltaPa AS SaldoComFaltaPa,
      ROUND(SaldoComFaltaPa * Var_IVA, 2) AS SaldoIVAComFalPag,
      (SaldoOtrasComis + SaldoComServGar) AS SaldoOtrasComis,


            CASE WHEN Var_CobraAccesoriosGen = SIPagaIVA THEN FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_IVASucursal, Var_PagaIVA)
      ELSE
        ROUND(SaldoOtrasComis * Var_IVA, 2) +  ROUND(SaldoComServGar * Var_IVA, 2)
            END  AS SaldoIVAOtrCom,
      ROUND(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
      SaldoCapVenNExi + SaldoInteresPro + SaldoInteresAtr +
      SaldoInteresVen + SaldoIntNoConta +
      (SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) + SaldoComFaltaPa + SaldoComServGar +
      SaldoOtrasComis, 2)  +

      ROUND(SaldoInteresPro * Var_IVA, 2) +
      ROUND(SaldoInteresAtr * Var_IVA, 2) +
      ROUND(SaldoInteresVen * Var_IVA, 2) +
      ROUND(SaldoIntNoConta * Var_IVA, 2) +
      ROUND(SaldoMoratorios * Var_IVAMora, 2) +
      ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
      ROUND(SaldoMoraCarVen * Var_IVAMora, 2) +
      ROUND(SaldoComFaltaPa * Var_IVA, 2) +
           ( CASE WHEN Var_CobraAccesoriosGen = SIPagaIVA THEN FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_IVASucursal, Var_PagaIVA)
      ELSE
        ROUND(SaldoOtrasComis * Var_IVA, 2) +  ROUND(SaldoComServGar * Var_IVA, 2)
            END ) +
      ROUND(SaldoComisionAnual, 2) +/*COMISION ANUAL*/
      ROUND(SaldoComisionAnual * Var_IVA, 2) +/*COMISION ANUAL*/
      ROUND(SaldoSeguroCuota,2) +
      ROUND(SaldoIVASeguroCuota,2) +
      ROUND(IFNULL(SaldoNotCargoRev, Decimal_Cero), 2) +
      ROUND(IFNULL(SaldoNotCargoSinIVA, Decimal_Cero), 2) +
      ROUND(IFNULL(SaldoNotCargoConIVA, Decimal_Cero), 2) +
      ROUND(IFNULL(SaldoNotCargoConIVA, Decimal_Cero) * Var_IVANotaCargo, 2)  AS TotalCuota,

      ROUND(Capital + Interes + IVAInteres + IFNULL(MontoSeguroCuota,Decimal_Cero) + IFNULL(IVASeguroCuota,Decimal_Cero) + IFNULL(MontoOtrasComisiones,Decimal_Cero) + IFNULL(MontoIVAOtrasComisiones,Decimal_Cero),2) AS MontoCuota,
      Var_TotalCap,Var_TotalInt,Var_TotalIva,
      /*SEGUROS*/
      ROUND(SaldoSeguroCuota,2) AS SaldoSeguroCuota,
      ROUND(SaldoIVASeguroCuota,2) AS SaldoIVASeguroCuota,
      ROUND(MontoSeguroCuota,2) AS MontoSeguroCuota,
      ROUND(IVASeguroCuota,2) AS IVASeguroCuota,
      Var_TotalMontoSeguroCuota AS TotalSeguroCuota,
      Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
      Var_CobraSeguroCuota AS CobraSeguroCuota,
      Var_CobraIVASeguroCuota AS CobraIVASeguroCuota,
      ROUND(SaldoComisionAnual, 2) AS SaldoComAnual,/*COMISION ANUAL*/
      ROUND(SaldoComisionAnual * Var_IVA, 2) SaldoComAnualIVA,/*COMISION ANUAL*/
            Var_TotalOtrasComisiones AS TotalOtrasComisiones,
            Var_TotalIVAOtrasComisiones AS TotalIVAOtrasComisiones,
            ROUND(MontoOtrasComisiones,2) AS MontoOtrasComisiones,
            ROUND(MontoIVAOtrasComisiones,2) AS MontoIVAOtrasComisiones,
            (ROUND(SaldoOtrasComis,2) + ROUND(SaldoComServGar,2)) AS SaldoOtrasComisiones,
            ROUND(SaldoNotCargoRev, 2) + ROUND(SaldoNotCargoSinIVA, 2) + ROUND(SaldoNotCargoConIVA, 2) AS SaldoNotasCargo,
            ROUND(SaldoNotCargoConIVA * Var_IVANotaCargo, 2) AS MontoIvaNotaCargo
    FROM AMORTICREDITO
    WHERE CreditoID = Par_CreditoID;

END IF;

IF(Par_NumCon = Con_CalOrig) THEN
  SELECT Cre.TipoCredito INTO Var_TipoCredito
    FROM CREDITOS Cre,
       CLIENTES Cli,
       SUCURSALES Suc,
       PRODUCTOSCREDITO Pro
    WHERE Cre.CreditoID = Par_CreditoID
      AND Cre.ClienteID = Cli.ClienteID
      AND Cli.SucursalOrigen = Suc.SucursalID
      AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

  IF(Var_TipoCredito != Reestructura) THEN
    SELECT   SUM(Capital),SUM(Interes), SUM(IVAInteres), SUM(MontoSeguroCuota), SUM(IVASeguroCuota),
        SUM(MontoOtrasComisiones),  SUM(MontoIVAOtrasComisiones)
        INTO Var_TotalCap,Var_TotalInt,Var_TotalIva, Var_TotalMontoSeguroCuota, Var_TotalIVASeguroCuota,
        Var_TotalOtrasComisiones, Var_TotalIVAOtrasComisiones
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID;
  ELSE
    SELECT SUM(Amo.Capital),      SUM(Amo.Interes), SUM(Amo.IVAInteres), SUM(Amo.MontoSeguroCuota), SUM(Amo.IVASeguroCuota),
        SUM(Amo.MontoOtrasComisiones),  SUM(Amo.MontoIVAOtrasComisiones)
        INTO Var_TotalCap,Var_TotalInt,Var_TotalIva, Var_TotalMontoSeguroCuota, Var_TotalIVASeguroCuota,
                Var_TotalOtrasComisiones, Var_TotalIVAOtrasComisiones
      FROM SOLICITUDCREDITO Sol
        INNER JOIN CREDITOS Cre
          ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Sol.Estatus= EstDesembolso
          AND Sol.TipoCredito= Reestructura
        INNER JOIN REESTRUCCREDITO Res
          ON Res.CreditoOrigenID = Cre.CreditoID
          AND Res.CreditoDestinoID = Cre.CreditoID
          AND Cre.TipoCredito = Reestructura
        INNER JOIN AMORTICREDITO Amo
          ON Amo.CreditoID = Cre.CreditoID
        WHERE Amo.CreditoID = Par_CreditoID
          AND (Amo.FechaLiquida > Var_FechaRegistro
          OR Amo.FechaLiquida = Fecha_Vacia);
  END IF;

  SELECT  AmortizacionID, FechaInicio,  FechaVencim,  FechaExigible,    Estatus,
      Capital,    Interes,    IVAInteres,   MontoSeguroCuota, IVASeguroCuota,
            MontoOtrasComisiones, MontoIVAOtrasComisiones,
      (Capital+ Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota + MontoOtrasComisiones + MontoIVAOtrasComisiones + MontoIntOtrasComis + MontoIVAIntComisi)  AS TotalCuota,
      SaldoCapital,FORMAT(Var_TotalCap,2) AS TotalCapital,FORMAT(Var_TotalInt,2) AS TotalInteres,
      FORMAT(Var_TotalIva,2) AS TotalIVA,
      FORMAT(Var_TotalMontoSeguroCuota,2) AS TotalSeguroCuota,
      FORMAT(Var_TotalIVASeguroCuota,2) AS TotalIVASeguroCuota,
      FORMAT(Var_TotalOtrasComisiones,2) AS TotalOtrasComisiones,
            FORMAT(Var_TotalIVAOtrasComisiones,2) AS TotalIVAOtrasComisiones
      FROM AMORTICREDITO
    WHERE CreditoID = Par_CreditoID;

END IF;

IF(Par_NumCon = Con_CalWSCRCB) THEN
  SELECT Cre.TipoCredito INTO Var_TipoCredito
    FROM CREDITOS Cre
    WHERE Cre.CreditoID = Par_CreditoID;

  IF(Var_TipoCredito != Reestructura) THEN
    SELECT   SUM(Capital),SUM(Interes), SUM(IVAInteres), SUM(MontoSeguroCuota), SUM(IVASeguroCuota)
        INTO Var_TotalCap,Var_TotalInt,Var_TotalIva, Var_TotalMontoSeguroCuota, Var_TotalIVASeguroCuota
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID;
  ELSE
    SELECT SUM(Amo.Capital),SUM(Amo.Interes), SUM(Amo.IVAInteres), SUM(Amo.MontoSeguroCuota), SUM(Amo.IVASeguroCuota)
        INTO Var_TotalCap,Var_TotalInt,Var_TotalIva, Var_TotalMontoSeguroCuota, Var_TotalIVASeguroCuota
      FROM SOLICITUDCREDITO Sol
        INNER JOIN CREDITOS Cre
          ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Sol.Estatus= EstDesembolso
          AND Sol.TipoCredito= Reestructura
        INNER JOIN REESTRUCCREDITO Res
          ON Res.CreditoOrigenID = Cre.CreditoID
          AND Res.CreditoDestinoID = Cre.CreditoID
          AND Cre.TipoCredito = Reestructura
        INNER JOIN AMORTICREDITO Amo
          ON Amo.CreditoID = Cre.CreditoID
        WHERE Amo.CreditoID = Par_CreditoID
          AND (Amo.FechaLiquida > Var_FechaRegistro
          OR Amo.FechaLiquida = Fecha_Vacia);
  END IF;

    SELECT  MIN(FechaInicio),
      MAX(FechaVencim),
            MAX((Capital+ Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota)) AS MontoCuo,
            MIN(ClienteID)

    INTO
      Var_FechaIniAmor,
            Var_FechaUltAmor,
            Var_MaxMontoCuota,
            Var_ClienteID
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID;


  SELECT  AmortizacionID,     FechaInicio,      FechaVencim,      FechaExigible,    Estatus,
      Capital,        Interes,        IVAInteres,       MontoSeguroCuota, IVASeguroCuota,
      Var_FechaIniAmor,   Var_FechaUltAmor,     Var_MaxMontoCuota,    Var_ClienteID AS ClienteID,
            Par_CreditoID AS CreditoID,
      (Capital+ Interes + IVAInteres + MontoSeguroCuota + IVASeguroCuota) AS TotalPago,
      SaldoCapital AS SaldoInsoluto,FORMAT(Var_TotalCap,2) AS TotalCapital,FORMAT(Var_TotalInt,2) AS TotalInteres,
      FORMAT(Var_TotalIva,2) AS TotalIVA,
            FORMAT(Var_TotalMontoSeguroCuota,2) AS TotalSeguroCuota,
      FORMAT(Var_TotalIVASeguroCuota,2) AS TotalIVASeguroCuota,
            DATEDIFF(FechaVencim,FechaInicio) AS Dias

      FROM AMORTICREDITO
    WHERE CreditoID = Par_CreditoID
        ORDER BY AmortizacionID;
END IF;

    /* CONSULTA PARA OBTENER DATOS DEL CREDITO CONTIGENTE */
  IF(Con_SaldosCont = Par_NumCon) THEN

    SELECT  Cli.PagaIVA,    Suc.IVA,      Pro.CobraIVAInteres,  Pro.CobraIVAMora, Suc.IVA,
        Cre.TipoCredito,  Cre.TipoCalInteres
      INTO  Var_PagaIVA,    Var_IVA,      Var_PagaIVAInt,     Var_PagaIVAMor,   Var_IVAMora,
        Var_TipoCredito,  Var_TipoCalInteres
      FROM CREDITOSCONT Cre,
         CLIENTES Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
      WHERE Cre.CreditoID = Par_CreditoID
        AND Cre.ClienteID = Cli.ClienteID
        AND Cli.SucursalOrigen = Suc.SucursalID
        AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

    SET Var_PagaIVA     := IFNULL(Var_PagaIVA, SIPagaIVA);
    SET Var_PagaIVAInt    := IFNULL(Var_PagaIVAInt, SIPagaIVA);
    SET Var_PagaIVAMor    := IFNULL(Var_PagaIVAMor, SIPagaIVA);
    SET Var_TipoCalInteres  := IFNULL(Var_TipoCalInteres, Int_SalInsol);
    SET Var_IVA       := IFNULL(Var_IVA, Entero_Cero);
    SET Var_IVAMora     := IFNULL(Var_IVAMora, Entero_Cero);

    IF(Var_PagaIVA = NOPagaIVA ) THEN
      SET Var_IVA := Entero_Cero;
      SET Var_IVAMora := Entero_Cero;
    ELSE
      IF (Var_PagaIVAInt = NOPagaIVA) THEN
        SET Var_IVA := Entero_Cero;
      END IF;

      IF (Var_PagaIVAMor = NOPagaIVA) THEN
        SET Var_IVAMora := Entero_Cero;
      END IF;
    END IF;

    IF(Var_TipoCredito != Reestructura) THEN
      SELECT   SUM(Capital),  SUM(Interes), SUM(IVAInteres),  SUM(MontoSeguroCuota),    SUM(IVASeguroCuota)
        INTO Var_TotalCap,  Var_TotalInt, Var_TotalIva,   Var_TotalMontoSeguroCuota,  Var_TotalIVASeguroCuota
        FROM AMORTICREDITOCONT
        WHERE CreditoID = Par_CreditoID;
      ELSE
      SELECT   SUM(Amo.Capital),  SUM(Amo.Interes), SUM(Amo.IVAInteres),  SUM(Amo.MontoSeguroCuota),    SUM(Amo.IVASeguroCuota)
        INTO Var_TotalCap,    Var_TotalInt,   Var_TotalIva,     Var_TotalMontoSeguroCuota,    Var_TotalIVASeguroCuota
        FROM SOLICITUDCREDITO Sol
          INNER JOIN CREDITOSCONT Cre
            ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
            AND Sol.Estatus= EstDesembolso
            AND Sol.TipoCredito= Reestructura
          INNER JOIN REESTRUCCREDITO Res
            ON Res.CreditoOrigenID = Cre.CreditoID
            AND Res.CreditoDestinoID = Cre.CreditoID
            AND Cre.TipoCredito = Reestructura
          INNER JOIN AMORTICREDITOCONT Amo
            ON Amo.CreditoID = Cre.CreditoID
          WHERE Amo.CreditoID = Par_CreditoID
            AND (Amo.FechaLiquida > Var_FechaRegistro
            OR Amo.FechaLiquida = Fecha_Vacia);
    END IF;

    SELECT
      AmortizacionID,     FechaInicio,        FechaVencim,        FechaExigible,
      Estatus,            Capital,            Interes,            IVAInteres,
      SaldoCapital,       SaldoCapVigente,    SaldoCapAtrasa,     SaldoCapVencido,
      SaldoCapVenNExi,
      ROUND(SaldoInteresPro,2) AS SaldoInteresPro,
      ROUND(SaldoInteresAtr,2) AS SaldoInteresAtr,
      ROUND(SaldoInteresVen,2) AS SaldoInteresVen,
      ROUND(SaldoIntNoConta,2) AS SaldoIntNoConta,

      CASE Var_TipoCalInteres
      WHEN Int_SalInsol THEN
      ROUND(SaldoInteresPro * Var_IVA, 2) +
      ROUND(SaldoInteresAtr * Var_IVA, 2) +
      ROUND(SaldoInteresVen * Var_IVA, 2) +
      ROUND(SaldoIntNoConta * Var_IVA, 2)
      WHEN Int_SalGlobal THEN
      ROUND(IF((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2))=Interes,
      IVAInteres,
      ((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2)) * Var_IVA)), 2)
      END AS SaldoIVAInteres,

      (SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) AS SaldoMoratorios,

      ROUND(SaldoMoratorios * Var_IVAMora, 2) +
      ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
      ROUND(SaldoMoraCarVen * Var_IVAMora, 2) AS SaldoIVAMora,

      SaldoComFaltaPa AS SaldoComFaltaPa,
      ROUND(SaldoComFaltaPa * Var_IVA, 2) AS SaldoIVAComFalPag,
      SaldoOtrasComis AS SaldoOtrasComis,
      ROUND(SaldoOtrasComis * Var_IVA, 2) AS SaldoIVAOtrCom,

      ROUND(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
      SaldoCapVenNExi + SaldoInteresPro + SaldoInteresAtr +
      SaldoInteresVen + SaldoIntNoConta +
      (SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) + SaldoComFaltaPa +
      SaldoOtrasComis, 2)  +

      ROUND(SaldoInteresPro * Var_IVA, 2) +
      ROUND(SaldoInteresAtr * Var_IVA, 2) +
      ROUND(SaldoInteresVen * Var_IVA, 2) +
      ROUND(SaldoIntNoConta * Var_IVA, 2) +
      ROUND(SaldoMoratorios * Var_IVAMora, 2) +
      ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
      ROUND(SaldoMoraCarVen * Var_IVAMora, 2) +
      ROUND(SaldoComFaltaPa * Var_IVA, 2) +
      ROUND(SaldoOtrasComis * Var_IVA, 2) +
      ROUND(SaldoComisionAnual, 2) +/*COMISION ANUAL*/
      ROUND(SaldoComisionAnual * Var_IVA, 2) +/*COMISION ANUAL*/
      ROUND(SaldoSeguroCuota,2) +
      ROUND(SaldoIVASeguroCuota,2) AS TotalCuota,

      ROUND(Capital + Interes + IVAInteres + IFNULL(MontoSeguroCuota,Decimal_Cero) + IFNULL(IVASeguroCuota,Decimal_Cero),2) AS MontoCuota,
      Var_TotalCap,Var_TotalInt,Var_TotalIva,
      /*SEGUROS*/
      ROUND(SaldoSeguroCuota,2) AS SaldoSeguroCuota,
      ROUND(SaldoIVASeguroCuota,2) AS SaldoIVASeguroCuota,
      ROUND(MontoSeguroCuota,2) AS MontoSeguroCuota,
      ROUND(IVASeguroCuota,2) AS IVASeguroCuota,
      Var_TotalMontoSeguroCuota AS TotalSeguroCuota,
      Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
      ROUND(SaldoComisionAnual, 2) AS SaldoComAnual,/*COMISION ANUAL*/
      ROUND(SaldoComisionAnual * Var_IVA, 2) SaldoComAnualIVA/*COMISION ANUAL*/
    FROM AMORTICREDITOCONT
    WHERE CreditoID = Par_CreditoID;

  END IF;

END TerminaStore$$