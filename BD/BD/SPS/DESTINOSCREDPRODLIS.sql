-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDPRODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESTINOSCREDPRODLIS`;DELIMITER $$

CREATE PROCEDURE `DESTINOSCREDPRODLIS`(

    Par_ProductoCreditoID   INT(11),
    Par_NumLis              TINYINT UNSIGNED,
    Aud_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,

    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
    )
TerminaStore: BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Lis_DestPorProd     INT;
DECLARE Var_Vivienda        CHAR(1);
DECLARE Var_Consumo         CHAR(1);
DECLARE Var_Comercial       CHAR(1);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Lis_DestPorProd     := 1;
SET Var_Vivienda        := 'H';
SET Var_Consumo         := 'C';
SET Var_Comercial       := 'O';

IF(Par_NumLis = Lis_DestPorProd) THEN
    SELECT  DE.DestinoCreID,    DE.Descripcion, DE.SubClasifID, CL.DescripClasifica,    IFNULL(DP.ProductoCreditoID, Entero_Cero) AS ProductoCreditoID,
            CASE DE.Clasificacion
                WHEN Var_Vivienda   THEN 'VIVIENDA'
                WHEN Var_Consumo    THEN 'CONSUMO'
                WHEN Var_Comercial  THEN 'COMERCIAL'
                ELSE DE.Clasificacion
                END AS Clasificacion
        FROM    DESTINOSCREDITO DE
        LEFT OUTER JOIN CLASIFICCREDITO CL
                ON DE.SubClasifID = CL.ClasificacionID
        LEFT OUTER JOIN DESTINOSCREDPROD DP
                ON  DE.DestinoCreID = DP.DestinoCreID
                AND DP.ProductoCreditoID = Par_ProductoCreditoID;

END IF;

END TerminaStore$$