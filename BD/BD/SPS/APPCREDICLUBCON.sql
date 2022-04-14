DELIMITER ;
DROP PROCEDURE IF EXISTS `APPCREDICLUBCON`;

DELIMITER $$

CREATE PROCEDURE `APPCREDICLUBCON`(
Par_ClienteID		INT(11),
Par_NoProducto		BIGINT(12),
Par_SucursalID		INT(11),
Par_TipoConsulta 	INT(11)
)
TerminaStore: BEGIN

DECLARE SaldoCtaAho 	INT(11);
DECLARE	ProductosClie	INT(11);
DECLARE SaldoInvCed		INT(11);
DECLARE MovmientoCta	INT(11);



SET	SaldoCtaAho 	:= 	1;
SET	ProductosClie	:=	2;
SET SaldoInvCed		:=	3;
SET MovmientoCta	:=	4;


IF(SaldoCtaAho =Par_TipoConsulta) THEN
	SELECT SaldoDispon AS saldo
		FROM CUENTASAHO
			WHERE CuentaAhoID = Par_NoProducto;
END IF;

IF(ProductosClie =Par_TipoConsulta) THEN

	DELETE FROM temp_ProductosCaptacion_Cliente WHERE ClienteID=Par_ClienteID;

	   INSERT INTO temp_ProductosCaptacion_Cliente
		SELECT CUE.ClienteID,	SUC.SucursalID,	TIP.Descripcion,	SUM(CUE.Saldo) AS Saldo
			FROM CUENTASAHO CUE
				INNER JOIN TIPOSCUENTAS TIP ON TIP.TipoCuentaID = CUE.TipoCuentaID
				INNER JOIN SUCURSALES SUC ON CUE.SucursalID = SUC.SucursalID
		WHERE CUE.ClienteID= Par_ClienteID
        AND TIP.TipoCuentaID IN (3,4,6) -- se agrego el filtro por el tipo de cuenta AEuan T_11943
		GROUP BY CUE.TipoCuentaID,
			CUE.ClienteID,SUC.SucursalID,TIP.Descripcion
        ;


		INSERT INTO temp_ProductosCaptacion_Cliente
		SELECT  INV.ClienteID,	SUC.SucursalID,	CAT.Descripcion,	SUM(INV.Monto) AS Saldo
			FROM INVERSIONES INV
				INNER JOIN CLIENTES CLI ON INV.ClienteID = CLI.ClienteID
				INNER JOIN CATINVERSION CAT ON CAT.TipoInversionID = INV.TipoInversionID
				INNER JOIN SUCURSALES SUC ON CLI.SucursalOrigen = SUC.SucursalID
			WHERE INV.ClienteID= Par_ClienteID AND INV.Estatus='N'
			GROUP BY INV.TipoInversionID,
            INV.ClienteID,	SUC.SucursalID,	CAT.Descripcion
            ;


		INSERT INTO temp_ProductosCaptacion_Cliente
		SELECT  CED.ClienteID,	SUC.SucursalID,	CONCAT(TIP.Descripcion,' CEDE'),	SUM(CED.Monto)
			FROM CEDES CED
		INNER JOIN TIPOSCEDES TIP ON CED.TipoCedeID = TIP.TipoCedeID
		INNER JOIN SUCURSALES SUC ON CED.SucursalID = SUC.SucursalID
		WHERE  CED.ClienteID =  Par_ClienteID AND CED.Estatus='N'
		GROUP BY CED.TipoCedeID,
				CED.ClienteID,	SUC.SucursalID
        ;


		UPDATE temp_ProductosCaptacion_Cliente
		SET Producto = (CASE WHEN Producto LIKE '%VISTA%' THEN 'VISTA' ELSE 'INVERSION' END);



SELECT 0 AS idorigen,
	   Producto AS tipo,
	   '' AS 'Producto',
       SUM(Saldo) AS saldo
FROM  temp_ProductosCaptacion_Cliente
WHERE ClienteID=Par_ClienteID
GROUP BY idorigen, Producto, tipo;


DELETE FROM temp_ProductosCaptacion_Cliente WHERE ClienteID=Par_ClienteID;


