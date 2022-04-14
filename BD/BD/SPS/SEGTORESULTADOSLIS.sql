-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORESULTADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTORESULTADOSLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTORESULTADOSLIS`(
    Par_Descripcion     VARCHAR(200),
    Par_Alcance         CHAR(1),
    Par_Estatus         CHAR(1),
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


    DECLARE     Lis_Principal       INT(11);
    DECLARE     Lis_SegtoResultados INT(11);


    SET Lis_Principal       := 1;
    SET Lis_SegtoResultados := 2;



    IF(Par_NumLis = Lis_Principal) THEN
        SELECT  ResultadoSegtoID,   Descripcion,    Alcance
            FROM    SEGTORESULTADOS;
    END IF;

    IF(Par_NumLis = Lis_SegtoResultados) THEN
        SELECT  ResultadoSegtoID,   Descripcion
            FROM    SEGTORESULTADOS
            WHERE Descripcion LIKE CONCAT("%",Par_Descripcion,"%") LIMIT 15;
    END IF;

END TerminaStore$$