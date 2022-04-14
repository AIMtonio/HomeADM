-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOFORMDESPROYCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOFORMDESPROYCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOFORMDESPROYCON`(
    Par_SegtoPrograID   INT(11),
    Par_SegtoRealizaID  INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_Empresa         INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_SucursalID      INT(11) ,
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN





    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT(11);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Con_Principal       INT(11);

    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Fecha_Vacia         := '1900-01-01';
    SET Con_Principal       := 1;


    IF(Par_NumCon = Con_Principal) THEN
        SELECT
            `SegtoPrograID`,    `SegtoRealizaID`,   `AsistenciaGpo`,    `AvanceProy`,           `MontoEstProd`,
            `UnidEstProd`,      `PrecioEstUni`,     `MontoEspVtas`,     `FechaComercializa`,    `ReconoceAdeudo`,
            `ConoceMtosFechas`, `TelefonoFijo`,     `TelefonoCel`
            FROM SEGTOFORMDESPROY Seg
            WHERE Seg.SegtoPrograID = Par_SegtoPrograID
            AND Seg.SegtoRealizaID  = Par_SegtoRealizaID;
    END IF;

END TerminaStore$$