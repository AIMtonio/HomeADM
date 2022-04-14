-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOXPLAZASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOXPLAZASCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOXPLAZASCON`(
    Par_SeguimientoID   INT(11),
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
    DECLARE Entero_Cero     INT(11);
    DECLARE Con_Plazas      INT(11);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia    := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Con_Plazas         := 6;

    IF(Par_NumCon = Con_Plazas) THEN
        SELECT
            SeguimientoID,  PlazaID
        FROM SEGTOXPLAZAS
        WHERE SeguimientoID = Par_SeguimientoID;
    END IF;

END TerminaStore$$