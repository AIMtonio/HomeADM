-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESTINOSCREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `DESTINOSCREDITOLIS`(

    Par_DestinoCreID    VARCHAR(100),
    Par_ProducCreditoID	INT(11),
    Par_NumLis          TINYINT UNSIGNED,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Lis_LineaCredito    INT;
DECLARE Lis_ProdCredito		INT;

SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Lis_LineaCredito    := 1;
SET Lis_ProdCredito		:= 2;

IF(Par_NumLis = Lis_LineaCredito) THEN
    SELECT DestinoCreID,    Descripcion
        FROM    DESTINOSCREDITO
        WHERE   Descripcion LIKE    CONCAT("%", Par_DestinoCreID, "%")
        LIMIT   0, 15;
ELSEIF (Par_NumLis = Lis_ProdCredito) THEN
	SELECT Dc.DestinoCreID, Dc.Descripcion
		FROM DESTINOSCREDPROD Dcp
			INNER JOIN DESTINOSCREDITO Dc
            ON Dcp.DestinoCreID = Dc.DestinoCreID
            AND Dcp.ProductoCreditoID = Par_ProducCreditoID
		WHERE Dc.Descripcion LIKE CONCAT("%", Par_DestinoCreID, "%")
        LIMIT 0,15;
END IF;

END TerminaStore$$