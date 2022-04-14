-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCUENACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCUENACT`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCUENACT`(
    Par_ClienteID           INT(11),
    Par_CuentaAhoID         BIGINT(12),
    Par_MontoAplica         DECIMAL(14,2),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(350),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN

    DECLARE Var_FechaSistema            DATE;
    DECLARE Var_CuentaAhoID             BIGINT(12);
    DECLARE Var_Saldo                   DECIMAL(14,2);
    DECLARE Var_MonAplicaCuenta         DECIMAL(14,2);
    DECLARE Var_MontoMaximoProteccion   DECIMAL(14,2);
    DECLARE ar_MontoAplicadoCreditos    DECIMAL(14,2);
    DECLARE Var_MontoAdeudoCred         DECIMAL(14,2);
    DECLARE Var_MontoAplicadoCreditos   DECIMAL(14,2);


    DECLARE EnteroCero      INT;
    DECLARE SalidaSI        CHAR(1);
    DECLARE Decimal_Cero    DECIMAL;


    SET EnteroCero          :=0;
    SET SalidaSI            :='S';
    SET Decimal_Cero        :=0.00;

ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIAPROTECCUENACT ');

        END;

    IF NOT EXISTS(SELECT ClienteID
                    FROM CLIENTES
                     WHERE ClienteID = Par_ClienteID)THEN
        SET Par_NumErr  :=1;
        SET Par_ErrMen  :='El Cliente indicado no existe';
        LEAVE ManejoErrores;
    END IF;

    SELECT CuentaAhoID, SaldoDispon INTO Var_CuentaAhoID, Var_Saldo
                    FROM CUENTASAHO
                    WHERE CuentaAhoID =Par_CuentaAhoID;


    IF(IFNULL(Var_CuentaAhoID,EnteroCero)= EnteroCero)THEN
        SET Par_NumErr  :=2;
        SET Par_ErrMen  :='La Cuenta indicada no existe';
        LEAVE ManejoErrores;
    END IF;


    SET Var_MontoMaximoProteccion := IFNULL((SELECT MontoMaxProtec FROM PARAMETROSCAJA LIMIT 1), Decimal_Cero);

    SET Var_MontoAplicadoCreditos :=IFNULL((SELECT SUM(MontoAplicaCred)
                                                FROM CLIAPROTECCRED
                                                    WHERE ClienteID =Par_ClienteID), Decimal_Cero);


    IF(Par_MontoAplica > EnteroCero AND Var_MontoAplicadoCreditos < Var_MontoMaximoProteccion)THEN
        SELECT  FORMAT(FUNCIONTOTDEUDACRE(Cre.CreditoID),2) INTO Var_MontoAdeudoCred
                FROM CREDITOS Cre
                WHERE Cre.ClienteID = Par_ClienteID
                  AND ( Cre.Estatus     =  'V'
                   OR   Cre.Estatus     =  'B')
                    LIMIT 1;

        SET Var_MontoAdeudoCred :=IFNULL(Var_MontoAdeudoCred, Decimal_Cero);
        IF(Var_MontoAdeudoCred > Decimal_Cero)THEN
            SET Par_NumErr  :=3;
            SET Par_ErrMen  :='El Cliente Aun Tiene Creditos Sin pagar. No se Puede aplicar la proteccion a Cuentas de Ahorro';
            LEAVE ManejoErrores;
        END IF;

    END IF;

    SET Aud_FechaActual     :=NOW();

        UPDATE  CLIAPROTECCUEN SET
            MonAplicaCuenta = Par_MontoAplica,

            EmpresaID       =Par_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        =Aud_Sucursal,
            NumTransaccion  =Aud_NumTransaccion
            WHERE ClienteID = Par_ClienteID
                AND CuentaAhoID = Par_CuentaAhoID;

    SELECT SUM(MonAplicaCuenta) INTO Var_MonAplicaCuenta
            FROM CLIAPROTECCUEN
                WHERE ClienteID = Par_ClienteID;
    SET Var_MonAplicaCuenta := IFNULL(Var_MonAplicaCuenta, Decimal_Cero);


    UPDATE  CLIAPLICAPROTEC SET
        MonAplicaCuenta = Var_MonAplicaCuenta,

        EmpresaID       =Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        =Aud_Sucursal,
        NumTransaccion  =Aud_NumTransaccion

        WHERE ClienteID = Par_ClienteID;


    SET Par_NumErr  :=0;
    SET Par_ErrMen  :='Proteccion del Ahorro Actualizado Correctamente';
END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'clienteID' AS control,
            EnteroCero AS consecutivo;
END IF;

END TerminaStore$$