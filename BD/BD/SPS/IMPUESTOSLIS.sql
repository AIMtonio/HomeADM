-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPUESTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `IMPUESTOSLIS`;DELIMITER $$

CREATE PROCEDURE `IMPUESTOSLIS`(

    Par_ImpuestoID      INT(11),
    Par_Descripcion     VARCHAR(50),
    Par_NumLis          TINYINT UNSIGNED,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(20),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN

DECLARE     Cadena_Vacia    CHAR(1);
DECLARE     Fecha_Vacia     DATE;
DECLARE     Entero_Cero     INT;
DECLARE     Lis_Principal   INT;
DECLARE     Lis_Tasa        INT;
DECLARE     Lis_Combo       INT;
DECLARE     EstatusActivo   CHAR(1);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Lis_Principal   := 1;
SET Lis_Tasa        := 2;
SET Lis_Combo       := 3;
SET EstatusActivo   :='A';

IF(Par_NumLis = Lis_Principal) THEN

    SELECT DISTINCT DES.ImpuestoID, DES.Descripcion, DES.DescripCorta
        FROM IMPUESTOS DES
        WHERE DES.Descripcion LIKE concat("%", Par_Descripcion, "%")
        LIMIT 0, 15;

END IF;

IF(Par_NumLis = Lis_Tasa) THEN

    SELECT DISTINCT DES.ImpuestoID, DES.Descripcion, DES.DescripCorta, ROUND(DES.Tasa,2)
        FROM IMPUESTOS DES
        WHERE DES.Descripcion LIKE concat("%", Par_Descripcion, "%")
        LIMIT 0, 15;

END IF;


IF(Par_NumLis = Lis_Combo) THEN

    SELECT DISTINCT DES.ImpuestoID, DES.DescripCorta
        FROM IMPUESTOS DES;

END IF;

END TerminaStore$$