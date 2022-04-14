-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEFACTPROVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEFACTPROVLIS`;
DELIMITER $$


CREATE PROCEDURE `DETALLEFACTPROVLIS`(
    Par_NoFactura       VARCHAR(20),
    Par_ProveedorID     INT(11),
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
	DECLARE		Var_NoTotalImp	INT(11);

	DECLARE     Entero_Cero     INT(11);
	DECLARE     Lis_Principal   INT(11);
	DECLARE     Lis_Detalle     INT(11);
	DECLARE     Lis_DetImp      INT(11);
	DECLARE 	Lis_ImporImp	INT(11);



	SET Entero_Cero     := 0;
	SET Lis_Principal   := 1;
	SET Lis_Detalle     := 2;
	SET Lis_DetImp      := 3;
	SET Lis_ImporImp	:= 4;

	IF(Par_NumLis = Lis_Detalle) THEN

	SELECT  Det.TipoGastoID,    ROUND(Det.Cantidad,0)AS Cantidad,   Det.Descripcion,    Det.PrecioUnitario,     Det.Importe,
			Det.Gravable,       Det.CentroCostoID,  Det.GravaCero,  TT.Descripcion AS DescripcionTG,
			PR.TipoPago,        Det.NoPartidaID,	Fac.Estatus
			FROM DETALLEFACTPROV Det INNER JOIN  FACTURAPROV Fac ON Det.NoFactura = Fac.NoFactura
											AND Fac.ProveedorID=Det.ProveedorID
				INNER JOIN TESOCATTIPGAS TT ON TT.TipoGastoID=Det.TipoGastoID
				INNER JOIN PROVEEDORES PR ON PR.ProveedorID = Fac.ProveedorID
			WHERE Det.NoFactura = Par_NoFactura
			AND Fac.ProveedorID = Par_ProveedorID;

	END IF;

	IF(Par_NumLis = Lis_DetImp) THEN
		SELECT COUNT(*) INTO Var_NoTotalImp
			FROM  DETALLEIMPFACT
            WHERE NoFactura = Par_NoFactura
            AND ProveedorID = Par_ProveedorID;

        SET @Var_Conse 	:=	0;

		SELECT  T.TipoProveedorID,T.ImpuestoID, IM.DescripCorta,IM.Tasa, IM.GravaRetiene,IM.BaseCalculo, IM.ImpuestoCalculo,
				Var_NoTotalImp AS NoTotalImpuesto,
                 @Var_Conse:=@Var_Conse+1 AS Consecutivo
			FROM PROVEEDORES P INNER JOIN TIPOPROVEIMPUES T  ON P.TipoProveedor = T.TipoProveedorID
							   INNER JOIN IMPUESTOS IM ON T.ImpuestoID = IM.ImpuestoID
			WHERE P.ProveedorID = Par_ProveedorID
		ORDER BY T.Orden;
	END IF;


	IF(Par_NumLis = Lis_ImporImp) THEN
			SELECT 	SUM(IFNULL(D.ImporteImpuesto,0.00))AS ImporteImpuesto, D.ImpuestoID, Fac.Estatus
				FROM FACTURAPROV Fac
				INNER JOIN DETALLEIMPFACT D ON Fac.ProveedorID = D.ProveedorID AND Fac.NoFactura = D.NoFactura
				WHERE   Fac.NoFactura = Par_NoFactura
				AND Fac.ProveedorID = Par_ProveedorID
				GROUP BY D.ImpuestoID;
	END IF;

END TerminaStore$$