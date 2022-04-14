-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACLICANCELPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACLICANCELPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTACLICANCELPRO`(

    Par_CuentaAhoID         BIGINT(12),
    Par_ClienteID           INT(11),
    Par_Fecha               DATE,
    Par_CantidadMov         DECIMAL(12,2),
    Par_DescripcionMov      VARCHAR(150),

    Par_MonedaID            INT(11),
    Par_ReferenciaMov       VARCHAR(35),
    Par_SucCliente          INT(11),
    Par_AltaEncPoliza       CHAR(1),
    Par_ConceptoCon         INT(11),

    Par_NatMovOpeAho        CHAR(1),
    Par_NatContaAho         CHAR(1),
    Par_TipoMovAhoID        CHAR(4),
    Par_ConceptoAho         INT(11),
    Par_AltaAfecAho         CHAR(1),

    Par_AltaDetPol          CHAR(1),
    Par_TipoInstrumentoID   INT(11),
    Par_Instrumento         VARCHAR(20),
    Par_CuentaContable      VARCHAR(50),
    Par_Cargos              DECIMAL(14,4),

    Par_Abonos              DECIMAL(14,4),
    Par_CentroCostos        INT(11),
    Par_ContaCredito        CHAR(1),
    Par_CreditoID           BIGINT(12),
    Par_AmortiCreID         INT(4),

    Par_ProdCreditoID       INT(11),
    Par_Clasificacion       CHAR(1),
    Par_SubClasifica        INT(11),
    Par_AltaPolizaCre       CHAR(1),
    Par_AltaMovCre          CHAR(1),

    Par_ConcContaCre        INT(11),
    Par_TipoMovCre          INT(11),
    Par_NatCredito          CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    INOUT Par_Poliza        BIGINT,
    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),

    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE AltaPoliza_SI       CHAR(1);
DECLARE AltaEncPolizaNO     CHAR(1);
DECLARE AltaConta_SI        CHAR(1);
DECLARE Pol_Automatica      CHAR(1);
DECLARE EstatusActivo       CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Salida_NO           CHAR(1);
DECLARE Var_SI              CHAR(1);
DECLARE Var_NO              CHAR(1);
DECLARE Var_Procedimiento   VARCHAR(20);
DECLARE Var_Consecutivo     BIGINT(20);

DECLARE Var_Cargos      DECIMAL(12,2);
DECLARE Var_Abonos      DECIMAL(12,2);
DECLARE Var_CuentaStr   VARCHAR(20);
DECLARE Var_SucursalCli INT(11);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Var_SI              := 'S';
SET Var_NO              := 'N';
SET AltaPoliza_SI       := 'S';
SET AltaConta_SI        := 'S';
SET AltaEncPolizaNO     := 'N';
SET Pol_Automatica      := 'A';
SET EstatusActivo       := 'A';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Salida_NO           := 'N';
SET Var_Procedimiento   := 'CONTACLICANCELPRO';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP- CONTACLICANCELPRO');
        END;

IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
    CALL MAESTROPOLIZAALT(
        Par_Poliza,         Aud_EmpresaID,      Par_Fecha,              Pol_Automatica,     Par_ConceptoCon,
        Par_DescripcionMov, Salida_NO,          Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
END IF;
IF(Par_NumErr != Entero_Cero)THEN
    LEAVE TerminaStore;
END IF;


IF (Par_AltaAfecAho = Var_SI) THEN
    CALL CONTAAHORROPRO(
        Par_CuentaAhoID,    Par_ClienteID,      Aud_NumTransaccion,     Par_Fecha,          Par_Fecha,
        Par_NatMovOpeAho,   Par_CantidadMov,    Par_DescripcionMov,     Par_ReferenciaMov,  Par_TipoMovAhoID,
        Par_MonedaID,       Par_SucCliente,     AltaEncPolizaNO,        Par_ConceptoCon,    Par_Poliza,
        AltaPoliza_SI,      Par_ConceptoAho,    Par_NatContaAho,        Par_NumErr,         Par_ErrMen,
        Entero_Cero,        Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
END IF;
IF(Par_NumErr != Entero_Cero)THEN
    LEAVE TerminaStore;
END IF;


IF (Par_ContaCredito = Var_SI) THEN
    CALL CONTACREDITOPRO(
        Par_CreditoID,      Par_AmortiCreID,    Par_CuentaAhoID,        Par_ClienteID,      Par_Fecha,
        Par_Fecha,          Par_CantidadMov,    Par_MonedaID,           Par_ProdCreditoID,  Par_Clasificacion,
        Par_SubClasifica,   Par_SucCliente,     Par_DescripcionMov,     Par_ReferenciaMov,  AltaEncPolizaNO,
        Par_ConceptoCon,    Par_Poliza,         Par_AltaPolizaCre,      Par_AltaMovCre,     Par_ConcContaCre,
        Par_TipoMovCre,     Par_NatCredito,     Var_NO,                 Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Var_NO,*/             Par_NumErr,             Par_ErrMen,         Var_Consecutivo,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
        Aud_EmpresaID,      Cadena_Vacia,       Aud_NumTransaccion);
END IF;

IF(Par_NumErr != Entero_Cero)THEN
    LEAVE TerminaStore;
END IF;


IF (Par_AltaDetPol = Var_SI) THEN
    CALL DETALLEPOLIZAALT(
        Aud_EmpresaID,      Par_Poliza,         Par_Fecha,              Par_CentroCostos,   Par_CuentaContable,
        Par_Instrumento,    Par_MonedaID,       Par_Cargos,             Par_Abonos,         Par_DescripcionMov,
        Par_ReferenciaMov,  Var_Procedimiento,  Par_TipoInstrumentoID,  Cadena_Vacia,       Decimal_Cero,
        Cadena_Vacia,       Salida_NO,          Par_NumErr,             Par_ErrMen,         Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);
END IF;

END ManejoErrores;

END TerminaStore$$