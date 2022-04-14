-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOPAGOCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOPAGOCREALT`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOPAGOCREALT`(
    Par_FechaRegistro   DATE,
    Par_Transaccion     BIGINT(20),
    Par_Consecutivo     BIGINT(20),
    Par_CreditoID       BIGINT(12),
    Par_ClienteID       INT,

    Par_MontoDeposito   DECIMAL(12,2),
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
            )
TerminaStore: BEGIN


SET Aud_FechaActual := NOW();

INSERT INTO DEPOSITOPAGOCRE(
    FechaRegistro,      Transaccion,        Consecutivo,        CreditoID,          ClienteID,
    MontoDeposito,      EmpresaID,          Usuario,            FechaActual,        DireccionIP,
    ProgramaID,         Sucursal,           NumTransaccion)
VALUES(
    Par_FechaRegistro,  Par_Transaccion,    Par_Consecutivo,    Par_CreditoID,      Par_ClienteID,
    Par_MontoDeposito,  Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

END TerminaStore$$