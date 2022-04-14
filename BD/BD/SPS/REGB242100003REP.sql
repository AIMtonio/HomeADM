-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGB242100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGB242100003REP`;
DELIMITER $$


CREATE PROCEDURE `REGB242100003REP`(
-- #=======================================================================================================# --
-- | SP PARA OBTENER DATOS PARA EL REPORTE DE B2421 -INFORMACION POR PRODUCTO DE CAPTACION                 | --
-- #==================================================#====================================================# --
-- | ANT:                                             | MOD: VMARTINEZ - 2018-10-26 - FOL:2945             | --
-- #==================================================#====================================================# --
    Par_Anio            INT(11),            -- Ano del reporte
    Par_Trimestre       INT(11),            -- Trimestre a reportar
    Par_NumReporte      TINYINT UNSIGNED,   -- Tipo de reporte 1: Excel 2: CVS

    Par_EmpresaID       INT(11),            -- Empresa ID
    Aud_Usuario         INT(11),            -- Usuario ID
    Aud_FechaActual     DATETIME,           -- Fecha Actual
    Aud_DireccionIP     VARCHAR(15),        -- Direccion IP
    Aud_ProgramaID      VARCHAR(50),        -- Programa ID
    Aud_Sucursal        INT(11),            -- Sucursal ID
    Aud_NumTransaccion  BIGINT(20)          -- Numero de transaccion
)

TerminaStore: BEGIN
    -- Declaracion de Variables.
    DECLARE Var_FechaHis            DATE;           -- Fecha del Historico
    DECLARE Var_MtoMinAporta        INT(11);        -- Monto de aportacion (minimo) del sistema
    DECLARE Var_MonedaBase          INT(11);        -- Moneda base del sistema
    DECLARE Var_ClaveEntidad        VARCHAR(300);   -- Clave de la Entidad de la Institucion
    DECLARE Var_Periodo             CHAR(6);        -- Periodo en el que se genera el reporte
    DECLARE Var_FechaIniPeriodo     DATE;           -- Fecha de inicio de periodo
    DECLARE Var_MesPeriodo          VARCHAR(2);     -- Mes del periodo
    DECLARE Var_Fecha               DATE;           -- Fecha conformada mpor el periodo
    DECLARE Var_MoviDepositos       VARCHAR(50);    -- Tipos de Movimientos correspondientes a Despositos
    DECLARE Var_MoviRetiros         VARCHAR(50);    -- Tipos de Movimientos correspondientes a Retiros
    DECLARE Var_InverRetiro         VARCHAR(50);    -- Inversiones --- Retiros
    DECLARE Var_InverDeposito       VARCHAR(50);    -- Inversiones --- Depositos
    DECLARE Var_TotalMovimientos    VARCHAR(200);   -- Total de movimientos a filtrar
    DECLARE Var_FecTrimestreAnt     DATE;           -- Fecha del trimestre anterior a  la fecha de corte
    DECLARE Var_FechaMigraSAFI      DATE;           -- Fecha en la que SAFI toma el control de las CEDES despues de la migracion

    -- Declaracion de Constantes
    DECLARE Rep_Excel           INT(11);
    DECLARE Rep_Csv             INT(11);
    DECLARE Entero_Cero         INT(11);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Decimal_Cero        DECIMAL(12,2);

    DECLARE Fecha_Vacia         DATE;
    DECLARE Cue_Activa          CHAR(1);
    DECLARE Cue_Bloqueada       CHAR(1);
    DECLARE Ins_CueAhorro       CHAR(1);
    DECLARE Ins_InvPlazo        CHAR(1);

    DECLARE Cons_BloqGarLiq     INT(11);
    DECLARE For_0841            CHAR(4);
    DECLARE SI                  CHAR(1);
    DECLARE Con_NO              CHAR(1);
    DECLARE Fisica              CHAR(1);

    DECLARE Moral               CHAR(1);
    DECLARE Fisica_empre        CHAR(1);
    DECLARE Masculino           CHAR(1);
    DECLARE Femenino            CHAR(1);
    DECLARE Apellido_Vacio      CHAR(1);

    DECLARE Clave_CertBursatil  INT(11);
    DECLARE Clave_DepVista      INT(11);
    DECLARE CLave_Periodicidad  INT(11);
    DECLARE Clave_Ahorrador     INT(11);
    DECLARE Clave_AhoradorCred  INT(11);

    DECLARE Clave_TipoTasa      INT(11);
    DECLARE Clave_TasaRefe      INT(11);
    DECLARE Clave_OpeDiferen    INT(11);
    DECLARE Clave_FrecPlazo     INT(11);
    DECLARE No_RetAntici        INT(11);

    DECLARE Si_RetAntici        INT(11);
    DECLARE Tip_MovAbono        CHAR(1);
    DECLARE Tip_MovCargo        CHAR(1);
    DECLARE Dep_ConInteres      VARCHAR(20);
    DECLARE Dep_ConIntCre       VARCHAR(20);
    DECLARE Dep_SinInteres      VARCHAR(20);

    DECLARE Dep_CedAmpCred      VARCHAR(20);
    DECLARE Dep_CedLibGrab      VARCHAR(20);

    DECLARE Dep_SinIntCre       VARCHAR(20);
    DECLARE Dep_AhoLibGrav      VARCHAR(20);
    DECLARE Dep_AhoAmpCre       VARCHAR(20);
    DECLARE Dep_PlaLibGrav      VARCHAR(20);
    DECLARE Dep_PlaLibAmpCre    VARCHAR(20);

    DECLARE Cuen_SinMovimiento  VARCHAR(20);
    DECLARE Codigo_Mexico       INT(11);
    DECLARE Cadena_Cero         CHAR(1);
    DECLARE Fecha_Nula          VARCHAR(8);
    DECLARE Tipo_GarLiq         VARCHAR(2);

    DECLARE Tipo_DepVis         VARCHAR(2);
    DECLARE Est_Cancelado       CHAR(1);
    DECLARE Est_Inactivo        CHAR(1);
    DECLARE Tipo_Nacional       CHAR(1);
    DECLARE Tipo_Extranj        CHAR(1);

    DECLARE Clave_NacFis        INT(11);
    DECLARE Clave_NacMor        INT(11);
    DECLARE Clave_ExtFis        INT(11);
    DECLARE Clave_ExtMor        INT(11);
    DECLARE Riesgo_Bajo         CHAR(1);

    DECLARE Riesgo_Medio        CHAR(1);
    DECLARE Riesgo_Alto         CHAR(1);
    DECLARE Clave_RiesBajo      INT(11);
    DECLARE Clave_RiesMedio     INT(11);
    DECLARE Clave_RiesAlto      INT(11);

    DECLARE Per_Masculino       INT(11);
    DECLARE Per_Femenino        INT(11);
    DECLARE Per_NoAplica        INT(11);
    DECLARE No_Aplica           VARCHAR(20);
    DECLARE Dep_Vista           CHAR(1);

    DECLARE Dep_Ahorro          CHAR(1);
    DECLARE Moneda_Nacional     INT(11);
    DECLARE Moneda_Extran       INT(11);
    DECLARE Nat_Bloqueo         CHAR(1);
    DECLARE Est_Pagado          CHAR(1);

    DECLARE Clave_OtraActiv     INT(11);
    DECLARE Rango_Uno           INT(11);
    DECLARE Rango_Dos           INT(11);
    DECLARE Rango_Tres          INT(11);
    DECLARE Rango_Cuatro        INT(11);

    DECLARE Rango_Cinco         INT(11);
    DECLARE Rango_Seis          INT(11);
    DECLARE Rango_Siete         INT(11);
    DECLARE Dep_VisCnInt        INT(11);
    DECLARE Dep_VisIntCre       INT(11);

    DECLARE Dep_VisSnInt        INT(11);
    DECLARE Dep_VisSnIntCre     INT(11);
    DECLARE Dep_AhoInte         INT(11);
    DECLARE Dep_AhoCre          INT(11);
    DECLARE Dep_Plazo           INT(11);

    DECLARE Dep_PlazoAmpCre     INT(11);
    DECLARE CaseMayus           VARCHAR(3);
    DECLARE Cliente_Inst        INT(11);
    DECLARE Var_FechaCieInv     DATE;
    DECLARE Prog_Cierre         VARCHAR(20);

    DECLARE Var_FecMesAnt       DATE;
    DECLARE Var_FechaCieCed     DATE;
    DECLARE LlaveCueDepositos   VARCHAR(20);
    DECLARE LlaveCueRetiros     VARCHAR(20);
    DECLARE LlaveInvDepositos   VARCHAR(20);
    DECLARE LlaveInvRetiros     VARCHAR(20);

    DECLARE Entero_Uno          INT(11);
    DECLARE Entero_Dos          INT(11);
    DECLARE Entero_Tres         INT(11);
    DECLARE Entero_Cuatro       INT(11);
    DECLARE SaldoMinimo         DECIMAL(12,2);


    -- Asignacion de Constantes
    SET Rep_Excel           := 1;                   -- Opcion de reporte para excel
    SET Rep_Csv             := 2;                   -- Opcion de reporte para CVS
    SET Entero_Cero         := 0;                   -- Entero Cero
    SET Entero_Uno          := 1;                   -- Entero uno
    SET Entero_Dos          := 2;                   -- Entero Dos

    SET Entero_Tres         := 3;                   -- Entero uno
    SET Entero_Cuatro       := 4;                   -- Entero uno
    SET Cadena_Vacia        := '';                  -- Cadena vacia
    SET Decimal_Cero        := 0.00;                -- DECIMAL Cero

    SET Fecha_Vacia         := '1900-01-01';        -- Fecha vacia
    SET Fecha_Nula          := '01011900';          -- Formato dd-mm-aaaa
    SET Cue_Activa          := 'A';                 -- cuenta activa
    SET Cue_Bloqueada       := 'B';                 -- cuneta bloqueada
    SET Ins_CueAhorro       := '1';                 -- Tipo de Instrumento: Cuenta de Ahorro

    SET Ins_InvPlazo        := '2';                 -- Tipo de Instrumento: Inversiones Plazo
    SET Cons_BloqGarLiq     := 8;                   -- Tipo de Bloqueo: Por Gtia Liquida
    SET For_0841            := '2421';              -- Clave del Formulario o Reporte
    SET SI                  :=  'S';                -- SI
    SET Con_NO              :=  'N';                -- NO

    SET Fisica              :=  'F';                -- Tipo de persona fisica
    SET Moral               :=  'M';                -- Tipo de persona moral
    SET Fisica_empre        :=  'A';                -- Persona Fisica Con Actividad Empresarial
    SET Masculino           :=  'M';                -- Sexo masculino
    SET Femenino            :=  'F';                -- Sexo femenino

    SET Apellido_Vacio      :=  'X';
    SET Clave_CertBursatil  := 21250201;            -- Clave de registro del certificado bursatil
    SET Clave_DepVista      := 100;                 -- Clave para Dep a la Vista
    SET Clave_Periodicidad  := 3;                   -- Clave para Mensual
    SET Clave_TipoTasa      := 101;                 -- Clave Tipo de Tasa - Fija

    SET Clave_TasaRefe      := 150;                 -- Clave de Tasa de Referencia - Tasa Fija
    SET Clave_OpeDiferen    := 101;                 -- Suma del Diferencial
    SET Clave_FrecPlazo     := 30;                  -- Frecuencua Mensual
    SET No_RetAntici        := 101;                 -- Clave No Retiro Anticipado
    SET Si_RetAntici        := 102;                 -- Clave Si Retiro Anticipado

    SET Tip_MovAbono        := 'A';                 -- Tipo de movimiento para abono a cuenta
    SET Tip_MovCargo        := 'C';                 -- Tipo de movimiento para cargo a cuenta
    SET Dep_ConInteres      := '210101020100';      -- Depositos a la vista con interes libres de gravamen
    SET Dep_ConIntCre       := '210101020200';      -- Depositos a la vista con interes libres de gravamen que amparan creditos
    SET Dep_SinInteres      := '210101010100';      -- Depositos a la vista sin interes libres de gravamen
    SET Dep_SinIntCre       := '210101010200';      -- Depositos a la vista sin interes libres de gravamen que amparan creditos

    SET Dep_CedAmpCred      := '211104020000';
    SET Dep_CedLibGrab      := '211104010000';

    SET Dep_AhoLibGrav      := '210102010000';      -- Depositos de ahorro libres de gravamen
    SET Dep_AhoAmpCre       := '210102020000';      -- Depositos de ahorro que amparan creditos
    SET Cuen_SinMovimiento  := '240120000000';      -- Cuentas sin movimiento
    SET Clave_Ahorrador     := 1;
    SET Clave_AhoradorCred  := 3;

    SET Codigo_Mexico       := 484;                 -- Pais Mexico CNBV
    SET Dep_PlaLibGrav      := '211190100000';      -- Depositos a plazo libres de gravamen
    SET Dep_PlaLibAmpCre    := '211190200000';      -- Depositos a plazo libres de gravamen que amparan creditos
    SET Cadena_Cero         := '0';
    SET Tipo_GarLiq         := 'GL';                -- Dep Garantia liquida

    SET Tipo_DepVis         := 'DV';                -- Dep a la Vista
    SET Est_Cancelado       := 'C';                 -- Estatus cancelado
    SET Est_Inactivo        := 'I';                 -- Estatus Activo
    SET Tipo_Nacional       := 'N';                 -- Cliente nacional
    SET Tipo_Extranj        := 'E';                 -- Cliente Extranjero

    SET Riesgo_Bajo         := 'B';                 -- Nivel riesgo Bajo
    SET Riesgo_Medio        := 'M';                 -- Nivel Riesgo Medio
    SET Riesgo_Alto         := 'A';                 -- Nivel Riesgo Alto
    SET Clave_RiesBajo      := 1;                   -- Clave de Nivel Bajo
    SET Clave_RiesMedio     := 2;                   -- Clave de Nivel Medio

    SET Clave_RiesAlto      := 3;                   -- Clave de Nivel Alto
    SET Clave_NacFis        := 1;                   -- Persona Fisica Nacional
    SET Clave_NacMor        := 2;                   -- Persona Moral Nacional
    SET Clave_ExtFis        := 3;                   -- Persona Fisica Extranjera
    SET Clave_ExtMor        := 4;                   -- Persona Moral Estranjera

    SET Per_Masculino       := 2;                   -- Persona Masculina
    SET Per_Femenino        := 1;                   -- Persona Femenina
    SET Per_NoAplica        := 0;                   -- No Aplica - Morales
    SET No_Aplica           := 'No aplica';         --  DESC. No Aplica
    SET Dep_Vista           := 'V';                 --  Deposito a la vista

    SET Dep_Ahorro          := 'A';                 -- deposito de Ahorro
    SET Moneda_Nacional     := 14;                  -- Moneda Nacional
    SET Moneda_Extran       := 4;                   -- Moneda Extranjera
    SET Nat_Bloqueo         := 'B';                 -- Naturaleza Bloqueado
    SET Est_Pagado          := 'P';                 -- Estatus Pagado

    SET Clave_OtraActiv     := 81299;               -- Clave Otra Actividad
    SET Rango_Uno           := 101;                 -- 1 a 7 Dias
    SET Rango_Dos           := 102;                 -- 8 a 30 Dias
    SET Rango_Tres          := 103;                 -- 31 a 90 Dias
    SET Rango_Cuatro        := 104;                 -- 91 a 180 dias

    SET Rango_Cinco         := 105;                 -- 181 - 365 dias
    SET Rango_Seis          := 106;                 -- 366 - 730 dias
    SET Rango_Siete         := 107;                 -- > 730 dias
    SET Dep_VisCnInt        := 3;                   -- deposito a la vista con intereses
    SET Dep_VisIntCre       := 4;                   -- deposito a la vista con inte ampara credito

    SET Dep_VisSnInt        := 1;                   -- eposito a la vista sin intereses
    SET Dep_VisSnIntCre     := 2;                   -- Deposito a la vista sin interes ampara credito
    SET Dep_AhoInte         := 5;                   -- Deposito de Ahorro
    SET Dep_AhoCre          := 6;                   -- Deposito de ahorro que ampara credito
    SET Dep_Plazo           := 9;                   -- depositos a plazo

    SET Dep_PlazoAmpCre     := 10;                  -- depositos a plazo que amparan creditos
    SET CaseMayus           := 'MA';                -- Convertir a Mayusculas
    SET SaldoMinimo         := 1000;                    -- Saldo minimo para considerar la cuenta activa
    SET Prog_Cierre         := 'CIERREMESAHORRO';

    SET LlaveCueDepositos   :=  'MoviDepositos';    -- Llave de parametro para movimientos de deposito
    SET LlaveCueRetiros     :=  'MoviRetiros' ;     -- Llave de parametro para movimientos de retiro
    SET LlaveInvDepositos   :=  'InverDeposito' ;   -- Llave de Parametro para movimientos de deposito de inversion
    SET LlaveInvRetiros     :=  'InverRetiro' ;     -- Llave de parametro para movimientos de retiro de inversion

    SELECT ValorParametro INTO  Var_MoviDepositos FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveCueDepositos;
    SELECT ValorParametro INTO  Var_MoviRetiros   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveCueRetiros;
    SELECT ValorParametro INTO  Var_InverRetiro   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveInvRetiros;
    SELECT ValorParametro INTO  Var_InverDeposito   FROM PARAMREGSERIER24 WHERE LlaveParametro = LlaveInvDepositos;

    SET Var_TotalMovimientos   := CONCAT(Var_MoviDepositos,',',Var_MoviRetiros,',',Var_InverRetiro,',',Var_InverDeposito);

    IF(Par_Trimestre = Entero_Uno) THEN
        SET  Var_FechaIniPeriodo := CONCAT(Par_Anio,'-01-01');
        SET  Var_MesPeriodo      := '03';
        SET Var_Fecha            := CONCAT(Par_Anio,'-',Var_MesPeriodo,'-31');
    END IF;

    IF(Par_Trimestre = Entero_Dos) THEN
        SET  Var_FechaIniPeriodo := CONCAT(Par_Anio,'-04-01');
        SET  Var_MesPeriodo      := '06';
        SET Var_Fecha            := CONCAT(Par_Anio,'-',Var_MesPeriodo,'-30');
    END IF;

    IF(Par_Trimestre = Entero_Tres ) THEN
        SET  Var_FechaIniPeriodo := CONCAT(Par_Anio,'-07-01');
        SET  Var_MesPeriodo      := '09';
        SET Var_Fecha            := CONCAT(Par_Anio,'-',Var_MesPeriodo,'-30');
    END IF;

    IF(Par_Trimestre = Entero_Cuatro ) THEN
        SET  Var_FechaIniPeriodo := CONCAT(Par_Anio,'-10-01');
        SET  Var_MesPeriodo      := '12';
        SET Var_Fecha            := CONCAT(Par_Anio,'-',Var_MesPeriodo,'-31');
    END IF;

    SET Var_Periodo = CONCAT(Par_Anio,Var_MesPeriodo);


    SET Var_ClaveEntidad := IFNULL((SELECT Par.ClaveEntidad
                                    FROM PARAMETROSSIS Par
                                        WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

    SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
    SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Var_Fecha);
    SET Var_FechaCieCed := (SELECT MAX(FechaCorte) FROM SALDOSCEDES WHERE FechaCorte <= Var_Fecha);

    DROP TABLE IF EXISTS TMPREGB0841;

    CREATE TEMPORARY TABLE TMPREGB0841(

        ClienteID       INT(11),
        ColoniaID       INT(11),
        CodigoPostal    VARCHAR(20),
        Localidad       VARCHAR(20),
        MunicipioID     INT(11),
        EstadoID        INT(11),

        CodigoPais      VARCHAR(20),
        NumeroCuenta    BIGINT(11),
        FechaApertura   VARCHAR(20),
        ClasfContable   VARCHAR(20),
        TipoProducto    VARCHAR(10),

        Moneda          CHAR(2),
        PersJuridica    INT(11),
        Genero          INT(11),
        SaldoFinal      DECIMAL(21,2),
        NumeroMov       BIGINT(18),

        INDEX TMPREGB0841_idx1(ClienteID),
        INDEX TMPREGB0841_idx2(NumeroCuenta),
        INDEX TMPREGB0841_idx3(EstadoID, MunicipioID, ColoniaID))
    ENGINE=INNODB DEFAULT CHARSET=LATIN1;

    SET Var_FechaHis := (SELECT MAX(Fecha)
                            FROM `HIS-CUENTASAHO` WHERE Fecha <= Var_Fecha);

    SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);

    SELECT MontoAportacion, MonedaBaseID INTO Var_MtoMinAporta, Var_MonedaBase
        FROM PARAMETROSSIS;

    SET Var_MtoMinAporta := IFNULL(Var_MtoMinAporta, Entero_Cero);

    SET Var_FecTrimestreAnt :=  DATE_SUB(Var_FechaHis, INTERVAL Entero_Tres MONTH);

    INSERT INTO TMPREGB0841
                -- Cliente ID
        SELECT  His.ClienteID,
                -- Colonia ID
                IFNULL(Dir.ColoniaID,Entero_Cero),
                -- Codigo Postal
                IFNULL(Dir.CP,Entero_Cero),
                -- Localidad
                IFNULL(Dir.LocalidadID,Entero_Cero),
                        -- Municipio
                IFNULL(Dir.MunicipioID, Entero_Cero),
                -- Estado
                IFNULL(Dir.EstadoID, Entero_Cero),
                -- Pais
                Codigo_Mexico,
                -- Numero Cuenta
                His.CuentaAhoID,
                -- Fecha Contratacion
                IFNULL(DATE_FORMAT(His.FechaApertura,'%Y%m%d'),Fecha_Nula),
                -- Clasificacion contable
                CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
                     Dep_ConInteres -- a la vista, con intereses, libres de gravamen.
                     WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista  THEN
                     Dep_SinInteres -- a la vista, sin intereses, libres de gravamen
                     WHEN ClasificacionConta = Dep_Ahorro  THEN
                     Dep_AhoLibGrav -- depoitos de ahorro, libres de gravamen
                END,

                -- Tipo Cuenta Aho
                Cadena_Vacia,
                -- Tipo de Moneda
                CASE WHEN His.MonedaID = Var_MonedaBase THEN Moneda_Nacional
                     ELSE Moneda_Extran
                END,
                -- Personalidad Juridica
                CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
                     WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
                     WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
                     WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
                     END,

                -- Genero
                CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
                END,
                -- Saldo Cuenta al Final del Periodo
                His.Saldo,
                -- Numero de mov. en los ultimos 3 meses
                Entero_Cero

            FROM `HIS-CUENTASAHO` His,  TIPOSCUENTAS Tip, SUCURSALES Suc,  CLIENTES Cli
                LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
                    AND IFNULL(Dir.Oficial, Con_NO) = SI
            WHERE His.Fecha = Var_FechaHis
                AND His.Estatus IN (Cue_Activa, Cue_Bloqueada)
                AND His.ClienteID = Cli.ClienteID
                AND His.ClienteID <>Cliente_Inst
                AND Tip.EsBancaria = Con_NO
                AND His.TipoCuentaID = Tip.TipoCuentaID
                AND His.SucursalID = Suc.SucursalID;

    -- Actualizacion de los movimientos de la cuenta

    UPDATE TMPREGB0841 Tem, `HIS-CUENAHOMOV` HisC SET
        Tem.NumeroMov =  HisC.NumeroMov
    WHERE Tem.NumeroCuenta = HisC.CuentaAhoID
        AND HisC.Fecha BETWEEN Var_FecTrimestreAnt AND Var_FechaHis;

    UPDATE TMPREGB0841  SET
        NumeroMov =  IFNULL(NumeroMov, Entero_Cero);

    -- Actualizacion de los tipos d ecuenta

    UPDATE TMPREGB0841 SET
        TipoProducto = CASE WHEN ClasfContable IN(Dep_SinInteres,Dep_SinIntCre, Dep_ConInteres, Dep_ConIntCre) AND SaldoFinal <= SaldoMinimo  AND NumeroMov = Entero_Cero THEN 119
                        WHEN ClasfContable IN(Dep_SinInteres,Dep_SinIntCre, Dep_ConInteres, Dep_ConIntCre)  AND SaldoFinal <= SaldoMinimo   AND NumeroMov > Entero_Cero THEN 112
                        WHEN ClasfContable IN(Dep_SinInteres,Dep_SinIntCre, Dep_ConInteres, Dep_ConIntCre)  AND SaldoFinal > SaldoMinimo    THEN 112
                        WHEN ClasfContable IN(Dep_AhoLibGrav,Dep_AhoAmpCre) AND SaldoFinal <= SaldoMinimo   AND NumeroMov = Entero_Cero THEN 121
                        WHEN ClasfContable IN(Dep_AhoLibGrav,Dep_AhoAmpCre) AND SaldoFinal <= SaldoMinimo   AND NumeroMov > Entero_Cero THEN 121
                        WHEN ClasfContable IN(Dep_AhoLibGrav,Dep_AhoAmpCre) AND SaldoFinal > SaldoMinimo THEN 114 END;

    -- --------------------------------------
    -- SALDOS BLOQUEADOS POR GTI LIQUIDA ----
    -- --------------------------------------
    -- Saldo Actual
    DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;
    CREATE TEMPORARY TABLE TMP_GTIALIQ_AHORRO(
        Cuenta  BIGINT(11),
        Saldo   DECIMAL(18,2),
        PRIMARY KEY(Cuenta));

    INSERT INTO TMP_GTIALIQ_AHORRO
        SELECT CuentaAhoID, SUM(CASE WHEN NatMovimiento = Nat_Bloqueo THEN  MontoBloq
                                     ELSE MontoBloq *-Entero_Uno
                                END) AS Saldo
        FROM BLOQUEOS
            WHERE DATE(FechaMov) <= Var_Fecha
                AND TiposBloqID = Cons_BloqGarLiq
                GROUP BY CuentaAhoID;

    UPDATE TMPREGB0841 Tem, TMP_GTIALIQ_AHORRO Gar SET
        ClasfContable = CASE WHEN   ClasfContable  = Dep_ConInteres THEN Dep_ConIntCre -- a la vista, sin intereses, que amparan crÃ©ditos otorgados.
                            WHEN    ClasfContable  = Dep_SinInteres THEN Dep_SinIntCre -- a la vista, con intereses, que amparan crÃ©ditos otorgados.
                            WHEN    ClasfContable  = Dep_AhoLibGrav THEN Dep_AhoAmpCre
                        END
        WHERE Tem.NumeroCuenta = Gar.Cuenta;

    DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;

    -- --------------------------------------
    -- CUENTAS ACTVAS Y NO ACTIVAS-----------
    -- --------------------------------------

    -- Se obtienen los movimientos de los ultimos 3 meses
    DROP TABLE IF EXISTS TMP_MOVCUENTAS;
    CREATE TEMPORARY TABLE TMP_MOVCUENTAS

    SELECT Cue.CuentaAhoID,SUM(Cue.CantidadMov) AS CantidadMovimiento FROM
        `HIS-CUENAHOMOV` Cue
        WHERE FIND_IN_SET(Cue.TipoMovAhoID ,Var_TotalMovimientos) > Entero_Cero
        AND Cue.Fecha BETWEEN Var_FechaIniPeriodo AND Var_FechaHis
        GROUP BY Cue.CuentaAhoID;

    CREATE INDEX idx_TMP_MOVCUENTAS_1 ON TMP_MOVCUENTAS(CuentaAhoID);


    UPDATE TMPREGB0841 Tem,TMP_MOVCUENTAS Mov SET
        TipoProducto = CASE TipoProducto WHEN 119 THEN 112
                                         WHEN 121 THEN 114
                            ELSE TipoProducto
                       END
    WHERE Tem.NumeroCuenta = Mov.CuentaAhoID;

    -- -----------------------------------------
    -- INVERSIONES A PLAZO ---------------------
    -- -----------------------------------------
    INSERT INTO TMPREGB0841

                -- Cliente ID
        SELECT  Inv.ClienteID,

                        -- Colonia ID
                IFNULL(Dir.ColoniaID,Entero_Cero),
                -- Codigo Postal
                IFNULL(Dir.CP,Entero_Cero),
                -- Localidad
                IFNULL(Dir.LocalidadID,Entero_Cero),
                -- Municipio
                IFNULL(Dir.MunicipioID, Entero_Cero),
                -- Estado
                IFNULL(Dir.EstadoID, Entero_Cero),
                -- Pais
                Codigo_Mexico,
                -- Numero Cuenta
                Inv.InversionID,
                -- Fecha Contratacion
                IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%Y%m%d'),Fecha_Nula),
                -- Clasificacion contable
                Dep_PlaLibGrav,
                -- Tipo Cuenta
                116,
                -- Tipo de Moneda
                CASE WHEN Inv.MonedaID = Var_MonedaBase THEN Moneda_Nacional
                     ELSE Moneda_Extran
                END,
                -- Personalidad Juridica
                CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
                     WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
                     WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
                     WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
                     END,
                -- Genero
                CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
                END,
                -- Saldo Cuenta al Final del Periodo
                (Inv.Monto + Inv.SaldoProvision) AS SaldoFinal,
                -- numero de movimientos
                Entero_Cero
        FROM HISINVERSIONES Inv, CATINVERSION Cat, SUCURSALES Suc, CLIENTES Cli
            LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
                            AND IFNULL(Dir.Oficial, Con_NO) = SI
        WHERE  Inv.ClienteID = Cli.ClienteID
            AND  Inv.ClienteID <> Cliente_Inst
            AND  Inv.FechaCorte  = Var_FechaCieInv
            AND     Inv.Estatus = Con_NO
            AND Inv.TipoInversionID = Cat.TipoInversionID
            AND Cli.SucursalOrigen = Suc.SucursalID
            ORDER BY Suc.SucursalID, Inv.InversionID;

    -- --------------------------------------
    -- INVERSIONES EN GARANTIA
    -- --------------------------------------
    DROP TABLE IF EXISTS TMP_INVGAR;
    CREATE TABLE TMP_INVGAR (
        InversionID BIGINT(11),
        Saldo       DECIMAL(21,2));
    CREATE INDEX idx1_TMP_INVGAR ON TMP_INVGAR (InversionID);

    INSERT INTO TMP_INVGAR
        SELECT Gar.InversionID,Gar.MontoEnGar
            FROM CREDITOINVGAR Gar
            WHERE FechaAsignaGar <= Var_Fecha;

    INSERT INTO TMP_INVGAR
        SELECT Gar.InversionID, Gar.MontoEnGar
            FROM HISCREDITOINVGAR Gar
            WHERE Gar.Fecha > Var_Fecha
              AND Gar.FechaAsignaGar <= Var_Fecha
              AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO');

    UPDATE TMPREGB0841 Tem, TMP_INVGAR Gar SET
        Tem.ClasfContable = CASE WHEN Tem.ClasfContable  = Dep_PlaLibGrav THEN Dep_PlaLibAmpCre -- a la vista, sin intereses, que amparan creditos otorgados.
                       ELSE Tem.ClasfContable END
        WHERE Tem.NumeroCuenta = Gar.InversionID;

    DROP TABLE IF EXISTS TMP_INVGAR;



    -- ------------------------------------------------------------------------------------------------------------------
    --   CEDES
    -- ------------------------------------------------------------------------------------------------------------------

    INSERT INTO TMPREGB0841

                -- Cliente ID
        SELECT  Ced.ClienteID,

                IFNULL(Dir.ColoniaID,Entero_Cero),

                -- Codigo Postal
                IFNULL(Dir.CP,Entero_Cero),

                IFNULL(Dir.LocalidadID,Entero_Cero),

                -- Municipio
                IFNULL(Dir.MunicipioID, Entero_Cero),

                -- Estado
                IFNULL(Dir.EstadoID, Entero_Cero),
                -- Pais
                Codigo_Mexico,

                -- Numero Contrato
                Ced.CedeID,

                -- Fecha Contratacion
                IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%Y%m%d'),Fecha_Nula),

                Dep_CedLibGrab,

                116,

                CASE WHEN Ced.MonedaID = Var_MonedaBase THEN Moneda_Nacional
                     ELSE Moneda_Extran
                END,

                CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
                     WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
                     WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
                     WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
                     END,

                CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
                     WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
                END,


                IFNULL(Sal.SaldoCapital,0) AS SaldoFinal,

                Entero_Cero

        FROM CEDES Ced
                LEFT OUTER JOIN SALDOSCEDES Sal
                ON Ced.CedeID = Sal.CedeID
                AND Sal.FechaCorte = Var_FechaCieCed,
             TIPOSCEDES Cat,
             SUCURSALES Suc,
             CLIENTES Cli
        LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
                                            AND IFNULL(Dir.Oficial, Con_NO) = SI
        WHERE  Ced.ClienteID = Cli.ClienteID
          AND  Ced.ClienteID <> Cliente_Inst
          AND  Sal.Estatus = Con_NO
          AND Ced.TipoCedeID = Cat.TipoCedeID
          AND Cli.SucursalOrigen = Suc.SucursalID
        ORDER BY Suc.SucursalID, Ced.TipoCedeID;

        DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
        CREATE TEMPORARY TABLE TMP_CARGOABONOCEDE
        SELECT CedeID, SUM(CASE WHEN NatMovimiento = Tip_MovAbono THEN Monto ELSE Entero_Cero END) AS InteresPagado,
        SUM(CASE WHEN NatMovimiento = Tip_MovCargo THEN Monto ELSE Entero_Cero END) AS InteresProvisionado
         FROM CEDESMOV WHERE CedeID IN(
            SELECT CedeID FROM SALDOSCEDES WHERE FechaCorte = Var_FechaCieCed
         ) AND Fecha <= Var_FechaCieCed
         GROUP BY CedeID;

        UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
            SET Ced.SaldoFinal = Ced.SaldoFinal + (Res.InteresProvisionado - Res.InteresPagado)
        WHERE Ced.NumeroCuenta = Res.CedeID
        AND Ced.ClasfContable = Dep_CedLibGrab;

        SELECT ValorParametro
            INTO Var_FechaMigraSAFI
        FROM PARAMGENERALES
        WHERE LlaveParametro = 'FechaMigraSAFI';

        IF Var_FechaCieCed <= Var_FechaMigraSAFI THEN
            UPDATE TMPREGB0841 Ced,TMP_SALDOCEDEINICIAL Res
                SET Ced.SaldoFinal = Ced.SaldoFinal + Res.MontoAjuste
            WHERE Ced.NumeroCuenta = Res.CedeID
            AND Ced.ClasfContable = Dep_CedLibGrab;
        END IF;


    -- <--------------------- FIN CEDES ---------------------------------------------------------------------------------

    -- --------------------------------------
    -- ESTADOS Y MUNICIPIOS -----------------
    -- --------------------------------------
    UPDATE TMPREGB0841 Tem, LOCALIDADREPUB Loc SET
        Tem.Localidad       = Loc.LocalidadCNBV
        WHERE Tem.EstadoID  = Loc.EstadoID
          AND Tem.MunicipioID = Loc.MunicipioID
          AND Tem.Localidad = Loc.LocalidadID;

    IF( Par_NumReporte = Rep_Excel) THEN
        SELECT  Var_Periodo AS Periodo,     Var_ClaveEntidad AS ClaveEntidad,       For_0841 AS Formulario,                 Localidad,          MunicipioID,
                EstadoID,                   CodigoPais,                             FechaApertura AS FechaContratacion,     ClasfContable,      TipoProducto ,
                Moneda,                     PersJuridica,                           Genero,                                 SUM(SaldoFinal) AS  SaldoFinal
        FROM TMPREGB0841
        GROUP BY Localidad,MunicipioID,EstadoID,CodigoPais,FechaApertura,ClasfContable,TipoProducto,Moneda,PersJuridica,Genero;


    END IF;

    IF( Par_NumReporte = Rep_Csv) THEN
        SELECT  CONCAT(
            IFNULL(For_0841,Cadena_Vacia),';',
            IFNULL(Localidad,Cadena_Vacia),';',
            IFNULL(MunicipioID,Cadena_Vacia),';',
            IFNULL(EstadoID,Cadena_Vacia),';',
            IFNULL(CodigoPais,Cadena_Vacia),';',
            IFNULL( FechaApertura,Cadena_Vacia),';',
            IFNULL( ClasfContable,Cadena_Vacia),';',
            IFNULL( TipoProducto ,Cadena_Vacia),';',
            IFNULL( Moneda,Cadena_Vacia),';',
            IFNULL( PersJuridica,Cadena_Vacia),';',
            IFNULL( Genero,Cadena_Vacia),';',
            IFNULL( SUM(SaldoFinal),Cadena_Vacia)) AS Valor
        FROM TMPREGB0841
        GROUP BY Localidad,MunicipioID,EstadoID,CodigoPais,FechaApertura,ClasfContable,TipoProducto,Moneda,PersJuridica,Genero;

    END IF;
END TerminaStore$$