-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOWSLIS`;

DELIMITER $$
CREATE PROCEDURE `AMORTICREDITOWSLIS`(
  /*SP para listar las amortizaciones de credito*/
  Par_CreditoID     BIGINT(12),       -- CREDITOID
  Par_Usuario       VARCHAR(15),        -- USUARIO
    Par_Clave       VARCHAR(100),     -- CLAVE
  Par_NumCon        TINYINT UNSIGNED,   -- NUMERO DE CONSULTA
    /* Parametros de Auditoria */
  Aud_EmpresaID     INT(11),        -- AUDITORIA

  Aud_Usuario       INT(11),        -- AUDITORIA
  Aud_FechaActual     DATETIME,       -- AUDITORIA
  Aud_DireccionIP     VARCHAR(15),      -- AUDITORIA
  Aud_ProgramaID      VARCHAR(50),      -- AUDITORIA
  Aud_Sucursal      INT(11),        -- AUDITORIA

  Aud_NumTransaccion    BIGINT(20)        -- AUDITORIA
  	)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_PagaIVA       CHAR(1);        -- PAGA IVA
DECLARE Var_IVA           DECIMAL(12,2);      -- IVA
DECLARE Var_PagaIVAInt    CHAR(1);        -- PAGA IVA INT
DECLARE Var_PagaIVAMor    CHAR(1);        -- PAGA IVA AMORT
DECLARE Var_IVAMora       DECIMAL(12,2);      -- IVA MORA
DECLARE Var_TotalInt    DECIMAL(14,2);      -- TOTAL INT
DECLARE Var_TipoCredito   CHAR(1);        -- TIPO CREDITO
DECLARE Var_FechaRegistro   DATE;         -- FECHA REGISTRO
DECLARE Var_PerfilWsVbc   INT(11);        -- PERFIL OPERACIONES VBC
DECLARE Var_CreditoID   BIGINT;         -- CREDITO ID
DECLARE Var_FecActual       DATE;         -- FECHA ACTUAL


-- Declaracion de Constantes
DECLARE Cadena_Vacia      CHAR(1);        -- CADENA VACIA
DECLARE Fecha_Vacia       DATE;         -- FECHA VACIA
DECLARE Entero_Cero       INT;          -- ENTERO CERO
DECLARE SIPagaIVA         CHAR(1);        -- PAGA IVA SI
DECLARE NOPagaIVA         CHAR(1);        -- PAGA IVA NO
DECLARE Con_Amorti        INT;          -- CONSULTA AMORTIZACIONES
DECLARE Con_AmortiPagos     INT;          -- CONSULTA AMORTI PAGOS
DECLARE Reestructura    CHAR(1);        -- REESTRUCTURA
DECLARE EstDesembolso     CHAR(1);        -- ES DESEMBOLSO
DECLARE Est_Vigente       CHAR(1);        -- ESTATUS VIGENTE
DECLARE Est_Vencido       CHAR(1);        -- ESTATUS VENCIDO
DECLARE Est_Atrasado      CHAR(1);        -- ESTATUS ATRASADO
DECLARE Est_Activo      CHAR(1);          -- ESTATUS ACTIVO
DECLARE Est_Pagado      CHAR(1);          -- ESTATUS PAGADO
DECLARE Var_Vigente       VARCHAR(50);      -- VIGENTE
DECLARE Var_Vencido       VARCHAR(50);      -- VENCIDO
DECLARE Var_Atrasado      VARCHAR(50);        -- ATRASADO
DECLARE Var_Pagado      VARCHAR(50);        -- PAGADO


-- Asignacion de Constantes
SET Cadena_Vacia        := '';          -- CADENA VACIA
SET Fecha_Vacia         := '1900-01-01';    -- FECHA VACIA
SET Entero_Cero         := 0;         -- ENTERO CERO
SET SIPagaIVA           := 'S';               -- SI PAGA IVA
SET NOPagaIVA           := 'N';               -- NO PAGA IVA
SET Con_Amorti          := 1;                 -- CONSULTA DE AMORTIZACIONES
SET Con_AmortiPagos       := 2;                 -- CONSULTA DE AMORTIZACIONES PAGADAS
SET Reestructura      := 'R';               -- ES REESTRUCTURA
SET EstDesembolso     := 'D';               -- ESTATUS DESEMBOLSO
SET Est_Vigente       := 'V';               -- ESTATUS VIGENTE
SET Est_Vencido       := 'B';               -- ESTATIS VENCIDO
SET Est_Atrasado      := 'A';             -- ESTATUS ATRASADO
SET Est_Pagado        := 'P';         -- ESTATUS PAGADO
SET Est_Activo        := 'A';         -- ESTATUS ACTIVO
SET Var_Vigente       := 'VIGENTE';     -- ESTATUS VIGENTE
SET Var_Vencido       := 'VENCIDO';     -- ESTATIS VENCIDO
SET Var_Atrasado      := 'ATRASADO';      -- ESTATUS ATRASADO
SET Var_Pagado        := 'PAGADO';      -- ESTATUS PAGASO


SET Var_PerfilWsVbc   := (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
SET Var_PerfilWsVbc   := IFNULL(Var_PerfilWsVbc,Entero_Cero);


SELECT FechaSistema INTO Var_FecActual
  FROM PARAMETROSSIS;

SELECT  Cli.PagaIVA,    Suc.IVA,      Pro.CobraIVAInteres,  Pro.CobraIVAMora, Suc.IVA,
    Cre.TipoCredito
  INTO  Var_PagaIVA,    Var_IVA,      Var_PagaIVAInt,     Var_PagaIVAMor,   Var_IVAMora,
    Var_TipoCredito
  FROM CREDITOS Cre,
     CLIENTES Cli,
     SUCURSALES Suc,
     PRODUCTOSCREDITO Pro
  WHERE Cre.CreditoID = Par_CreditoID
    AND Cre.ClienteID = Cli.ClienteID
    AND Cli.SucursalOrigen = Suc.SucursalID
    AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

SET Var_PagaIVA     := IFNULL(Var_PagaIVA,    SIPagaIVA);
SET Var_PagaIVAInt    := IFNULL(Var_PagaIVAInt,   SIPagaIVA);
SET Var_PagaIVAMor    := IFNULL(Var_PagaIVAMor,   SIPagaIVA);
SET Var_IVA       := IFNULL(Var_IVA,      Entero_Cero);
SET Var_IVAMora     := IFNULL(Var_IVAMora,    Entero_Cero);

IF(Var_PagaIVA = NOPagaIVA ) THEN
  SET Var_IVA     := Entero_Cero;
  SET Var_IVAMora   := Entero_Cero;
ELSE
  IF (Var_PagaIVAInt = NOPagaIVA) THEN
    SET Var_IVA   := Entero_Cero;
  END IF;
  IF (Var_PagaIVAMor = NOPagaIVA) THEN
    SET Var_IVAMora := Entero_Cero;
  END IF;
END IF;

SELECT FechaRegistro  INTO Var_FechaRegistro
  FROM  REESTRUCCREDITO Res,
      CREDITOS Cre
  WHERE Res.CreditoOrigenID   = Par_CreditoID
    AND Res.CreditoDestinoID  = Par_CreditoID
    AND Cre.CreditoID       = Res.CreditoDestinoID
    AND Res.EstatusReest    = EstDesembolso
    AND Res.Origen        = Reestructura;


IF(Con_Amorti = Par_NumCon) THEN

  IF(Var_PerfilWsVbc = Entero_Cero)THEN
    SELECT  Entero_Cero   AS CreditoID,
        Entero_Cero   AS AmortizacionID,
        Entero_Cero   AS ClienteID,
        Fecha_Vacia   AS FechaExigible,
        Entero_Cero   AS TotalExigible,
        Entero_Cero   AS Capital,
        Entero_Cero   AS Interes,
        Entero_Cero   AS IvaInteres,
        Entero_Cero   AS InteresMora,
        Entero_Cero   AS IvaInteresMora,
        Cadena_Vacia  AS Estatus,
              '60'      AS NumErr,
        'No existe perfil definido para el usuario.' AS ErrMen;
    LEAVE TerminaStore;
  END IF;

  SET Aud_Usuario := (SELECT UsuarioID
                          FROM USUARIOS
                          WHERE Clave = Par_Usuario
                              AND Contrasenia = Par_Clave
                              AND Estatus = Est_Activo  AND RolID = Var_PerfilWsVbc);

  SET Aud_Usuario := IFNULL(Aud_Usuario, Entero_Cero);
  IF(Aud_Usuario = Entero_Cero)THEN
    SELECT  Entero_Cero   AS CreditoID,
        Entero_Cero   AS AmortizacionID,
        Entero_Cero   AS ClienteID,
        Fecha_Vacia   AS FechaExigible,
        Entero_Cero   AS TotalExigible,
        Entero_Cero   AS Capital,
        Entero_Cero   AS Interes,
        Entero_Cero   AS IvaInteres,
        Entero_Cero   AS InteresMora,
        Entero_Cero   AS IvaInteresMora,
        Cadena_Vacia  AS Estatus,
              '07'      AS NumErr,
        'Usuario o Password no valido' AS ErrMen;
    LEAVE TerminaStore;
  END IF;

  SET Var_CreditoID := (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);

  IF(Var_CreditoID = Entero_Cero)THEN
    SELECT  Entero_Cero   AS CreditoID,
        Entero_Cero   AS AmortizacionID,
        Entero_Cero   AS ClienteID,
        Fecha_Vacia   AS FechaExigible,
        Entero_Cero   AS TotalExigible,
        Entero_Cero   AS Capital,
        Entero_Cero   AS Interes,
        Entero_Cero   AS IvaInteres,
        Entero_Cero   AS InteresMora,
        Entero_Cero   AS IvaInteresMora,
        Cadena_Vacia  AS Estatus,
              '01'      AS NumErr,
        'El Credito No Existe' AS ErrMen;
    LEAVE TerminaStore;
  END IF;

  SELECT
    CreditoID,    AmortizacionID,   ClienteID,    FechaExigible,
    CASE Estatus
      WHEN Est_Vigente  THEN Var_Vigente
      WHEN Est_Vencido  THEN Var_Vencido
      WHEN Est_Atrasado   THEN Var_Atrasado
      ELSE Estatus END AS Estatus,
    ROUND(SaldoCapVigente + SaldoCapAtrasa  + SaldoCapVencido + SaldoCapVenNExi ,2) AS Capital,
    ROUND(SaldoInteresPro + SaldoInteresAtr + SaldoInteresVen + SaldoIntNoConta ,2) AS Interes,
    ( ROUND(SaldoInteresPro   * Var_IVA, 2) + ROUND(SaldoInteresAtr   * Var_IVA, 2) +
      ROUND(SaldoInteresVen   * Var_IVA, 2) + ROUND(SaldoIntNoConta   * Var_IVA, 2)) AS IvaInteres,
    (SaldoMoratorios+ SaldoMoraVencido  + SaldoMoraCarVen)AS InteresMora,
    ( ROUND(SaldoMoratorios   * Var_IVAMora, 2) +
      ROUND(SaldoMoraVencido  * Var_IVAMora, 2) +
      ROUND(SaldoMoraCarVen   * Var_IVAMora, 2) ) AS IvaInteresMora,
    ROUND(
      SaldoCapVigente + SaldoCapAtrasa  + SaldoCapVencido + SaldoCapVenNExi +
      SaldoInteresPro + SaldoInteresAtr + SaldoInteresVen + SaldoIntNoConta +
      (SaldoMoratorios+ SaldoMoraVencido  + SaldoMoraCarVen) + SaldoComFaltaPa + SaldoComServGar +
      SaldoOtrasComis, 2)  +
      ROUND(SaldoInteresPro   * Var_IVA, 2) +
      ROUND(SaldoInteresAtr   * Var_IVA, 2) +
      ROUND(SaldoInteresVen   * Var_IVA, 2) +
      ROUND(SaldoIntNoConta   * Var_IVA, 2) +
      ROUND(SaldoMoratorios   * Var_IVAMora, 2) +
      ROUND(SaldoMoraVencido  * Var_IVAMora, 2) +
      ROUND(SaldoMoraCarVen   * Var_IVAMora, 2) +
      ROUND(SaldoComFaltaPa   * Var_IVA, 2) +
      ROUND(SaldoComServGar   * Var_IVA, 2) +
      ROUND(SaldoOtrasComis   * Var_IVA, 2) +
      ROUND(SaldoComisionAnual, 2) +/*COMISION ANUAL*/
      ROUND(SaldoComisionAnual * Var_IVA, 2) +/*COMISION ANUAL*/
      ROUND(SaldoSeguroCuota,2) +
      ROUND(SaldoIVASeguroCuota,2) AS TotalExigible, Entero_Cero AS NumErr, "CONSULTA REALIZADA" AS ErrMen
  FROM AMORTICREDITO
  WHERE   CreditoID   =   Par_CreditoID
    AND Estatus   IN  (Est_Vigente, Est_Vencido, Est_Atrasado)
  ;
END IF;

IF(Con_AmortiPagos = Par_NumCon) THEN

  IF(Var_PerfilWsVbc = Entero_Cero)THEN
    SELECT  Entero_Cero   AS CreditoID,
        Entero_Cero   AS AmortizacionID,
        Entero_Cero   AS ClienteID,
        Fecha_Vacia   AS FechaExigible,
        Entero_Cero   AS TotalPagado,
        Entero_Cero   AS CapitalPagado,
        Entero_Cero   AS Interes,
        Entero_Cero   AS IvaInteres,
        Entero_Cero   AS InteresMora,
        Entero_Cero   AS IvaInteresMora,
        Fecha_Vacia   AS FechaPago,
        Entero_Cero   AS DiasAtraso,
        Cadena_Vacia  AS Estatus,
              '60'      AS NumErr,
        'No existe perfil definido para el usuario.' AS ErrMen;
    LEAVE TerminaStore;
  END IF;

  SET Aud_Usuario := (SELECT UsuarioID
                          FROM USUARIOS
                          WHERE Clave = Par_Usuario
                              AND Contrasenia = Par_Clave
                              AND Estatus = Est_Activo  AND RolID = Var_PerfilWsVbc);

  SET Aud_Usuario := IFNULL(Aud_Usuario, Entero_Cero);
  IF(Aud_Usuario = Entero_Cero)THEN
    SELECT  Entero_Cero   AS CreditoID,
        Entero_Cero   AS AmortizacionID,
        Entero_Cero   AS ClienteID,
        Fecha_Vacia   AS FechaExigible,
        Entero_Cero   AS TotalPagado,
        Entero_Cero   AS CapitalPagado,
        Entero_Cero   AS Interes,
        Entero_Cero   AS IvaInteres,
        Entero_Cero   AS InteresMora,
        Entero_Cero   AS IvaInteresMora,
        Fecha_Vacia   AS FechaPago,
        Entero_Cero   AS DiasAtraso,
        Cadena_Vacia  AS Estatus,
              '07'      AS NumErr,
        'Usuario o Password no valido' AS ErrMen;
    LEAVE TerminaStore;
  END IF;

  SET Var_CreditoID := (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);

  IF(Var_CreditoID = Entero_Cero)THEN
    SELECT  Entero_Cero   AS CreditoID,
        Entero_Cero   AS AmortizacionID,
        Entero_Cero   AS ClienteID,
        Fecha_Vacia   AS FechaExigible,
        Entero_Cero   AS TotalPagado,
        Entero_Cero   AS CapitalPagado,
        Entero_Cero   AS Interes,
        Entero_Cero   AS IvaInteres,
        Entero_Cero   AS InteresMora,
        Entero_Cero   AS IvaInteresMora,
        Fecha_Vacia   AS FechaPago,
        Entero_Cero   AS DiasAtraso,
        Cadena_Vacia  AS Estatus,
              '01'      AS NumErr,
        'El Credito No Existe' AS ErrMen;
    LEAVE TerminaStore;
  END IF;

  SELECT  A.CreditoID,  IFNULL(D.FechaPago,Fecha_Vacia) AS FechaPago ,  A.AmortizacionID, A.FechaExigible,  A.ClienteID,
      CASE A.Estatus
        WHEN Est_Vigente  THEN Var_Vigente
        WHEN Est_Vencido  THEN Var_Vencido
        WHEN Est_Atrasado   THEN Var_Atrasado
        WHEN Est_Pagado   THEN Var_Pagado
        ELSE A.Estatus END AS Estatus,
      ROUND(IFNULL(SUM(D.MontoTotPago),Entero_Cero) ,2) AS TotalPagado,
      ROUND(IFNULL(SUM(D.MontoCapOrd + D.MontoCapAtr + D.MontoCapVen),Entero_Cero),2) AS CapitalPagado,
        ROUND(IFNULL(SUM(D.MontoIntOrd + D.MontoIntAtr + D.MontoIntVen),Entero_Cero),2) AS Interes,
        ROUND(IFNULL(SUM(D.MontoIntOrd + D.MontoIntAtr + D.MontoIntVen),Entero_Cero),2) AS IvaInteres,
        ROUND(IFNULL(SUM(D.MontoIntMora),Entero_Cero),2) AS InteresMora,
        ROUND(IFNULL(SUM(D.MontoIntMora),Entero_Cero),2) AS IvaInteresMora,
        CASE A.Estatus
          WHEN Est_Pagado   THEN Entero_Cero
          WHEN Est_Vigente  THEN Entero_Cero
          ELSE DATEDIFF(Var_FecActual, A.FechaVencim) END AS DiasAtraso,
        Entero_Cero AS NumErr, "CONSULTA REALIZADA" AS ErrMen
      FROM AMORTICREDITO A
          LEFT JOIN DETALLEPAGCRE D ON D.AmortizacionID = A.AmortizacionID
               AND D.CreditoID = A.CreditoID
        WHERE A.CreditoID= Par_CreditoID
        GROUP BY A.AmortizacionID,  D.FechaPago,  A.CreditoID,  A.FechaExigible,
             A.ClienteID,     A.Estatus;


END IF;

END TerminaStore$$