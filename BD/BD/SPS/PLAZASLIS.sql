-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZASLIS`;DELIMITER $$

CREATE PROCEDURE `PLAZASLIS`(
    Par_Nombre          VARCHAR(100),
    Par_NumLis          TINYINT UNSIGNED,
    Par_EmpresaID       INT(11),

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
    DECLARE Lis_Principal   INT(11);
    DECLARE Lis_Plazas      INT(11);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Lis_Principal   := 1;
    SET Lis_Plazas      := 3;

    IF(Par_NumLis = Lis_Principal) THEN
        SELECT  `PlazaID`,      `Nombre`,       `PlazaCLABE`
        FROM PLAZAS
        WHERE Nombre LIKE CONCAT("%", Par_Nombre, "%")
        LIMIT 0, 15;
    END IF;


    IF(Par_NumLis = Lis_Plazas) THEN
        SELECT  `PlazaID`,      `Nombre`
        FROM PLAZAS;
    END IF;

END TerminaStore$$