-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCURACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCURACT`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSUCURACT`(
    Par_NumReqGasID         INT(11),
    Par_SucursalID          INT(11),
    Par_UsuarioID           INT(11),
    Par_FechRequisicion     DATE,
    Par_FormaPago           CHAR(1),

    Par_CuentaDepositar     BIGINT(12),
    Par_EstatusReq          CHAR(1),
    Par_TipoGasto           CHAR(1),
    Par_NumAct              INT,
    Par_Salida              CHAR(1),

    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(20),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Entero_Cero         INT(1);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Act_Principal       INT;
DECLARE Var_Efectivo        CHAR(1);
DECLARE Var_NumMovReq       INT;
DECLARE Est_Pendiente       CHAR(1);
DECLARE Est_Finalizado      CHAR(1);
DECLARE Est_Cancelado       CHAR(1);
DECLARE Var_Estatus         CHAR(1);
DECLARE Est_Autorizado      CHAR(1);


SET Entero_Cero             := 0;
SET Cadena_Vacia            := '';
SET Var_Efectivo            := 'E';
SET Est_Autorizado          := 'A';
SET Est_Pendiente           := 'P';
SET Est_Finalizado          := 'F';
SET Est_Cancelado           := 'C';
SET Act_Principal           := 1;
SET Aud_FechaActual         := NOW();

IF(Act_Principal = Par_NumAct)THEN
    SET Var_NumMovReq := (SELECT  COUNT(*)
                        FROM REQGASTOSUCURMOV
                        WHERE NumReqGasID = Par_NumReqGasID
                        AND Estatus         <> Est_Cancelado);

    IF( IFNULL(Var_NumMovReq, Entero_Cero) = Entero_Cero) THEN
        SET Var_Estatus := Est_Cancelado;
    ELSE
        SET Var_NumMovReq := (SELECT  COUNT(*)
                        FROM REQGASTOSUCURMOV
                        WHERE NumReqGasID   = Par_NumReqGasID
                        AND Estatus         = Est_Pendiente);
        IF( IFNULL(Var_NumMovReq, Entero_Cero) = Entero_Cero) THEN
            SET Var_Estatus := Est_Finalizado;
        ELSE
            SET Var_Estatus := Par_EstatusReq;
        END IF;
    END IF;

    UPDATE REQGASTOSUCUR SET
        FormaPago       = Par_FormaPago,
        EstatusReq      = Var_Estatus,
        TipoGasto       = Par_TipoGasto,
        EmpresaID       = Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
    WHERE NumReqGasID   = Par_NumReqGasID
     AND SucursalID     = Par_SucursalID;
END IF;

SELECT '000' AS NumErr,
    CONCAT("Requisicion de Gastos Actualizada: ", CONVERT(Par_NumReqGasID, CHAR))  AS ErrMen,
    'numReqGasID' AS control,
    Par_NumReqGasID AS consecutivo;

END TerminaStore$$