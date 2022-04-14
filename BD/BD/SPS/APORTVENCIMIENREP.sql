


-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTVENCIMIENREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTVENCIMIENREP`;
DELIMITER $$

CREATE PROCEDURE `APORTVENCIMIENREP`(
	-- SP para generar el reporte de Aportaciones Vencidas
	Par_FechaInicial        DATE,       -- Fecha inicial
	Par_FechaFinal          DATE,       -- Fecha final
	Par_TipoAportacionID    INT(11),    -- Tipo de aportacion
	Par_SucursalID          INT(11),    -- ID de la sucursal
	Par_PromotorID          INT(11),    -- ID del promotor
	Par_TipoMonedaID        INT(11),    -- Tipo de moneda
	Par_Estatus             CHAR(1),    -- Estatus

	Par_EmpresaID		    INT(11),     -- Parametro de auditoria
	Aud_Usuario        	    INT(11),     -- Parametro de auditoria
	Aud_FechaActual    	    DATE,        -- Parametro de auditoria
	Aud_DireccionIP    	    VARCHAR(15), -- Parametro de auditoria
	Aud_ProgramaID     	    VARCHAR(50), -- Parametro de auditoria
	Aud_Sucursal       	    INT(11),     -- Parametro de auditoria
	Aud_NumTransaccion      BIGINT(20)   -- Parametro de auditoria
)
TerminaStore: BEGIN
	/*DECLARACION DE VARIABLES */
	DECLARE Var_Sentencia       VARCHAR(10000);    -- Alamcena la consulta a ejecuta


	/*DECLARACION DE CONSTANTES */
	DECLARE Cadena_Vacia        VARCHAR(20);
	DECLARE Entero_Cero         INT;
	DECLARE Estatus_Vig         CHAR(1);
	DECLARE Estatus_Pag         CHAR(1);
	DECLARE Cadena_Cero         CHAR(1);

	/* ASIGNACION  DE CONSTANTES */
	SET	Entero_Cero		        := 0;      -- Constante entero cero
	SET Cadena_Vacia            := '';     -- Cadena vacia
	SET Estatus_Vig		        :='N';     -- Estatus vigente
	SET Estatus_Pag		        :='P';     -- Estatus pagado
	SET Cadena_Cero				:='0';     -- Cadena cero


	DROP TEMPORARY TABLE IF EXISTS TMPAPORTVENCIM;
	CREATE TEMPORARY TABLE TMPAPORTVENCIM(
		ConsecutivoID INT(11) NOT NULL AUTO_INCREMENT,
		AportacionID INT(11),
		TipoAportacionID INT(11),
		DescripAportacion VARCHAR(200),
		ClienteID INT(11),
		NombreCompleto VARCHAR(200),
		TasaFija DECIMAL(12,2),
		TasaISR DECIMAL(12,2),
		TasaNeta DECIMAL(12,2),
		Monto DECIMAL(18,2),
		Capital DECIMAL(18,2),
		Plazo INT(11),
		PlazoOriginal INT(11),
		FechaInicio DATE,
		FechaVencimiento DATE,
		InteresRetener DECIMAL(18,2),
		InteresGenerado DECIMAL(18,2),
		InteresRecibir DECIMAL(18,2),
		TotalRecibir DECIMAL(18,2),
		MonedaId INT(11),
		Descripcion VARCHAR(200),
		SucursalID INT(11),
		NombreSucurs VARCHAR(200),
		PromotorID INT(11),
		NombrePromotor VARCHAR(300),
		Estatus VARCHAR(100),
		EstatusAmortizacion CHAR(2),
		UltimaCuota CHAR(1),
		EstatusCond VARCHAR(5),
		ReinversionAut VARCHAR(50),
		Notas VARCHAR(1000),
		Cuenta BIGINT(20),
		Especificaciones VARCHAR(1000),
		TipoDocumento VARCHAR(30),
		Cantidad DECIMAL(18,2),
		TipoInteres VARCHAR(50),
		Condiciones VARCHAR(700),
		TipoDocReno VARCHAR(30),
		CantidadReno DECIMAL(18,2),
		TotalReno DECIMAL(18,2),
		PRIMARY KEY (`ConsecutivoID`,`AportacionID`)
	);

	-- Asignacion de VARIABLES
	SET Var_Sentencia := CONCAT(
		'INSERT INTO TMPAPORTVENCIM (',
			'AportacionID, TipoAportacionID, DescripAportacion, ',
			'ClienteID,NombreCompleto,TasaFija, TasaISR, TasaNeta, Monto, ',
			'Capital,Plazo, PlazoOriginal,FechaInicio, FechaVencimiento,  InteresRetener, ',
			'InteresGenerado, InteresRecibir, TotalRecibir, MonedaId, Descripcion, ',
			'SucursalID,NombreSucurs,PromotorID,NombrePromotor, ',
			'Estatus, EstatusAmortizacion, ',
			'UltimaCuota,EstatusCond,ReinversionAut,Notas,Cuenta, ',
			'Especificaciones, TipoDocumento, Cantidad, TipoInteres, Condiciones, ',
			'TipoDocReno, CantidadReno, TotalReno) ',
		' SELECT ',
			' C.AportacionID,C.TipoAportacionID,TC.Descripcion AS DescripAportacion,',
			' C.ClienteID,CL.NombreCompleto,C.TasaFija,C.TasaISR,C.TasaNeta,C.Monto,',
			' AC.Capital AS Capital,C.Plazo, C.PlazoOriginal, AC.FechaInicio,AC.FechaPago AS FechaVencimiento,AC.InteresRetener,',
			' AC.SaldoProvision AS InteresGenerado, ',
			' (AC.Interes-AC.InteresRetener) AS InteresRecibir,',
			' IF(C.PagoIntCapitaliza = \'S\',',
				' ((AC.SaldoCap)+(AC.Interes-AC.InteresRetener)),',
				' ((AC.Capital)+(AC.Interes-AC.InteresRetener))',
			' ) AS TotalRecibir,',
			' MO.MonedaId, MO.Descripcion, SU.SucursalID,  SU.NombreSucurs, PO.PromotorID, PO.NombrePromotor,',
			' CASE C.Estatus WHEN "N" THEN "VIGENTE" WHEN "P" THEN "PAGADA" END AS Estatus, AC.Estatus AS EstatusAmortizacion, ',
			' IF( (SELECT AC.FechaPago WHERE AC.AportacionID = C.AportacionID ORDER BY AC.AmortizacionID DESC LIMIT 1)',
			' BETWEEN "', Par_FechaInicial ,'" AND "', Par_FechaFinal,'", "S", "N" ) AS UltimaCuota, IFNULL(O.Estatus, "") AS EstatusCond,',
			' CASE ',
				' WHEN (O.Estatus = \'A\' AND O.ReinversionAutomatica=\'S\') THEN \'SI\' ',
				' WHEN (O.Estatus = \'A\' AND O.ReinversionAutomatica=\'N\') THEN \'NO\' ',
				' WHEN O.Estatus = \'P\' THEN \'PENDIENTE\' ',
				' WHEN O.Estatus = \'R\' THEN \'POR AUTORIZAR\' ',
				' ELSE \'\' ',
			' END AS ReinversionAut, CONCAT(C.Notas," \n",O.Notas), C.CuentaAhoID, ACta.Especificaciones,',
			' CASE WHEN COri.ConsolidarSaldos =\'S\' THEN \'CONSOLIDACION\' ELSE UPPER(TDoc.NombreCorto) END AS TipoDocumento,',
			' IFNULL(CASE ',
						' WHEN COri.ConsolidarSaldos =\'S\' THEN ACO.STotalCons ',
						' WHEN C.OpcionAport = 2 THEN C.CantidadReno ',
						' WHEN C.OpcionAport = 3 THEN C.CantidadReno ',
					' ELSE 0.00 END, 0.00) AS Cantidad,',
			' CASE ',
				' WHEN (C.TipoPagoInt = \'V\') THEN \'AL VENCIMIENTO\' ',
				' WHEN (C.TipoPagoInt = \'E\' AND C.PagoIntCapitaliza=\'S\') THEN \'CAPITALIZABLE\' ',
				' WHEN (C.TipoPagoInt = \'E\' AND C.PagoIntCapitaliza=\'N\') THEN \'MENSUAL\' ',
				' ELSE \'\' ',
			' END AS TipoInteres, O.Condiciones,',
			' CASE ',
				' WHEN O.ConsolidarSaldos =\'S\' THEN \'CONSOLIDACION\' ',
				' ELSE UPPER(Op.NombreCorto) ',
			' END AS TipoDocReno,',
			' IFNULL(CASE ',
						' WHEN O.ConsolidarSaldos =\'S\' THEN APC.STotalCons ',
						' WHEN C.OpcionAport = 2 THEN C.CantidadReno ',
						' WHEN C.OpcionAport = 3 THEN C.CantidadReno ',
						' ELSE 0.00 ',
					' END, 0.00) AS CantidadReno, IFNULL(O.MontoRenovacion, 0.00)',
			' FROM APORTACIONES AS C',
				' INNER JOIN TIPOSAPORTACIONES AS TC ON C.TipoAportacionID = TC.TipoAportacionID');

	SET Par_TipoAportacionID:= IFNULL(Par_TipoAportacionID, Entero_Cero);

	IF(Par_TipoAportacionID!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND TC.TipoAportacionID =',CONVERT(Par_TipoAportacionID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,
				' INNER JOIN CLIENTES AS CL ON C.ClienteID = CL.ClienteID',
				' INNER JOIN MONEDAS AS MO ON C.MonedaID = MO.MonedaID');

	SET Par_TipoMonedaID := IFNULL(Par_TipoMonedaID,Entero_Cero);
	IF(Par_TipoMonedaID!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND MO.MonedaID =',CONVERT(Par_TipoMonedaID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,
				' INNER JOIN SUCURSALES AS SU ON CL.SucursalOrigen = SU.SucursalID');

	SET Par_SucursalID:= IFNULL(Par_SucursalID, Entero_Cero);
	IF(Par_SucursalID!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND SU.SucursalID =',CONVERT(Par_SucursalID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,
				' INNER JOIN PROMOTORES AS PO ON CL.PromotorActual = PO.PromotorID');

	SET Par_PromotorID:= IFNULL(Par_PromotorID,Entero_Cero);
	IF(Par_PromotorID!=Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND PO.PromotorID=',CONVERT(Par_PromotorID,CHAR));
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,
				' INNER JOIN AMORTIZAAPORT AS AC ON C.AportacionID = AC.AportacionID');

	SET Par_Estatus:= IFNULL(Par_Estatus,Cadena_Cero);

	IF(Par_Estatus = Cadena_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND ( AC.Estatus = "',Estatus_Vig,'" OR  AC.Estatus = "',Estatus_Pag,'" )');
	END IF;

	IF(Par_Estatus != Cadena_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND AC.Estatus = "',Par_Estatus,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,
				' INNER JOIN APORTACIONOPCIONES TDoc ON C.OpcionAport = TDoc.OpcionID',
				' LEFT JOIN CONDICIONESVENCIMAPORT O ON O.AportacionID = C.AportacionID',
				' LEFT JOIN APORTACIONOPCIONES Op ON Op.OpcionID = IFNULL(O.OpcionAportID,1)',
				-- Consolidacion Al Vencimiento Consolidacion
				' LEFT JOIN (SELECT AportacionID , SUM(TotalCons) AS STotalCons FROM APORTCONSOLIDADAS WHERE AportacionID != AportConsID GROUP BY AportacionID) AS APC ',
							' ON APC.AportacionID = C.AportacionID',
				-- Condicion de vencimiento anterior
				' LEFT JOIN CONDICIONESVENCIMAPORT COri ON COri.AportacionID = C.AportacionRenovada ',
				' LEFT JOIN APORTACIONOPCIONES OpOri ON OpOri.OpcionID = IFNULL(COri.OpcionAportID,1)',
				' LEFT JOIN (SELECT AportacionID , SUM(TotalCons) AS STotalCons FROM APORTCONSOLIDADAS WHERE AportacionID <> AportConsID GROUP BY AportacionID) AS ACO ',
							' ON ACO.AportacionID = C.AportacionRenovada',
				' LEFT JOIN (SELECT AportacionID, GROUP_CONCAT(CONCAT(ClaveUsuario, \' \',FechaActual, \' \',Comentario) ORDER BY FechaActual DESC SEPARATOR "\n") AS Especificaciones ',
							' FROM CAMBIOTASAAPORT GROUP BY AportacionID) AS ACta ',
							' ON ACta.AportacionID = C.AportacionID',
			' WHERE AC.FechaPago BETWEEN ? AND ?' ,
			' ORDER BY C.AportacionID,SU.SucursalID, C.TipoAportacionID, PO.PromotorID, CL.ClienteID, AC.FechaPago ;');

	SET @Sentencia	  = (Var_Sentencia);
	SET @FechaInicial = Par_FechaInicial;
	SET @FechaFinal	  = Par_FechaFinal;

	PREPARE SINVERVENCIMIENREP FROM @Sentencia;
	EXECUTE SINVERVENCIMIENREP USING @FechaInicial, @FechaFinal;
	DEALLOCATE PREPARE SINVERVENCIMIENREP;

	SELECT ConsecutivoID,	AportacionID,			TipoAportacionID,	DescripAportacion,	ClienteID,
		NombreCompleto,		TasaFija,				TasaISR,			TasaNeta,			Monto,
		Capital,			Plazo,					PlazoOriginal,		FechaInicio,		FechaVencimiento,
		InteresRetener,		InteresGenerado,		InteresRecibir,		TotalRecibir, 		MonedaId,
		Descripcion, 		SucursalID, 			NombreSucurs,		PromotorID, 		NombrePromotor,
		Estatus, 			EstatusAmortizacion,	UltimaCuota,		EstatusCond, 		ReinversionAut,
		Notas, 				Cuenta,					IFNULL(Especificaciones,Cadena_Vacia) AS Especificaciones,	TipoDocumento,
		Cantidad,			TipoInteres,		Condiciones,			TipoDocReno,		CantidadReno,
		TotalReno
	FROM TMPAPORTVENCIM;

END TerminaStore$$

