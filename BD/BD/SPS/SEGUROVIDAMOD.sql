-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROVIDAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROVIDAMOD`;DELIMITER $$

CREATE PROCEDURE `SEGUROVIDAMOD`(
    Par_SeguroVidaID    INT(11),
    Par_CreditoID       BIGINT(12),
    Par_SolCreditoID    BIGINT(20),
    Par_FechaVenci      DATE,
    Par_Beneficiario    VARCHAR(200),
    Par_DireccionBen    VARCHAR(300),
    Par_TipoRelacionID  INT,
    Par_MontoPoliza     DECIMAL(12,2),
    Par_ForCobroSegVida CHAR(1),

    Par_Salida          CHAR(1),
OUT Par_NumErr          INT,
OUT Par_ErrMen          VARCHAR(200),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Var_SeguroVidaID    INT(11);
DECLARE Var_FecActual       DATE;
DECLARE Var_ClienteID       INT (11);
DECLARE Var_Control         VARCHAR(20);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE SalidaSI                CHAR(1);
DECLARE SalidaNO                CHAR(1);
DECLARE Seg_InActivo        CHAR(1);




SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Seg_InActivo    := 'I';


ManejoErrores: BEGIN


SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;
SET Par_CreditoID       := IFNULL(Par_CreditoID, Entero_Cero);
SET Par_SolCreditoID    := IFNULL(Par_SolCreditoID, Entero_Cero);
SET Par_SeguroVidaID    := IFNULL(Par_SeguroVidaID, Entero_Cero);

IF(Par_CreditoID > Entero_Cero) THEN
    SET Var_Control := 'creditoID';
ELSE
    SET Var_Control := 'solicitudCreditoID';
END IF;


SET Aud_FechaActual := CURRENT_TIMESTAMP();

SELECT FechaSucursal INTO Var_FecActual
    FROM SUCURSALES
    WHERE SucursalID = Aud_Sucursal;

SET Var_FecActual   := IFNULL(Var_FecActual, Fecha_Vacia);

IF(IFNULL(Par_FechaVenci, Fecha_Vacia)) = Fecha_Vacia THEN
    SET Par_NumErr  := 1;
    SET Par_ErrMen  := 'La Fecha de Vencimiento del Seguro esta Vacia';
    LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_FechaVenci, Fecha_Vacia)) = Fecha_Vacia THEN
    SET Par_NumErr  := 2;
    SET Par_ErrMen  := 'La Fecha de Inicio del Seguro esta Vacia';
    LEAVE ManejoErrores;
END IF;


IF (NOT EXISTS(SELECT Rel.Descripcion
                FROM TIPORELACIONES Rel
                WHERE TipoRelacionID =   Par_TipoRelacionID)  )  THEN

    SET Par_NumErr  := 3;
    SET Par_ErrMen  := 'La Relacion con el Beneficiario no es Valida.';


END IF;

IF (Par_CreditoID = Entero_Cero AND Par_SolCreditoID = Entero_Cero) THEN
    SET Par_NumErr  := 4;
    SET Par_ErrMen  := 'Favor de Especificar una Solicitud o un Credito Valido.';
    LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Beneficiario, Cadena_Vacia)) = Cadena_Vacia THEN
    SET Par_NumErr  := 5;
    SET Par_ErrMen  := 'Favor de Especificar el Nombre del Beneficiario del Seguro';
    LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_DireccionBen, Cadena_Vacia)) = Cadena_Vacia THEN
    SET Par_NumErr  := 6;
    SET Par_ErrMen  := 'Favor de Especificar la Direccion del Beneficiario del Seguro';
    LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_MontoPoliza, Entero_Cero)) = Entero_Cero THEN
    SET Par_NumErr  := 7;
    SET Par_ErrMen  := 'El monto de la Poliza en Caso de Fallecimiento es Incorrecto.';
    LEAVE ManejoErrores;
END IF;

IF( Par_SeguroVidaID != Entero_Cero) THEN
    UPDATE SEGUROVIDA SET
        FechaInicio = Var_FecActual,
        FechaVencimiento = Par_FechaVenci,
        Beneficiario    = Par_Beneficiario,
        DireccionBen    = Par_DireccionBen,
        TipoRelacionID  = Par_TipoRelacionID,
        MontoPoliza     = Par_MontoPoliza,
        ForCobroSegVida = Par_ForCobroSegVida,

        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

        WHERE SeguroVidaID = Par_SeguroVidaID;

ELSEIF (Par_SeguroVidaID = Entero_Cero AND Par_CreditoID != Entero_Cero) THEN

    UPDATE SEGUROVIDA SET
        FechaInicio = Var_FecActual,
        FechaVencimiento = Par_FechaVenci,
        Beneficiario    = Par_Beneficiario,
        DireccionBen    = Par_DireccionBen,
        TipoRelacionID  = Par_TipoRelacionID,
        MontoPoliza     = Par_MontoPoliza,
        ForCobroSegVida = Par_ForCobroSegVida,

        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

        WHERE CreditoID = Par_CreditoID;

ELSE

    IF EXISTS (SELECT SeguroVidaID
                FROM SEGUROVIDA
                WHERE SolicitudCreditoID = Par_SolCreditoID LIMIT 1) THEN
                    UPDATE SEGUROVIDA SET
                        FechaInicio = Var_FecActual,
                        FechaVencimiento = Par_FechaVenci,
                        Beneficiario    = Par_Beneficiario,
                        DireccionBen    = Par_DireccionBen,
                        TipoRelacionID  = Par_TipoRelacionID,
                        MontoPoliza     = Par_MontoPoliza,
                        ForCobroSegVida = Par_ForCobroSegVida,

                        Usuario         = Aud_Usuario,
                        FechaActual     = Aud_FechaActual,
                        DireccionIP     = Aud_DireccionIP,
                        ProgramaID      = Aud_ProgramaID,
                        Sucursal        = Aud_Sucursal,
                        NumTransaccion  = Aud_NumTransaccion
                    WHERE SolicitudCreditoID = Par_SolCreditoID;

        ELSE
                CALL FOLIOSAPLICAACT('SEGUROVIDA', Var_SeguroVidaID);
                SET Var_ClienteID  := (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCreditoID);
                INSERT INTO SEGUROVIDA  (
                SeguroVidaID,   ClienteID,          CuentaID,           CreditoID,      SolicitudCreditoID,
                FechaInicio,    FechaVencimiento,   Estatus,            Beneficiario,   DireccionBen,
                TipoRelacionID, MontoPoliza,        ForCobroSegVida,    EmpresaID,      Usuario,
                FechaActual,    DireccionIP,        ProgramaID,         Sucursal,       NumTransaccion  ) VALUES (

                Var_SeguroVidaID,   Var_ClienteID,      Entero_Cero,            Par_CreditoID,      Par_SolCreditoID,
                Var_FecActual,      Par_FechaVenci,     Seg_InActivo,           Par_Beneficiario,   Par_DireccionBen,
                Par_TipoRelacionID, Par_MontoPoliza,    Par_ForCobroSegVida,    Aud_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion  );

        END IF;

END IF;

SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := "Seguro de Vida Modifciado Exitosamente.";


END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control;
END IF;

END TerminaStore$$