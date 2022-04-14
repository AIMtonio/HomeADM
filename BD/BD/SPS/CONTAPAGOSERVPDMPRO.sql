-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAPAGOSERVPDMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAPAGOSERVPDMPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTAPAGOSERVPDMPRO`(



    Par_CatalogoServID  INT(11),
    Par_PagoServicioID  INT(11),
    Par_SucursalID      INT(11),
    Par_CajaID          INT(11),
    Par_Fecha           DATE,

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
    Par_AltaPagoServ    CHAR(1),
    Par_AltaEncPol      CHAR(1),
    Par_AltaDetPol      CHAR(1),

    Par_NatDetPol       CHAR(1),
    Par_OrigenPago      CHAR(1),
    INOUT Par_Poliza    BIGINT(20),

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


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Salida_SI           CHAR(1);
    DECLARE Var_SI              CHAR(1);
    DECLARE Salida_NO           CHAR(1);
    DECLARE AltaPagoServ_Si     CHAR(1);
    DECLARE AltaEncPol_Si       CHAR(1);
    DECLARE AltaDetPol_Si       CHAR(1);
    DECLARE AltaMovsTeso_Si     CHAR(1);
    DECLARE Est_Activo          CHAR(1);
    DECLARE Pol_Automatica      CHAR(1);
    DECLARE Var_ConceptoConID   INT(11);
    DECLARE Var_Tercero         CHAR(1);
    DECLARE Var_Interno         CHAR(1);
    DECLARE Conciliado_NO       CHAR(1);
    DECLARE Reg_Automatico      CHAR(1);
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE TipoInstrumentoID   INT(11);
    DECLARE For_SucOrigen       CHAR(3);
    DECLARE For_SucCliente      CHAR(3);


    DECLARE Var_SucursalCaja        INT;
    DECLARE Var_EstatusCa           CHAR(1);
    DECLARE Var_EstatusOpera        CHAR(1);
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_Descripcion         VARCHAR(150);
    DECLARE Var_ConceptoConDes      VARCHAR(150);
    DECLARE Var_NombreServicio      VARCHAR(50);
    DECLARE Procedimiento           VARCHAR(30);
    DECLARE Var_Origen              CHAR(1);
    DECLARE Var_CobraComision       CHAR(1);
    DECLARE Var_MontoComision       DECIMAL(14,2);
    DECLARE Var_CtaContaCom         VARCHAR(25);
    DECLARE Var_CtaContaIVACom      VARCHAR(25);
    DECLARE Var_CtaPagarProv        VARCHAR(25);
    DECLARE Var_MontoServicio       DECIMAL(14,2);
    DECLARE Var_CtaContaServ        VARCHAR(25);
    DECLARE Var_CtaContaIVAServ     VARCHAR(25);
    DECLARE Var_CuentaConta         VARCHAR(25);
    DECLARE Var_CuentaContaIva      VARCHAR(25);
    DECLARE Var_CuentaContaProv     VARCHAR(25);
    DECLARE Var_Cargos              DECIMAL(14,4);
    DECLARE Var_Abonos              DECIMAL(14,4);
    DECLARE Var_CtaContaBan         VARCHAR(15);
    DECLARE Var_CuentaAhoID         BIGINT(12);
    DECLARE Var_CentroCosto         INT;
    DECLARE Var_NumErrChar          CHAR(3);
    DECLARE Var_MontoCargo          DECIMAL(12,4);
    DECLARE Var_MontoAbono          DECIMAL(12,4);
    DECLARE Var_ServReactivaCte     INT;
    DECLARE Var_MonTotalReactivaCli DECIMAL(14,2);
    DECLARE Var_CCostosServicio     VARCHAR(30);
    DECLARE Var_CentroCostosID      INT(11);
    DECLARE Var_ClienteID           INT(11);
    DECLARE Var_SucCliente          INT(11);
    DECLARE Var_Control             VARCHAR(100);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET Var_SI              := 'S';
    SET Salida_SI           := 'S';
    SET AltaDetPol_Si       := 'S';
    SET AltaEncPol_Si       := 'S';
    SET AltaPagoServ_Si     := 'S';
    SET AltaMovsTeso_Si     := 'S';
    SET Conciliado_NO       := 'N';
    SET Salida_NO           := 'N';
    SET Pol_Automatica      := 'A';
    SET Var_ConceptoConID   := 500;
    SET Procedimiento       := 'CONTAPAGOSERVPDMPRO';
    SET Var_Tercero         := 'T';
    SET Var_Interno         := 'I';
    SET Reg_Automatico      := 'A';
    SET Nat_Cargo           := 'C';
    SET TipoInstrumentoID   := 8;


    SET Var_Descripcion     := 'PAGO DE SERVICIOS-';
    SET For_SucOrigen       := '&SO';
    SET For_SucCliente      := '&SC';
    SET Var_CentroCostosID  := 0;

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                         'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAPAGOSERVPDMPRO');
                SET Var_Control = 'sqlException';
            END;


        IF(Par_AltaPagoServ = AltaPagoServ_Si) THEN
            CALL PAGOSERVICIOSALT(
                Par_CatalogoServID,     Par_SucursalID,     Par_CajaID,         Par_Fecha,      Par_Referencia,
                Par_SegundaRefe,        Par_MonedaID,       Par_MontoServicio,  Par_IvaServicio,Par_Comision,
                Par_IVAComision,        Par_Total,          Par_ClienteID,      Par_ProspectoID,Par_CreditoID,
                Par_OrigenPago,         Salida_NO,          Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
                Aud_NumTransaccion);

            IF (Par_NumErr != Entero_Cero) THEN
                SET Var_Control     := 'catalogoServID';
                SET Var_Consecutivo := Entero_Cero;
                LEAVE ManejoErrores;
            END IF;
        END IF;



        IF (Par_AltaEncPol = AltaEncPol_Si) THEN

            SET  Var_ConceptoConDes := (SELECT Descripcion
                                          FROM CONCEPTOSCONTA
                                         WHERE ConceptoContaID = Var_ConceptoConID);
            CALL MAESTROPOLIZASALT(
                Par_Poliza,         Par_EmpresaID,      Par_Fecha,          Pol_Automatica,     Var_ConceptoConID,
                Var_ConceptoConDes, Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            IF (Par_NumErr != Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;



        IF(Par_AltaDetPol = AltaDetPol_Si) THEN
            SELECT  NombreServicio,     Origen,             CobraComision,      MontoComision,      CtaContaCom,
                    CtaContaIVACom,     CtaPagarProv,       MontoServicio,      CtaContaServ,       CtaContaIVAServ,
                    CCostosServicio
            INTO    Var_NombreServicio, Var_Origen,         Var_CobraComision,  Var_MontoComision,  Var_CtaContaCom,
                    Var_CtaContaIVACom, Var_CtaPagarProv,   Var_MontoServicio,  Var_CtaContaServ,   Var_CtaContaIVAServ,
                    Var_CCostosServicio
                FROM CATALOGOSERV
                WHERE   CatalogoServID  = Par_CatalogoServID;

            SET Var_Descripcion     := CONCAT(Var_Descripcion,Var_NombreServicio);
            SET Var_CCostosServicio := IFNULL(Var_CCostosServicio, Cadena_Vacia);



            IF LOCATE(For_SucOrigen, Var_CCostosServicio) > 0 THEN
                SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
            ELSE
                IF LOCATE(For_SucCliente, Var_CCostosServicio) > 0 THEN
                    SET Var_SucCliente := (SELECT SucursalOrigen
                                             FROM CLIENTES
                                            WHERE ClienteID = Par_ClienteID);
                    IF (Var_SucCliente > 0) THEN
                        SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
                    ELSE
                        SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
                    END IF;
                ELSE
                    SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
                END IF;
            END IF;

            IF(Var_Origen = Var_Tercero ) THEN

                IF(Var_CobraComision = Var_SI ) THEN
                    IF(Par_Comision > Decimal_Cero) THEN
                        SET Var_CuentaConta     := Var_CtaContaCom;

                        IF(Par_NatDetPol = Nat_Cargo) THEN
                            SET Var_Cargos  := Par_Comision;
                            SET Var_Abonos  := Decimal_Cero;
                        ELSE
                            SET Var_Cargos  := Decimal_Cero;
                            SET Var_Abonos  := Par_Comision;
                        END IF;


                        CALL DETALLEPOLIZASALT(
                            Par_EmpresaID,          Par_Poliza,         Par_Fecha,          Var_CentroCostosID,     Var_CuentaConta,
                            Par_CatalogoServID,     Par_MonedaID,       Var_Cargos,         Var_Abonos,         Var_Descripcion,
                            Par_Referencia,         Procedimiento,      TipoInstrumentoID,  Cadena_Vacia,       Entero_Cero,
                            Cadena_Vacia,           Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
                            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                        IF (Par_NumErr != Entero_Cero) THEN
                            LEAVE ManejoErrores;
                        END IF;
                    ELSE
                        IF(Par_IVAComision > Decimal_Cero) THEN
                            SET Var_CuentaContaIva  := Var_CtaContaIVACom;

                            IF(Par_NatDetPol    = Nat_Cargo) THEN
                                SET Var_Cargos  := Par_IVAComision;
                                SET Var_Abonos  := Decimal_Cero;
                            ELSE
                                SET Var_Cargos  := Decimal_Cero;
                                SET Var_Abonos  := Par_IVAComision;
                            END IF;


                            CALL DETALLEPOLIZASALT(
                                Par_EmpresaID,          Par_Poliza,         Par_Fecha,          Var_CentroCostosID,       Var_CuentaContaIva,
                                Par_CatalogoServID,     Par_MonedaID,       Var_Cargos,         Var_Abonos,         Var_Descripcion,
                                Par_Referencia,         Procedimiento,      TipoInstrumentoID,  Cadena_Vacia,       Entero_Cero,
                                Cadena_Vacia,           Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
                                Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                            IF (Par_NumErr != Entero_Cero) THEN
                                LEAVE ManejoErrores;
                            END IF;
                        END IF;
                    END IF;
                END IF;

                IF (Par_MontoServicio > Decimal_Cero) THEN
                    IF(IFNULL(Par_MontoServicio, Decimal_Cero))= Decimal_Cero THEN
                        SET Par_NumErr      := 001;
                        SET Par_ErrMen      := 'El Monto del Servicio esta Vacio.';
                        SET Var_Control     := 'comision';
                        SET Var_Consecutivo := Entero_Cero;
                        LEAVE ManejoErrores;
                    END IF;

                    SET Var_CuentaContaProv := Var_CtaPagarProv;
                    IF(Par_NatDetPol    = Nat_Cargo) THEN
                        SET Var_Cargos  := Par_MontoServicio;
                        SET Var_Abonos  := Decimal_Cero;
                    ELSE
                        SET Var_Cargos  := Decimal_Cero;
                        SET Var_Abonos  := Par_MontoServicio;
                    END IF;


                    CALL DETALLEPOLIZASALT(
                        Par_EmpresaID,          Par_Poliza,         Par_Fecha,          Var_CentroCostosID,       Var_CuentaContaProv,
                        Par_CatalogoServID,     Par_MonedaID,       Var_Cargos,         Var_Abonos,         Var_Descripcion,
                        Par_Referencia,         Procedimiento,      TipoInstrumentoID,  Cadena_Vacia,       Entero_Cero,
                        Cadena_Vacia,           Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
                        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr != Entero_Cero) THEN
                        LEAVE ManejoErrores;
                    END IF;
                END IF;
            ELSE
                IF (Par_MontoServicio > Decimal_Cero) THEN
                    IF(IFNULL(Par_MontoServicio, Decimal_Cero))= Decimal_Cero THEN
                        SET Par_NumErr      := 001;
                        SET Par_ErrMen      := 'El Monto del Servicio esta Vacio.';
                        SET Var_Control     := 'comision';
                        SET Var_Consecutivo := Entero_Cero;
                        LEAVE ManejoErrores;
                    END IF;

                    SET Var_CuentaConta     := Var_CtaContaServ;

                    IF(Par_NatDetPol    = Nat_Cargo) THEN
                        SET Var_Cargos  := Par_MontoServicio;
                        SET Var_Abonos  := Entero_Cero;
                    ELSE
                        SET Var_Cargos  := Entero_Cero;
                        SET Var_Abonos  := Par_MontoServicio;
                    END IF;


                    CALL DETALLEPOLIZASALT(
                        Par_EmpresaID,          Par_Poliza,         Par_Fecha,          Var_CentroCostosID,       Var_CuentaConta,
                        Par_CatalogoServID,     Par_MonedaID,       Var_Cargos,         Var_Abonos,         Var_Descripcion,
                        Par_Referencia,         Procedimiento,      TipoInstrumentoID,  Cadena_Vacia,       Entero_Cero,
                        Cadena_Vacia,           Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
                        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr != Entero_Cero) THEN
                        LEAVE ManejoErrores;
                    END IF;
                END IF;


                IF(Par_IvaServicio > Decimal_Cero) THEN

                    SET Var_CuentaContaIva  := Var_CtaContaIVAServ;

                    IF(Par_NatDetPol = Nat_Cargo) THEN
                        SET Var_Cargos  := Par_IvaServicio;
                        SET Var_Abonos  := Entero_Cero;
                    ELSE
                        SET Var_Cargos  := Entero_Cero;
                        SET Var_Abonos  := Par_IvaServicio;
                    END IF;


                    CALL DETALLEPOLIZASALT(
                        Par_EmpresaID,          Par_Poliza,         Par_Fecha,          Var_CentroCostosID,       Var_CuentaContaIva,
                        Par_CatalogoServID,     Par_MonedaID,       Var_Cargos,         Var_Abonos,         Var_Descripcion,
                        Par_Referencia,         Procedimiento,      TipoInstrumentoID,  Cadena_Vacia,       Entero_Cero,
                        Cadena_Vacia,           Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
                        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr != Entero_Cero) THEN
                        LEAVE ManejoErrores;
                    END IF;
                END IF;
            END IF;
        END IF;

        SET Par_NumErr      := 000;
        SET Par_ErrMen      := 'Movimientos Realizados.';
        SET Var_Consecutivo := Par_Poliza;

    END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  Par_NumErr      AS NumErr,
                    Par_ErrMen      AS ErrMen,
                    Var_Control     AS control,
                    Var_Consecutivo AS consecutivo;
        END IF;

END TerminaStore$$