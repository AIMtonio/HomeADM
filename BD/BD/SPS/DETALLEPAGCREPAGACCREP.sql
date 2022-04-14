-- DETALLEPAGCREPAGACCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS DETALLEPAGCREPAGACCREP;

DELIMITER $$
CREATE PROCEDURE DETALLEPAGCREPAGACCREP(
	-- Store Procedure de Reporte para los pagos de accesorios en un rango de fechas determinados
	-- Modulo: Cartera --> Reporte --> Detalle de Accesorios
	Par_FechaInicio			DATE,			-- Fecha en que inicia la primer amortizacion
	Par_FechaFin			DATE,			-- Fecha en que inicia la primer amortizacion
	Par_Sucursal			INT(11),		-- ID de la sucursal
	Par_ProducCreditoID		INT(11),		-- producto de credito
	Par_InstitNominaID		INT(11),		-- ID de la institucion de Nómina
	Par_ConvenioNominaID	BIGINT UNSIGNED,-- Numero del Convenio de Nomina

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero
	DECLARE Con_TipoMovAcc		INT(11);	-- Constante Tipo Movimiento 43 Comisiones
	DECLARE Con_TipoMovIVAAcc	INT(11);	-- Constante Tipo Movimiento 26 IVA de Comisiones
	DECLARE Con_TipoMovInt		INT(11);	-- Constante Tipo Movimiento 57 Interes Comisiones
	DECLARE Con_TipoMovIVAInt	INT(11);	-- Constante Tipo Movimiento 58 IVA Interes Comisiones
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE Con_NatAbono		CHAR(1);	-- Constante Naturaleza Abono
	DECLARE Con_Comodin			CHAR(1);	-- Constante Comodin
	DECLARE Con_DescripcionPago	VARCHAR(25);-- Constante Pago de Credito
	DECLARE Fecha_Vacia			DATE;		-- Constante Fecha Vacia

	-- Asignacion de Constante
	SET Entero_Cero			:= 0;
	SET Con_TipoMovAcc		:= 43;
	SET Con_TipoMovIVAAcc	:= 26;
	SET Con_TipoMovInt		:= 57;
	SET Con_TipoMovIVAInt	:= 58;
	SET Cadena_Vacia		:= '';
	SET Con_NatAbono		:= 'A';
	SET Con_Comodin			:= '%';

	SET Con_DescripcionPago	:= 'PAGO DE CREDITO';
	SET Fecha_Vacia			:= '1900-01-01';

	DROP TABLE IF EXISTS TMP_DETALLEPAGCREPAGACCREP;
	CREATE TEMPORARY TABLE TMP_DETALLEPAGCREPAGACCREP(
		CreditoID				BIGINT(12),
		NombreInstit			VARCHAR(500),
		DescripcionConvenio		VARCHAR(500),
		ClienteID				INT(11),
		NombreCompleto			VARCHAR(500),

		NombreProducto			VARCHAR(500),
		Sucursal				VARCHAR(500),
		FechaLiquida			DATE,
		AmortizacionID			INT(11),
		AccesorioID				INT(11),

		DescripcionAccesorio	VARCHAR(500),
		MontoAccesorio			DECIMAL(18,2),
		IVAaccesorio			DECIMAL(18,2),
		MontoInteres			DECIMAL(18,2),
		IVAMontoInteres			DECIMAL(18,2),
		TotalPagado				DECIMAL(18,2),
		InstitNominaID 			INT(11),
		ConvenioNominaID		INT(11),
		NombreCorto				VARCHAR(20)	NOT NULL COMMENT 'Abreviatura del Accesorio',
		PRIMARY KEY (CreditoID, AmortizacionID, AccesorioID),
		KEY `IDX_TMP_DETALLEPAGCREPAGACCREP_1` (TotalPagado));

	INSERT INTO TMP_DETALLEPAGCREPAGACCREP(
		CreditoID,				NombreInstit,		DescripcionConvenio,	ClienteID,		NombreCompleto,
		NombreProducto,			Sucursal,			FechaLiquida,			AmortizacionID,	AccesorioID,
		DescripcionAccesorio,	MontoAccesorio,		IVAaccesorio,			MontoInteres, 	IVAMontoInteres,
		TotalPagado,			InstitNominaID,		ConvenioNominaID,		NombreCorto)
	SELECT Cre.CreditoID AS 'CreditoID',
		Cadena_Vacia,
		Cadena_Vacia,
		Entero_Cero,
		Cadena_Vacia,
		Cadena_Vacia,
		Cadena_Vacia,
		CASE WHEN ( MAX(DetAcc.FechaLiquida) <> Fecha_Vacia ) THEN  MAX(DetAcc.FechaLiquida)
			 ELSE  MAX(Det.FechaPago) END AS 'FechaLiquida',
		Det.AmortizacionID AS 'AmortizacionID',
		DetAcc.AccesorioID AS 'AccesorioID',
		Cadena_Vacia,
		Entero_Cero,
		Entero_Cero,
		Entero_Cero,
		Entero_Cero,
		Entero_Cero,
		Entero_Cero,
		Entero_Cero,
		Cadena_Vacia
	FROM CREDITOS Cre
	LEFT JOIN INSTITNOMINA Nom ON Cre.InstitNominaID = Nom.InstitNominaID
	LEFT JOIN CONVENIOSNOMINA Conv ON Cre.ConvenioNominaID = Conv.ConvenioNominaID
	INNER JOIN PRODUCTOSCREDITO Pro	ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN DETALLEPAGCRE Det ON Cre.CreditoID = Det.CreditoID
	INNER JOIN DETALLEACCESORIOS DetAcc ON Det.CreditoID = DetAcc.CreditoID AND Det.AmortizacionID = DetAcc.AmortizacionID
	WHERE Det.FechaPago BETWEEN Par_FechaInicio AND Par_FechaFin
	  AND ((Det.MontoComision + Det.MontoAccesorios )> Entero_Cero)
	  AND Cre.SucursalID = IF(Par_Sucursal = Entero_Cero, Cre.SucursalID, Par_Sucursal)
	  AND Cre.ProductoCreditoID = IF(Par_ProducCreditoID = Entero_Cero, Cre.ProductoCreditoID, Par_ProducCreditoID)
	  AND IFNULL(Cre.InstitNominaID,Entero_Cero) = IF(Par_InstitNominaID = Entero_Cero, IFNULL(Cre.InstitNominaID,Entero_Cero), Par_InstitNominaID)
	  AND IFNULL(Cre.ConvenioNominaID,Entero_Cero) = IF(Par_ConvenioNominaID = Entero_Cero, IFNULL(Cre.ConvenioNominaID,Entero_Cero), Par_ConvenioNominaID)
	GROUP BY Cre.CreditoID, Det.AmortizacionID, DetAcc.AccesorioID;

	UPDATE TMP_DETALLEPAGCREPAGACCREP Tmp
	INNER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
	LEFT JOIN INSTITNOMINA Nom ON Cre.InstitNominaID = Nom.InstitNominaID
	LEFT JOIN CONVENIOSNOMINA Conv ON Cre.ConvenioNominaID = Conv.ConvenioNominaID SET
		Tmp.NombreInstit		= IFNULL(Nom.NombreInstit, Cadena_Vacia),
		Tmp.DescripcionConvenio	= IFNULL(Conv.Descripcion, Cadena_Vacia);

	UPDATE TMP_DETALLEPAGCREPAGACCREP Tmp
	INNER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID SET
		Tmp.ClienteID = Cli.ClienteID,
		Tmp.NombreCompleto = Cli.NombreCompleto;

	UPDATE TMP_DETALLEPAGCREPAGACCREP Tmp
	INNER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
	INNER JOIN PRODUCTOSCREDITO Pro	ON Cre.ProductoCreditoID = Pro.ProducCreditoID SET
		Tmp.NombreProducto = Pro.Descripcion;

	UPDATE TMP_DETALLEPAGCREPAGACCREP Tmp
	INNER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID
	INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID SET
		Tmp.Sucursal = Suc.NombreSucurs;

	UPDATE TMP_DETALLEPAGCREPAGACCREP Tmp, ACCESORIOSCRED Acc SET
		Tmp.DescripcionAccesorio = Acc.Descripcion,
		Tmp.NombreCorto			 = Acc.NombreCorto
	WHERE Tmp.AccesorioID = Acc.AccesorioID;

	-- Creo la tabla pivote para saldos
	DROP TABLE IF EXISTS TMP_DETALLEPAGCREPAGACCMOVSREP;
	CREATE TEMPORARY TABLE TMP_DETALLEPAGCREPAGACCMOVSREP(
	CreditoID				BIGINT(12),
	AccesorioID				INT(11),
	AmortizacionID			INT(11),
	NombreCorto				VARCHAR(20)	NOT NULL COMMENT 'Abreviatura del Accesorio',
	PRIMARY KEY (CreditoID, AmortizacionID, AccesorioID));

	DROP TABLE IF EXISTS TMP_DETALLEPAGCREPAGACCPAGREP;
	CREATE TEMPORARY TABLE TMP_DETALLEPAGCREPAGACCPAGREP(
	CreditoID				BIGINT(12),
	AccesorioID				INT(11),
	AmortizacionID			INT(11),
	MontoAccesorio 			DECIMAL(18,2),
	IVAaccesorio 			DECIMAL(18,2),
	MontoInteres			DECIMAL(18,2),
	IVAMontoInteres			DECIMAL(18,2),
	PRIMARY KEY (CreditoID, AmortizacionID, AccesorioID));

	-- Se insertan los datos de mi tabla pivote
	INSERT INTO TMP_DETALLEPAGCREPAGACCMOVSREP(
	CreditoID, AmortizacionID, AccesorioID, NombreCorto)
	SELECT CreditoID, AmortizacionID, AccesorioID, NombreCorto
	FROM TMP_DETALLEPAGCREPAGACCREP
	GROUP BY CreditoID, AmortizacionID, AccesorioID, NombreCorto;

	-- Inserto los movimientos de pago de credito por accesorio asi como su iva de acuerdo al tipo de movimiento
	INSERT INTO TMP_DETALLEPAGCREPAGACCPAGREP(
			CreditoID, AmortizacionID, AccesorioID, MontoAccesorio, IVAaccesorio, MontoInteres, IVAMontoInteres)
	SELECT	Tmp.CreditoID, Tmp.AmortizacionID, Tmp.AccesorioID,
			SUM(CASE WHEN Mov.TipoMovCreID = Con_TipoMovAcc
						  THEN IFNULL(Mov.Cantidad, Entero_Cero)
						  ELSE Entero_Cero
				END) AS MontoAccesorio,
			SUM(CASE WHEN Mov.TipoMovCreID = Con_TipoMovIVAAcc
						  THEN IFNULL(Mov.Cantidad, Entero_Cero)
						  ELSE Entero_Cero
				END) AS IVAaccesorio,
			SUM(CASE WHEN Mov.TipoMovCreID = Con_TipoMovInt
						  THEN IFNULL(Mov.Cantidad, Entero_Cero)
						  ELSE Entero_Cero
				END) AS MontoInteres,
			SUM(CASE WHEN Mov.TipoMovCreID = Con_TipoMovIVAInt
						  THEN IFNULL(Mov.Cantidad, Entero_Cero)
						  ELSE Entero_Cero
				END) AS IVAMontoInteres
	FROM CREDITOSMOVS Mov
	INNER JOIN TMP_DETALLEPAGCREPAGACCMOVSREP Tmp ON Mov.CreditoID = Tmp.CreditoID
	WHERE Mov.CreditoID = Tmp.CreditoID
	  AND Mov.AmortiCreID = Tmp.AmortizacionID
	  AND Mov.FechaOperacion BETWEEN Par_FechaInicio AND Par_FechaFin
	  AND Mov.TipoMovCreID IN (Con_TipoMovAcc,Con_TipoMovIVAAcc, Con_TipoMovInt, Con_TipoMovIVAInt )
	  AND Mov.NatMovimiento = Con_NatAbono
	  AND Mov.Descripcion = Con_DescripcionPago
	  AND Mov.Referencia LIKE CONCAT(Con_Comodin,Tmp.NombreCorto,Con_Comodin)
	GROUP BY Tmp.CreditoID, Tmp.AmortizacionID, Tmp.AccesorioID;

	-- Actualizo los saldos de pagos de creditos para los accesorios
	UPDATE TMP_DETALLEPAGCREPAGACCREP Tmp, TMP_DETALLEPAGCREPAGACCPAGREP DetAcc SET
		Tmp.MontoAccesorio	= DetAcc.MontoAccesorio,
		Tmp.IVAaccesorio	= DetAcc.IVAaccesorio,
		Tmp.MontoInteres	= DetAcc.MontoInteres,
		Tmp.IVAMontoInteres = DetAcc.IVAMontoInteres,
		Tmp.TotalPagado		= DetAcc.MontoAccesorio + DetAcc.IVAaccesorio + DetAcc.MontoInteres + DetAcc.IVAMontoInteres
	WHERE Tmp.CreditoID = DetAcc.CreditoID
	  AND Tmp.AmortizacionID = DetAcc.AmortizacionID
	  AND Tmp.AccesorioID = DetAcc.AccesorioID;

	-- Select de salida para los accesorios que tiene pagos y se descartan los que no tiene ningun pago
	SELECT
		CreditoID,				NombreInstit,		DescripcionConvenio,	ClienteID,		NombreCompleto,
		NombreProducto,			Sucursal,			FechaLiquida,			AmortizacionID,	AccesorioID,
		MontoAccesorio,			IVAaccesorio,		MontoInteres,			IVAMontoInteres,TotalPagado,
		InstitNominaID,
		DescripcionAccesorio AS 'DescripciónAccesorio'
	FROM TMP_DETALLEPAGCREPAGACCREP
	WHERE TotalPagado > Entero_Cero;

END TerminaStore$$