END IF;

IF(SaldoInvCed=Par_TipoConsulta) THEN

            	SELECT 	INV.ClienteID AS idsocio,		CLI.SucursalOrigen AS idorigenp,	INV.TipoInversionID AS idproducto,	INV.InversionID AS idauxiliar,
				CONCAT("Deposito a Plazo ",INV.Plazo," dias Crediclub") AS desProducto,
				CASE CAT.Reinversion WHEN 'S' THEN 'Se Reinvierte'
									ELSE 'No se Reinvierte' END AS InsVen,
				INV.Plazo,
                INV.Tasa AS  'TasAnu',
                INV.ValorGatReal AS 'GanAnu',
                INV.FechaInicio AS 'fechaape',
                INV.FechaVencimiento AS 'FecVen',
                INV.InteresGenerado AS 'IntBruto',
                INV.InteresRetener AS 'RetISR',
                (INV.Monto + INV.InteresGenerado) AS 'MonVen',
                INV.Monto  AS 'MonInv'
        FROM INVERSIONES INV
				INNER JOIN CLIENTES CLI ON INV.ClienteID = CLI.ClienteID
                INNER JOIN CATINVERSION CAT ON INV.TipoInversionID = CAT.TipoInversionID
			WHERE INV.ClienteID= Par_ClienteID AND INV.Estatus='N'

		UNION ALL
				SELECT CED.ClienteID  AS idsocio,	 CLI.SucursalOrigen AS idorigenp,		CED.TipoCedeID AS idproducto,	CED.CedeID AS idauxiliar,
                CONCAT("Deposito a Plazo ",CED.Plazo," Interés retirable c/28 dias") AS desProducto,
								CASE CAT.Reinversion WHEN 'S' THEN 'Se Reinvierte'
									ELSE 'No se Reinvierte' END AS InsVen,
				CED.Plazo,
                CED.TasaFija AS  'TasAnu',
                CED.ValorGatReal AS 'GanAnu',
                CED.FechaInicio AS 'fechaape',
                CED.FechaVencimiento AS 'FecVen',
                CED.InteresGenerado AS 'IntBruto',
                CED.InteresRetener AS 'RetISR',
                (CED.Monto + CED.InteresGenerado) AS 'MonVen',
                CED.Monto  AS 'MonInv'
        FROM CEDES CED
				INNER JOIN CLIENTES CLI ON CED.ClienteID = CLI.ClienteID
                INNER JOIN TIPOSCEDES CAT ON CED.TipoCedeID = CAT.TipoCedeID
			WHERE CED.ClienteID= Par_ClienteID AND CED.Estatus='N';
END IF;

IF(MovmientoCta = Par_TipoConsulta) THEN


                 SELECT 	CONCAT(CMA.Fecha,' ',TIME(CMA.FechaActual)) AS fecha,
				CMA.CantidadMov AS 'monto',
                CMA.DescripcionMov AS 'TipMov',
                CMA.NumTransaccion AS 'transaccion',
				CASE CMA.NatMovimiento	WHEN 'A' THEN 'Abono'
				 WHEN 'C' THEN 'Cargo' ELSE '' END AS Movimiento

			FROM CUENTASAHOMOV CMA
				WHERE CMA.CuentaAhoID=Par_NoProducto
				AND CMA.Fecha>=DATE_ADD( NOW(),INTERVAL -(  6) MONTH)
		UNION
			SELECT 	CONCAT(CMA.Fecha,' ',TIME(CMA.FechaActual)) AS fecha,
					CMA.CantidadMov AS 'monto',
                    CMA.DescripcionMov AS 'TipMov',
                    CMA.NumTransaccion AS 'transaccion',
					CASE CMA.NatMovimiento	WHEN 'A' THEN 'Abono'
						WHEN 'C' THEN 'Cargo' ELSE '' END AS Movimiento
			FROM `HIS-CUENAHOMOV` CMA
				WHERE  CMA.CuentaAhoID=Par_NoProducto
                 AND CMA.Fecha>=DATE_ADD( NOW(),INTERVAL -(  6) MONTH);
END IF;

END TerminaStore$$