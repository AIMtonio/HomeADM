-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCLASIFCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOCLASIFCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOCLASIFCON`(
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
    DECLARE Con_Clasifica   INT(11);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Con_Clasifica   := 5;

    IF(Par_NumCon = Con_Clasifica ) THEN
        SELECT CampoClasificacion, OrdenClasificacion
        FROM SEGTOCLASIFSEGTO
        WHERE SeguimientoID = Par_SeguimientoID;
    END IF;

END TerminaStore$$