-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTERACOBRANZAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTERACOBRANZAREP`;DELIMITER $$

CREATE PROCEDURE `CARTERACOBRANZAREP`(
-- SP QUE SE UTILIZA PARA LA GENERACION DEL REPORTE CARTERA POR COBRANZA DEL MODULO DE COBRANZA

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT (11),
    Aud_NumTransaccion  BIGINT
  )
TerminaStore: BEGIN

-- Declaracion de constantes
    DECLARE Entero_Cero     INT(11);
    DECLARE Decimal_Cero    DECIMAL(16,2);
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Est_Vigente     CHAR(1);

    DECLARE Est_VigenteDes  CHAR(15);
    DECLARE Est_Vencido     CHAR(1);
    DECLARE Est_VencidoDes  CHAR(15);
    DECLARE FechaSist       DATE;
    DECLARE Var_Si          CHAR(1);

    DECLARE Cuota_Semanal   CHAR(1);
    DECLARE Cuota_SemDesc   VARCHAR(15);
    DECLARE Cuota_Catorce   CHAR(1);
    DECLARE Cuota_CatDesc   VARCHAR(15);
    DECLARE Cuota_Quincenal CHAR(1);

    DECLARE Cuota_QuinDesc  VARCHAR(15);
    DECLARE Cuota_Mensual   CHAR(1);
    DECLARE Cuota_MenDesc   VARCHAR(15);
    DECLARE Cuota_Periodo   CHAR(1);
    DECLARE Cuota_PerDesc   VARCHAR(15);

    DECLARE Cuota_Bimestral     CHAR(1);
    DECLARE Cuota_BimDesc       VARCHAR(15);
    DECLARE Cuota_Trimestral    CHAR(1);
    DECLARE Cuota_TrimDesc      VARCHAR(15);
    DECLARE Cuota_Tetrames      CHAR(1);

    DECLARE Cuota_TetraDesc     VARCHAR(15);
    DECLARE Cuota_Semestral     CHAR(1);
    DECLARE Cuota_SemesDesc     VARCHAR(15);
    DECLARE Cuota_Anual         CHAR(1);
    DECLARE Cuota_AnualDesc     VARCHAR(15);

    DECLARE Cuota_Libres    CHAR(1);
    DECLARE Cuota_libDesc   VARCHAR(15);
    DECLARE Var_AhoOrd      INT(11);
    DECLARE Var_AhoVis      INT(11);
    DECLARE Est_Si          CHAR(2);

    DECLARE Est_No              CHAR(2);
    DECLARE Var_FechaAnterior   DATE;
    DECLARE Var_FechaCorte      DATE;
    DECLARE Est_Pagado          CHAR(1);
    DECLARE Est_Activo          CHAR(1);

    DECLARE EsAhorroInversion   VARCHAR(50);
    DECLARE EsInversion         VARCHAR(50);
    DECLARE EsAhorro            VARCHAR(50);
    DECLARE Var_No              CHAR(1);
    DECLARE Est_Bloq            CHAR(1);

    DECLARE Var_TipoBloqueo     INT(11);
    DECLARE Est_Atrasado        CHAR(1);


-- Asignación de constantes
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Est_Vigente         := 'V';       -- Estatus del credito V- Vigente

    SET Est_VigenteDes      := 'VIGENTE';   -- Descripcion estatus del credito V- Vigente
    SET Est_Vencido         := 'B';       -- Estatus del credito B- Vencido
    SET Est_VencidoDes      := 'VENCIDO';   -- Descripcion estatus del credito B- Vencido
    SET Var_Si              := 'S';

    SET Cuota_Semanal       :='S';        -- Cuota S - Semanal
    SET Cuota_SemDesc       :='SEMANAL';    -- Descripcion Cuota S - Semanal
    SET Cuota_Catorce       :='C';        -- Cuota C - Cartorcenal
    SET Cuota_CatDesc       :='CATORCENAL';   -- Descripcion Cuota C - Cartorcenal
    SET Cuota_Quincenal     :='Q';        -- Cuota Q - Quincenal

    SET Cuota_QuinDesc      :='QUINCENAL';    -- Descripcion Cuota Q - Quincenal
    SET Cuota_Mensual       :='M';        -- Cuota M - Mensual
    SET Cuota_MenDesc       :='MENSUAL';    -- Descripcion Cuota M - Mensual
    SET Cuota_Periodo       :='P';        -- Cuota P - Periodo
    SET Cuota_PerDesc       :='PERIODO';    -- Descripcion Cuota P - Periodo

    SET Cuota_Bimestral     :='B';        -- Cuota B - Bimestral
    SET Cuota_BimDesc       :='BIMESTRAL';    -- Descripcion Cuota B - Bimestral
    SET Cuota_Trimestral    :='T';        -- Cuota T - Trimestral
    SET Cuota_TrimDesc      :='TRIMESTRAL';   -- Descripcion Cuota T - Trimestral
    SET Cuota_Tetrames      :='R';        -- Cuota R - Tetratrimestral

    SET Cuota_TetraDesc     :='TETRATRIMESTRAL'; -- Descripcion Cuota R - Tetratrimestral
    SET Cuota_Semestral     :='E';        -- Cuota E - Semestral
    SET Cuota_SemesDesc     :='SEMESTRAL';    -- Descripcion Cuota E - Semestral
    SET Cuota_Anual         :='A';        -- Cuota A - Anual
    SET Cuota_AnualDesc     :='ANUAL';      -- Descripcion Cuota A - Anual

    SET Cuota_Libres        :='L';        -- Cuota L - Libres
    SET Cuota_libDesc       :='LIBRES';     -- Descripcion Cuota L - Libres
    SET Est_Si              :='SI';
    SET Est_No              :='NO';
    SET Est_Pagado          :='P';        -- Estatus Pagado P
    SET Est_Activo          :='A';        -- Estatus Activo A

    SET EsAhorroInversion   :='AHORRO-INVERSION';
    SET EsInversion         :='INVERSION';
    SET EsAhorro            :='AHORRO';
    SET Var_No              :='N';
    SET Est_Bloq            :='B';        -- ESTATUS BLOQUEADO

    SET Var_TipoBloqueo     := 8;       -- ID TIPOBLOQUEO TABLA BLOQUEOS
    SET Est_Atrasado        :='A';


    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);        -- FECHA DEL SISTEMA
    SET Var_FechaAnterior   := (SELECT DATE_ADD(FechaSist, INTERVAL -1 DAY));
    SELECT MAX(FechaCorte) INTO Var_FechaCorte FROM SALDOSCREDITOS;     -- ULTIMA FECHA DE CORTE


   -- ================ TABLA TEMPORAL PARA ALMACENAR LOS DATOS DEL CLIENTE Y DEL EJECUTIVO ===================

    DROP TABLE IF EXISTS TMPCARTERACLIENTE;
    CREATE TEMPORARY TABLE TMPCARTERACLIENTE(
      CreditoID     BIGINT(12),
            SolicitudCreditoID  BIGINT(12),
            SucursalEjecutivo INT(11),
            SucursalEjeDesc   VARCHAR(50),
            NumUsuario      BIGINT(12),
            NombreUsuario   VARCHAR(200),
      ClienteID     BIGINT(12),
      NombreCompleto    VARCHAR(200),
      FechaNacimiento   DATE,
      Edad        INT(11),
            GrupoNOSolidario  CHAR(2),
            FechaIngreso    DATE,
            PersonaRelacionada  CHAR(2),
      DireccionCompleta VARCHAR(200),
      MunicipioID     INT(11),
            Municipio     VARCHAR(100),
      EstadoID      INT(11),
            LocalidadID     INT(11),
            Localidad     VARCHAR(100),
      OcupacionID     INT(11),
            Ocupacion     TEXT,
      Telefono      VARCHAR(20),
      TelefonoCelular   VARCHAR(20),
      TelTrabajo      VARCHAR(20),
            NumPromesasPago   INT(11)

    );


  -- =================== SE LLENA LA TABLA CON LOS DATOS DEL CLIENTE ===================

    INSERT  INTO  TMPCARTERACLIENTE   (CreditoID,   SolicitudCreditoID,   ClienteID,      NombreCompleto,   FechaNacimiento,
                     Edad,      FechaIngreso,       DireccionCompleta,  MunicipioID,    LocalidadID,
                     EstadoID,    OcupacionID,      Telefono,       TelefonoCelular,  TelTrabajo)

      SELECT  Cre.CreditoID,     Cre.SolicitudCreditoID,  Cre.ClienteID,      Cli.NombreCompleto,
          Cli.FechaNacimiento, TIMESTAMPDIFF(YEAR, Cli.FechaNacimiento, CURDATE()) AS edad,
          Cli.FechaAlta,     Dir.DireccionCompleta,   Dir.MunicipioID,    Dir.LocalidadID, Dir.EstadoID,
          Cli.OcupacionID,   Cli.Telefono,        Cli.TelefonoCelular,  Cli.TelTrabajo
      FROM  SALDOSCREDITOS Sal
          INNER JOIN  CREDITOS Cre    ON  Sal.CreditoID=Cre.CreditoID
          INNER JOIN  CLIENTES Cli    ON  Cre.ClienteID=Cli.ClienteID
          LEFT  JOIN  DIRECCLIENTE Dir  ON  Cre.ClienteID= Dir.ClienteID
              AND   Dir.Oficial=Var_Si
      WHERE   Sal.FechaCorte =Var_FechaCorte
        AND (Sal.EstatusCredito=Est_Vencido OR Sal.EstatusCredito=Est_Vigente) ;



  -- ===================  SE ACTUALIZAN CAMPOS ===================

    -- MUNICIPIO
    UPDATE  TMPCARTERACLIENTE T,
      MUNICIPIOSREPUB M
  SET   T.Municipio=M.Nombre
    WHERE   T.MunicipioID=M.MunicipioID
    AND T.EstadoID=M.EstadoID;

    -- LOCALIDAD
    UPDATE  TMPCARTERACLIENTE T,
      LOCALIDADREPUB L
  SET   T.Localidad=L.NombreLocalidad
    WHERE T.EstadoID=L.EstadoID
    AND T.MunicipioID=L.MunicipioID
        AND T.LocalidadID=L.LocalidadID;

    -- OCUPACION
  UPDATE  TMPCARTERACLIENTE T,
      OCUPACIONES O
    SET T.Ocupacion=O.Descripcion
    WHERE T.OcupacionID=O.OcupacionID;

    -- DATOS DEL EJECUTIVO
  UPDATE  TMPCARTERACLIENTE T,
      SOLICITUDCREDITO S,
            USUARIOS U
  SET   T.NumUsuario=IFNULL(S.UsuarioAltaSol,Entero_Cero),
      T.NombreUsuario=U.NombreCompleto,
            T.SucursalEjecutivo=U.SucursalUsuario
  WHERE T.SolicitudCreditoID=S.SolicitudCreditoID
    AND S.UsuarioAltaSol=U.UsuarioID;


        -- DATOS DEL EJECUTIVO CREDITOS SIN SOLICITUD
  UPDATE  TMPCARTERACLIENTE T,
      CREDITOS C,
            USUARIOS U
  SET   T.NumUsuario=IFNULL(C.Usuario,Entero_Cero),
      T.NombreUsuario=U.NombreCompleto,
            T.SucursalEjecutivo=U.SucursalUsuario
  WHERE T.CreditoID=C.CreditoID
    AND C.Usuario=U.UsuarioID
        AND IFNULL(T.SolicitudCreditoID,Entero_Cero)=Entero_Cero;

         -- DESCRIPCION SUCURSAL
    UPDATE  TMPCARTERACLIENTE T,
      SUCURSALES S
  SET   T.SucursalEjeDesc=S.NombreSucurs
  WHERE T.SucursalEjecutivo=S.SucursalID;

  -- GRUPO NO SOLIDARIO
    UPDATE  TMPCARTERACLIENTE T
    SET   T.GrupoNOSolidario=Est_No
    WHERE   T.ClienteID  NOT IN (SELECT ClienteID
  FROM  INTEGRAGRUPONOSOL);

    UPDATE  TMPCARTERACLIENTE T
    SET   T.GrupoNOSolidario=Est_Si
    WHERE   T.ClienteID  IN (SELECT ClienteID
  FROM  INTEGRAGRUPONOSOL);

  -- PERSONA RELACIONADA
    UPDATE  TMPCARTERACLIENTE T
  SET   T.PersonaRelacionada=Est_Si
    WHERE   T.ClienteID IN (SELECT ClienteID
        FROM RELACIONCLIEMPLEADO );

    UPDATE  TMPCARTERACLIENTE T
  SET   T.PersonaRelacionada=Est_No
    WHERE   T.ClienteID NOT IN (SELECT ClienteID
        FROM RELACIONCLIEMPLEADO );



  -- ================ TABLA TEMPORAL PARA ALMACENAR LOS DATOS DEL CREDITO ===================

    DROP TABLE IF EXISTS TMPCARTERADETALLECRED;
  CREATE TEMPORARY TABLE TMPCARTERADETALLECRED(
      CreditoID       BIGINT(12),
            ClienteID       BIGINT(12),
            SucursalCredito   INT(11),
            SucursalCreDesc   VARCHAR(50),
      ProductoCreditoID INT(11),
            ProductoCredito   VARCHAR(100),
      EstatusCredito    VARCHAR(20),
      FechaInicio     DATE,
      FechaVencimiento  DATE,
      FrecuenciaCap   VARCHAR(20),
            AhorroOrd     DECIMAL(16,2),
            AhorroVista     DECIMAL(16,2),
            SaldoInversiones  DECIMAL(16,2),
      MontoCredito    DECIMAL(16,2),
      Total       DECIMAL(16,2),
      SalCapVigente   DECIMAL(16,2),
      SalCapVencido   DECIMAL(16,2),
      SalCapAtrasado    DECIMAL(16,2),
      SalIntOrdinario   DECIMAL(16,2),
      SalMoratorios   DECIMAL(16,2),
            CuotasPagadas   INT(11),
            CuotasVigentes    INT(11),
            CuotasVencidas    INT(11),
      DiasAtraso      INT(11),
            FechaUltimoPago   DATE,
      MontoGarantia   DECIMAL(16,2),
            CuentaGL      VARCHAR(50),
            GarPrendHipot     CHAR(2)
      );

-- =================== SE LLENA LA TABLA CON LOS DATOS DEL CREDITO ===================
  INSERT  INTO TMPCARTERADETALLECRED(
        CreditoID,    ProductoCreditoID,  EstatusCredito,   FechaInicio,    FechaVencimiento,
                FrecuenciaCap,  MontoCredito,     Total,        SalCapVigente,    SalCapVencido,
                SalCapAtrasado, SalIntOrdinario,  SalMoratorios,    DiasAtraso)

            SELECT  Sal.CreditoID,    MAX(Sal.ProductoCreditoID),
          CASE  WHEN MAX(Sal.EstatusCredito)=Est_Vencido   THEN  Est_VencidoDes
              WHEN MAX(Sal.EstatusCredito)=Est_Vigente   THEN  Est_VigenteDes
          END     AS EstatusCredito,
          MIN(Sal.FechaInicio),  MAX(Sal.FechaVencimiento),
                    CASE  WHEN MAX(Sal.FrecuenciaCap)=Cuota_Semanal  THEN  Cuota_SemDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Catorce  THEN  Cuota_CatDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Quincenal  THEN  Cuota_QuinDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Mensual  THEN  Cuota_MenDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Periodo  THEN  Cuota_PerDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Bimestral  THEN  Cuota_BimDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Trimestral THEN  Cuota_TrimDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Tetrames THEN  Cuota_TetraDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Semestral  THEN  Cuota_SemesDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Anual    THEN  Cuota_AnualDesc
                            WHEN MAX(Sal.FrecuenciaCap)=Cuota_Libres   THEN  Cuota_libDesc
          END     AS FrecuenciaCap,
          SUM(Sal.MontoCredito),
                    IFNULL(SUM(SalCapVigente  + SalCapAtrasado + SalCapVencido + SalCapVenNoExi),Entero_Cero) AS Total,
                    SUM(Sal.SalCapVigente),   IFNULL(SUM(Sal.SalCapVencido + Sal.SalCapVenNoExi),Entero_Cero),
                     SUM(Sal.SalCapAtrasado),    SUM(Sal.SalIntOrdinario),
                    IFNULL(SUM((SalIntNoConta+SalIntVencido+SalMoratorios+SaldoMoraVencido+SaldoMoraCarVen)),Entero_Cero) AS SalMoratorios,    MAX(Sal.DiasAtraso)
      FROM  SALDOSCREDITOS Sal
      WHERE   Sal.FechaCorte =Var_FechaCorte
        AND (Sal.EstatusCredito=Est_Vencido OR Sal.EstatusCredito=Est_Vigente)
        GROUP BY Sal.CreditoID;

      -- ===================  SE ACTUALIZAN CAMPOS ===================
  -- SUCURSAL CREDITO
    UPDATE  TMPCARTERADETALLECRED T,
      CREDITOS C
  SET   T.SucursalCredito=C.SucursalID,
      T.ClienteID=C.ClienteID
    WHERE   T.CreditoID=C.CreditoID;

        -- DESCRIPCION SUCURSAL
    UPDATE  TMPCARTERADETALLECRED T,
      SUCURSALES S
  SET   T.SucursalCreDesc=S.NombreSucurs
  WHERE T.SucursalCredito=S.SucursalID;

    -- PRODUCTO CREDITO
    UPDATE  TMPCARTERADETALLECRED T,
      PRODUCTOSCREDITO P
  SET   T.ProductoCredito=P.Descripcion
    WHERE   T.ProductoCreditoID=P.ProducCreditoID;


      -- ===================  TABLA DE AYUDA AHORRO ===================

        DROP TABLE IF EXISTS   TMPCARTERAAHORRO;
    CREATE TEMPORARY TABLE TMPCARTERAAHORRO(
      CreditoID       BIGINT(12),
      AhorroOrd     DECIMAL(16,2),
            AhorroVista     DECIMAL(16,2)

            );

     -- CONSULTAR DE PARAMETROS CAJA LOS TIPOS DE CUENTA
    SELECT  CtaOrdinaria, CuentaVista
      INTO  Var_AhoOrd,   Var_AhoVis
    FROM  PARAMETROSCAJA;

       -- LLENAR LA TABLA DE AYUDA

        INSERT INTO TMPCARTERAAHORRO ( CreditoID,   AhorroOrd,     AhorroVista)


    SELECT Cre.CreditoID,
        SUM(CASE WHEN C.TipoCuentaID = Var_AhoOrd THEN  IFNULL(C.SaldoDispon,Entero_Cero)
                ELSE  Entero_Cero END) AS ORD,
        SUM(CASE WHEN C.TipoCuentaID = Var_AhoVis THEN  IFNULL(C.SaldoDispon,Entero_Cero)
                ELSE  Entero_Cero END) AS VISTA

    FROM  CREDITOS Cre
      INNER JOIN CLIENTES Cli
        ON Cre.ClienteID=Cli.ClienteID
            INNER JOIN  CUENTASAHO C
        ON Cli.ClienteID=C.ClienteID

    WHERE (Cre.Estatus=Est_Vencido OR Cre.Estatus=Est_Vigente)
    GROUP BY  Cre.CreditoID;

         -- ACTUALIZAR TABLA DE CREDITOS CON DATOS DE AHORRO
    UPDATE  TMPCARTERADETALLECRED T,
      TMPCARTERAAHORRO A
  SET   T.AhorroOrd=A.AhorroOrd,
      T.AhorroVista=A.AhorroVista

    WHERE   T.CreditoID=A.CreditoID;

    -- ======================== TABLA DE AYUDA INVERSIONES ===================

        DROP TABLE IF EXISTS   TMPCARTERAINVERSION;
    CREATE TEMPORARY TABLE TMPCARTERAINVERSION(
      ClienteID       BIGINT(12),
      Inversion     DECIMAL(16,2)

            );
            INSERT INTO TMPCARTERAINVERSION ( ClienteID,  Inversion)
    SELECT  CL.ClienteID,SUM(IFNULL( I.Monto,Entero_Cero)) AS Inversion

      FROM  INVERSIONES I
            INNER JOIN CLIENTES CL
            ON I.ClienteID=CL.ClienteID
        WHERE I.Estatus   = Var_No
                GROUP BY CL.ClienteID;

  --  ACTUALIZAR TABLA DE CREDITOS CON DATO DE INVERSION
     UPDATE  TMPCARTERADETALLECRED T,
       TMPCARTERAINVERSION I
  SET   T.SaldoInversiones=I.Inversion

    WHERE   T.ClienteID=I.ClienteID;


-- ===================  TABLAS DE AYUDA GARANTIA LIQUIDA ===================
    DROP TABLE IF EXISTS TMPGARLIQUIDACOBRANZA;
  CREATE TEMPORARY TABLE TMPGARLIQUIDACOBRANZA
  SELECT SUM(T.MontoEnGar) AS MontoEnGar , T.CreditoID
    FROM TMPCARTERADETALLECRED C,
             CREDITOINVGAR  T
    WHERE C.CreditoID   = T.CreditoID
      AND FechaAsignaGar <= Var_FechaCorte
    GROUP BY T.CreditoID;

     -- ACTUALIZAR EN LA TABLA DE DETALLE DE CREDITO EL CAMPO DE MONTO GARANTIA
        UPDATE  TMPCARTERADETALLECRED F,
        TMPGARLIQUIDACOBRANZA T
      SET F.MontoGarantia   = T.MontoEnGar,
            F.CuentaGL      = EsInversion
    WHERE F.CreditoID   = T.CreditoID;

  -- TABLA AYUDA DE HISCREDITOINVGAR
  DROP TABLE IF EXISTS TMPHISCREDITOINVGAR;
  CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR
  SELECT SUM(Gar.MontoEnGar) AS MontoEnGar , Gar.CreditoID
    FROM TMPCARTERADETALLECRED    Tmp,
             HISCREDITOINVGAR Gar
    WHERE Gar.Fecha > Var_FechaCorte
      AND Gar.FechaAsignaGar <= Var_FechaCorte
      AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
      AND Gar.CreditoID = Tmp.CreditoID
    GROUP BY Gar.CreditoID;

  -- ACTUALIZAR EN LA TABLA DE DETALLE DE CREDITO SUMAR AL CAMPO DE MONTO GARANTIA
  UPDATE  TMPCARTERADETALLECRED Tmp,
      TMPHISCREDITOINVGAR   Gar
    SET Tmp.MontoGarantia  =  IFNULL(Tmp.MontoGarantia, Decimal_Cero) + Gar.MontoEnGar,
      Tmp.CuentaGL     =  EsInversion
    WHERE Gar.CreditoID  =  Tmp.CreditoID;

  -- TABLA AYUDA DE BLOQUEOS
    DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
  CREATE TEMPORARY TABLE TMPMONTOGARCUENTAS (
  SELECT Blo.Referencia,  SUM(CASE WHEN Blo.NatMovimiento = Est_Bloq
          THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
         ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
      END) AS MontoEnGar
    FROM  BLOQUEOS    Blo,
        TMPCARTERADETALLECRED   Tmp
      WHERE DATE(Blo.FechaMov) <= Var_FechaCorte
        AND Blo.TiposBloqID = Var_TipoBloqueo
        AND Blo.Referencia  = Tmp.CreditoID
     GROUP BY Blo.Referencia);

  -- ACTUALIZAR EN LA TABLA DE DETALLE DE CREDITO SUMAR AL CAMPO DE MONTO GARANTIA
  UPDATE  TMPCARTERADETALLECRED Tmp,
      TMPMONTOGARCUENTAS    Blo
    SET Tmp.MontoGarantia   = IFNULL(Tmp.MontoGarantia, Decimal_Cero) +MontoEnGar,
      Tmp.CuentaGL  = EsAhorro
  WHERE Blo.Referencia  = Tmp.CreditoID
   AND IFNULL(MontoGarantia,Entero_Cero) = Entero_Cero;

  UPDATE  TMPCARTERADETALLECRED   Tmp,
      TMPMONTOGARCUENTAS    Blo
    SET Tmp.MontoGarantia = IFNULL(Tmp.MontoGarantia, Decimal_Cero) +MontoEnGar,
      Tmp.CuentaGL =  EsAhorroInversion
  WHERE Blo.Referencia  = Tmp.CreditoID
   AND IFNULL(MontoGarantia,Entero_Cero) > Entero_Cero
   AND CuentaGL <>  EsAhorro
   AND MontoEnGar >Entero_Cero;
  DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;

-- ===================  TABLA DE AYUDA GARANTIA PREN. HIPOTECARIA ===================

        DROP TABLE IF EXISTS   TMPGARHIPO;
    CREATE TEMPORARY TABLE TMPGARHIPO(
      CreditoID       BIGINT(12),
      Monto       DECIMAL(16,2),
            TieneGar      CHAR(2)
            );

    -- LLENAR TABLA DE GARANTIA PREN. HIPOTECARIA
    INSERT INTO TMPGARHIPO (CreditoID, Monto, TieneGar)

    SELECT  CreditoID,  GarHipotecaria,
        CASE WHEN IFNULL(GarHipotecaria,Entero_Cero)=Entero_Cero THEN Est_No
        ELSE Est_Si END
    FROM CREGARPRENHIPO;

     -- ACTUALIZAR EN LA TABLA DE DETALLE DEL CREDITO EL CAMPO DE GarPrendHipot
    UPDATE  TMPCARTERADETALLECRED T,
      TMPGARHIPO G
  SET   T.GarPrendHipot=G.TieneGar
    WHERE   T.CreditoID=G.CreditoID;

-- ===================  TABLA DE AYUDA CUOTAS ===================
     DROP TABLE IF EXISTS   TMPCUOTASCARTERA;
    CREATE TEMPORARY TABLE TMPCUOTASCARTERA(
      CreditoID       BIGINT(12),
      PAGADAS       INT(10),
            VENCIDAS      INT(10),
            VIGENTES      INT(10),
            FECHAULTIMO     DATE
            );

-- LLENAR TABLA DE AYUDA CUOTAS
        INSERT INTO TMPCUOTASCARTERA(CreditoID,   PAGADAS,  VENCIDAS, VIGENTES, FECHAULTIMO)
    SELECT  CreditoID,
        COUNT(CASE WHEN Estatus=Est_Pagado THEN AmortizacionID  END)  AS PAGADAS,
        COUNT(CASE WHEN Estatus=Est_Vencido THEN AmortizacionID  END) AS VENCIDAS,
        COUNT(CASE WHEN Estatus=Est_Vigente OR Estatus=Est_Atrasado THEN AmortizacionID  END) AS VIGENTES,
        MAX(IFNULL(FechaLiquida,Fecha_Vacia)) AS ULTIMOPAGO
    FROM AMORTICREDITO
    GROUP BY CreditoID;

-- ACTUALIZAR EN LA TABLA DE DETALLE DEL CREDITO CAMPOS DE CUOTAS
    UPDATE  TMPCARTERADETALLECRED T,
      TMPCUOTASCARTERA C
  SET   T.CuotasPagadas=C.PAGADAS,
      T.CuotasVigentes=C.VIGENTES,
            T.CuotasVencidas=C.VENCIDAS,
            T.FechaUltimoPago=C.FECHAULTIMO
    WHERE   T.CreditoID=C.CreditoID;


-- ===================  TABLA DE AYUDA ASIGNACION ===================
     DROP TABLE IF EXISTS   TMPASIGCARTERARE;
    CREATE TEMPORARY TABLE TMPASIGCARTERARE(
      CreditoID       BIGINT(12),
      FechaAsig     DATE,
            NombreGes     VARCHAR(200)
            );

    INSERT INTO TMPASIGCARTERARE (CreditoID,  FechaAsig,  NombreGes)
      SELECT  Det.CreditoID, Cob.FechaAsig,  Ges.NombreCompleto
    FROM    COBCARTERAASIG Cob
    INNER JOIN GESTORESCOBRANZA Ges
      ON Cob.GestorID=Ges.GestorID
    INNER JOIN DETCOBCARTERAASIG Det
      ON Cob.FolioAsigID=Det.FolioAsigID
    WHERE Det.CredAsignado=Var_Si;
-- ===================  TABLA DE AYUDA AVALES ===================

     DROP TABLE IF EXISTS TMPDATOSAVALESSPS;
    CREATE TEMPORARY TABLE TMPDATOSAVALESSPS(
      CreditoID     BIGINT,
      SolicitudCreditoID  BIGINT,
      AvalID        BIGINT,
      ClienteID     BIGINT,
      ProspectoID     BIGINT,
      NombreCompleto    VARCHAR(500),
      Telefono      VARCHAR(50),
      Aval        VARCHAR(1000));

    CREATE INDEX id_indexClienteID ON TMPDATOSAVALESSPS (ClienteID);


    INSERT INTO TMPDATOSAVALESSPS
    SELECT  cre.CreditoID,      aps.SolicitudCreditoID,   aps.AvalID,     aps.ClienteID,  aps.ProspectoID,
        '' AS NombreCompleto,   '' AS Telefono, '' AS Aval
      FROM AVALESPORSOLICI aps
          INNER JOIN CREDITOS cre
            ON cre.SolicitudCreditoID = aps.SolicitudCreditoID;

    UPDATE TMPDATOSAVALESSPS  T,
        CLIENTES      C SET
      T.NombreCompleto= C.NombreCompleto,
      T.Telefono    = IFNULL(C.TelefonoCelular,'')
    WHERE T.ClienteID = C.ClienteID;


    UPDATE TMPDATOSAVALESSPS  T,
        PROSPECTOS      P SET
      T.NombreCompleto= P.NombreCompleto,
      T.Telefono    = P.Telefono
    WHERE T.ProspectoID = P.ProspectoID
      AND T.NombreCompleto = Cadena_Vacia;


    UPDATE TMPDATOSAVALESSPS  T,
        AVALES        A SET
      T.NombreCompleto= A.NombreCompleto,
      T.Telefono    = A.TelefonoCel
    WHERE T.AvalID = A.AvalID
      AND T.NombreCompleto = Cadena_Vacia;


        UPDATE TMPDATOSAVALESSPS  T
    SET   T.Aval=CONCAT(T.ClienteID,',', NombreCompleto, ',',Telefono);

    -- =========================AGREGA EL NUMERO DE PROMESAS DE PAGO DE CADA CREDITO============================
         DROP TABLE IF EXISTS   TMPNUMPROMESASPAGO;
    CREATE TEMPORARY TABLE TMPNUMPROMESASPAGO(
      CreditoID       BIGINT(12),
      NumPromesas     INT(11)
            );

    INSERT INTO TMPNUMPROMESASPAGO(
        CreditoID,    NumPromesas
    )SELECT tmp.CreditoID,  COUNT(psc.NumPromesa)
      FROM TMPCARTERACLIENTE tmp
        LEFT JOIN BITACORASEGCOB bsc
          ON tmp.CreditoID = bsc.CreditoID
        INNER JOIN PROMESASEGCOB psc
          ON bsc.BitacoraID = psc.BitacoraID
      GROUP BY bsc.CreditoID;

    UPDATE TMPCARTERACLIENTE tmp,  TMPNUMPROMESASPAGO tpp
      SET tmp.NumPromesasPago = IFNULL(tpp.NumPromesas,Entero_Cero)
    WHERE tmp.CreditoID = tpp.CreditoID;

    -- =========================SELECT FINAL QUE REGRESA LOS DATOS EN EL SP=================================================

    SELECT  T1.CreditoID,       CONCAT( MAX(T1.SucursalEjecutivo), ' - ',   MAX(T1.SucursalEjeDesc)) AS SucursalEjecutivo,
            MAX(T1.NumUsuario) AS NumUsuario,       MAX(T1.NombreUsuario) AS NombreUsuario,         MAX(T1.ClienteID) AS ClienteID,     MAX(T1.NombreCompleto) AS NombreCompleto,       MAX(T1.FechaNacimiento) AS FechaNacimiento,
            MAX(T1.Edad) AS Edad,                   MAX(T1.GrupoNOSolidario) AS GrupoNOSolidario,   MAX(T1.FechaIngreso) AS FechaIngreso,  MAX(T1.DireccionCompleta) AS DireccionCompleta, MAX(T1.Municipio) AS Municipio,
            MAX(T1.Localidad) AS Localidad,         MAX(T1.Ocupacion) AS Ocupacion,                 MAX(T1.Telefono) AS Telefono,       MAX(T1.TelefonoCelular) AS TelefonoCelular,     MAX(T1.TelTrabajo) AS TelTrabajo,
            CONCAT(MAX(T2.SucursalCredito),' - ',MAX(T2.SucursalCreDesc)) AS SucursalCredito,       MAX(T2.ProductoCreditoID) AS ProductoCreditoID, MAX(T2.ProductoCredito) AS ProductoCredito,
            MAX(T2.EstatusCredito) AS EstatusCredito,   MIN(T2.FechaInicio) AS FechaInicio,         MAX(T2.FechaVencimiento) AS FechaVencimiento,   MAX(T2.FrecuenciaCap) AS FrecuenciaCap,     MAX(T2.AhorroOrd) AS AhorroOrd,
            MAX(T2.AhorroVista) AS AhorroVista,         SUM(T2.SaldoInversiones) AS SaldoInversiones,   SUM(T2.MontoCredito) AS MontoCredito,       IFNULL(SUM(T2.Total),Entero_Cero) AS Total,
            IFNULL(SUM(T2.SalCapVigente),Entero_Cero)  AS SalCapVigente,        IFNULL(SUM(T2.SalCapVencido),Entero_Cero) AS SalCapVencido,
            SUM(T2.SalCapAtrasado) AS SalCapAtrasado,   SUM(T2.SalIntOrdinario) AS SalIntOrdinario,     SUM(T2.SalMoratorios) AS SalMoratorios,     MAX(T2.CuotasPagadas) AS CuotasPagadas,     MAX(T2.CuotasVigentes) AS CuotasVigentes,
            SUM(T2.CuotasVencidas) AS CuotasVencidas,   MAX(T2.DiasAtraso) AS DiasAtraso,               MAX(T2.FechaUltimoPago) AS FechaUltimoPago, SUM(T2.MontoGarantia) AS MontoGarantia,
            IFNULL(MAX(T2.GarPrendHipot),Est_No) AS GarPrendHipot,   MAX(T1.PersonaRelacionada) AS PersonaRelacionada,   MAX(Asig.FechaAsig) AS FechaAsig, MAX(Asig.NombreGes) AS NombreGes,
            GROUP_CONCAT(AV.Aval SEPARATOR ';') AS Avales, MAX(T1.NumPromesasPago) AS PromesasPago
    FROM  TMPCARTERACLIENTE T1
    INNER JOIN TMPCARTERADETALLECRED T2
      ON T1.CreditoID=T2.CreditoID

        LEFT JOIN TMPASIGCARTERARE Asig
      ON T1.CreditoID=Asig.CreditoID
    LEFT JOIN   TMPDATOSAVALESSPS AV
        ON T1.CreditoID=AV.CreditoID
    GROUP BY  T1.CreditoID ;


END TerminaStore$$