-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEIMPUESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEIMPUESLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEIMPUESLIS`(
    Par_TipoProve       INT,
    Par_NumLis          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN



DECLARE Entero_Cero     INT;
DECLARE Lis_Principal   INT;
DECLARE Lis_ImpProv     INT;
DECLARE Lis_ImpGrid     INT;


SET Entero_Cero     := 0;
SET Lis_Principal   := 1;
SET Lis_ImpProv     := 2;
SET Lis_ImpGrid     := 3;

IF(Par_NumLis = Lis_ImpProv) THEN
    SELECT  ImpuestoID, Orden
        FROM TIPOPROVEIMPUES
        WHERE TipoProveedorID = Par_TipoProve ORDER BY ImpuestoID;
END IF;

IF(Par_NumLis = Lis_ImpGrid) THEN
    SELECT  T.TipoProveedorID,T.ImpuestoID, IM.DescripCorta,IM.Tasa,T.Orden
        FROM TIPOPROVEIMPUES T INNER JOIN IMPUESTOS IM ON T.ImpuestoID = IM.ImpuestoID
        WHERE TipoProveedorID = Par_TipoProve
ORDER BY T.Orden;
END IF;

END TerminaStore$$