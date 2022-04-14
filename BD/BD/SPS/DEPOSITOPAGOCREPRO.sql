-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOPAGOCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOPAGOCREPRO`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOPAGOCREPRO`(
    Par_CreditoID       BIGINT,
    Par_MontoPagar      DECIMAL(12, 2),
    Par_Fecha           DATE,
    Par_EmpresaID       INT,
    Par_Salida          CHAR(1),

INOUT Par_NumErr        INT(11),
INOUT Par_ErrMen        VARCHAR(400),
INOUT Par_Consecutivo   BIGINT,

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
        )
TerminaStore: BEGIN


DECLARE Var_FechaRegistro   DATE;
DECLARE Var_Transaccion     BIGINT;
DECLARE Var_Consecutivo     BIGINT;
DECLARE Var_CreditoID       BIGINT;
DECLARE Var_MontoDeposito   DECIMAL(12,2);
DECLARE Var_SumaMontoDep    DECIMAL(12,2);

DECLARE Var_SaldoMonPago    DECIMAL(12,2);
DECLARE Var_MontoAplicar    DECIMAL(12,2);
DECLARE Var_CreditoCursor   INT(11);
DECLARE Var_ConsecutivoDep  BIGINT(20);
DECLARE Var_ClienteCre      INT(11);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12, 2);



DECLARE CURSORDEPOSI CURSOR FOR
    SELECT  FechaRegistro,  Transaccion,    Consecutivo,    CreditoID,  MontoDeposito
        FROM DEPOSITOPAGOCRE
        WHERE CreditoID = Par_CreditoID
          AND (MontoDeposito - IFNULL(MontoAplicado,Decimal_Cero)) > Decimal_Cero
        ORDER BY FechaRegistro, Transaccion;


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.00;
SET Var_SaldoMonPago    := Par_MontoPagar;
SET Aud_FechaActual     := NOW();

SET Var_SumaMontoDep    := (SELECT  SUM(MontoDeposito)
                                FROM DEPOSITOPAGOCRE
                                WHERE CreditoID = Par_CreditoID
                                  AND (MontoDeposito - IFNULL(MontoAplicado,Decimal_Cero)) > Decimal_Cero
                                ORDER BY FechaRegistro, Transaccion);
SET Var_SumaMontoDep    := IFNULL(Var_SumaMontoDep,Decimal_Cero);


IF(Par_MontoPagar > Var_SumaMontoDep ) THEN
    SET Var_ClienteCre := (SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
    CALL FOLIOSAPLICAACT('DEPOSITOPAGOCRE', Var_ConsecutivoDep);

    CALL DEPOSITOPAGOCREALT(
        Par_Fecha,                          Aud_NumTransaccion, Var_ConsecutivoDep, Par_CreditoID,      Var_ClienteCre,
        Par_MontoPagar - Var_SumaMontoDep,  Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,                     Aud_Sucursal,       Aud_NumTransaccion
    );
END IF;


OPEN CURSORDEPOSI;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    CICLO:LOOP

    FETCH CURSORDEPOSI INTO
        Var_FechaRegistro,  Var_Transaccion,    Var_Consecutivo,    Var_CreditoID,  Var_MontoDeposito;

    SET Var_MontoAplicar = Decimal_Cero;

    IF(Var_SaldoMonPago <= Decimal_Cero) THEN
        LEAVE CICLO;
    END IF;

    IF(Var_SaldoMonPago > Var_MontoDeposito) THEN
        SET Var_MontoAplicar    := Var_MontoDeposito;
    ELSE
        SET Var_MontoAplicar    := Var_SaldoMonPago;
    END IF;

    UPDATE DEPOSITOPAGOCRE SET
        MontoAplicado   = Var_MontoAplicar,
        FechaAplicacion = Par_Fecha,
        NumTraAplica    = Aud_NumTransaccion,

        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
    WHERE FechaRegistro = Var_FechaRegistro
        AND Transaccion = Var_Transaccion
        AND Consecutivo = Var_Consecutivo
        AND CreditoID   = Var_CreditoID;

    SET Var_SaldoMonPago    := Var_SaldoMonPago - IFNULL(Var_MontoAplicar,Decimal_Cero);

    END LOOP CICLO;
END;
CLOSE CURSORDEPOSI;


END TerminaStore$$