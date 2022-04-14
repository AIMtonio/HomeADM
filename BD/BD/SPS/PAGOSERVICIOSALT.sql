-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSERVICIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSERVICIOSALT`;
DELIMITER $$

CREATE PROCEDURE `PAGOSERVICIOSALT`(

    Par_CatalogoServID  INT(11),
    Par_SucursalID      INT(11),
    Par_CajaID      INT(11),
    Par_Fecha       DATE,
    Par_Referencia      VARCHAR(200),

    Par_SegundaRefe     VARCHAR(200),
    Par_MonedaID        INT(11),
    Par_MontoServicio   DECIMAL(14,2),
    Par_IvaServicio     DECIMAL(14,2),
    Par_Comision        DECIMAL(14,2),

    Par_IVAComision     DECIMAL(14,2),
    Par_Total           DECIMAL(14,2),
    Par_ClienteID       INT(11),
    Par_ProspectoID     BIGINT(20),
    Par_CreditoID       BIGINT(12),
    Par_OrigenPago      CHAR(1),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Fecha_Vacia     DATE;
DECLARE Salida_SI       CHAR(1);
DECLARE Var_NO          CHAR(1);

DECLARE Est_Activo      CHAR(1);
DECLARE EstO_Cerrado    CHAR(1);


DECLARE Var_SucursalCaja    INT;
DECLARE Var_EstatusCa       CHAR(1);
DECLARE Var_EstatusOpera    CHAR(1);
DECLARE Var_Consecutivo     INT(11);
DECLARE Var_ClienteID       INT(11);
DECLARE Var_ProspectoID     BIGINT(20);
DECLARE Var_CreditoID       BIGINT(12);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Salida_SI       := 'S';
SET Var_NO          := 'N';

SET Est_Activo      := 'A';
SET EstO_Cerrado    :='C';


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-PAGOSERVICIOSALT");
        END;
    IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT '001' AS NumErr,
                 'El numero de Sucursal esta Vacio.' AS ErrMen,
                 'sucursalID' AS control,
                 Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El numero de Sucursal esta Vacio.' ;
        END IF;
        LEAVE ManejoErrores;
    END IF;

    SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
    IF(IFNULL(Par_ClienteID, Entero_Cero)) >  Entero_Cero THEN
        SET Var_ClienteID := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID);
        IF(IFNULL(Var_ClienteID, Entero_Cero)) =  Entero_Cero THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '002' AS NumErr,
                     'El numero de cliente indicado no existe .' AS ErrMen,
                     'clienteID' AS control,
                     Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 2;
                SET Par_ErrMen := 'El numero de cliente indicado no existe .' ;
            END IF;
        LEAVE ManejoErrores;
        END IF;
    END IF;

    SET  Par_ProspectoID:= IFNULL(Par_ProspectoID, Entero_Cero);
    IF(IFNULL(Par_ProspectoID, Entero_Cero)) >  Entero_Cero THEN
        SET Var_ProspectoID := (SELECT ProspectoID FROM PROSPECTOS WHERE ProspectoID = Par_ProspectoID);
        IF(IFNULL(Var_ProspectoID, Entero_Cero)) =  Entero_Cero THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '002' AS NumErr,
                     'El numero de prospecto indicado no existe .' AS ErrMen,
                     'clienteID' AS control,
                     Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 2;
                SET Par_ErrMen := 'El numero de prospecto indicado no existe .' ;
            END IF;
        LEAVE ManejoErrores;
        END IF;
    END IF;

    SET  Par_CreditoID:= IFNULL(Par_CreditoID, Entero_Cero);
    IF(IFNULL(Par_CreditoID, Entero_Cero)) >  Entero_Cero THEN
        SELECT CreditoID, ClienteID INTO Var_CreditoID, Var_ClienteID
            FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

        IF(IFNULL(Var_CreditoID, Entero_Cero)) =  Entero_Cero THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '002' AS NumErr,
                     'El numero de credito indicado no existe .' AS ErrMen,
                     'clienteID' AS control,
                     Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 2;
                SET Par_ErrMen := 'El numero de credito indicado no existe .' ;
            END IF;
            LEAVE ManejoErrores;
        END IF;

        IF ( IFNULL(Var_ClienteID, Entero_Cero) !=  Par_ClienteID )THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '002' AS NumErr,
                     'El numero de Cliente indicado no corresponde con el numero de credito.' AS ErrMen,
                     'clienteID' AS control,
                     Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 2;
                SET Par_ErrMen := 'El numero de Cliente indicado no corresponde con el numero de credito.' ;
            END IF;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SET Par_CajaID := IFNULL(Par_CajaID, Entero_Cero);
    IF(IFNULL(Par_CajaID, Entero_Cero)) >  Entero_Cero THEN
        SELECT SucursalID, Estatus,EstatusOpera INTO Var_SucursalCaja, Var_EstatusCa, Var_EstatusOpera
                FROM CAJASVENTANILLA
                WHERE CajaID        =   Par_CajaID;

        IF(IFNULL(Var_SucursalCaja, Entero_Cero)) =  Entero_Cero THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '002' AS NumErr,
                     'El numero de caja indicado no existe .' AS ErrMen,
                     'cajaID' AS control,
                     Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 2;
                SET Par_ErrMen := 'El numero de caja indicado no existe .' ;
            END IF;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Var_EstatusOpera, Cadena_Vacia)) = EstO_Cerrado THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '011' AS NumErr,
                      'La Caja se encuentra Cerrada.' AS ErrMen,
                      'referencia' AS control,
                        Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 11;
                SET Par_ErrMen := 'La Caja se encuentra Cerrada.' ;
            END IF;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Var_EstatusCa, Cadena_Vacia)) <> Est_Activo THEN
            IF (Par_Salida = Salida_SI) THEN
                SELECT '012' AS NumErr,
                      'La Caja no se encuentra Activa.' AS ErrMen,
                      'referencia' AS control,
                        Entero_Cero AS consecutivo;
            ELSE
                SET Par_NumErr := 12;
                SET Par_ErrMen := 'La Caja no se encuentra Activa.' ;
            END IF;
            LEAVE ManejoErrores;
        END IF;

    END IF;

    IF(IFNULL(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT '003' AS NumErr,
                  'La fecha esta Vacia.' AS ErrMen,
                  'fecha' AS control,
                    Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'La fecha esta Vacia.' ;
        END IF;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT '006' AS NumErr,
                 'El numero de Moneda esta Vacio.' AS ErrMen,
                 'monedaID' AS control,
                 Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr := 6;
            SET Par_ErrMen := 'El numero de Moneda esta Vacio.' ;
        END IF;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT '010' AS NumErr,
                  'La Referencia esta vacia.' AS ErrMen,
                  'referencia' AS control,
                    Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr := 10;
            SET Par_ErrMen := 'La Referencia esta vacia.' ;
        END IF;
        LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual := CURRENT_TIMESTAMP();
    SET Var_Consecutivo := (SELECT IFNULL(MAX(PagoServicioID),Entero_Cero) + 1 FROM PAGOSERVICIOS);

    INSERT INTO PAGOSERVICIOS (
        PagoServicioID,     CatalogoServID,     SucursalID,         CajaID,             Fecha,
        Referencia,         SegundaRefe,        MonedaID,           MontoServicio,      IvaServicio,
        Comision,           IVAComision,        ClienteID,          ProspectoID,        CreditoID,
        Aplicado,           FolioDispersion,    OrigenPago,         EmpresaID,          Usuario,
        FechaActual,        DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion,
        Total
    )VALUES(
        Var_Consecutivo,    Par_CatalogoServID, Par_SucursalID,     Par_CajaID,         Par_Fecha,
        Par_Referencia,     Par_SegundaRefe,    Par_MonedaID,       Par_MontoServicio,  Par_IvaServicio,
        Par_Comision,       Par_IVAComision,    Par_ClienteID,      Par_ProspectoID,    Par_CreditoID,
        Var_NO,             Entero_Cero,        Par_OrigenPago,     Par_EmpresaID,      Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion,
        Par_Total
    );

    SET Par_NumErr := 0;
    SET Par_ErrMen := "Pago de Servicio Agregado";
END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'pagoServicioID' AS control,
        Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$