-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOREALIZADOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOREALIZADOSCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOREALIZADOSCON`(
    Par_SegtoPrograID   INT(11),
    Par_SegtoRealizaID  INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE     Cadena_Vacia        CHAR(1);
    DECLARE     Fecha_Vacia     DATE;
    DECLARE     Entero_Cero     INT;
    DECLARE     Con_Principal       INT;
    DECLARE     Con_Estatus     INT;

    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Con_Principal   := 1;
    SET Con_Estatus     := 3;

    IF(Par_NumCon = Con_Principal) THEN
        SELECT
            SegtoPrograID,      SegtoRealizaID,     UsuarioSegto,       FechaSegto,             HoraCaptura,
            TipoContacto,       NombreContacto,     ClienteEnterado,    FechaCaptura,           Comentario,
            ResultadoSegtoID,   FechaSegtoFor,      HoraSegtoFor,       RecomendacionSegtoID,   SegdaRecomendaSegtoID,
            Estatus,            TelefonFijo,        TelefonCel
        FROM SEGTOREALIZADOS
            WHERE SegtoPrograID = Par_SegtoPrograID
            AND SegtoRealizaID  = Par_SegtoRealizaID;
    END IF;

    IF(Par_NumCon = Con_Estatus) THEN
        SELECT SegtoRealizaID,  Estatus  FROM SEGTOREALIZADOS
            WHERE SegtoPrograID = Par_SegtoPrograID ORDER BY SegtoRealizaID DESC LIMIT 1;
    END IF;

END TerminaStore$$