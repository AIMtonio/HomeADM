-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORESCOBRAORDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTORESCOBRAORDCON`;DELIMITER $$

CREATE PROCEDURE `SEGTORESCOBRAORDCON`(
    Par_SegtoPrograID   INT(11),
    Par_SegtoRealizaID  INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Par_Empresa         INT(11),
    Par_Usuario         INT(11),
    Par_FechaActual     DATETIME,
    Par_DireccionIP     VARCHAR(15),
    Par_ProgramaID      VARCHAR(50),
    Par_SucursalID      INT(11),
    Par_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia     CHAR(1);
    DECLARE Entero_Cero      INT;
    DECLARE Fecha_Vacia      DATE;
    DECLARE Con_Principal    INT(11);

    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Fecha_Vacia         := '1900-01-01';
    SET Con_Principal       := 1;


    IF(Par_NumCon = Con_Principal) THEN
        SELECT  SegtoPrograID,  SegtoRealizaID, FechaPromPago,  MontoPromPago,      ExistFlujo,
                FechaEstFlujo,  OrigenPagoID,   MotivoNPID,     NombreOriRecursos,  TelefonoFijo,
                TelefonoCel
            FROM SEGTORESCOBRAORD Sep
            WHERE Sep.SegtoPrograID   = Par_SegtoPrograID
              AND Sep.SegtoRealizaID  = Par_SegtoRealizaID;
    END IF;

END TerminaStore$$