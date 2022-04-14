-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSLIS`;DELIMITER $$

CREATE PROCEDURE `PUESTOSLIS`(
    Par_ClavePuestoID       VARCHAR(10),
    Par_Descripcion         VARCHAR(100),
    Par_NumLis              TINYINT UNSIGNED,

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT(11);
    DECLARE Lis_Principal       INT(11);
    DECLARE EstatusActivo       CHAR(1);
    DECLARE Lis_Ejecutivo       INT(11);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Lis_Principal       := 1;
    SET EstatusActivo       :='A';
    SET Lis_Ejecutivo       := 4;

    IF(Par_NumLis = Lis_Principal) THEN

        SELECT DISTINCT DES.ClavePuestoID, DES.Descripcion
            FROM PUESTOS DES
            WHERE DES.Descripcion   LIKE    CONCAT("%", Par_Descripcion, "%")
            AND Estatus='V'
            LIMIT 0, 15;
    END IF;


    IF(Par_NumLis = Lis_Ejecutivo) THEN
         SELECT DISTINCT DES.ClavePuestoID, DES.Descripcion
            FROM PUESTOS DES
            WHERE Estatus='V' AND EsGestor = 'S';
    END IF;

END TerminaStore$$