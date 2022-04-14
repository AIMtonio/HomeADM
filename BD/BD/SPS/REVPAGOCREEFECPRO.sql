-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVPAGOCREEFECPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVPAGOCREEFECPRO`;DELIMITER $$

CREATE PROCEDURE `REVPAGOCREEFECPRO`(
    Par_TranRespaldo    BIGINT(20),
    Par_UsuarioClave    VARCHAR(25),
    Par_ContraseniaAut  VARCHAR(45),
    Par_Motivo          VARCHAR(400),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

        )
TerminaStore:BEGIN

DECLARE Var_FechaSistema        DATE;
DECLARE Var_SaldoEfecMN         DECIMAL(14,2);
DECLARE Var_SaldoEfecME         DECIMAL(14,2);
DECLARE Var_SumaTotalMN         DECIMAL(14,2);
DECLARE Var_SumaTotalME         DECIMAL(14,2);
DECLARE Var_DenominacionID      INT;
DECLARE Var_CantidadDenom       DECIMAL(12,2);
DECLARE Var_MonedaID            INT;
DECLARE Var_Monto               DECIMAL(14,2);
DECLARE Var_Naturaleza          INT(11);
DECLARE Var_MontoEnFirme        DECIMAL(14,2);
DECLARE Var_CajaID              INT(11);
DECLARE Var_SucursalCaja        INT(11);
DECLARE Var_Instrumento         BIGINT(12);
DECLARE Var_Referencia          VARCHAR(200);
DECLARE Var_TipoOperacion       INT;
DECLARE Var_CreditoID           BIGINT(12);
DECLARE Var_CuentaAhoID         BIGINT(12);
DECLARE Var_MontoPagado         DECIMAL(14,2);
DECLARE Var_MonedaIDCredito     INT(11);
DECLARE Var_CambioEntregado     DECIMAL(14,2);
DECLARE Var_MontoRecibido       DECIMAL(14,2);
DECLARE Var_CueClienteID        INT;
DECLARE Var_CueSaldo            DECIMAL(14,2);
DECLARE Var_CueMonedaID         INT;
DECLARE Var_CueEstatus          CHAR(1);
DECLARE Var_ValorDenominacion   INT(11);
DECLARE Var_CantidadDenomActual DECIMAL(12,2);



DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT(11);
DECLARE Salida_SI           CHAR(1);
DECLARE Salida_NO           CHAR(1);
DECLARE Efectivo            CHAR(1);
DECLARE TipoOperEntPagoCre  INT;
DECLARE TipoOperSalPagoCre  INT;
DECLARE OperSalPrepagoCred  INT;
DECLARE OperEntPrepagoCred  INT;
DECLARE OperSalDepGarLiqAdi INT;
DECLARE OperaSalCambio      INT;
DECLARE DescripOperacion    VARCHAR(50);
DECLARE MonedaNacional      INT;
DECLARE EstatusActiva       CHAR(1);
DECLARE NaturalezaEntrada   INT;
DECLARE NaturalezaSalida    INT;
DECLARE Decimal_Cero        DECIMAL(14,2);


DECLARE CURDENOMINACIONMOV CURSOR FOR
    SELECT DenominacionID, Cantidad, Monto, MonedaID, Naturaleza
        FROM DENOMINACIONMOVS
            WHERE CajaID = Var_CajaID
                AND Fecha   =   Var_FechaSistema
                AND SucursalID = Var_SucursalCaja
                AND Transaccion =Par_TranRespaldo;


DECLARE CURCAJASMOVS CURSOR FOR
        SELECT CajaID, MontoEnFirme, Instrumento, Referencia, TipoOperacion,SucursalID
            FROM CAJASMOVS
                WHERE Transaccion   =Par_TranRespaldo
                AND Fecha           = Var_FechaSistema;


DECLARE CURRESPAGCREDITO CURSOR FOR
    SELECT RES.CreditoID,RES.CuentaAhoID,RES.MontoPagado,CRE.MonedaID
        FROM RESPAGCREDITO RES
            LEFT JOIN CREDITOS CRE ON CRE.CreditoID = RES.CreditoID
            WHERE TranRespaldo =Par_TranRespaldo;


SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET Salida_SI           :='S';
SET Salida_NO           :='N';
SET Efectivo            :='E';
SET TipoOperEntPagoCre  :=8;
SET TipoOperSalPagoCre  :=28;
SET OperSalPrepagoCred  :=79;
SET OperEntPrepagoCred  :=78;
SET OperSalDepGarLiqAdi :=44;
SET OperaSalCambio      :=26;
SET DescripOperacion    :='PAGO DE CREDITO';
SET MonedaNacional      :=1;
SET EstatusActiva       :='A';
SET NaturalezaEntrada   :=1;
SET NaturalezaSalida    :=2;
SET Decimal_Cero        :=0.00;

ManejoErrores: BEGIN

    SELECT FechaSistema INTO Var_FechaSistema
        FROM PARAMETROSSIS
            LIMIT 1;
    SET Var_CambioEntregado := Entero_Cero;
    SET Var_SumaTotalMN     :=0.0;
    SET Var_SumaTotalME     :=0.0;
    SET Aud_FechaActual     :=NOW();


    OPEN  CURCAJASMOVS;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                CICLOCAJASMOVS: LOOP
                    FETCH CURCAJASMOVS  INTO Var_CajaID,    Var_MontoEnFirme,   Var_Instrumento,
                                            Var_Referencia, Var_TipoOperacion,  Var_SucursalCaja ;

                        IF(Var_TipoOperacion = TipoOperEntPagoCre OR Var_TipoOperacion = OperEntPrepagoCred)THEN
                            SET Var_MontoRecibido :=Var_MontoEnFirme;
                        END IF;

                        IF(Var_TipoOperacion = OperaSalCambio)THEN
                            SET Var_CambioEntregado :=Var_CambioEntregado + Var_MontoEnFirme ;
                        END IF;

                        IF(Var_TipoOperacion = OperSalDepGarLiqAdi)THEN
                                CALL SALDOSAHORROCON(
                                        Var_CueClienteID, Var_CueSaldo, Var_CueMonedaID, Var_CueEstatus, Var_Instrumento);
                                IF(Var_CueSaldo < Var_MontoEnFirme)THEN
                                    SET Par_NumErr  := 1;
                                    SET Par_ErrMen  := CONCAT('La cuenta ',CONVERT(Var_Instrumento, CHAR),' no cuenta con saldo suficiente para aplicar la reversa');
                                    LEAVE ManejoErrores;
                                END IF;
                                IF(IFNULL(Var_CueEstatus,Cadena_Vacia) != EstatusActiva)THEN
                                    SET Par_NumErr  := 2;
                                    SET Par_ErrMen  := CONCAT('La cuenta no existe o no se encuentra Activa');
                                    LEAVE ManejoErrores;
                                END IF;
                                    UPDATE CUENTASAHO SET
                                        Saldo       =   (Saldo - Var_MontoEnFirme),
                                        SaldoDispon =   (SaldoDispon - Var_MontoEnFirme),
                                        AbonosMes   =   (AbonosMes - Var_MontoEnFirme),
                                        AbonosDia   =   (AbonosDia - Var_MontoEnFirme)
                                    WHERE CuentaAhoID= Var_Instrumento;

                            END IF;

                END LOOP CICLOCAJASMOVS;
            END;
        CLOSE CURCAJASMOVS;

    SET Var_CajaID:=IFNULL(Var_CajaID,Entero_Cero);


    OPEN  CURRESPAGCREDITO;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLORESPAGCREDITO: LOOP
                FETCH CURRESPAGCREDITO  INTO Var_CreditoID, Var_CuentaAhoID, Var_MontoPagado, Var_MonedaIDCredito;

                    IF(Var_MonedaIDCredito = MonedaNacional)THEN
                        SET Var_SumaTotalMN := ROUND(Var_SumaTotalMN + Var_MontoPagado,2);
                    ELSEIF(Var_MonedaIDCredito != MonedaNacional)THEN
                        SET Var_SumaTotalME := Var_SumaTotalME + Var_MontoPagado;
                    END IF;


            END LOOP CICLORESPAGCREDITO;
        END;
    CLOSE CURRESPAGCREDITO;
    IF(Var_CajaID >Entero_Cero)THEN
         SELECT  Caj.SaldoEfecMN, Caj.SaldoEfecMN INTO Var_SaldoEfecMN, Var_SaldoEfecME
                FROM CAJASVENTANILLA Caj
                  WHERE SucursalID=Var_SucursalCaja
                        AND CajaID     = Var_CajaID;

            SET Var_SaldoEfecMN := IFNULL(Var_SaldoEfecMN, Entero_Cero);
            SET Var_SaldoEfecME := IFNULL(Var_SaldoEfecME, Entero_Cero);

        IF(Var_SaldoEfecMN < Var_SumaTotalMN) THEN
                SET Par_NumErr  := 1;
                SET Par_ErrMen  := 'La Reversa no puede ser realizada, ya que no cuenta con Saldo en la Caja, donde se hizo la Operacion';
                LEAVE ManejoErrores;
        ELSEIF(Var_SaldoEfecME < Var_SumaTotalME)THEN
                SET Par_NumErr  := 2;
                SET Par_ErrMen  := 'La Reversa no puede ser realizada, ya que no cuenta con Saldo en la Caja, donde se hizo la Operacion';
                LEAVE ManejoErrores;
        END IF;
    END IF;

    CALL REVERSASOPERALT(
            Par_TranRespaldo,   Par_Motivo,     DescripOperacion,   TipoOperSalPagoCre,     Par_TranRespaldo,
            Var_MontoRecibido,  Var_CajaID,     Var_SucursalCaja,   Var_FechaSistema,       Par_UsuarioClave,
            Par_ContraseniaAut, Aud_Usuario,    Decimal_Cero,       Decimal_Cero,           Salida_NO,
            Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;



        OPEN  CURDENOMINACIONMOV;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                CICLODENOMIN: LOOP
                    FETCH CURDENOMINACIONMOV  INTO Var_DenominacionID, Var_CantidadDenom, Var_Monto,
                                                Var_MonedaID, Var_Naturaleza;

            SET Var_CantidadDenomActual := (SELECT Cantidad
                                            FROM BALANZADENOM
                                                WHERE SucursalID = Var_SucursalCaja
                                                    AND CajaID = Var_CajaID
                                                    AND DenominacionID = Var_DenominacionID);
            SET Var_ValorDenominacion   :=(SELECT Valor
                                                FROM DENOMINACIONES
                                                WHERE DenominacionID=Var_DenominacionID);
            SET Var_CantidadDenomActual := IFNULL(Var_CantidadDenomActual,Entero_Cero);


                IF(Var_Naturaleza = NaturalezaSalida)THEN
                    UPDATE BALANZADENOM SET
                            Cantidad = Cantidad + Var_CantidadDenom
                        WHERE SucursalID = Var_SucursalCaja
                            AND CajaID = Var_CajaID
                            AND DenominacionID = Var_DenominacionID;
                END IF;

                IF(Var_Naturaleza = NaturalezaEntrada)THEN
                    IF (Var_CantidadDenomActual >= Var_CantidadDenom )THEN
                        UPDATE BALANZADENOM SET
                                Cantidad = Cantidad - Var_CantidadDenom
                            WHERE SucursalID = Var_SucursalCaja
                                AND CajaID = Var_CajaID
                                AND DenominacionID = Var_DenominacionID;
                    ELSE
                        SET Par_NumErr  := 3;
                        IF(Var_DenominacionID <> 7)THEN
                            SET Par_ErrMen  := CONCAT('La Reversa no puede ser realizada, ya que no cuenta con Saldo en la Caja,',"<br>",'
                                                    Denominacion: ',CONVERT(Var_ValorDenominacion, CHAR),'  Cantidad Requerida: ',Var_CantidadDenom);
                        ELSE
                            SET Par_ErrMen  := CONCAT('La Reversa no puede ser realizada, ya que no cuenta con Saldo en la Caja,',"<br>",'
                                                    Monedas   Cantidad Requerida: ',Var_CantidadDenom);
                        END IF;

                        LEAVE ManejoErrores;
                    END IF;
                END IF;

        END LOOP CICLODENOMIN;
    END;
    CLOSE CURDENOMINACIONMOV;


    SET Var_MontoRecibido :=Var_MontoRecibido - Var_CambioEntregado;


    UPDATE CAJASVENTANILLA SET
                SaldoEfecMN = SaldoEfecMN - Var_MontoRecibido
                WHERE SucursalID = Var_SucursalCaja
                    AND CajaID =Var_CajaID;


    DELETE FROM DENOMINACIONMOVS
            WHERE SucursalID    =Var_SucursalCaja
                AND CajaID      =Var_CajaID
                AND Fecha       =Var_FechaSistema
                AND Transaccion =Par_TranRespaldo;


    DELETE FROM CAJASMOVS
        WHERE Transaccion   =Par_TranRespaldo
        AND Fecha           = Var_FechaSistema;


    DELETE FROM RESPAGCREDITO
            WHERE TranRespaldo = Par_TranRespaldo;

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := 'Reversa de Pago de Credito, Realizada Exitosamente.';

END ManejoErrores;
    IF (Par_Salida = Salida_SI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'creditoID' AS control,
            Entero_Cero AS consecutivo;
    END IF;

END TerminaStore$$