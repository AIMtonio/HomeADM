-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACAJAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACAJAPRO`;DELIMITER $$

CREATE PROCEDURE `CONTACAJAPRO`(

    Par_NumeroMov           BIGINT,
    Par_FechaAplicacion     DATE,
    Par_CantidadMov         DECIMAL(12,2),
    Par_DescripcionMov      VARCHAR(150),
    Par_MonedaID            INT(11),

    Par_SucCliente          INT,
    Par_AltaEncPoliza       CHAR(1),
    Par_ConceptoCon         INT,
    INOUT Par_Poliza        BIGINT,
    Par_AltaDetPol          CHAR(1),

    Par_ConceptoCaja        INT,
    Par_NatConta            CHAR(1),
    Par_ReferDetPol         VARCHAR(200),
    Par_InstruDetPol        VARCHAR(20),
    Par_RemesaCatalogoID    INT,
    Par_TipoInstrumentoID   INT(11),


    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),

    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

        )
TerminaStore:BEGIN

    DECLARE     Salida_SI           CHAR(1);
    DECLARE     Salida_NO           CHAR(1);
    DECLARE     AltaEncabePoliza_SI CHAR(1);
    DECLARE     AltaDetPoliza_SI    CHAR(1);
    DECLARE     Pol_Automatica      CHAR(1);
    DECLARE     Nat_Cargo           CHAR(1);
    DECLARE     Decimal_Cero        DECIMAL(14,2);
    DECLARE     Entero_Cero         INT(11);


    DECLARE Var_Cargos              DECIMAL(14,2);
    DECLARE Var_Abonos              DECIMAL(14,2);


    SET Salida_NO           :='N';
    SET Salida_SI           :='S';
    SET AltaEncabePoliza_SI :='S';
    SET AltaDetPoliza_SI    :='S';
    SET Pol_Automatica      := 'A';
    SET Nat_Cargo           :='C';
    SET Decimal_Cero        :=0.0;
    SET Entero_Cero         :=0;

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr := 999;
                SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                     'esto le ocasiona. Ref: SP-CONTACAJAPRO');
            END;

        IF (Par_AltaEncPoliza = AltaEncabePoliza_SI) THEN
            CALL MAESTROPOLIZASALT(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Pol_Automatica,     Par_ConceptoCon,
                Par_DescripcionMov, Salida_NO,          Par_NumErr,             Par_ErrMen,         Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);
                IF(Par_NumErr>Entero_Cero) THEN
                    LEAVE ManejoErrores;
                END IF;
        END IF;

        IF(Par_AltaDetPol=AltaDetPoliza_SI)THEN
            IF(Par_NatConta = Nat_Cargo) THEN
                SET Var_Cargos  := Par_CantidadMov;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Par_CantidadMov;
            END IF;

            CALL POLIZACAJAPRO(
                Par_EmpresaID,      Par_Poliza,             Par_FechaAplicacion,    Par_ConceptoCaja,   Par_InstruDetPol,
                Par_MonedaID,       Var_Cargos,             Var_Abonos,             Par_DescripcionMov, Par_ReferDetPol,
                Par_SucCliente,     Par_RemesaCatalogoID,   Par_TipoInstrumentoID,  Salida_NO,          Par_NumErr,
                Par_ErrMen,         Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            IF(Par_NumErr>Entero_Cero) THEN
                    LEAVE ManejoErrores;
            END IF;
        END IF;

        SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := 'Informacion Procesada Exitosamente.';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                '' AS control,
                0 AS consecutivo;
    END IF;

END TerminaStore$$