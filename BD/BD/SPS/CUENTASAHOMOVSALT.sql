-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVSALT`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVSALT`(

    Par_CuentaAhoID         BIGINT(12),
    Par_NumeroMov           BIGINT(20),
    Par_Fecha               DATE,
    Par_NatMovimiento       CHAR(1),
    Par_CantidadMov         DECIMAL(12,2),

    Par_DescripcionMov      VARCHAR(150),
    Par_ReferenciaMov       VARCHAR(50),
    Par_TipoMovAhoID        CHAR(4),
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


    DECLARE Var_TipoMovID                   CHAR(4);
    DECLARE Var_EstatusDes                  VARCHAR(50);
    DECLARE Var_Control                     VARCHAR(100);
    DECLARE Var_Consecutivo                 VARCHAR(20);


    DECLARE Cliente                         INT;
    DECLARE SaldoDisp                       DECIMAL(12,2);
    DECLARE MonedaCon                       INT;
    DECLARE EstatusC                        CHAR(1);
    DECLARE Cadena_Vacia                    CHAR(1);
    DECLARE Entero_Cero                     INT;
    DECLARE Decimal_Cero                    DECIMAL(12,2);
    DECLARE EstatusActual                   CHAR(1);
    DECLARE EstatusActivo                   CHAR(1);
    DECLARE Nat_Cargo                       CHAR(1);
    DECLARE Nat_Abono                       CHAR(1);
    DECLARE Fecha_Vacia                     DATE;
    DECLARE Salida_NO                       CHAR(1);
    DECLARE Var_Si                          CHAR(1);
    DECLARE Est_Cancelado                   CHAR(1) ;
    DECLARE Salida_SI                       CHAR(1);


    SET Cadena_Vacia                        := '';
    SET Fecha_Vacia                         := '1900-01-01';
    SET Entero_Cero                         := 0;
    SET Decimal_Cero                        := 0.0;
    SET EstatusActivo                       := 'A';
    SET Nat_Cargo                           := 'C';
    SET Nat_Abono                           := 'A';
    SET Salida_NO                           := 'N';
    SET Var_Si                              := 'S';
    SET Est_Cancelado                       :='C';
    SET SaldoDisp                           := 0.0;
    SET Var_Control                         := Cadena_Vacia;
    SET Var_Consecutivo                     := Cadena_Vacia;
    SET Salida_SI                           := 'S';

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr      := 999;
            SET Par_ErrMen      := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                        'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOMOVSALT');
            SET Var_Consecutivo := Entero_Cero;
            SET Var_Control := 'sqlException' ;
        END;

        IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr      := 001;
            SET Par_ErrMen      := CONCAT('El Numero de Cuenta esta Vacio.');
            SET Var_Control     := 'cuentaAhoID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NumeroMov, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr      := 002;
            SET Par_ErrMen      := CONCAT('El Numero de Movimiento esta Vacio.');
            SET Var_Control     := 'numeroMov' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr      := 003;
            SET Par_ErrMen      := CONCAT('La Fecha esta Vacia.');
            SET Var_Control     := 'numeroMov' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 004;
            SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento esta Vacia.');
            SET Var_Control     := 'natMovimiento' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NatMovimiento<>Nat_Cargo)THEN
            IF(Par_NatMovimiento<>Nat_Abono)THEN
                SET Par_NumErr      := 005;
                SET Par_ErrMen      := CONCAT('La Naturaleza del Movimiento no es Correcta.');
                SET Var_Control     := 'natMovimiento' ;
                SET Var_Consecutivo := '0';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_NatMovimiento<>Nat_Abono)THEN
            IF(Par_NatMovimiento<>Nat_Cargo)THEN
                SET Par_NumErr      := 006;
                SET Par_ErrMen      := CONCAT('La naturaleza del Movimiento no es correcta.');
                SET Var_Control     := 'natMovimiento' ;
                SET Var_Consecutivo := '0';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(IFNULL(Par_CantidadMov, Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr      := 007;
            SET Par_ErrMen      := CONCAT('La Cantidad esta Vacia.');
            SET Var_Control     := 'natMovimiento' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_DescripcionMov, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 008;
            SET Par_ErrMen      := CONCAT('La Descripcion del Movimiento esta Vacia.');
            SET Var_Control     := 'descripcionMov' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 009;
            SET Par_ErrMen      := CONCAT('La Referencia esta Vacia.');
            SET Var_Control     := 'referenciaMov' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoMovAhoID, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 010;
            SET Par_ErrMen      := CONCAT('El Tipo de Movimiento esta Vacio.');
            SET Var_Control     := 'tipoMov' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;

        CALL SALDOSAHORROCON(
            Cliente,  SaldoDisp,  MonedaCon,  EstatusC, Par_CuentaAhoID);

        IF(IFNULL(EstatusC, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr      := 011;
            SET Par_ErrMen      := CONCAT('La Cuenta no Existe.');
            SET Var_Control     := 'cuentaAhoID' ;
            SET Var_Consecutivo := '0';
            LEAVE ManejoErrores;
        END IF;


        IF (EstatusC  ='R') THEN
            SET Var_EstatusDes :='REGISTRADA';
            ELSEIF(EstatusC ='A')THEN
                SET Var_EstatusDes :='ACTIVA';
                ELSEIF(EstatusC ='B') THEN
                    SET Var_EstatusDes :='BLOQUEADA';
                    ELSEIF(EstatusC ='I'  )THEN
                        SET Var_EstatusDes :='INACTIVA';
                            ELSEIF( EstatusC  ='C'  )THEN
                                SET Var_EstatusDes :='CANCELADA';
        END IF;


        IF(Par_NatMovimiento=Nat_Cargo)THEN
            IF(EstatusC=EstatusActivo) THEN
                IF(SaldoDisp>=Par_CantidadMov) THEN

                    CALL SALDOSCTAHORROACT(
                    Par_CuentaAhoID,        Par_NatMovimiento,          Par_CantidadMov,        Salida_NO,              Par_NumErr,
                    Par_ErrMen,             Aud_EmpresaID ,             Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
                    IF(Par_NumErr > Entero_Cero)THEN
                        LEAVE ManejoErrores;
                    END IF;
                END IF;

                IF(SaldoDisp<Par_CantidadMov) THEN
                    SET Par_NumErr      := 012;
                    SET Par_ErrMen      := CONCAT('Saldo Insuficiente.');
                    SET Var_Control     := 'cuentaAhoID' ;
                    SET Var_Consecutivo := '0';
                    LEAVE ManejoErrores;
                END IF;
            END IF;

            IF(EstatusC<>EstatusActivo) THEN
                SET Par_NumErr      := 013;
                SET Par_ErrMen      := CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus ',Var_EstatusDes, ' Cuenta: ', Par_CuentaAhoID);
                SET Var_Control     := 'cuentaAhoID' ;
                SET Var_Consecutivo := '0';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_NatMovimiento=Nat_Abono)THEN

            IF(EstatusC = EstatusActivo) THEN
                CALL SALDOSCTAHORROACT(
                    Par_CuentaAhoID,        Par_NatMovimiento,      Par_CantidadMov,        Salida_NO,          Par_NumErr,
                    Par_ErrMen,             Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                IF(Par_NumErr > Entero_Cero)THEN
                    LEAVE ManejoErrores;
                END IF;
            END IF;

            IF(EstatusC <> EstatusActivo) THEN
                SET Par_NumErr      := 014;
                SET Par_ErrMen      := CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus: ',Var_EstatusDes, ' Cuenta: ', Par_CuentaAhoID);
                SET Var_Control     := 'cuentaAhoID' ;
                SET Var_Consecutivo := '0';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        SET Aud_FechaActual := CURRENT_TIMESTAMP();
        SET Var_TipoMovID := (SELECT TipoMovAhoID
                                FROM TIPOSMOVSAHO
                                    WHERE TipoMovAhoID = Par_TipoMovAhoID AND EsEfectivo = Var_Si);

        CALL PLDOPEINUALERTNUMPRO(
            Par_CuentaAhoID,        Par_NumeroMov,          Par_Fecha,          Par_NatMovimiento,      Par_CantidadMov,
            Par_DescripcionMov,     Par_ReferenciaMov,      Par_TipoMovAhoID,   MonedaCon,              Cliente,
            Salida_NO,              Par_NumErr,             Par_ErrMen,         Aud_EmpresaID ,         Aud_Usuario,
            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
        );

        IF(Par_NumErr > Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Var_TipoMovID, Cadena_Vacia) != Cadena_Vacia) THEN
            CALL EFECTIVOMOVALT(
                Par_CuentaAhoID,        Par_NumeroMov,          Par_Fecha,          Par_NatMovimiento,      Par_CantidadMov,
                Par_DescripcionMov,     Par_ReferenciaMov,      Par_TipoMovAhoID,   MonedaCon,              Cliente,
                Salida_NO,              Par_NumErr,             Par_ErrMen,         Aud_EmpresaID,          Aud_Usuario,
                Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion
            );

            IF(Par_NumErr > Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

        SET Aud_FechaActual := NOW();

        INSERT INTO CUENTASAHOMOV(
            CuentaAhoID,                NumeroMov,              Fecha,              NatMovimiento,      CantidadMov,
            DescripcionMov,             ReferenciaMov,          TipoMovAhoID,       MonedaID,           EmpresaID,
            Usuario,                    FechaActual,            DireccionIP,        ProgramaID,         Sucursal,
            NumTransaccion)
        VALUES(
            Par_CuentaAhoID,            Aud_NumTransaccion,     Par_Fecha,          Par_NatMovimiento,      Par_CantidadMov,
            Par_DescripcionMov,         Par_ReferenciaMov,      Par_TipoMovAhoID,   MonedaCon,              Aud_EmpresaID,
            Aud_Usuario,                Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
            Aud_NumTransaccion);

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Agregado Exitosamente el Movimiento de la Cuenta.');
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