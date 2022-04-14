-- EDOCTAV2REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2REP`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2REP`(
  -- SP que consulta la informacion generada del Estado Cuenta para mostrarla en el PDF
  Par_Seccion 			INT(11),		-- Seccion del Estado de Cuenta a Consultar
  Par_ClienteID			INT(11),		-- Cliente a Consultar
  Par_CuentaAhoID		BIGINT(12),		-- Cuenta a Consultar
  Par_InversionID		INT(11),		-- Inversion a Consultar
  Par_CedeID			INT(11),		-- Cede a Consultar
  Par_CreditoID			BIGINT(11)		-- Credito a Consultar
)
TerminaStore: BEGIN
  -- Declaracion de Variables
  DECLARE Var_FolioProceso		BIGINT(20);
  DECLARE Var_FecIni			DATE;
  DECLARE Var_FecFin			DATE;
  DECLARE Var_RutaLogo			VARCHAR(500);
  DECLARE Var_EstatusTimbre		INT(1);
  DECLARE Var_InstitucionID		INT(11);
  DECLARE Var_NombreInstit		VARCHAR(250);
  DECLARE Var_DirInstit 		VARCHAR(250);
  DECLARE Var_RFCInstit			VARCHAR(20);
  DECLARE Var_OtrasCiuUEAU		VARCHAR(50);

  -- Declaracion de Constantes.
  DECLARE Cadena_Vacia            	CHAR(1);          -- Cadena Vacia
  DECLARE Fecha_Vacia             	DATE;             -- Fecha Vacia
  DECLARE Entero_Cero             	INT(11);          -- Entero Cero
  DECLARE TimbreExitoso				INT(11);
  DECLARE Sec_Encabezado			INT(11);
  DECLARE Sec_DatosCte				INT(11);
  DECLARE Sec_ResumCapta			INT(11);
  DECLARE Sec_GraficaCapta			INT(11);
  DECLARE Sec_HeaderAho				INT(11);
  DECLARE Sec_DetalleAho			INT(11);
  DECLARE Sec_GraficaAho			INT(11);
  DECLARE Sec_HeaderInv				INT(11);
  DECLARE Sec_DetalleInv			INT(11);
  DECLARE Sec_HeaderCede			INT(11);
  DECLARE Sec_DetalleCede			INT(11);
  DECLARE Sec_ResumenCred			INT(11);
  DECLARE Sec_HeaderCred			INT(11);
  DECLARE Sec_DetalleCred			INT(11);
  DECLARE Sec_CargosObjetados		INT(11);
  DECLARE Sec_MensajesImp			INT(11);
  DECLARE Sec_Timbrado				INT(11);
  DECLARE Sec_Litros				INT(11);
  DECLARE Sec_Abreviaturas			INT(11);
  DECLARE Var_InstCtaAho			CHAR(2);          -- Tipo de instrumento Cuenta de Ahorro
  DECLARE Var_NatCargo				CHAR(1);          -- Naturaleza del movimiento Cargo
  DECLARE Var_MovComisiApe			INT(11);          -- Comision por apertura
  DECLARE Var_MovIVAComisiApe		INT(11);          -- IVA de Comision por apertura
  DECLARE Var_MovComisiDisp			INT(11);          -- Comision por disposicion
  DECLARE Var_MovIVAComisiDisp		INT(11);          -- IVA de Comision por disposicion

  -- Asignacion de Constantes
  SET Cadena_Vacia                	:= '';            -- Cadena Vacia
  SET Fecha_Vacia                 	:= '1900-01-01';  -- Fecha Vacia
  SET Entero_Cero                 	:= 0;             -- Entero Cero
  SET TimbreExitoso					:= 2;


  SET Sec_Encabezado				:= 0;
  SET Sec_DatosCte					:= 1;
  SET Sec_ResumCapta				:= 2;
  SET Sec_GraficaCapta				:= 3;
  SET Sec_HeaderAho					:= 4;
  SET Sec_DetalleAho				:= 5;
  SET Sec_GraficaAho				:= 6;
  SET Sec_HeaderInv					:= 7;
  SET Sec_DetalleInv				:= 8;
  SET Sec_HeaderCede				:= 9;
  SET Sec_DetalleCede				:= 10;
  SET Sec_ResumenCred				:= 11;
  SET Sec_HeaderCred				:= 12;
  SET Sec_DetalleCred				:= 13;
  SET Sec_CargosObjetados			:= 14;
  SET Sec_MensajesImp				:= 15;
  SET Sec_Timbrado					:= 16;
  SET Sec_Litros					:= 18;
  SET Sec_Abreviaturas				:= 17;
  SET Var_InstCtaAho				:= 'CA';          -- Tipo de instrumento Cuenta de Ahorro
  SET Var_NatCargo					:= 'C';           -- Naturaleza del movimiento Cargo
  SET Var_MovComisiDisp				:= 236;           -- Comision por disposicion
  SET Var_MovIVAComisiDisp			:= 235;           -- IVA de Comision por disposicion
  SET Var_MovComisiApe				:= 83;            -- Comision por apertura
  SET Var_MovIVAComisiApe			:= 84;            -- IVA de Comision por apertura

	-- Encabezado del PDF
	IF(Par_Seccion = Sec_Encabezado) THEN

		SELECT 	FechaInicio, 	FechaFin, 		InstitucionID,		FolioProceso, 		RutaLogo,
				IF(IFNULL(OtrasCiuUEAU, Cadena_Vacia) <> Cadena_Vacia, CONCAT('TEL: ', OtrasCiuUEAU), Cadena_Vacia)
		INTO 	Var_FecIni,		Var_FecFin,		Var_InstitucionID, 	Var_FolioProceso,	Var_RutaLogo,
				Var_OtrasCiuUEAU
		FROM EDOCTAV2PARAMS
		Limit 1;

		SELECT 		Nombre, 			DirFiscal, 		RFC
			INTO 	Var_NombreInstit,	Var_DirInstit, 	Var_RFCInstit
		FROM INSTITUCIONES
		WHERE InstitucionID = Var_InstitucionID;


		SELECT  EstatusTimbrado
		INTO Var_EstatusTimbre
		FROM EDOCTAV2TIMBRADOINGRE
		WHERE ClienteID = Par_ClienteID
		  AND FolioProceso = Var_FolioProceso
		LIMIT 1  ;


		SELECT 	Var_FecIni,				Var_FecFin,		Var_InstitucionID, 		Var_FolioProceso,	Var_RutaLogo,
				Var_OtrasCiuUEAU,		Var_NombreInstit,		Var_DirInstit, 	Var_RFCInstit,
				DAY(Var_FecFin) AS Dias,
				CASE WHEN IFNULL(Var_EstatusTimbre, Entero_Cero) = TimbreExitoso THEN 'S' ELSE 'N' END AS Timbrado;

	END IF;

	-- Datos Del Cliente
	IF(Par_Seccion = Sec_DatosCte) THEN
  		SELECT 	AnioMes,				SucursalID,		ClienteID,		        FolioProceso,		NombreCompleto,	
		     	NombreSucursalCte,   	TipoPer,		TipoPersona,	        Calle,		      	NumInt,			
				NumExt,			    	Colonia,        MunicipioDelegacion,	Localidad,	     	Estado,		
				CodigoPostal,		    RFC,			DireccionCompleta,   	FechaGeneracion,	RegHacienda,
				ParteSocial,        	PDFGenerado
  		FROM EDOCTAV2DATOSCTE
  		WHERE ClienteID = Par_ClienteID;
	END IF;



	-- Resumen de Captacion
	IF(Par_Seccion = Sec_ResumCapta) THEN
		SELECT 	AnioMes,			SucursalID,		ClienteID,			InstrumentoID,		MonedaID,
				MonedaDescri,		Etiqueta,		SaldoPromedio,		SaldoAnterior,		SaldoActual,
				TipoInstrumento,	FolioProceso
		FROM EDOCTAV2RESUMCAPTA
		WHERE ClienteID = Par_ClienteID;
	END IF;



	-- Encabezado de Cuenta de Ahorro
	IF(Par_Seccion = Sec_HeaderAho) THEN
		SELECT 	AnioMes,		ClienteID,			SucursalID,		CuentaAhoID,		TipoCuentaID,
				ProductoDesc,	SaldoMesAnterior,	SaldoActual,	SaldoPromedio,		Clabe,
				SaldoMinimo,	ISRRetenido,		GatNominal,		GatReal,			TasaBruta,
				InteresPerido,	MontoComision,		IvaComision,	MonedaID,			MonedaDescri,
				DepositosMes,	RetirosMes,			Estatus,		FolioProceso
		FROM EDOCTAV2HEADERCTA
		WHERE ClienteID = Par_ClienteID
		ORDER BY TipoCuentaID;
	END IF;


	-- Detalle de Movimientos por Cuenta de Ahorro
	IF(Par_Seccion = Sec_DetalleAho) THEN
		SELECT 	AnioMes,		ClienteID,		SucursalID,		CuentaAhoID,		FechaMovimiento,
				Referencia,		Concepto,		Cargo,			Abono,				Orden,
				FolioProceso,	Transaccion
		FROM EDOCTAV2DETACTA
		WHERE ClienteID = Par_ClienteID
		  AND CuentaAhoID = Par_CuentaAhoID
		ORDER BY FechaMovimiento, Transaccion, Abono DESC;
	END IF;


	-- Grafica de Cuenta de Ahorro
	IF(Par_Seccion = Sec_GraficaAho) THEN
		SELECT 	AnioMes,		ClienteID,		CuentaAhoID,		Descripcion,	Monto
		FROM EDOCTAV2GRAFICA
		WHERE ClienteID = Par_ClienteID
		  AND CuentaAhoID = Par_CuentaAhoID
		ORDER BY Orden;
	END IF;



	-- Encabezado de Cedes
	IF(Par_Seccion = Sec_HeaderCede) THEN
		SELECT 	AnioMes,		SucursalID,			ClienteID,			CuentaAhoID,		CedeID,
				Estatus,		FechaLiquida,		TipoCedeID,			ProductoDesc,		Capital,
				FechaInicio,	FechaVencimiento,	Plazo,				TasaInteresAnual,	ISRRetenido,
				GatNominal,		GatReal,			InteresPeriodo,		MontoComision,		IvaComision,
				FolioProcesoID
		FROM  EDOCTAV2HEADERCEDES
		WHERE ClienteID = Par_ClienteID
		ORDER BY FechaInicio, CedeID;
	ENd IF;



	-- Detalle de Movimientos de Cedes
	IF(Par_Seccion = Sec_DetalleCede) THEN
		SELECT 	AnioMes,		CedeID,		Fecha,			Concepto,			Depositos,
				Retiros,		Orden,		Transaccion,	FolioProcesoID
		FROM  EDOCTAV2DETACEDES
		WHERE CedeID = Par_CedeID
		ORDER BY CedeID, Fecha, Orden;
	ENd IF;



	-- Resumen de Creditos
	IF(Par_Seccion = Sec_ResumenCred) THEN
		SELECT 	AnioMes,			SucursalID,			ClienteID,			CreditoID,			ProductoCreditoID,
				Producto,			SaldoInsoluto,		FechaProxPago,		FechaLeyenda,		MontoProximoPago,
				FolioProcesoID
		FROM EDOCTAV2RESUMCREDITOS
		WHERE ClienteID = Par_ClienteID
		ORDER BY ProductoCreditoID, CreditoID;
	END IF;



	-- Encabezado de Creditos
	IF(Par_Seccion = Sec_HeaderCred) THEN
		SELECT		FechaInicio,	FechaFin
			INTO	Var_FecIni,		Var_FecFin
			FROM EDOCTAV2PARAMS;

		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2COMISIONES;
		CREATE TEMPORARY TABLE TMPEDOCTAV2COMISIONES
		(PRIMARY KEY (CreditoID))
		SELECT	CAST(SUBSTRING(his.ReferenciaMov, 6) AS UNSIGNED) AS CreditoID,	SUM(his.CantidadMov) AS CantidadMov
			FROM `HIS-CUENAHOMOV` AS his
			INNER JOIN EDOCTAV2RESUMCAPTA AS edo ON his.CuentaAhoID = edo.InstrumentoID AND edo.TipoInstrumento = Var_InstCtaAho
			WHERE edo.ClienteID = Par_ClienteID
			AND his.NatMovimiento = Var_NatCargo
			AND his.TipoMovAhoID IN (Var_MovComisiApe, Var_MovComisiDisp)
			AND his.Fecha BETWEEN Var_FecIni AND Var_FecFin
			GROUP BY his.ReferenciaMov;

		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2IVACOMISIONES;
		CREATE TEMPORARY TABLE TMPEDOCTAV2IVACOMISIONES
		(PRIMARY KEY (CreditoID))
		SELECT	CAST(SUBSTRING(his.ReferenciaMov, 6) AS UNSIGNED) AS CreditoID,	SUM(his.CantidadMov) AS CantidadMov
			FROM `HIS-CUENAHOMOV` AS his
			INNER JOIN EDOCTAV2RESUMCAPTA AS edo ON his.CuentaAhoID = edo.InstrumentoID AND edo.TipoInstrumento = Var_InstCtaAho
			WHERE edo.ClienteID = Par_ClienteID
			AND his.NatMovimiento = Var_NatCargo
			AND his.TipoMovAhoID IN (Var_MovIVAComisiApe, Var_MovIVAComisiDisp)
			AND his.Fecha BETWEEN Var_FecIni AND Var_FecFin
			GROUP BY his.ReferenciaMov;

		SELECT 	edo.FolioProceso,			edo.AnioMes,			edo.CreditoID,			edo.SucursalID,				edo.ClienteID,
				edo.ProductoCreditoID,		edo.NombreProducto,		edo.CuentaClabe,		edo.ImporteCredito,			edo.FechaMinistrado,
				edo.FechaVencimiento,		edo.SaldoInsoluto,		edo.SaldoInicial,		edo.PagoAmortizaciones,		edo.CAT,
				edo.TasaOrdinaria,			edo.TasaMoratoria,		edo.PagoIntOrdMes,		edo.PagoIVAIntOrdMes,		edo.PagoMoraMes,
				edo.PagoIVAMoraMes,			edo.FechaProxPag,		edo.FechaProxPagLey,	edo.CapitalProxpago,		edo.InteresProxPago,
				edo.IvaProxPago,		edo.OtrCargosProxPago,		edo.IVAOtrCargosProxPago,edo.PlazoID,				edo.DiasDelPlazo,	
				edo.FrecPlazo,			edo.PlazoEnMes,         	(edo.PagoComisiMes + IFNULL(tmpcom.CantidadMov, Entero_Cero)) AS PagoComisiMes,
		    	(edo.PagoIVAComisiMes + IFNULL(tmpiva.CantidadMov, Entero_Cero)) AS PagoIVAComisiMes
		FROM EDOCTAV2HEADERCRED AS edo
		LEFT JOIN TMPEDOCTAV2COMISIONES AS tmpcom ON edo.CreditoID = tmpcom.CreditoID
		LEFT JOIN TMPEDOCTAV2IVACOMISIONES AS tmpiva ON edo.CreditoID = tmpiva.CreditoID
		WHERE edo.ClienteID = Par_ClienteID
		ORDER BY edo.ProductoCreditoID, edo.CreditoID;

		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2COMISIONES;
		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2IVACOMISIONES;
	END IF;


	-- Detalle de Movimientos del Credito
	IF(Par_Seccion = Sec_DetalleCred) THEN
		SELECT 	FolioProceso,		AnioMes,			CreditoID,		AmortiCreID,		SucursalID,
				ClienteID,			FechaOperacion,		Referencia,		Concepto,			Cargo,
				Abono,				Orden,				Transaccion
		FROM EDOCTAV2DETCRE
		WHERE CreditoID = Par_CreditoID
		ORDER BY CreditoID, FechaOperacion, AmortiCreID, Orden;
	END IF;


	-- Seccion de Cargos Objetados o Transacciones Reclamadas
	IF(Par_Seccion = Sec_CargosObjetados) THEN
		SELECT 	AnioMes,			SucursalID,		ClienteID,		Instrumento,
				FechaIncidencia,	Descripcion,	MontoObjetado,	FechaReporte,
				CargoObjetadoID,	FolioProceso
		FROM EDOCTAV2CAROBJETADOS
		WHERE ClienteID = Par_ClienteID
		ORDER BY FechaIncidencia, Instrumento;
	END IF;


	-- Consulta de Timbre de un Estado de cuenta
	IF(Par_Seccion = Sec_Timbrado) THEN
		SELECT 	ClienteID, 		CFDIFechaEmision, 	CFDINoCertSat, 			CFDIUUID, 			CFDISelloCFD,
				CFDISelloSAT, 	CFDICadenaOrig, 	CFDIFechaCertifica, 	CFDINoCertEmision,	FROM_BASE64(CodigoQR) AS CodigoQR
		FROM EDOCTAV2TIMBRADOINGRE
		WHERE ClienteID = Par_ClienteID
		AND EstatusTimbrado = TimbreExitoso;
	END IF;

	-- Consulta la tabla de abreviaturas
	IF(Par_Seccion = Sec_Abreviaturas) THEN
		SELECT 	Abreviatuta01,	Descripcion01,	Abreviatuta02, 	Descripcion02
		FROM EDOCTAV2ABREVIATURAS;
	END IF;

	-- Datos Del Cliente
	IF(Par_Seccion = Sec_Litros) THEN
  		SELECT AnioMes,	CreditoID,	ClienteID,	LitrosMeta as Meta,	TotalLitros as Total,	LitConsumidos as Consumidos,	CliProcEspecifico FROM EDOCTAV2LITROS
		WHERE ClienteID = Par_ClienteID
		AND CreditoID = Par_CreditoID;
	END IF;


END TerminaStore$$
