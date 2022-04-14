-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EFECTIVOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EFECTIVOMOVALT`;DELIMITER $$

CREATE PROCEDURE `EFECTIVOMOVALT`(

    Par_CuentaAhoID         BIGINT(12),
    Par_NumeroMov           BIGINT(20),
    Par_Fecha               DATE,
    Par_NatMovimiento       CHAR(1),
    Par_CantidadMov         DECIMAL(12,2),

    Par_DescripcionMov      VARCHAR(150),
    Par_ReferenciaMov       VARCHAR(50),
    Par_TipoMovAhoID        CHAR(4),
    Par_MonedaID            INT,
    Par_ClienteID           INT,

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


    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Consecutivo     VARCHAR(20);


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE Nat_Abono           CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Fecha               DATE;
    DECLARE No_Considerado      CHAR(1);
    DECLARE Salida_SI           CHAR(1);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Nat_Cargo           := 'C';
    SET Nat_Abono           := 'A';
    SET No_Considerado      := 'N';
    SET Salida_SI           := 'S';

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-EFECTIVOMOVALT');
            SET Var_Consecutivo := Entero_Cero;
            SET Var_Control := 'sqlException' ;
        END;

        SET Aud_FechaActual := NOW();

        INSERT EFECTIVOMOVS (
                CuentasAhoID,           ClienteID,              NumeroMov,          Fecha,              NatMovimiento,
                CantidadMov,            DescripcionMov,         ReferenciaMov,      TipoMovAhoID,       MonedaID,
                Estatus,                EmpresaID,              Usuario,            FechaActual,        DireccionIP,
                ProgramaID,             Sucursal,               NumTransaccion)
            VALUES(
                Par_CuentaAhoID,        Par_ClienteID,          Aud_NumTransaccion,     Par_Fecha,          Par_NatMovimiento,
                Par_CantidadMov,        Par_DescripcionMov,     Par_ReferenciaMov,      Par_TipoMovAhoID,   Par_MonedaID,
                No_Considerado,         Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Agregado Exitosamente el Movimiento de Efectivo.');
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