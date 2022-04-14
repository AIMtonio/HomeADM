-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEIMPFACTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEIMPFACTLIS`;
DELIMITER $$


CREATE PROCEDURE `DETALLEIMPFACTLIS`(
    Par_NoFactura       VARCHAR(20),
    Par_ProveedorID     INT,
    Par_NumPartida      INT,
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



DECLARE		Var_NoTotalImp	INT(11);

DECLARE     Entero_Cero     INT;
DECLARE     Lis_Principal   INT;


SET Entero_Cero     := 0;
SET Lis_Principal   := 1;


IF(Par_NumLis = Lis_Principal) THEN
	SET @Var_Conse 	:=	0;
    SELECT COUNT(*) INTO Var_NoTotalImp
			FROM  DETALLEIMPFACT
            WHERE NoFactura = Par_NoFactura
            AND ProveedorID = Par_ProveedorID;

	SELECT  DET.ImpuestoID, DET.ImporteImpuesto, DET.NoPartidaID, F.Estatus, Var_NoTotalImp AS NoTotalImpuesto, @Var_Conse:=@Var_Conse+1 AS Consecutivo
			FROM FACTURAPROV F 
				INNER JOIN  DETALLEIMPFACT DET on F.ProveedorID = DET.ProveedorID AND F.NoFactura 	= DET.NoFactura
				INNER JOIN DETALLEFACTPROV DF ON DET.ProveedorID = DF.ProveedorID
											  AND DET.NoFactura = DF.NoFactura
											  AND DET.NoPartidaID = DF.NoPartidaID
			WHERE DET.NoFactura = Par_NoFactura
			AND DET.ProveedorID = Par_ProveedorID
            AND F.Estatus="I"
			ORDER BY DET.ImpuestoID;

END IF;

END TerminaStore$$