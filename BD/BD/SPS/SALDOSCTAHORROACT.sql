-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCTAHORROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCTAHORROACT`;DELIMITER $$

CREATE PROCEDURE `SALDOSCTAHORROACT`(

    Par_CuentaAhoID         BIGINT(12),
    Par_NatMovimiento       CHAR(1),
    Par_CantidadMov         DECIMAL(12,2),
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,

    INOUT Par_ErrMen        VARCHAR(400),
    Aud_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),

    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
    )
TerminaStore: BEGIN

    DECLARE     Var_CuentaAhoID     BIGINT(12);
    DECLARE     Var_Control         VARCHAR(100);
    DECLARE     Var_Consecutivo     BIGINT(20);


    DECLARE     Cadena_Vacia    CHAR(1);
    DECLARE     Entero_Cero     INT;
    DECLARE     Decimal_Cero    DECIMAL(12,2);
    DECLARE     Nat_Cargo       CHAR(1);
    DECLARE     Nat_Abono       CHAR(1);
    DECLARE     Salida_SI       CHAR(1);


    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.0;
    SET Nat_Cargo       := 'C';
    SET Nat_Abono       := 'A';
    SET Salida_SI       := 'S';
    SET Par_NumErr      := 999;

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr      := 999;
            SET Par_ErrMen      := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                        'Disculpe las molestias que esto le ocasiona. Ref: SP-SALDOSCTAHORROACT');
            SET Var_Control     := 'sqlException' ;
        END;

        IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr      := 001;
            SET Par_ErrMen      := CONCAT('El Numero de Cuenta esta Vacio.');
            SET Var_Control     := 'cuentaAhoID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        SET Var_CuentaAhoID := (SELECT CuentaAhoID
                                    FROM CUENTASAHO
                                        WHERE CuentaAhoID = Par_CuentaAhoID);

        SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);

        IF(Var_CuentaAhoID = Entero_Cero) THEN
            SET Par_NumErr      := 002;
            SET Par_ErrMen      := CONCAT('La Cuenta no Existe.');
            SET Var_Control     := 'cuentaAhoID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 003;
            SET Par_ErrMen      := CONCAT('La naturaleza del Movimiento esta vacia.');
            SET Var_Control     := 'natMovimiento' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NatMovimiento<>Nat_Cargo)THEN
            IF(Par_NatMovimiento<>Nat_Abono)THEN
                SET Par_NumErr      := 004;
                SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento no es Correcta.');
                SET Var_Control     := 'natMovimiento' ;
                SET Var_Consecutivo := '0';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_NatMovimiento<>Nat_Abono)THEN
            IF(Par_NatMovimiento<>Nat_Cargo)THEN
                SET Par_NumErr      := 005;
                SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento no es Correcta.');
                SET Var_Control     := 'natMovimiento' ;
                SET Var_Consecutivo := '0';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(IFNULL(Par_CantidadMov, Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr      := 006;
            SET Par_ErrMen      := CONCAT('La Cantidad esta Vacia.');
            SET Var_Control     := 'cantidadMov' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NatMovimiento = Nat_Abono) THEN
            UPDATE CUENTASAHO SET
                    AbonosDia       = AbonosDia     +Par_CantidadMov,
                    AbonosMes       = AbonosMes     +Par_CantidadMov,
                    Saldo           = (SaldoDispon + SaldoBloq) + Par_CantidadMov,
                    SaldoDispon     = (((SaldoDispon + SaldoBloq + SaldoSBC) + Par_CantidadMov) - SaldoBloq - SaldoSBC)
                WHERE CuentaAhoID   = Par_CuentaAhoID;
        END IF;

        IF(Par_NatMovimiento = Nat_Cargo) THEN
            UPDATE CUENTASAHO SET
                CargosDia       = CargosDia     +Par_CantidadMov,
                CargosMes       = CargosMes     +Par_CantidadMov,
                Saldo           = (SaldoDispon + SaldoBloq) - Par_CantidadMov,
                SaldoDispon     = (((SaldoDispon + SaldoBloq + SaldoSBC) - Par_CantidadMov) - SaldoBloq - SaldoSBC)
            WHERE CuentaAhoID   = Par_CuentaAhoID;
        END IF;
        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Actualizacion Realizada Exitosamente a la Cuenta:', Par_CuentaAhoID);
        SET Var_Control := 'cuentaAhoID' ;
        SET Var_Consecutivo := Entero_Cero;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;
END TerminaStore$$