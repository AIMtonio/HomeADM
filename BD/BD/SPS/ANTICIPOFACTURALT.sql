-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANTICIPOFACTURALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANTICIPOFACTURALT`;DELIMITER $$

CREATE PROCEDURE `ANTICIPOFACTURALT`(
    Par_ProveedorID     INT(11),
    Par_NoFactura       VARCHAR(20),
    Par_ClaveDispMov    INT(11),
    Par_FormaPago       CHAR(1),
    Par_MontoAnticipo   DECIMAL(12,2),
    Par_TotalFactura    DECIMAL(12,2),
    Par_SaldoFactura    DECIMAL(12,2),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN


DECLARE AnticipoFactID  INT;
DECLARE Var_Poliza      BIGINT;
DECLARE Var_RFC         CHAR(13);
DECLARE Var_Control     VARCHAR(100);
DECLARE Var_NatConta    CHAR(2);
DECLARE Var_CtaAntProv  VARCHAR(25);
DECLARE Var_CtaProvee   VARCHAR(25);


DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE SalidaSI        CHAR(1);
DECLARE Si_EmitePoliza  CHAR(1);
DECLARE No_EmitePoliza  CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE FechaSist       DATE;
DECLARE Est_Registra    CHAR(1);
DECLARE Tipo_AltAntFact CHAR(1);
DECLARE Var_SaldoFactura DECIMAL(12,2);
DECLARE Con_PagoAntNO   CHAR(1);
DECLARE CentroCostos    INT(2);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Cuenta_Vacia    VARCHAR(15);
DECLARE Con_AntFactAlta INT;
DECLARE Des_AntFactAlta VARCHAR(100);


SET Entero_Cero     := 0;
SET Decimal_Cero     := 0.0;
SET Cadena_Vacia    := '';
SET SalidaSI        := 'S';
SET Si_EmitePoliza  := 'S';
SET No_EmitePoliza  := 'N';
SET SalidaNO        := 'N';
SET Fecha_Vacia     := '1900-01-01';
SET Est_Registra    := 'R';
SET Tipo_AltAntFact := 'A';
SET Con_PagoAntNO   := 'N';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Cuenta_Vacia    := '000000000000000';
SET Con_AntFactAlta := 83;
SET Des_AntFactAlta := 'ALTA DE ANTICIPO DE FACTURA';

SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Aud_FechaActual := CURRENT_TIMESTAMP();

SET CentroCostos:= (SELECT CenCostoManualID FROM FACTURAPROV WHERE ProveedorID=Par_ProveedorID AND NoFactura=Par_NoFactura );
ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-ANTICIPOFACTURALT');
                        SET Var_Control = 'sqlException' ;
            END;

IF(IFNULL(Par_ProveedorID, Entero_Cero)) = Entero_Cero THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '001' AS NumErr,
            'El Proveedor esta vacio.' AS ErrMen,
            'proveedorID' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 1;
        SET Par_ErrMen := 'El Proveedor esta vacio.';
    END IF;
END IF;


IF(IFNULL(Par_NoFactura, Cadena_Vacia)) = Cadena_Vacia THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '002' AS NumErr,
            'El Numero de Factura esta vacio' AS ErrMen,
            'noFactura' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 2;
        SET Par_ErrMen := 'El Numero de Factura esta vacio';
    END IF;
END IF;

IF(IFNULL(Par_FormaPago, Cadena_Vacia)) = Cadena_Vacia THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '003' AS NumErr,
            'El Tipo de Pago esta vacio' AS ErrMen,
            'formaPago' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 3;
        SET Par_ErrMen := 'El Tipo de Pago esta vacio';
    END IF;
END IF;

IF(IFNULL(Par_MontoAnticipo, Decimal_Cero)) <= Decimal_Cero THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '004' AS NumErr,
            'El Monto Anticipo debe ser mayor que Cero' AS ErrMen,
            'montoAnticipo' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 4;
        SET Par_ErrMen := 'El Monto Anticipo debe ser mayor que Cero';
    END IF;
END IF;

IF(Par_MontoAnticipo > Par_SaldoFactura ) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '005' AS NumErr,
            'El Monto de Anticipo debe ser menor o igual al Saldo' AS ErrMen,
            'montoAnticipo' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 5;
        SET Par_ErrMen := 'El Monto de Anticipo debe ser menor o igual al Saldo';
    END IF;
END IF;

SET AnticipoFactID := (SELECT IFNULL(COUNT(*),0)+1 FROM ANTICIPOFACTURA);

INSERT INTO ANTICIPOFACTURA (
        AnticipoFactID,         ProveedorID,            NoFactura,          ClaveDispMov,
        FechaAnticipo,          EstatusAnticipo,        FormaPago,          MontoAnticipo,
        TotalFactura,           SaldoFactura,           FechaCancela,       EmpresaID,
        Usuario,                FechaActual,            DireccionIP,        ProgramaID,
        Sucursal,               NumTransaccion)
    VALUES(
        AnticipoFactID,         Par_ProveedorID,        Par_NoFactura,          Par_ClaveDispMov,
        FechaSist,              Est_Registra,           Par_FormaPago,          Par_MontoAnticipo,
        Par_TotalFactura,       Par_SaldoFactura,       Fecha_Vacia,            Aud_EmpresaID,
        Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
        Aud_Sucursal,           Aud_NumTransaccion);




SET Var_RFC = (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
                 FROM PROVEEDORES
                 WHERE ProveedorID = Par_ProveedorID);

    SELECT CuentaAnticipo,CuentaCompleta
    INTO Var_CtaAntProv, Var_CtaProvee
    FROM PROVEEDORES
    WHERE ProveedorID = Par_ProveedorID;

    SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
    SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);


    SET Var_NatConta := Nat_Cargo;


    CALL CONTAFACTURAPRO(
        Par_ProveedorID,        Par_NoFactura,      Tipo_AltAntFact,    Con_PagoAntNO,      Si_EmitePoliza,
        Var_Poliza,             FechaSist,          Par_MontoAnticipo,  Entero_Cero,        CentroCostos,
        Var_CtaProvee,          Entero_Cero,        Var_RFC,            Cadena_Vacia,       Var_NatConta,
        Con_AntFactAlta,        Des_AntFactAlta,    Entero_Cero,        SalidaNO,           Par_NumErr,
        Par_ErrMen,             Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
    );

    IF (Par_Salida = SalidaSI) THEN
        IF(Par_NumErr != Entero_Cero)THEN
                SELECT '100' AS NumErr,
                    'Error en el alta de poliza' AS ErrMen,
                    'proveedorID' AS control,
                    Entero_Cero AS consecutivo;
                LEAVE TerminaStore;
            END IF;
    END IF;

    IF (Par_Salida = SalidaNO) THEN
        IF(Par_NumErr != Entero_Cero)THEN
            SET Par_NumErr := 100;
            SET Par_ErrMen := 'Error en el alta de poliza.';
        END IF;
    END IF;


        SET Var_NatConta := Nat_Abono;

        CALL CONTAFACTURAPRO(
        Par_ProveedorID,        Par_NoFactura,      Tipo_AltAntFact,    Con_PagoAntNO,      No_EmitePoliza,
        Var_Poliza,             FechaSist,          Par_MontoAnticipo,  Entero_Cero,        CentroCostos,
        Var_CtaAntProv,         Entero_Cero,        Var_RFC,            Cadena_Vacia,       Var_NatConta,
        Con_AntFactAlta,        Des_AntFactAlta,    Entero_Cero,        SalidaNO,           Par_NumErr,
        Par_ErrMen,             Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
    );

    IF (Par_Salida = SalidaSI) THEN
        IF(Par_NumErr != Entero_Cero)THEN
                SELECT '100' AS NumErr,
                    'Error en el alta de poliza' AS ErrMen,
                    'proveedorID' AS control,
                    Entero_Cero AS consecutivo;
                LEAVE TerminaStore;
            END IF;
    END IF;

    IF (Par_Salida = SalidaNO) THEN
        IF(Par_NumErr != Entero_Cero)THEN
            SET Par_NumErr := 100;
            SET Par_ErrMen := 'Error en el alta de poliza.';
        END IF;
    END IF;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT '000' AS NumErr,
          "Anticipo de Factura Agregado Correctamente." AS ErrMen,
             'noFactura' AS control,
            Var_Poliza AS consecutivo;
    END IF;
    IF (Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Anticipo de Factura Agregado Correctamente.';
    END IF;

END TerminaStore$$