-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACAMBIOSUCURCLIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACAMBIOSUCURCLIPRO`;DELIMITER $$

CREATE PROCEDURE `CONTACAMBIOSUCURCLIPRO`(

    Par_ClienteID               INT(11),
    Par_SucursalOrigen          INT(11),
    Par_SucursalDestino         INT(11),
    Par_NatMovimiento           CHAR(1),

    Par_AltaEncPol              CHAR(1),
    Par_ConceptoConta           INT(11),

    Par_DescripcionMov          VARCHAR(100),
    INOUT Par_PolizaID          BIGINT,

    INOUT Par_NumErr            INT(11),
    INOUT Par_ErrMen            VARCHAR(400),

    Aud_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
    )
TerminaStore:BEGIN

    DECLARE Var_CuentaAhoID         BIGINT(12);
    DECLARE Var_ClienteID           INT(11);
    DECLARE Var_MontoGL             DECIMAL(14,2);
    DECLARE Var_MontoAhorro         DECIMAL(14,2);
    DECLARE Var_MonedaBaseID        INT(11);
    DECLARE Var_Fecha               DATE;
    DECLARE Var_FechaApl            DATE;
    DECLARE Var_EsHabil             CHAR(1);
    DECLARE Var_Poliza              INT;
    DECLARE Var_SaldoDisponible     DECIMAL(14,2);
    DECLARE Var_Abonos              DECIMAL(14,2);
    DECLARE Var_Cargos              DECIMAL(14,2);

    DECLARE Var_InversionID         INT(11);
    DECLARE Var_MontoInver          DECIMAL(14,2);
    DECLARE Var_SaldoProvis         DECIMAL(14,2);
    DECLARE Var_SaldoAtrasa         DECIMAL(14,2);

    DECLARE Var_MontoAmparado       DECIMAL(14,2);

    DECLARE Var_SaldoCapVencido     DECIMAL(14,2);
    DECLARE Var_SaldoIntVencido     DECIMAL(14,2);
    DECLARE Var_SaldoIntNoConta     DECIMAL(14,2);
    DECLARE Var_SaldoMoraVen        DECIMAL(14,2);
    DECLARE Var_SaldoMoratorio      DECIMAL(14,2);



    DECLARE Var_CreditoID           BIGINT(12);
    DECLARE Var_ProdCreditoID       INT(11);
    DECLARE Var_Clasificacion       CHAR(1);
    DECLARE Var_SubClasifica        INT(11);
    DECLARE Var_SaldoCapVigente     DECIMAL(14,2);
    DECLARE Var_SaldoInterProvi     DECIMAL(14,2);
    DECLARE Var_SaldoResInteres     DECIMAL(14,2);
    DECLARE Var_SaldoResCapital     DECIMAL(14,2);
    DECLARE Var_GeneraPol           CHAR(1);
    DECLARE Var_CuentaAhoIDPol      BIGINT(12);
    DECLARE Var_InversionIDPol      INT(11);
    DECLARE Var_CreditoIDPol        BIGINT(12);
    DECLARE Var_FechaEstimacion     DATE;
    DECLARE Var_AbonosGarantia      DECIMAL(14,2);
    DECLARE Var_CargosGarantia      DECIMAL(14,2);
    DECLARE Var_EstatusCre          CHAR(1);



    DECLARE NatCargo                CHAR(1);
    DECLARE NatAbono                CHAR(1);
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Entero_Cero             INT(11);
    DECLARE DescripcionMov          VARCHAR(100);
    DECLARE TipoMovAho              INT(11);
    DECLARE AltaEncPolSI            CHAR(1);
    DECLARE AltaEncPolNO            CHAR(1);
    DECLARE AltDetPolSI             CHAR(1);
    DECLARE AltDetPolNO             CHAR(1);
    DECLARE ConceptoConta           INT(11);
    DECLARE ConceptoAho             INT(11);
    DECLARE Pol_Automatica          CHAR(1);
    DECLARE Salida_NO               CHAR(1);
    DECLARE ConceptoInv             INT(11);
    DECLARE ConceptoInvInt          INT(11);
    DECLARE DescripcionGL           VARCHAR(100);
    DECLARE TipoGL                  INT(11);
    DECLARE EsDepODev               CHAR(1);
    DECLARE Decimal_Cero            DECIMAL(14,2);
    DECLARE DescripcionCred         VARCHAR(100);
    DECLARE DescripCredVen          VARCHAR(100);

    DECLARE Nat_Bloqueo             CHAR(1);
    DECLARE Est_AbonadoCta          CHAR(1);
    DECLARE Est_Vigente             CHAR(1);
    DECLARE Est_Vencido             CHAR(1);
    DECLARE Est_Castigado           CHAR(1);
    DECLARE ConceptoOperaCap        INT(11);
    DECLARE ConceptoOperaIntCargo   INT(11);
    DECLARE ConceptoOperaIntAbono   INT(11);
    DECLARE ConceptoEPRCCargo       INT(11);
    DECLARE ConceptoEPRCAbono       INT(11);
    DECLARE ConceptoEPRCIntCargo    INT(11);
    DECLARE ConceptoEPRCIntAbono    INT(11);
    DECLARE EsDeposito              CHAR(1);
    DECLARE EsDevolucion            CHAR(1);
    DECLARE ReferenciaCredito       VARCHAR(200);
    DECLARE ConceptoOperaCredIntC   INT(11);
    DECLARE ConceptoOperaCredIntA   INT(11);
    DECLARE ConceptoOperaEPRCC      INT(11);
    DECLARE ConceptoOperaEPRCA      INT(11);
    DECLARE ConceptoOperaEPRCIntC   INT(11);
    DECLARE ConceptoOperaEPRCIntA   INT(11);
    DECLARE TipoReclaLiberar        CHAR(1);
    DECLARE TipoReclaAsignar        CHAR(1);
    DECLARE GeneraSI                CHAR(1);
    DECLARE ConceptoAhoGL           INT(11);

    DECLARE ConceptoCarIntAtr       INT(11);

    DECLARE ConceptoCarCapVen       INT(11);
    DECLARE ConceptoCarIntVen       INT(11);
    DECLARE ConceptoIntNoConC       INT(11);
    DECLARE ConceptoIntNoConA       INT(11);
    DECLARE ConceptoInMoraVen       INT(11);
    DECLARE ConceptoIngIntMor       INT(11);
    DECLARE ConceptoEPRCResulta     INT(11);
    DECLARE ConceptoEPRCBalance     INT(11);

    DECLARE ConceptoCastigoCap          INT(11);
    DECLARE ConceptoCastigoCapCorr      INT(11);
    DECLARE ConceptoCastigoInt          INT(11);
    DECLARE ConceptoCastigoIntCorr      INT(11);
    DECLARE ConceptoCastigoIntMora      INT(11);
    DECLARE ConceptoCastigoIntMoraCorr  INT(11);





    DECLARE  CONTACUENTATEMP CURSOR FOR
            SELECT  IFNULL(CuentaAhoID,Entero_Cero) ,ClienteID,IFNULL(MontoGL,Decimal_Cero) ,
                    IFNULL(MontoAhorro,Decimal_Cero)
                FROM CUENTASAHOTEMP
                WHERE ClienteID=Par_ClienteID;


    DECLARE INVERSIONTMP CURSOR FOR
            SELECT  IFNULL(InversionID,Entero_Cero),ClienteID,MontoDispon,  SaldoProvision,CuentaAhoID,
                IFNULL(MontoAmparado,Entero_Cero)
                FROM INVERSIONTMP
                WHERE ClienteID=Par_ClienteID
                AND (MontoDispon > Entero_Cero OR SaldoProvision > Entero_Cero );


    DECLARE CREDITOTMP CURSOR FOR
            SELECT  IFNULL(CreditoID,Entero_Cero),ClienteID,ProductoCredito ,
                    Clasificacion,      SubClasifacion
            FROM TMPCREDITOS;

    SET NatCargo            := "C";
    SET NatAbono            := "A";
    SET Cadena_Vacia        := "";
    SET Entero_Cero         := 0;
    SET DescripcionMov      := "CUENTAS AHORRO ";
    SET TipoMovAho          := 401;
    SET AltaEncPolSI        := "S";
    SET AltaEncPolNO        := "N";
    SET AltDetPolSI         := "S";
    SET AltDetPolNO         := "N";
    SET ConceptoConta       := 410;
    SET ConceptoAho         := 1;
    SET Pol_Automatica      := "A";
    SET Salida_NO           := "N";
    SET ConceptoInv         := 1;
    SET ConceptoInvInt      := 5;
    SET DescripcionGL       := "CREDITOS OTORGADOS";
    SET TipoGL              := 8;
    SET Decimal_Cero        := 0.0;
    SET DescripcionCred     := "CREDITOS CAPITAL VIGENTE";
    SET DescripCredVen      := "CREDITOS CAPITAL VENCIDO";
    SET Nat_Bloqueo         := "B";
    SET Est_AbonadoCta      := "N";
    SET Est_Vigente         := "V";
    SET Est_Vencido         := "B";
    SET Est_Castigado       := "K";
    SET ConceptoOperaCap    := 1;
    SET EsDeposito          := "D";
    SET EsDevolucion        := "V";
    SET TipoReclaLiberar    := 'L';
    SET TipoReclaAsignar    := 'A';
    SET GeneraSI            := "S";

    SET ConceptoCarIntAtr   :=20;

    SET ConceptoOperaCredIntC := 5;
    SET ConceptoOperaCredIntA := 19;
    SET ConceptoOperaEPRCC    := 17;
    SET ConceptoOperaEPRCA    := 38;
    SET ConceptoOperaEPRCIntC := 36;
    SET ConceptoOperaEPRCIntA := 39;
    SET ConceptoAhoGL         := 30;

    SET ConceptoCarCapVen       :=3;
    SET ConceptoCarIntVen       :=21;
    SET ConceptoIntNoConC       :=11;
    SET ConceptoIntNoConA       :=12;
    SET ConceptoInMoraVen       :=34;
    SET ConceptoIngIntMor       :=35;
    SET ConceptoEPRCResulta     :=50;
    SET ConceptoEPRCBalance     :=49;


    SET ConceptoCastigoCap          := 29;
    SET ConceptoCastigoCapCorr      := 30;
    SET ConceptoCastigoInt          := 40;
    SET ConceptoCastigoIntCorr      := 41;
    SET ConceptoCastigoIntMora      := 42;
    SET ConceptoCastigoIntMoraCorr  := 43;



    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = '999';
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP- CONTACAMBIOSUCURSALPRO');
        END;


    SELECT FechaSistema,MonedaBaseID,ContabilidadGL  INTO Var_Fecha,Var_MonedaBaseID ,Var_GeneraPol
        FROM PARAMETROSSIS;


    SET Var_FechaEstimacion:=(SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha<=Var_Fecha);
    SET Var_FechaEstimacion:=IFNULL(Var_FechaEstimacion,'1900-01-01');


    CALL DIASFESTIVOSCAL(
        Var_Fecha,          Entero_Cero,        Var_FechaApl,       Var_EsHabil,        Aud_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

    TRUNCATE TABLE CUENTASAHOTEMP;
    TRUNCATE TABLE INVERSIONTMP;
    TRUNCATE TABLE TMPCREDITOS;
    TRUNCATE TABLE TMPMONTOAMPARADO;



    INSERT INTO CUENTASAHOTEMP (CuentaAhoID,MontoGL)
        SELECT C.CuentaAhoID ,SUM(IFNULL(B.MontoBloq,Entero_Cero))
            FROM CUENTASAHO C
            LEFT JOIN BLOQUEOS B ON B.CuentaAhoID=C.CuentaAhoID
                                 AND IFNULL(B.FolioBloq,Entero_Cero)=Entero_Cero
                                 AND B.NatMovimiento=Nat_Bloqueo
                                 AND B.TiposBloqID=TipoGL
            WHERE C.ClienteID=Par_ClienteID
            GROUP BY C.CuentaAhoID;


    IF(Var_GeneraPol = GeneraSI)THEN

        UPDATE CUENTASAHOTEMP CT
            INNER JOIN CUENTASAHO C ON CT.CuentaAhoID=C.CuentaAhoID
            SET
                CT.MontoAhorro = C.Saldo-CT.MontoGL,
                CT.ClienteID =C.ClienteID;
    ELSE

        UPDATE CUENTASAHOTEMP CT
            INNER JOIN CUENTASAHO C ON CT.CuentaAhoID=C.CuentaAhoID
            SET
                CT.MontoAhorro = C.Saldo,
                CT.ClienteID =C.ClienteID,
                CT.MontoGL=Decimal_Cero;

    END IF;


    INSERT INTO  INVERSIONTMP ( InversionID,    ClienteID, MontoTotal,SaldoProvision, CuentaAhoID,
                                MontoAmparado,  MontoDispon)
        SELECT InversionID,ClienteID,IFNULL(Monto,Decimal_Cero),IFNULL(SaldoProvision,Decimal_Cero),
               CuentaAhoID,Entero_Cero,Entero_Cero
            FROM INVERSIONES
            WHERE ClienteID=Par_ClienteID
            AND Estatus =Est_AbonadoCta;


    INSERT INTO TMPMONTOAMPARADO(InversionID,Monto)
        SELECT Inv.InversionID,IFNULL(SUM(CI.MontoEnGar),Entero_Cero)
            FROM INVERSIONTMP Inv
            LEFT JOIN CREDITOINVGAR CI ON Inv.InversionID=  CI.InversionID
            GROUP BY Inv.InversionID;


    UPDATE INVERSIONTMP INV
        INNER JOIN TMPMONTOAMPARADO TMP ON TMP.InversionID=INV.InversionID
        SET  INV.MontoAmparado =TMP.Monto,
             INV.MontoDispon =INV.MontoTotal-TMP.Monto;



    INSERT INTO TMPCREDITOS (CreditoID,ClienteID,Estatus, ProductoCredito,Clasificacion,
                    SubClasifacion)
        SELECT  Cre.CreditoID,Cre.ClienteID,Cre.Estatus,Cre.ProductoCreditoID,
                Des.Clasificacion, Des.SubClasifID
            FROM CREDITOS Cre ,
                 DESTINOSCREDITO Des
            WHERE Cre.ClienteID=Par_ClienteID
             AND   Cre.Estatus  IN (Est_Vigente, Est_Vencido, Est_Castigado)
            AND   Cre.DestinoCreID = Des.DestinoCreID;

    SET Var_CuentaAhoIDPol  :=Entero_Cero;
    SET Var_InversionIDPol  :=Entero_Cero;
    SET Var_CreditoIDPol    :=Entero_Cero;

    SELECT  IFNULL(CuentaAhoID,Entero_Cero) INTO Var_CuentaAhoIDPol
                    FROM CUENTASAHOTEMP
                    WHERE ClienteID=Par_ClienteID
                    AND (MontoAhorro>Entero_Cero
                        OR MontoGL > Entero_Cero)
                    LIMIT 1;
    IF(Var_CuentaAhoIDPol <= Entero_Cero)THEN
        SELECT  IFNULL(InversionID,Entero_Cero) INTO Var_InversionIDPol
                    FROM INVERSIONTMP
                    WHERE ClienteID=Par_ClienteID
                    AND (MontoDispon > Entero_Cero
                        OR SaldoProvision > Entero_Cero )
                    LIMIT 1;
    END IF;
    IF(Var_InversionIDPol <= Entero_Cero)THEN
        SELECT  IFNULL(CreditoID,Entero_Cero) INTO Var_CreditoIDPol
                    FROM TMPCREDITOS LIMIT 1;
    END IF;

    IF Par_PolizaID = Entero_Cero  AND (Var_CuentaAhoIDPol >Entero_Cero  ||
            Var_InversionIDPol > Entero_Cero || Var_CreditoIDPol > Entero_Cero)THEN

        SET Par_DescripcionMov:=    'REASIGNACION DE SUCURSAL';
        CALL MAESTROPOLIZAALT   (
            Par_PolizaID,       Aud_EmpresaID,  Var_Fecha,      Pol_Automatica, ConceptoConta,
            Par_DescripcionMov, Salida_NO,      Aud_Usuario,    Aud_FechaActual,Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);
    END IF;


    OPEN CONTACUENTATEMP;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            LOOP

            FETCH CONTACUENTATEMP INTO
            Var_CuentaAhoID, Var_ClienteID, Var_MontoGL,Var_MontoAhorro;

            UPDATE CUENTASAHO
                SET SucursalID=Par_SucursalDestino
            WHERE CuentaAhoID=Var_CuentaAhoID
            AND ClienteID=Var_ClienteID;

                IF Par_NatMovimiento=NatCargo THEN
                        SET Var_Abonos:=Decimal_Cero;
                        SET Var_Cargos:=Var_MontoAhorro ;
                        SET Var_AbonosGarantia = Decimal_Cero;
                        SET Var_CargosGarantia = Var_MontoGL;
                        SET EsDepODev :=EsDevolucion;
                ELSE
                        SET Var_Abonos:=Var_MontoAhorro;
                        SET Var_Cargos:= Decimal_Cero;
                        SET Var_AbonosGarantia = Var_MontoGL;
                        SET Var_CargosGarantia = Decimal_Cero;
                        SET EsDepODev :=EsDeposito;
                END IF;
                IF Var_CuentaAhoID!=Entero_Cero AND Var_MontoAhorro>Decimal_Cero THEN

                    CALL POLIZAAHORROPRO(
                            Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Par_ClienteID,      ConceptoAho,
                            Var_CuentaAhoID,    Var_MonedaBaseID,   Var_Cargos,             Var_Abonos,         CONCAT(DescripcionMov,Var_CuentaAhoID),
                            CONCAT("Cta.",CONVERT(Var_CuentaAhoID, CHAR)),                  Aud_Usuario,        Aud_FechaActual,
                            Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);
                END IF;

                IF Var_CuentaAhoID!=Entero_Cero AND Var_MontoGL>Decimal_Cero THEN
                    CALL POLIZAAHORROPRO(
                        Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Par_ClienteID,          ConceptoAhoGL,
                        Var_CuentaAhoID,    Var_MonedaBaseID,   Var_CargosGarantia,     Var_AbonosGarantia,     DescripcionGL,
                        CONCAT("Cta.",CONVERT(Var_CuentaAhoID, CHAR)),                  Aud_Usuario,            Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

                END IF;

            END LOOP;
        END;
    CLOSE CONTACUENTATEMP;


    OPEN INVERSIONTMP;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP
        FETCH INVERSIONTMP INTO
        Var_InversionID , Var_ClienteID , Var_MontoInver,Var_SaldoProvis,Var_CuentaAhoID,Var_MontoAmparado;
        IF Var_InversionID!=Entero_Cero THEN
                    CALL CONTAINVERSIONPRO(
                            Var_InversionID,    Aud_EmpresaID,      Var_Fecha,         Var_MontoInver,       Cadena_Vacia,
                            Par_ConceptoConta,  ConceptoInv,        ConceptoAho,       Par_NatMovimiento,    AltaEncPolNO,
                            AltaEncPolNO,       Par_PolizaID,       Var_CuentaAhoID,   Var_ClienteID,        Var_MonedaBaseID,
                            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,   Aud_ProgramaID,       Aud_Sucursal,
                            Aud_NumTransaccion   );
        END IF;

        IF Var_SaldoProvis>Entero_Cero THEN
                    CALL CONTAINVERSIONPRO(
                            Var_InversionID,    Aud_EmpresaID,      Var_Fecha,         Var_SaldoProvis,       Cadena_Vacia,
                            Par_ConceptoConta,  ConceptoInvInt,     ConceptoAho,       Par_NatMovimiento,    AltaEncPolNO,
                            AltaEncPolNO,       Par_PolizaID,       Var_CuentaAhoID,   Var_ClienteID,        Var_MonedaBaseID,
                            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,   Aud_ProgramaID,       Aud_Sucursal,
                            Aud_NumTransaccion   );
        END IF;
        IF Var_MontoAmparado!=Entero_Cero THEN
            IF Par_NatMovimiento=NatCargo THEN

                            CALL INVERRECLACONTAPRO(
                                    Var_InversionID,    Var_MontoAmparado,  TipoReclaLiberar,               Par_PolizaID,       Salida_NO,
                                    Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            ELSE


                            CALL INVERRECLACONTAPRO(
                                    Var_InversionID,    Var_MontoAmparado,  TipoReclaAsignar,   Par_PolizaID,       Salida_NO,
                                    Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            END IF;
        END IF;
    END LOOP;
    END;
    CLOSE INVERSIONTMP;


    OPEN CREDITOTMP;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP
        FETCH CREDITOTMP INTO
        Var_CreditoID, Var_ClienteID, Var_ProdCreditoID,Var_Clasificacion,Var_SubClasifica;

        SET Var_EstatusCre := (SELECT Estatus FROM CREDITOS WHERE CreditoID = Var_CreditoID);

        UPDATE CREDITOS
            SET SucursalID=Par_SucursalDestino
        WHERE CreditoID=Var_CreditoID
        AND ClienteID=Var_ClienteID;
        IF Var_CreditoID > Entero_Cero THEN
            IF (Var_EstatusCre  = Est_Vigente ) THEN

            SET Var_SaldoCapVigente := (SELECT IFNULL(Cre.SaldoCapVigent,Decimal_Cero)+IFNULL(Cre.SaldoCapAtrasad,Decimal_Cero)
                                        FROM  CREDITOS  Cre
                                         LEFT JOIN CALRESCREDITOS Cal
                                            ON Cal.CreditoID=Cre.CreditoID
                                            AND Cal.Fecha=Var_FechaEstimacion
                                        WHERE Cre.CreditoID=Var_CreditoID);
            SET Var_SaldoInterProvi := (SELECT IFNULL(Cre.SaldoInterProvi,Decimal_Cero)
                                        FROM  CREDITOS  Cre
                                         LEFT JOIN CALRESCREDITOS Cal
                                            ON Cal.CreditoID=Cre.CreditoID
                                            AND Cal.Fecha=Var_FechaEstimacion
                                        WHERE Cre.CreditoID=Var_CreditoID);
            SET Var_SaldoAtrasa := (SELECT  IFNULL(Cre.SaldoInterAtras,Decimal_Cero)
                                     FROM  CREDITOS  Cre
                                     LEFT JOIN CALRESCREDITOS Cal
                                        ON Cal.CreditoID=Cre.CreditoID
                                        AND Cal.Fecha=Var_FechaEstimacion
                                    WHERE Cre.CreditoID=Var_CreditoID);
           SET Var_SaldoResInteres := ( SELECT IFNULL(Cal.SaldoResInteres,Decimal_Cero)
                                        FROM  CREDITOS  Cre
                                     LEFT JOIN CALRESCREDITOS Cal
                                        ON Cal.CreditoID=Cre.CreditoID
                                        AND Cal.Fecha=Var_FechaEstimacion
                                    WHERE Cre.CreditoID=Var_CreditoID);
           SET Var_SaldoResCapital := ( SELECT IFNULL(Cal.SaldoResCapital,Decimal_Cero)
                                         FROM  CREDITOS  Cre
                                         LEFT JOIN CALRESCREDITOS Cal
                                            ON Cal.CreditoID=Cre.CreditoID
                                            AND Cal.Fecha=Var_FechaEstimacion
                                        WHERE Cre.CreditoID=Var_CreditoID);

                        IF Par_NatMovimiento=NatCargo THEN
                            SET Var_Cargos           :=Decimal_Cero;
                            SET Var_Abonos           :=Var_SaldoCapVigente;
                            SET ConceptoOperaIntCargo:=ConceptoOperaCredIntC;
                            SET ConceptoOperaIntAbono:=ConceptoOperaCredIntA;
                            SET ConceptoEPRCCargo    :=ConceptoOperaEPRCC;
                            SET ConceptoEPRCAbono    :=ConceptoOperaEPRCA;
                            SET ConceptoEPRCIntCargo :=ConceptoOperaEPRCIntC;
                            SET ConceptoEPRCIntAbono :=ConceptoOperaEPRCIntA;
                        ELSE
                            SET Var_Abonos           :=Decimal_Cero;
                            SET Var_Cargos           :=Var_SaldoCapVigente;
                            SET Par_SucursalOrigen   :=Par_SucursalDestino;
                            SET ConceptoOperaIntAbono:=ConceptoOperaCredIntC;
                            SET ConceptoOperaIntCargo:=ConceptoOperaCredIntA;
                            SET ConceptoEPRCCargo    :=ConceptoOperaEPRCA;
                            SET ConceptoEPRCAbono    :=ConceptoOperaEPRCC;
                            SET ConceptoEPRCIntCargo :=ConceptoOperaEPRCIntA;
                            SET ConceptoEPRCIntAbono :=ConceptoOperaEPRCIntC;
                        END IF;

                        IF Var_SaldoCapVigente>Decimal_Cero THEN
                            SET DescripcionCred:=CONCAT(DescripcionCred," - ",Var_CreditoID);
                            SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoOperaCap,   Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,         Var_MonedaBaseID,   DescripcionCred,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);
                        END IF;

                        IF Var_SaldoInterProvi>Decimal_Cero THEN
                                SET DescripcionCred:=CONCAT("INTERES PROVISIONADO - ",Var_CreditoID);
                                SET ReferenciaCredito:= CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoOperaIntCargo,  Var_Clasificacion,      Var_SubClasifica,   Var_SaldoInterProvi,
                                    Decimal_Cero,       Var_MonedaBaseID,   DescripcionCred,         ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoOperaIntAbono,  Var_Clasificacion,  Var_SubClasifica,   Decimal_Cero,
                                    Var_SaldoInterProvi,Var_MonedaBaseID,   DescripcionCred,        ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                        END IF;
                        IF Var_SaldoAtrasa>Decimal_Cero THEN

                                IF Par_NatMovimiento=NatCargo THEN
                                    SET Var_Cargos           :=Decimal_Cero;
                                    SET Var_Abonos           :=Var_SaldoAtrasa;

                                ELSE
                                    SET Var_Abonos           :=Decimal_Cero;
                                    SET Var_Cargos           :=Var_SaldoAtrasa;
                                END IF;

                                SET DescripcionCred:=CONCAT("INTERES MOROSO - ",Var_CreditoID);
                                SET ReferenciaCredito:= CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoCarIntAtr,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                    Var_Abonos,       Var_MonedaBaseID,   DescripcionCred,         ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);


                        END IF;

                        IF Var_SaldoResCapital>Decimal_Cero THEN
                                SET DescripcionCred:=CONCAT("EPRC INTERES- ",Var_CreditoID);
                                SET ReferenciaCredito:= CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoEPRCCargo,  Var_Clasificacion,      Var_SubClasifica,   Var_SaldoResCapital,
                                    Decimal_Cero,       Var_MonedaBaseID,   DescripcionCred,         ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoEPRCAbono,  Var_Clasificacion,  Var_SubClasifica,   Decimal_Cero,
                                    Var_SaldoResCapital,Var_MonedaBaseID,   DescripcionCred,        ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                        END IF;

                        IF Var_SaldoResInteres>Decimal_Cero THEN
                                SET DescripcionCred:=CONCAT("INTERES DE EPRC - ",Var_CreditoID);
                                SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoEPRCIntCargo,   Var_Clasificacion,      Var_SubClasifica,   Var_SaldoResInteres,
                                    Decimal_Cero,       Var_MonedaBaseID,   DescripcionCred,        ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                                CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoEPRCIntAbono,   Var_Clasificacion,  Var_SubClasifica,   Decimal_Cero,
                                    Var_SaldoResInteres,Var_MonedaBaseID,   DescripcionCred,        ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);
                        END IF;
                    END IF;
            END IF;
            IF (Var_EstatusCre = Est_Vencido) THEN



               SET  Var_SaldoCapVencido := (SELECT  IFNULL(SaldoCapVencido,Decimal_Cero)+IFNULL(SaldCapVenNoExi,Decimal_Cero) AS SaldoCapVencido
                                            FROM  CREDITOS
                                            WHERE CreditoID=Var_CreditoID);

                SET Var_SaldoIntVencido := (SELECT IFNULL(saldoInterVenc,Decimal_Cero)
                                            FROM  CREDITOS
                                            WHERE CreditoID=Var_CreditoID);

                SET Var_SaldoIntNoConta :=  (SELECT IFNULL(SaldoIntNoConta,Decimal_Cero)
                                            FROM  CREDITOS
                                            WHERE CreditoID=Var_CreditoID);
                SET Var_SaldoMoraVen    := (SELECT IFNULL(SaldoMoraCarVen,Decimal_Cero)
                                            FROM  CREDITOS
                                            WHERE CreditoID=Var_CreditoID);

                SET Var_SaldoMoratorio :=  (SELECT IFNULL(SaldoMoraVencido,Decimal_Cero)
                                            FROM  CREDITOS
                                            WHERE CreditoID=Var_CreditoID);
                SET Var_SaldoResCapital :=   (SELECT  IFNULL(Cal.SaldoResCapital,Decimal_Cero)
                                                FROM CALRESCREDITOS Cal
                                                WHERE DATE(Cal.Fecha) =Var_FechaEstimacion
                                                AND Cal.CreditoID=Var_CreditoID);

                    IF Par_NatMovimiento=NatCargo THEN

                            SET Par_SucursalOrigen   :=Par_SucursalDestino;

                        ELSE

                            SET Par_SucursalOrigen   :=Par_SucursalOrigen;

                        END IF;
                    IF (Var_SaldoCapVencido>Decimal_Cero) THEN

                        IF Par_NatMovimiento=NatCargo THEN
                            SET Var_Cargos           :=Var_SaldoCapVencido;
                            SET Var_Abonos           :=Decimal_Cero;

                        ELSE
                            SET Var_Abonos           :=Var_SaldoCapVencido;
                            SET Var_Cargos           :=Decimal_Cero;

                        END IF;

                            SET DescripCredVen:=CONCAT(DescripCredVen," - ",Var_CreditoID);
                            SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoCarCapVen,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,       Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);


                    END IF;
                    IF Var_SaldoResCapital>Decimal_Cero THEN
                                SET DescripcionCred:=CONCAT("EPRC CAPITAL - ",Var_CreditoID);
                                SET ReferenciaCredito:= CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));

                        IF Par_NatMovimiento=NatCargo THEN
                            SET Var_Cargos           :=Var_SaldoResCapital;
                            SET Var_Abonos           :=Decimal_Cero;
                            SET ConceptoEPRCCargo    :=ConceptoOperaEPRCA;
                            SET ConceptoEPRCAbono    :=ConceptoOperaEPRCC;
                        ELSE
                            SET Var_Abonos           :=Var_SaldoResCapital;
                            SET Var_Cargos           :=Decimal_Cero;
                            SET ConceptoEPRCCargo    :=ConceptoOperaEPRCC;
                            SET ConceptoEPRCAbono    :=ConceptoOperaEPRCA;
                        END IF;

                            CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoEPRCCargo,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                    Var_Abonos,         Var_MonedaBaseID,   DescripcionCred,         ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                            CALL POLIZACREDITOPRO(
                                    Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                    Par_SucursalOrigen, ConceptoEPRCAbono,  Var_Clasificacion,      Var_SubClasifica,   Var_Abonos,
                                    Var_Cargos,         Var_MonedaBaseID,   DescripcionCred,        ReferenciaCredito,
                                    Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                        END IF;

                    IF (Var_SaldoIntVencido>Decimal_Cero) THEN
                            SET DescripCredVen:=CONCAT("INTERES VENCIDO - ",Var_CreditoID);
                            SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));


                        IF Par_NatMovimiento=NatCargo THEN
                            SET Var_Cargos           :=Var_SaldoIntVencido;
                            SET Var_Abonos           :=Decimal_Cero;

                        ELSE
                            SET Var_Abonos           :=Var_SaldoIntVencido;
                            SET Var_Cargos           :=Decimal_Cero;

                        END IF;


                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoCarIntVen,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,       Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                            SET DescripCredVen:=CONCAT("INGRESOS POR INTERES VENCIDO - ",Var_CreditoID);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,          Var_Fecha,                  Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoOperaCredIntC,   Var_Clasificacion,          Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,Var_MonedaBaseID,        DescripCredVen,         ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,             Entero_Cero,                Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);




                        SET DescripCredVen:=CONCAT("EPRC INTERES - ",Var_CreditoID);

                        CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoEPRCBalance,    Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,       Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                            SET DescripCredVen:=CONCAT("EPRC INTERES - ",Var_CreditoID);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,          Var_Fecha,                  Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoEPRCResulta, Var_Clasificacion,          Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,Var_MonedaBaseID,        DescripCredVen,         ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,             Entero_Cero,                Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);



                    END IF;



                    IF (Var_SaldoIntNoConta>Decimal_Cero) THEN
                            SET DescripCredVen:=CONCAT("INTERES CUENTAS DE ORDEN - ",Var_CreditoID);
                            SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));

                            IF Par_NatMovimiento=NatCargo THEN
                                SET Var_Cargos           :=Var_SaldoIntNoConta;
                                SET Var_Abonos           :=Decimal_Cero;
                            ELSE
                                SET Var_Abonos           :=Var_SaldoIntNoConta;
                                SET Var_Cargos           :=Decimal_Cero;



                            END IF;

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoIntNoConA,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoIntNoConC,  Var_Clasificacion,      Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);
                    END IF;

                    IF (Var_SaldoMoraVen>Decimal_Cero) THEN

                            SET DescripCredVen:=CONCAT("INTERES MORATORIO VEN. - ",Var_CreditoID);
                            SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));

                            IF Par_NatMovimiento=NatCargo THEN
                                SET Var_Cargos           :=Var_SaldoMoraVen;
                                SET Var_Abonos           :=Decimal_Cero;
                            ELSE
                                SET Var_Abonos           :=Var_SaldoMoraVen;
                                SET Var_Cargos           :=Decimal_Cero;

                            END IF;

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoIngIntMor,  Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoInMoraVen,   Var_Clasificacion,      Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);



                    END IF;

                     IF (Var_SaldoMoratorio > 0) THEN
                        IF Par_NatMovimiento=NatCargo THEN
                            SET Var_Cargos           :=Var_SaldoMoratorio;
                            SET Var_Abonos           :=Decimal_Cero;

                        ELSE
                            SET Var_Abonos           :=Var_SaldoMoratorio;
                            SET Var_Cargos           :=Decimal_Cero;

                        END IF;

                            SET DescripCredVen:=CONCAT("EPRC MORA -  ",Var_CreditoID);

                        CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoEPRCBalance,    Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,       Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,          Aud_NumTransaccion);


                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,          Var_Fecha,                  Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoEPRCResulta, Var_Clasificacion,          Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,Var_MonedaBaseID,        DescripCredVen,         ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,             Entero_Cero,                Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);

                    END IF;
            END IF;
            IF (Var_EstatusCre = Est_Castigado) THEN

                 SELECT SaldoCapital,       SaldoInteres,           SaldoMoratorio
                 INTO Var_SaldoCapVencido,  Var_SaldoIntVencido,    Var_SaldoMoraVen
                 FROM  CRECASTIGOS WHERE CreditoID =  Var_CreditoID;

                 IF Par_NatMovimiento=NatCargo THEN
                            SET Par_SucursalOrigen   :=Par_SucursalOrigen;
                        ELSE
                            SET Par_SucursalOrigen   :=Par_SucursalDestino;
                 END IF;

                IF (Var_SaldoCapVencido>Decimal_Cero) THEN
                         SET DescripCredVen:=CONCAT("CASTIGO  CAPITAL. - ",Var_CreditoID);
                        SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                            IF Par_NatMovimiento=NatCargo THEN
                                SET Var_Cargos           :=Var_SaldoCapVencido;
                                SET Var_Abonos           :=Decimal_Cero;
                            ELSE
                                SET Var_Abonos           :=Var_SaldoCapVencido;
                                SET Var_Cargos           :=Decimal_Cero;
                            END IF;

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,          Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoCastigoCapCorr, Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,         Var_MonedaBaseID,       DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,             Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,          Aud_NumTransaccion);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoCastigoCap,  Var_Clasificacion,      Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);
               END IF;
               IF (Var_SaldoIntVencido>Decimal_Cero) THEN
                         SET DescripCredVen:=CONCAT("CASTIGO INTERES NORMAL. - ",Var_CreditoID);
                        SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                            IF Par_NatMovimiento=NatCargo THEN
                                SET Var_Cargos           :=Var_SaldoIntVencido;
                                SET Var_Abonos           :=Decimal_Cero;
                            ELSE
                                SET Var_Abonos           :=Var_SaldoIntVencido;
                                SET Var_Cargos           :=Decimal_Cero;
                            END IF;

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,          Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoCastigoIntCorr, Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,         Var_MonedaBaseID,       DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,             Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,          Aud_NumTransaccion);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoCastigoInt,  Var_Clasificacion,      Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);
               END IF;
                IF (Var_SaldoMoraVen>Decimal_Cero) THEN
                         SET DescripCredVen:=CONCAT("CASTIGO INTERES MORA. - ",Var_CreditoID);
                        SET ReferenciaCredito:=CONCAT("Cred.",CONVERT(Var_CreditoID, CHAR));
                            IF Par_NatMovimiento=NatCargo THEN
                                SET Var_Cargos           :=Var_SaldoMoraVen;
                                SET Var_Abonos           :=Decimal_Cero;
                            ELSE
                                SET Var_Abonos           :=Var_SaldoMoraVen;
                                SET Var_Cargos           :=Decimal_Cero;
                            END IF;

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,          Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen, ConceptoCastigoIntCorr, Var_Clasificacion,      Var_SubClasifica,   Var_Cargos,
                                Var_Abonos,         Var_MonedaBaseID,       DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,             Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,          Aud_NumTransaccion);

                            CALL POLIZACREDITOPRO(
                                Par_PolizaID,       Aud_EmpresaID,      Var_Fecha,              Var_CreditoID,      Var_ProdCreditoID,
                                Par_SucursalOrigen,ConceptoCastigoInt,  Var_Clasificacion,      Var_SubClasifica,   Var_Abonos,
                                Var_Cargos,         Var_MonedaBaseID,   DescripCredVen,        ReferenciaCredito,
                                Par_NumErr,         Par_ErrMen,         Entero_Cero,            Aud_Usuario,         Aud_FechaActual,
                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);
               END IF;
            END IF;
        END LOOP;
        END;
    CLOSE CREDITOTMP;

END ManejoErrores;

END TerminaStore$$