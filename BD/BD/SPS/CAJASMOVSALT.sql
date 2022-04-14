-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASMOVSALT`;DELIMITER $$

CREATE PROCEDURE `CAJASMOVSALT`(



    Par_SucursalID      INT(11),
    Par_CajaID          INT(11),
    Par_Fecha           DATE,
    Par_Transaccion     BIGINT(20),
    Par_MonedaID        INT(11),

    Par_MontoEnFir      DECIMAL(14,2),
    Par_MontoSBC        DECIMAL(14,2),
    Par_TipoOpe         INT(11),
    Par_Instrumento     BIGINT(20),
    Par_Referencia      VARCHAR(200),

    Par_Comision        DECIMAL(14,2),
    Par_IVAComision     DECIMAL(14,2),

    Par_Salida          CHAR(1),
    INOUT   Par_NumErr  INT(11),
    INOUT   Par_ErrMen  VARCHAR(400),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

    )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Bigint_Vacio        BIGINT(20);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Est_Activo          CHAR(1);
    DECLARE EstO_Cerrado        CHAR(1);


    DECLARE Var_Consecutivo     INT(11);
    DECLARE Var_SucursalCaja    INT;
    DECLARE Var_EstatusCa       CHAR(1);
    DECLARE Var_EstatusOpera    CHAR(1);
    DECLARE Var_Control         VARCHAR(100);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.0;
    SET Bigint_Vacio    := 0;
    SET Salida_SI       := 'S';
    SET Est_Activo      := 'A';
    SET EstO_Cerrado    := 'C';

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CAJASMOVSALT');
                SET Var_Control = 'sqlException';
            END;

        IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El numero de Sucursal esta Vacio.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 2;
            SET Par_ErrMen := 'El numero de caja esta vacio.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'La fecha esta Vacia.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Transaccion, Bigint_Vacio)) = Bigint_Vacio THEN
            SET Par_NumErr := 4;
            SET Par_ErrMen := 'La transaccion esta Vacia.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 6;
            SET Par_ErrMen := 'El numero de Moneda esta Vacio.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoEnFir, Decimal_Cero))= Decimal_Cero
        AND (IFNULL(Par_MontoSBC, Decimal_Cero))= Decimal_Cero  THEN
            SET Par_NumErr := 6;
            SET Par_ErrMen := 'El Monto esta Vacio.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_TipoOpe, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 8;
            SET Par_ErrMen := 'El Tipo de Operacion esta vacio.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Instrumento, Bigint_Vacio)) = Bigint_Vacio THEN
            SET Par_NumErr := 9;
            SET Par_ErrMen := 'El Instrumento esta Vacio.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr := 10;
            SET Par_ErrMen := 'La Referencia esta vacia.' ;
            LEAVE ManejoErrores;
        END IF;


        SELECT SucursalID, Estatus, EstatusOpera
          INTO Var_SucursalCaja, Var_EstatusCa, Var_EstatusOpera
          FROM  CAJASVENTANILLA
         WHERE  CajaID = Par_CajaID;

        IF(IFNULL(Var_EstatusOpera, Cadena_Vacia)) = EstO_Cerrado THEN
            SET Par_NumErr := 11;
            SET Par_ErrMen := 'La Caja se encuentra Cerrada.' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Var_EstatusCa, Cadena_Vacia)) <> Est_Activo THEN
            SET Par_NumErr := 12;
            SET Par_ErrMen := 'La Caja no se encuentra Activa.' ;
            LEAVE ManejoErrores;
        END IF;


        SET Aud_FechaActual := NOW();

        SET Var_Consecutivo := (SELECT IFNULL(COUNT(*),0) + 1
                                  FROM CAJASMOVS
                                 WHERE Transaccion = Par_Transaccion);

        INSERT INTO CAJASMOVS (
            SucursalID,         CajaID,             Fecha,              Transaccion,            Consecutivo,
            MonedaID,           MontoEnFirme,       MontoSBC,           TipoOperacion,          Instrumento,
            Referencia,         Comision,           IVAComision,        EmpresaID,              Usuario,
            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,               NumTransaccion)
        VALUES (
            Var_SucursalCaja,   Par_CajaID,         Par_Fecha,          Par_Transaccion,        Var_Consecutivo,
            Par_MonedaID,       Par_MontoEnFir,     Par_MontoSBC,       Par_TipoOpe,            Par_Instrumento,
            Par_Referencia,     Par_Comision,       Par_IVAComision,    Aud_EmpresaID,          Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Movimiento Realizado Correctamente';

    END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  Par_NumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'cajaID' AS control,
                    (SELECT LPAD(Entero_Cero, 10, 0)) AS consecutivo;
        END IF;

END TerminaStore$$