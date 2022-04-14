-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROVIDACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROVIDACON`;DELIMITER $$

CREATE PROCEDURE `SEGUROVIDACON`(
    Par_SeguroVidaID    BIGINT,
    Par_SolCreditoID    BIGINT,
    Par_CreditoID       BIGINT(12),
    Par_CuentaAhoID     BIGINT,
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN




DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Con_Principal   INT;
DECLARE Con_AltaCredSol INT;



SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_Principal   := 1;
SET Con_AltaCredSol := 2;


IF(Par_NumCon = Con_Principal) THEN
    SELECT  Seg.SeguroVidaID,   Seg.ClienteID,          Seg.CuentaID,       Seg.CreditoID,      Seg.SolicitudCreditoID,
            Seg.FechaInicio,    Seg.FechaVencimiento,   Seg.Estatus,        Seg.Beneficiario,   Seg.DireccionBen,
            Seg.TipoRelacionID, Tir.Descripcion,        Seg.MontoPoliza,    Seg.ForCobroSegVida
        FROM SEGUROVIDA Seg,
             TIPORELACIONES Tir
        WHERE Seg.SeguroVidaID = Par_SeguroVidaID
          AND Seg.TipoRelacionID    = Tir.TipoRelacionID;

END IF;

IF(Par_NumCon = Con_AltaCredSol) THEN

    SET Par_SolCreditoID    := IFNULL(Par_SolCreditoID, Entero_Cero);
    SET Par_CreditoID    := IFNULL(Par_CreditoID, Entero_Cero);

    IF(Par_CreditoID != Entero_Cero) THEN
        SELECT  Seg.SeguroVidaID,   Seg.ClienteID,          Seg.CuentaID,       Seg.CreditoID,      Seg.SolicitudCreditoID,
                Seg.FechaInicio,    Seg.FechaVencimiento,   Seg.Estatus,        Seg.Beneficiario,   Seg.DireccionBen,
                Seg.TipoRelacionID, Tir.Descripcion,        Seg.MontoPoliza,    Seg.ForCobroSegVida
            FROM SEGUROVIDA Seg,
                 TIPORELACIONES Tir
            WHERE Seg.CreditoID = Par_CreditoID
              AND Seg.TipoRelacionID    = Tir.TipoRelacionID;
    ELSE

        SELECT  Seg.SeguroVidaID,   Seg.ClienteID,          Seg.CuentaID,       Seg.CreditoID,      Seg.SolicitudCreditoID,
                Seg.FechaInicio,    Seg.FechaVencimiento,   Seg.Estatus,        Seg.Beneficiario,   Seg.DireccionBen,
                Seg.TipoRelacionID, Tir.Descripcion,        Seg.MontoPoliza,    Seg.ForCobroSegVida
            FROM SEGUROVIDA Seg,
                 TIPORELACIONES Tir
            WHERE Seg.SolicitudCreditoID = Par_SolCreditoID
              AND Seg.TipoRelacionID    = Tir.TipoRelacionID;
    END IF;


END IF;


END TerminaStore$$