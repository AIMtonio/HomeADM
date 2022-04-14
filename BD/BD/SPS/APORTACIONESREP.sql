-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESREP`;

DELIMITER $$
CREATE PROCEDURE `APORTACIONESREP`(
	/*SP QUE GENERA EL REPORTE DE APORTACIONES POR PERIODO O RANGO DE FECHAS*/
	Par_TipoAportacionID	INT(11),				-- Tipo de aportacion
	Par_PromotorID			INT(11),				-- ID del promotor
	Par_SucursalID			INT(11),				-- ID de la sucursal
	Par_ClienteID			INT(11),				-- ID del cliente
	Par_FechaApertura		DATE,					-- Fecha de Corte/Inicio

	Par_FechaFin			DATE,					-- Fecha de Fin
	Par_Estatus				CHAR(1),				-- Estatus
	Par_NumRep				TINYINT UNSIGNED,		-- Numero de reporte 1- Fecha corte, 2- Periodo
	Aud_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria

	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT					-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Var_FechaVacia			 DATE;
	DECLARE Var_EnteroCero			 INT(11);
	DECLARE Var_EstVigente			 CHAR(1);
	DECLARE Var_EstVacio			 CHAR(1);
	DECLARE Var_EstPrevencido		 CHAR(1);

	DECLARE Var_EstPagada			 CHAR(1);
	DECLARE Var_EstCancelada		 CHAR(1);
	DECLARE Var_AmortEstPagada		 CHAR(1);
	DECLARE Var_SiCapitaliza		 CHAR(1);
	DECLARE Var_CargoNatMovimiento	 CHAR(1);

	DECLARE Var_AbonoNatMovimiento	 CHAR(1);
	DECLARE Var_TipoMovAportID		 INT(11);
	DECLARE Var_ExternasTipoCuenta	 CHAR(1);
	DECLARE Var_EstAutorizado		 CHAR(1);
	DECLARE Var_Cadena_Vacia		 VARCHAR(20);
	DECLARE Var_MovCapital			INT;				-- Constante ID MOV Capital
	DECLARE Var_MovInteres			INT;				-- Constante ID MOV Interes
	DECLARE Var_MovISR				INT;				-- Constante ID MOV ISR
	DECLARE Var_AlVencimiento		CHAR(1);			-- Constante al Vencimiento
	DECLARE Var_DecimalCero			DECIMAL(12,2);		-- Constante Decimal Cero
	DECLARE Var_ValorSI				CHAR(1);			-- Constante SI
	DECLARE Var_ValorNO				CHAR(1);			-- Constante NO
	DECLARE	TipoReg_Aport			INT(11);
	DECLARE	TipoReg_CondV			INT(11);


	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia	 VARCHAR(5000);
	DECLARE Var_FecIniMes	 DATE;
	DECLARE Var_FecFinMes	 DATE;
	DECLARE Var_SentFiltro	 VARCHAR(5000);
	DECLARE Var_FechaVenAnt	 DATE;						-- Fecha de VEncimiento Anticipado
	DECLARE Var_NumReg		 INT;						-- Numero de Registros
	DECLARE Var_Contador	 INT;						-- Numero de REgistros
	DECLARE Var_Capital		 DECIMAL(12,2);				-- Variable para almacenar Capital
	DECLARE Var_Interes		 DECIMAL(12,2);				-- Variable para almacenar Inetres
	DECLARE Var_ISR			 DECIMAL(12,2);				-- Variable para almacenar ISR
	DECLARE Var_CapitalAct	 DECIMAL(12,2);				-- Variable para almacenar Capital Actual
	DECLARE Var_InteresAct	 DECIMAL(12,2);				-- Variable para almacenar Interes Actual
	DECLARE Var_ISRAct		 DECIMAL(12,2);				-- Variable para almacenar ISR Actual
	DECLARE Var_AportaRen	 INT(11);					-- Variable para al,acenar AportacionID


	-- ASIGNACION DE CONSTANTES
	SET Var_FechaVacia			:= '1900-01-01';-- Fecha para valores vacios
	SET Var_EnteroCero			:= 0;			-- Constante Valor Cero
	SET Var_EstVigente			:= 'N';			-- Estatus Vigente de una Aportacion
	SET Var_EstVacio			:= 'T';			-- Valor para estatus todos
	SET Var_EstPrevencido		:= 'V';			-- Estatus Prevencido de una aportacion

	SET Var_EstPagada			:= 'P';			-- Estatus Pagada de  una aportacion
	SET Var_EstCancelada		:= 'C';			-- Estatus cancelada de  una aportacion
	SET Var_AmortEstPagada		:= 'P';			-- Estatus Pagada de una amorticazacion de aportacion
	SET Var_SiCapitaliza		:= 'S';			-- Si capitaliza interes
	SET Var_CargoNatMovimiento	:= 'C';			-- Tipo de movimiento Cargo

	SET Var_AbonoNatMovimiento	:= 'A';			-- Tipo de movimiento Abono
	SET Var_TipoMovAportID		:= 100;			-- Tipo de Movimiento que sea igual a 100
	SET Var_ExternasTipoCuenta	:= 'E';			-- Tipo de cuenta destino: Externas
	SET Var_EstAutorizado		:= 'A';			-- Indica el Estatus Autorizado de la cuenta Transfer
	SET Var_Cadena_Vacia		:= '';			-- Constante cadena vacia
	SET	Var_MovCapital			:= 602;			-- Constante ID MOV Capital
	SET	Var_MovInteres			:= 603;			-- Constante ID MOV Interes
	SET	Var_MovISR				:= 605;			-- Constante ID MOV ISR
	SET	Var_AlVencimiento		:= 'V';			-- Constante al Vencimiento
	SET	Var_ValorSI				:= 'S';			-- Constante SI
	SET	Var_ValorNO				:= 'N';			-- Constante NO
	SET	TipoReg_Aport			:= 01;			-- Tipo de Registro Alta de aportaciones.
	SET	TipoReg_CondV			:= 02;			-- Tipo de Registro Alta de condiciones de vencimiento.

	DROP TEMPORARY TABLE IF EXISTS TMPAPORTVIG;
	CREATE TEMPORARY TABLE TMPAPORTVIG(
		ConsecutivoID 			INT(11) NOT NULL AUTO_INCREMENT,
		AportacionID 			INT(11),
		TipoAportacionID 		INT(11),
		DescripcionAportacion 	VARCHAR(200),
		CuentaAhoID 			BIGINT(20),
		ClienteID 				INT(11),
		FechaInicio 			DATE,
		FechaVencimiento 		DATE,
		Monto 					DECIMAL(18,2),
		Plazo 					INT(11),
		TasaFija 				DECIMAL(12,2),
		TasaISR 				DECIMAL(12,2),
		Estatus 				CHAR(1),
		FechaApertura 			DATE,
		TasaFV 					CHAR(1),
		Descripcion 			VARCHAR(200),
		CalculoInteres 			INT(11),
		FormulaInteres 			VARCHAR(50),
		SobreTasa 				DECIMAL(12,2),
		PisoTasa 				DECIMAL(12,2),
		TechoTasa 				DECIMAL(12,2),
		TasaBase 				DECIMAL(12,2),
		TasaBaseDes 			VARCHAR(20),
		NombreCompleto 			VARCHAR(300),
		SucursalOrigen 			INT(11),
		NombreSucurs 			VARCHAR(200),
		PromotorActual 			INT(11),
		NombrePromotor 			VARCHAR(300),
		FechaAlta 				DATE,
		PlazoOriginal 			INT(11),
		InteresGenerado 		DECIMAL(18,2),
		InteresRetener 			DECIMAL(18,2),
		InteresRecibir 			DECIMAL(18,2),
		tipoPagoInt 			VARCHAR (100),
		NombreCorto 			VARCHAR (100),
		Cantidad 				DECIMAL(18,2),
		MontoGlobal 			DECIMAL(18,2),
		DiaPago 				VARCHAR(50),
		InstitucionUno 			VARCHAR(200),
		CuentaDestUno 			BIGINT(20),
		InstitucionDos 			VARCHAR(200),
		CuentaDestDos 			BIGINT(20),
		InstitucionTres 		VARCHAR(200),
		CuentaDestTres 			BIGINT(20),
		TasaSugerida 			DECIMAL(12,2),
		DiferenciaTasa 			VARCHAR(50),
		ReinversionAut 			VARCHAR(50),
		Notas 					VARCHAR(1000),
		SaldoCap 				DECIMAL(18,2) DEFAULT 0.00,
		Especificaciones 		VARCHAR(700) DEFAULT '',
		FechaVenAnt 			DATE DEFAULT '1900-01-01',
		DineroNuevo 			DECIMAL(18,2) DEFAULT 0.00,
		MontoLiqApoAnt 			DECIMAL(20,2) DEFAULT 0.00,
		InteresIncRenov 		DECIMAL(18,2) DEFAULT 0.00,
		InteresPagPeriodo 		DECIMAL(18,2) DEFAULT 0.00,
		InteresDevPeriodo 		DECIMAL(18,2) DEFAULT 0.00,
		InteresDevMes 			DECIMAL(18,2) DEFAULT 0.00,
		InteresDevNoPagPeriodo 	DECIMAL(18,2) DEFAULT 0.00,
		MontoRenovado 			DECIMAL(18,2) DEFAULT 0.00,
		DescEstatus				VARCHAR(15)	DEFAULT '',
		PRIMARY KEY (`ConsecutivoID`,`AportacionID`)
	);

	SET Par_FechaApertura	:= IFNULL(Par_FechaApertura, Var_FechaVacia);
	SET Par_FechaFin 		:= IFNULL(Par_FechaFin, Par_FechaApertura);


	DROP TEMPORARY TABLE IF EXISTS TMPAPORTFILTRO;
	CREATE TEMPORARY TABLE TMPAPORTFILTRO(
		AportacionID 			INT(11),
		Estatus 				CHAR(1) DEFAULT NULL,
		PRIMARY KEY (`AportacionID`),
		INDEX idxTMPAPORTFILTRO_1(Estatus)
	);

	SET Var_SentFiltro := 'INSERT INTO TMPAPORTFILTRO (AportacionID, Estatus)';
	SET Var_SentFiltro := CONCAT(Var_SentFiltro, 'SELECT Ce.AportacionID,
							CASE
							WHEN Ce.Estatus = \'C\' AND FechaVenAnt != "',Var_FechaVacia,'"
											THEN IF (Ce.FechaVenAnt > "',Par_FechaFin,'", "',Var_EstVigente,'", "',Var_EstPrevencido,'")
							WHEN Ce.Estatus = \'P\' THEN IF (Ce.FechaPago > "',Par_FechaFin,'","',Var_EstVigente,'","',Var_EstPagada,'")
							WHEN Ce.Estatus = \'C\' THEN Ce.Estatus
							WHEN Ce.Estatus = \'N\' THEN Ce.Estatus
							ELSE Ce.Estatus
						END AS Estatus
						FROM APORTACIONES Ce
						WHERE ' );
	IF (Par_NumRep = 1) THEN
		SET Var_SentFiltro := CONCAT(Var_SentFiltro, ' Ce.FechaInicio <=  "', Par_FechaApertura, '" ' );
	ELSE
		SET Var_SentFiltro := CONCAT(Var_SentFiltro, ' Ce.FechaInicio >=  "', Par_FechaApertura, '" ' );
		SET Var_SentFiltro := CONCAT(Var_SentFiltro, ' AND Ce.FechaInicio <= "',Par_FechaFin, '" ' );
	END IF;

	SET @Sentencia  = (Var_SentFiltro);

	PREPARE SPAPORTAFILTROREP FROM @Sentencia;
	EXECUTE SPAPORTAFILTROREP;
	DEALLOCATE PREPARE SPAPORTAFILTROREP;


	-- Asignacion de VARIABLES
    SET Var_Sentencia := (
							'INSERT INTO TMPAPORTVIG (AportacionID, TipoAportacionID, DescripcionAportacion, CuentaAhoID,
							ClienteID, FechaInicio, FechaVencimiento, Monto, PlazoOriginal,
							TasaFija, TasaISR, Estatus, FechaApertura, TasaFV,
							Descripcion, CalculoInteres, FormulaInteres, SobreTasa, PisoTasa,
							TechoTasa, TasaBase, TasaBaseDes, NombreCompleto, SucursalOrigen,
							NombreSucurs, PromotorActual, NombrePromotor, FechaAlta, Plazo,
							InteresGenerado, InteresRetener, InteresRecibir, tipoPagoInt, NombreCorto,
							Cantidad, MontoGlobal, DiaPago,ReinversionAut,Notas,
							Especificaciones, FechaVenAnt, DescEstatus, DineroNuevo, MontoRenovado,
							MontoLiqApoAnt)'
							);

	SET Var_Sentencia := CONCAT(Var_Sentencia, 'SELECT Ce.AportacionID, Ce.TipoAportacionID, Ti.Descripcion AS DescripcionAportacion, Ce.CuentaAhoID,
												Ce.ClienteID, Ce.FechaInicio, Ce.FechaVencimiento, Ce.Monto, Ce.Plazo,
												Ce.TasaFija, Ce.TasaISR, Fil.Estatus, Ce.FechaApertura, Ti.TasaFV,
												Ti.Descripcion, Ce.CalculoInteres,
												CASE Ce.CalculoInteres
													WHEN "1" THEN "Tasa Fija"
													WHEN "2" THEN "Tasa Inicio Mes + Puntos"
												ELSE "No Definido" END AS FormulaInteres, Ce.SobreTasa, Ce.PisoTasa, Ce.TechoTasa, Ce.TasaBase,
													IFNULL(Tb.Nombre, "NA") AS TasaBaseDes, Cl.NombreCompleto, Cl.SucursalOrigen, Su.NombreSucurs,
													Cl.PromotorActual, Pr.NombrePromotor,Cl.FechaAlta, Ce.PlazoOriginal, Ce.InteresGenerado,
													Ce.InteresRetener, Ce.InteresRecibir,
												CASE
													WHEN (Ce.TipoPagoInt = \'V\') THEN \'AL VENCIMIENTO\'
													WHEN (Ce.TipoPagoInt = \'E\'	AND Ce.PagoIntCapitaliza = \'S\') THEN \'CAPITALIZABLE\'
													WHEN (Ce.TipoPagoInt = \'E\'	AND Ce.PagoIntCapitaliza = \'N\') THEN \'MENSUAL\'
												END AS tipoPagoInt,
												CASE
														WHEN COri.ConsolidarSaldos =\'S\' THEN \'CONSOLIDACION\'
														ELSE UPPER(op.NombreCorto)
												END AS NombreCorto,
												CASE
													WHEN Ce.OpcionAport = 2 THEN Ce.CantidadReno
													WHEN Ce.OpcionAport = 3 THEN Ce.CantidadReno
													ELSE 0
												END AS Cantidad, Ce.MontoGlobal, IF(Ce.TipoPagoInt=\'V\',Ce.FechaPago,Ce.DiasPago) AS DiaPago,
												CASE
													WHEN (cond.Estatus = \'A\' AND cond.ReinversionAutomatica=\'S\') THEN \'SI\'
													WHEN (cond.Estatus = \'A\' AND cond.ReinversionAutomatica=\'N\') THEN \'NO\'
													WHEN cond.Estatus = \'P\' THEN \'PENDIENTE\'
													WHEN cond.Estatus = \'R\' THEN \'POR AUTORIZAR\'
													ELSE \'\'
												END AS ReinversionAut,
												TRIM(CONCAT(IFNULL(Ce.Notas,"")," ",IFNULL(cond.Notas,""))),
												IFNULL(ACta.Especificaciones,"") AS Especificaciones,
												Ce.FechaVenAnt,
												CASE
													WHEN Fil.Estatus = \'V\' THEN \'PREVENCIDO\'
													WHEN Fil.Estatus = \'C\' THEN \'CANCELADO\'
													WHEN Fil.Estatus = \'P\' THEN \'PAGADO\'
													WHEN Fil.Estatus = \'N\' THEN \'VIGENTE\'
												END AS DescEstatus,
												CASE
													WHEN Ce.OpcionAport = 1 THEN Ce.Monto
													WHEN COri.ConsolidarSaldos =\'S\' THEN Cons.STotalCons
													WHEN Ce.OpcionAport = 2 THEN Ce.CantidadReno
													WHEN Ce.OpcionAport = 5 THEN Ce.Monto
													ELSE 0.00 END AS DineroNuevo,
												IFNULL(CASE WHEN cond.ConsolidarSaldos != \'S\' THEN cond.MontoRenovacion
													WHEN cond.ConsolidarSaldos = \'S\' THEN Cons.STotalCons
													ELSE 0 END, 0)AS MontoRenovado,
												IFNULL(CASE WHEN COri.ConsolidarSaldos != \'S\' THEN COri.Monto
													ELSE 0 END, 0)AS MontoLiqApoAnt
													FROM TMPAPORTFILTRO Fil INNER JOIN APORTACIONES Ce ON Fil.AportacionID = Ce.AportacionID
												INNER JOIN TIPOSAPORTACIONES Ti ON ( Ce.TipoAportacionID = Ti.TipoAportacionID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN TIPO DE APORTACION */
	IF(IFNULL(Par_TipoAportacionID, Var_EnteroCero) > Var_EnteroCero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  Ce.TipoAportacionID = ',Par_TipoAportacionID, ' ' );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' )
		INNER JOIN CLIENTES Cl ON ( Ce.ClienteID = Cl.ClienteID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN NUMERO DE cliente */
	IF(IFNULL(Par_ClienteID, Var_EnteroCero) > Var_EnteroCero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  Ce.ClienteID = ',Par_ClienteID, ' ' );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' )
		INNER JOIN SUCURSALES Su ON ( Cl.SucursalOrigen = Su.SucursalID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN NUMERO DE SUCURSAL */
	IF(IFNULL(Par_SucursalID, Var_EnteroCero) > Var_EnteroCero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  Cl.SucursalOrigen = ',Par_SucursalID, ' ' );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' )
		INNER JOIN PROMOTORES Pr ON ( Cl.PromotorActual = Pr.PromotorID ');

	/* SE COMPARA PARA SABER SI SE RECIBE UN NUMERO DE PROMOTOR */
	IF(IFNULL(Par_PromotorID, Var_EnteroCero) > Var_EnteroCero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND  Cl.PromotorActual = ',Par_PromotorID, ' ' );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' )
		LEFT JOIN TASASBASE Tb ON ( Ce.TasaBase = Tb.TasaBaseID) ');

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		INNER JOIN APORTACIONOPCIONES op ON Ce.OpcionAport=op.OpcionID');

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		LEFT JOIN CONDICIONESVENCIMAPORT cond ON Ce.AportacionID=cond.AportacionID');

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		LEFT JOIN CONDICIONESVENCIMAPORT COri ON COri.AportacionID = Ce.AportacionRenovada
		LEFT JOIN APORTACIONOPCIONES OpOri ON OpOri.OpcionID = IFNULL(COri.OpcionAportID,1)');

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		LEFT JOIN (SELECT AportacionID , SUM(TotalCons) AS STotalCons, SUM(TotalAport) AS STotalAport
		 FROM APORTCONSOLIDADAS
		GROUP BY AportacionID) AS Cons ON Cons.AportacionID = Ce.AportacionID ');

	SET Var_Sentencia := CONCAT(Var_Sentencia, '
		LEFT JOIN (SELECT AportacionID, GROUP_CONCAT(CONCAT(ClaveUsuario, \' \',FechaActual, \' \',Comentario) ORDER BY FechaActual DESC SEPARATOR "\n") AS Especificaciones
		FROM CAMBIOTASAAPORT GROUP BY AportacionID) AS ACta
		ON ACta.AportacionID = Ce.AportacionID');

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' WHERE ' );

	/*FILTRO POR ESTATUS*/
	IF(IFNULL(Par_Estatus, Var_EstVacio) = Var_EstVacio) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' Fil.Estatus IN(\'N\', \'P\', \'C\', \'V\') ' );
	ELSE -- PREVENCIDO

		SET Var_Sentencia := CONCAT(Var_Sentencia, ' Fil.Estatus ="',Par_Estatus,'" ' );
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia, ' ORDER BY Cl.SucursalOrigen, Ce.ClienteID, Cl.PromotorActual;');

	SET @Sentencia  = (Var_Sentencia);

	PREPARE SPAPORTACIONESREP FROM @Sentencia;
	EXECUTE SPAPORTACIONESREP;
	DEALLOCATE PREPARE SPAPORTACIONESREP;

	# SE GUARDAN LAS APORTACIONES QUE HAYAN TENIDO ESPECIFICACIÓN DE TASA.
	DROP TABLE IF EXISTS `TMPCAMBIOTASAAPORT` ;
	CREATE TABLE `TMPCAMBIOTASAAPORT` (
		`ConsecutivoID` bigint(20) NOT NULL COMMENT 'ID Consecutivo',
		`AportacionID` bigint(20) DEFAULT NULL COMMENT 'ID de la aportacion',
		INDEX(ConsecutivoID,AportacionID)
	);

	# SE GUARDAN AQUELLOS CAMBIOS EXCEPTO LOS DE CONDICIONES DE VENCIMIENTO (APORTACIONES NO NACIDAS).
	INSERT INTO TMPCAMBIOTASAAPORT (
		ConsecutivoID,			AportacionID)
	SELECT
		MAX(CAM.ConsecutivoID),	TMP.AportacionID
	FROM TMPAPORTVIG TMP
		INNER JOIN CAMBIOTASAAPORT CAM ON TMP.AportacionID = CAM.AportacionID
	WHERE CAM.TipoRegistro = TipoReg_Aport
	GROUP BY TMP.AportacionID;

	-- ACTUALIZACIÓN DE TASAS SUGERIDAS Y SI TUVO CAMBIO DE TASA.
	UPDATE TMPAPORTVIG A
		INNER JOIN TMPCAMBIOTASAAPORT T ON A.AportacionID=T.AportacionID
		INNER JOIN CAMBIOTASAAPORT C
			ON T.ConsecutivoID=C.ConsecutivoID AND T.AportacionID=C.AportacionID
	SET
		A.Especificaciones = LEFT(CONCAT(C.ClaveUsuario,' ',C.FechaActual,' ',C.Comentario),700),
		A.TasaSugerida = C.TasaSugerida,
		A.DiferenciaTasa =
			CASE
				WHEN A.TasaFija>C.TasaSugerida THEN CONCAT('+',A.TasaFija-C.TasaSugerida)
				WHEN A.TasaFija<C.TasaSugerida THEN CONCAT('-',C.TasaSugerida-A.TasaFija)
				ELSE ''
			END;

	-- ACTUALIZACIÓN DE TASAS SUGERIDAS DE LOS QUE NO HUBO CAMBIO DE TASA.
	UPDATE TMPAPORTVIG A
	SET
		A.TasaSugerida = A.TasaFija
	WHERE A.TasaSugerida IS NULL;

	SET @conta := 1;
	SET @totalReg := (SELECT COUNT(*) FROM TMPAPORTVIG);
	-- INICIO DEL CICLO PARA ACTUALIZAR CUENTAS E INSTITUCIONES
	WHILE @conta <= @totalReg DO
		SET @tmpCliente := (SELECT ClienteID FROM TMPAPORTVIG WHERE ConsecutivoID=@conta);
		SET @tmpCuenta := 0;
		SET @tmpNombre := '';
		-- Cuenta 1
	SELECT ctas.Clabe, ins.NombreCorto
		INTO @tmpCuenta, @tmpNombre
	FROM CUENTASTRANSFER ctas
		INNER JOIN INSTITUCIONES ins ON ctas.InstitucionID = ins.ClaveParticipaSpei
	WHERE ctas.ClienteID = @tmpCliente
		AND ctas.TipoCuenta = Var_ExternasTipoCuenta
		AND ctas.Estatus = Var_EstAutorizado
	ORDER BY ctas.CuentaTranID ASC
	LIMIT 1;

	UPDATE TMPAPORTVIG
		SET InstitucionUno = IFNULL(@tmpNombre,''),
		CuentaDestUno = IFNULL(@tmpCuenta,0)
	WHERE ConsecutivoID=@conta;

	-- Cuenta 2
	SET @tmpCuenta := 0;
	SET @tmpNombre := '';

	SELECT ctas.Clabe, ins.NombreCorto
	INTO @tmpCuenta, @tmpNombre
	FROM CUENTASTRANSFER ctas
		INNER JOIN INSTITUCIONES ins ON ctas.InstitucionID = ins.ClaveParticipaSpei
	WHERE ctas.ClienteID = @tmpCliente
		AND ctas.TipoCuenta = Var_ExternasTipoCuenta
		AND ctas.Estatus = Var_EstAutorizado
	ORDER BY ctas.CuentaTranID ASC
	LIMIT 1,1;

	UPDATE TMPAPORTVIG
		SET InstitucionDos = IFNULL(@tmpNombre,0),
			CuentaDestDos = IFNULL(@tmpCuenta,0)
	WHERE ConsecutivoID=@conta;

	-- Cuenta 3
	SET @tmpCuenta := 0;
	SET @tmpNombre := '';

	SELECT ctas.Clabe, ins.NombreCorto
	INTO @tmpCuenta, @tmpNombre
	FROM CUENTASTRANSFER ctas
		INNER JOIN INSTITUCIONES ins ON ctas.InstitucionID = ins.ClaveParticipaSpei
	WHERE ctas.ClienteID = @tmpCliente
		AND ctas.TipoCuenta = Var_ExternasTipoCuenta
		AND ctas.Estatus = Var_EstAutorizado
	ORDER BY ctas.CuentaTranID ASC
	LIMIT 2,1;

	UPDATE TMPAPORTVIG
		SET InstitucionTres = IFNULL(@tmpNombre,0),
			CuentaDestTres = IFNULL(@tmpCuenta,0)
	WHERE ConsecutivoID=@conta;

	SET @conta := @conta +1;
	END WHILE; -- FIN DEL CICLO PARA ACTUALIZAR LAS CUENTAS

	-- Se asigna el capital de al aportacion sin considerar capitalizacion
	UPDATE TMPAPORTVIG TMP
		INNER JOIN APORTACIONES Apo ON TMP.AportacionID = Apo.AportacionID
	SET TMP.SaldoCap = Apo.Monto;

	DROP TEMPORARY TABLE IF EXISTS TMPAPORTVIGAMO;
	CREATE TEMPORARY TABLE TMPAPORTVIGAMO(
		AportacionID 	INT(11),
		AmortizacionID 	INT(11),
	 KEY (`AportacionID`,`AmortizacionID`)
	 );

	-- Obtener la ultima amortizacion de las aportaciones pagadas
	INSERT INTO TMPAPORTVIGAMO (
		AportacionID, AmortizacionID)
	SELECT 	Amo.AportacionID,
			MAX(Amo.AmortizacionID) AS MAmortizacionID
		FROM TMPAPORTVIG Tmp INNER JOIN APORTACIONES Apo
			ON Tmp.AportacionId 		= Apo.AportacionId
			AND Apo.PagoIntCapitaliza 	= Var_SiCapitaliza
			INNER JOIN AMORTIZAAPORT Amo ON Tmp.AportacionId 	= Amo.AportacionId
		WHERE Apo.Estatus = Var_EstPagada
		  AND Amo.FechaInicio <= Par_FechaFin
		GROUP BY Amo.AportacionID;

	-- Obtener la ultima amortizacion de las aportaciones con vencimiento anticipado
	INSERT INTO TMPAPORTVIGAMO (
		AportacionID, AmortizacionID)
	SELECT Amo.AportacionID,
			MAX(Amo.AmortizacionID) AS MAmortizacionID
		FROM TMPAPORTVIG Tmp INNER JOIN APORTACIONES Apo
			ON Tmp.AportacionId 		= Apo.AportacionId
			AND Apo.PagoIntCapitaliza 	= Var_SiCapitaliza
			INNER JOIN AMORTIZAAPORT Amo ON Tmp.AportacionId 	= Amo.AportacionId
		WHERE (Apo.Estatus = Var_EstCancelada
			AND Apo.FechaVenAnt != Var_FechaVacia)
			AND Amo.FechaInicio <= Apo.FechaVenAnt
			AND Amo.FechaInicio <= Par_FechaFin
		GROUP BY Amo.AportacionID;

	-- Obtener la amortizacion en curso
	INSERT INTO TMPAPORTVIGAMO (
		AportacionID, AmortizacionID)
	SELECT Amo.AportacionID,
		MAX(Amo.AmortizacionID) AS MAmortizacionID
		FROM TMPAPORTVIG Tmp INNER JOIN APORTACIONES Apo
			ON Tmp.AportacionId 		= Apo.AportacionId
			AND Apo.PagoIntCapitaliza 	= Var_SiCapitaliza
			INNER JOIN AMORTIZAAPORT Amo ON Tmp.AportacionId = Amo.AportacionId
		WHERE Apo.Estatus = Var_EstVigente
			AND Amo.FechaInicio <= Par_FechaFin
		GROUP BY Amo.AportacionID;

	-- Se actualizada el saldo de capital para las aportaciones que capitaliza interes
	UPDATE TMPAPORTVIG TMP
		INNER JOIN TMPAPORTVIGAMO Apo ON TMP.AportacionID = Apo.AportacionID
		INNER JOIN AMORTIZAAPORT Amo ON Apo.AportacionID = Amo.AportacionID
		AND Apo.AmortizacionID = Amo.AmortizacionID
	SET TMP.SaldoCap =  Amo.SaldoCap;

	TRUNCATE TABLE TMPAPORTVIGAMO;
	-- Fin Saldo capital


	DROP TEMPORARY TABLE IF EXISTS TMPAPORTAMOCAPINT;
	CREATE TEMPORARY TABLE TMPAPORTAMOCAPINT(
		AportacionID 	INT(11),
		AmortizacionID 	INT(11),
		Capital 		DECIMAL(18,2),
		Interes 		DECIMAL(18,2),
	KEY (`AportacionID`,`AmortizacionID`)
	);

	-- Intereses provenientes de Increm de Renov
	-- Interes Proveniente de consolidacion
	DROP TEMPORARY TABLE IF EXISTS TMPINTDEV;
	CREATE TEMPORARY TABLE TMPINTDEV(
		AportacionID 			INT(11),
		IntDevCon	 			DECIMAL(14,2) DEFAULT 0.00,
		KEY (`AportacionID`)
	);

	INSERT INTO TMPINTDEV (AportacionID,IntDevCon)
		SELECT Tmp.AportacionID, (SUM(ACon.Interes)-SUM(ACon.ISR)) AS Intereses
			FROM TMPAPORTVIG Tmp
			INNER JOIN APORTACIONES Apo ON Tmp.AportacionID = Apo.AportacionID
			INNER JOIN CONDICIONESVENCIMAPORT Ven ON Ven.AportacionID = Apo.AportacionRenovada
			INNER JOIN APORTCONSOLIDADAS ACon ON Ven.AportacionID = ACon.AportacionID
			INNER JOIN APORTACIONES ApoCon ON ACon.AportConsID = ApoCon.AportacionID
			WHERE Ven.ConsolidarSaldos = Var_ValorSI
			  AND ApoCon.TipoPagoInt = Var_AlVencimiento
			GROUP BY Tmp.AportacionID;

	UPDATE TMPAPORTVIG TMP
		INNER JOIN TMPINTDEV IntDev ON TMP.AportacionID = IntDev.AportacionID
		SET TMP.InteresIncRenov = IntDev.IntDevCon;
	-- Fin - InteresIncRenov

	-- Obtener los Intereses pagados en el periodo
	TRUNCATE TABLE TMPAPORTAMOCAPINT;
	IF(Par_NumRep = 1) THEN -- Fecha corte
		-- Pagados en el mes de acuerdo a la fecha de corte
		SET Var_FecIniMes := DATE_ADD(Par_FechaApertura, interval -1*(day(Par_FechaApertura))+1 day);
		SET Var_FecFinMes := LAST_DAY(Par_FechaApertura);

		INSERT INTO TMPAPORTAMOCAPINT(AportacionID, Interes)
		SELECT AportacionID, SUM(Monto) AS Interes
			FROM APORTMOV
				WHERE NatMovimiento 	= Var_AbonoNatMovimiento
				  AND TipoMovAportID 	= Var_TipoMovAportID
				  AND Fecha 			BETWEEN Var_FecIniMes AND Var_FecFinMes
			GROUP BY AportacionID;
	ELSE -- 2- Periodo
		INSERT INTO TMPAPORTAMOCAPINT(AportacionID, Interes)
			SELECT AportacionID, SUM(Monto) AS Interes
			FROM APORTMOV
				WHERE NatMovimiento 	= Var_AbonoNatMovimiento
				  AND TipoMovAportID 	= Var_TipoMovAportID
				  AND Fecha 			BETWEEN Par_FechaApertura AND Par_FechaFin
			GROUP BY AportacionID;
	END IF;

	-- Actualizar los Intereses pagados en el periodo
	UPDATE TMPAPORTVIG TMP
			INNER JOIN TMPAPORTAMOCAPINT Inp ON TMP.AportacionID = Inp.AportacionID
		SET TMP.InteresPagPeriodo = Inp.Interes;

	TRUNCATE TABLE TMPAPORTAMOCAPINT;
	-- Fin de Intereses pagados en el periodo

	-- Obtener los Intereses devengados no pagados en el periodo
	DROP TEMPORARY TABLE IF EXISTS TMPAPORTADEV;
	CREATE TEMPORARY TABLE TMPAPORTADEV(
		AportacionID 			INT(11),
		InteresDevNoPagPeriodo 	DECIMAL(18,2),
	KEY (`AportacionID`)
	);

	IF(Par_NumRep = 1) THEN -- Fecha corte
		SET Var_FecIniMes := DATE_ADD(Par_FechaApertura, interval -1*(day(Par_FechaApertura))+1 day);
		SET Var_FecFinMes := LAST_DAY(Par_FechaApertura);

		INSERT INTO TMPAPORTADEV
		SELECT AportacionID,
				SUM(CASE WHEN NatMovimiento = Var_CargoNatMovimiento THEN Monto ELSE 0 END)-
				SUM(CASE WHEN NatMovimiento = Var_AbonoNatMovimiento THEN Monto ELSE 0 END) AS InteresDevNoPagPeriodo
			FROM APORTMOV
				WHERE Fecha 		<= Var_FecFinMes
				AND TipoMovAportID 	= Var_TipoMovAportID
			GROUP BY TipoMovAportID, AportacionID;
	ELSE -- 2 Periodo
		INSERT INTO TMPAPORTADEV
		SELECT AportacionID,
				SUM(CASE WHEN NatMovimiento = Var_CargoNatMovimiento THEN Monto ELSE 0 END)-
				SUM(CASE WHEN NatMovimiento = Var_AbonoNatMovimiento THEN Monto ELSE 0 END) AS InteresDevNoPagPeriodo
			FROM APORTMOV
				WHERE Fecha 		<= Par_FechaFin
				AND TipoMovAportID 	= Var_TipoMovAportID
			GROUP BY TipoMovAportID, AportacionID;
	END IF;

	UPDATE TMPAPORTVIG TMP
		INNER JOIN TMPAPORTADEV dev ON TMP.AportacionID = dev.AportacionID
	SET TMP.InteresDevNoPagPeriodo = dev.InteresDevNoPagPeriodo;
	-- Fin de InteresDevNoPagPeriodo

	-- Inicio Actualiza el Intereses por denvengar en el periodo
	IF(Par_NumRep = 1) THEN -- Fecha corte
		SET Var_FecIniMes := DATE_ADD(Par_FechaApertura, interval -1*(day(Par_FechaApertura))+1 day);
		SET Var_FecFinMes := LAST_DAY(Par_FechaApertura);

		-- Obtener la amortizacion en curso de acuerdo al mes
		INSERT INTO TMPAPORTVIGAMO (
				AportacionID, AmortizacionID)
		SELECT 	Amo.AportacionID, MAX(Amo.AmortizacionID) AS MAmortizacionID
			FROM TMPAPORTVIG Tmp INNER JOIN AMORTIZAAPORT Amo ON Tmp.AportacionId = Amo.AportacionId
			WHERE Amo.FechaInicio 		<= 	Var_FecIniMes
			  AND Amo.FechaVencimiento 	> 	Var_FecFinMes
			GROUP BY Amo.AportacionID;

	ELSE -- 2 Periodo
		-- Obtener la amortizacion en curso de acuerdo al periodo
		INSERT INTO TMPAPORTVIGAMO (
				AportacionID, AmortizacionID)
		SELECT 	Amo.AportacionID, MAX(Amo.AmortizacionID) AS MAmortizacionID
			FROM TMPAPORTVIG Tmp INNER JOIN AMORTIZAAPORT Amo ON Tmp.AportacionId = Amo.AportacionId
			WHERE Amo.FechaInicio 		<=  Par_FechaFin
			GROUP BY Amo.AportacionID;
	END IF;

	-- Se actualiza el interes por devengar (Interes - Devengado)
	UPDATE TMPAPORTVIG TMP
		INNER JOIN TMPAPORTVIGAMO Apo ON TMP.AportacionID 		= Apo.AportacionID
		INNER JOIN AMORTIZAAPORT Amo ON Apo.AportacionID 		= Amo.AportacionID
									 AND Apo.AmortizacionID 	= Amo.AmortizacionID
		SET TMP.InteresDevPeriodo =  Amo.Interes - TMP.InteresDevNoPagPeriodo;

	TRUNCATE TABLE TMPAPORTVIGAMO;
	-- Fin - InteresDevPeriodo

	-- Interes Devengado en el mes o periodo
	TRUNCATE TABLE TMPAPORTAMOCAPINT;

	IF(Par_NumRep = 1) THEN -- Fecha corte
		SET Var_FecIniMes := DATE_ADD(Par_FechaApertura, interval -1*(day(Par_FechaApertura))+1 day);
		SET Var_FecFinMes := LAST_DAY(Par_FechaApertura);

		INSERT INTO TMPAPORTAMOCAPINT(AportacionID, Interes)
		SELECT AportacionID, SUM(Monto) AS Interes
			FROM APORTMOV
			WHERE NatMovimiento 	= Var_CargoNatMovimiento
			  AND TipoMovAportID 	= Var_TipoMovAportID
			  AND Fecha 			BETWEEN Var_FecIniMes AND Var_FecFinMes
			GROUP BY AportacionID;
	ELSE -- 2 Periodo
		INSERT INTO TMPAPORTAMOCAPINT(AportacionID, Interes)
		SELECT AportacionID, SUM(Monto) AS Interes
			FROM APORTMOV
			WHERE NatMovimiento 	= Var_CargoNatMovimiento
			  AND TipoMovAportID 	= Var_TipoMovAportID
			  AND Fecha 			BETWEEN Par_FechaApertura AND Par_FechaFin
			GROUP BY AportacionID;
	END IF;

	-- Actualiza el Interes Devengado Mes
	UPDATE TMPAPORTVIG TMP
		INNER JOIN TMPAPORTAMOCAPINT Inp ON TMP.AportacionID = Inp.AportacionID
	SET TMP.InteresDevMes =  Inp.Interes;

	TRUNCATE TABLE TMPAPORTAMOCAPINT;
	-- Fin InteresDevMes

	-- Tabla para obtener el ultimo pago de la aportacion que se renovo.
	DROP TEMPORARY TABLE IF EXISTS TMPULTPAGO;
	CREATE TEMPORARY TABLE TMPULTPAGO(
		AportacionID 		INT(11),
		AportacionRenovada	INT(11),
		AmortizacionID		INT(11),
		KEY (`AportacionID`)
	);

	-- Se inserta la infromación de la ultima amortizacion pagada de la aportacion
	INSERT INTO TMPULTPAGO (AportacionID, AportacionRenovada, AmortizacionID)
	SELECT	AporVig.AportacionID, MAX(Tmp.AportacionRenovada), MAX(Amo.AmortizacionID) AS MAXmortizacionID
			FROM TMPAPORTVIG AporVig
			INNER JOIN APORTACIONES Tmp ON AporVig.AportacionID = Tmp.AportacionID
			INNER JOIN AMORTIZAAPORT Amo ON Tmp.AportacionRenovada = Amo.AportacionId
			WHERE Tmp.AportacionRenovada 	<> Var_EnteroCero
			  AND Amo.Estatus 				= Var_EstPagada
			  AND Amo.FechaVencimiento 		<= Par_FechaFin
			GROUP BY AporVig.AportacionID;

	-- Se actualiza el campo MontoLiqApoAnt
	UPDATE TMPAPORTVIG Fil
		INNER JOIN TMPULTPAGO Tmp ON Fil.AportacionID = Tmp.AportacionID
		LEFT JOIN APORTACIONES Apo ON Tmp.AportacionRenovada = Apo.AportacionID
		LEFT JOIN AMORTIZAAPORT Amor ON  Amor.AmortizacionID = Tmp.AmortizacionID
									AND  Amor.AportacionID 	= Tmp.AportacionRenovada
	SET Fil.MontoLiqApoAnt = (IFNULL(CASE
		WHEN Apo.PagoIntCapitaliza = Var_ValorSI THEN (Amor.Capital+Amor.Interes-Amor.InteresRetener)
		ELSE Amor.Capital
		END,Var_DecimalCero));

	-- APORTACIONES CON VENCIMIENTO ANTICIPADO

	DROP TEMPORARY TABLE IF EXISTS TMPVENCIMANTI;

	CREATE TEMPORARY TABLE TMPVENCIMANTI(
		ConsecutivoID 			INT(11) NOT NULL AUTO_INCREMENT,
		AportacionID 			INT(11),
		AportacionRenovada		INT(11),
		Capital 				DECIMAL (14,2) DEFAULT 0.00,
		Intereses				DECIMAL (14,2) DEFAULT 0.00,
		ISR						DECIMAL (14,2) DEFAULT 0.00,
		PRIMARY KEY (`ConsecutivoID`,`AportacionID`)
	);

	-- Aportacion Renovada con Vencimiento Anticipado
	INSERT INTO TMPVENCIMANTI (AportacionID, AportacionRenovada)
		SELECT Apo.AportacionID, Apo.AportacionRenovada
			FROM TMPAPORTVIG TMP
			INNER JOIN APORTACIONES Apo ON TMP.AportacionID = Apo.AportacionID
				INNER JOIN APORTACIONES ARen ON ARen.AportacionID = Apo.AportacionRenovada
											AND  ARen.FechaVenAnt <> Var_FechaVacia
			WHERE Apo.AportacionRenovada <> Var_EnteroCero;

	SET	Var_NumReg = (Select COUNT(ConsecutivoID) FROM TMPVENCIMANTI);
	SET	Var_Contador = 1;

	-- Ciclo para aportaciones Renovadas Anticipadamente.
	WHILE Var_Contador <= Var_NumReg DO
		SET	Var_AportaRen	:= (SELECT AportacionRenovada FROM TMPVENCIMANTI WHERE ConsecutivoID = Var_Contador);
		SET	Var_Capital		:= Var_DecimalCero;
		SET	Var_ISR			:= Var_DecimalCero;
		SET	Var_Interes		:= Var_DecimalCero;
		SET	Var_CapitalAct	:= Var_DecimalCero;
		SET	Var_ISRAct		:= Var_DecimalCero;
		SET	Var_InteresAct	:= Var_DecimalCero;

		SET	Var_FechaVenAnt	:= (SELECT FechaVenAnt FROM APORTACIONES WHERE AportacionID = Var_AportaRen);

		SELECT IFNULL(SUM(CantidadMov),Var_DecimalCero)
				INTO Var_Capital
			FROM `HIS-CUENAHOMOV`
			WHERE ReferenciaMov = Var_AportaRen
			  AND TipoMovAhoID = Var_MovCapital
			  AND Fecha = Var_FechaVenAnt
			GROUP BY ReferenciaMov;

		SELECT IFNULL(SUM(CantidadMov),Var_DecimalCero)
				INTO Var_Interes
			FROM `HIS-CUENAHOMOV`
			WHERE ReferenciaMov = Var_AportaRen
			  AND TipoMovAhoID = Var_MovInteres
			  AND Fecha = Var_FechaVenAnt
			GROUP BY ReferenciaMov;

		SELECT IFNULL(SUM(CantidadMov),Var_DecimalCero)
				INTO Var_ISR
			FROM `HIS-CUENAHOMOV`
			WHERE ReferenciaMov = Var_AportaRen
			  AND TipoMovAhoID = Var_MovISR
			  AND Fecha = Var_FechaVenAnt
			GROUP BY ReferenciaMov;

		SELECT IFNULL(SUM(CantidadMov),Var_DecimalCero)
				INTO Var_CapitalAct
			FROM CUENTASAHOMOV
			WHERE ReferenciaMov = Var_AportaRen
			  AND TipoMovAhoID = Var_MovCapital
			  AND Fecha = Var_FechaVenAnt
			GROUP BY ReferenciaMov;

		SELECT IFNULL(SUM(CantidadMov),Var_DecimalCero)
				INTO Var_InteresAct
			FROM CUENTASAHOMOV
			WHERE ReferenciaMov = Var_AportaRen
			  AND TipoMovAhoID = Var_MovInteres
			  AND Fecha = Var_FechaVenAnt
			GROUP BY ReferenciaMov;

		SELECT IFNULL(SUM(CantidadMov),Var_DecimalCero)
				INTO Var_ISRAct
			FROM CUENTASAHOMOV
			WHERE ReferenciaMov = Var_AportaRen
			  AND TipoMovAhoID = Var_MovISR
			  AND Fecha = Var_FechaVenAnt
			GROUP BY ReferenciaMov;

		UPDATE TMPVENCIMANTI
			SET	Capital			= (Var_Capital + Var_CapitalAct),
				Intereses		= (Var_Interes + Var_InteresAct),
				ISR				= (Var_ISR + Var_ISRAct)
			WHERE ConsecutivoID = Var_Contador;

	SET	Var_Contador	:= Var_Contador + 1;
	END WHILE; -- Fin del Ciclo para aportaciones Renovadas Anticipadamente.

	UPDATE TMPAPORTVIG Fil
			INNER JOIN TMPVENCIMANTI Tmp ON Fil.AportacionID = Tmp.AportacionID
			LEFT JOIN APORTACIONES Apo ON Tmp.AportacionRenovada = Apo.AportacionID
		SET Fil.MontoLiqApoAnt = (IFNULL(CASE
			WHEN Apo.PagoIntCapitaliza = Var_ValorSI THEN (Tmp.Capital+Tmp.Intereses-Tmp.ISR)
			ELSE Tmp.Capital
		END,Var_DecimalCero));

	-- FIN APORTACIONES CON VENCIMIENTO ANTICIPADO

	-- Monto Liquidación Aportación Anterior para Consolidaciones
	DROP TEMPORARY TABLE IF EXISTS TMPMONLIQCON;
	CREATE TEMPORARY TABLE TMPMONLIQCON(
		AportacionID 		INT(11),
		AportacionRenovada	INT(11),
		MontoLiqApoAnt 		DECIMAL(20,2) DEFAULT 0.00,
		KEY (`AportacionID`)
	);

	-- Se inserta la infromación de la ultima amortizacion pagada de la aportacion
	INSERT INTO TMPMONLIQCON (AportacionID, AportacionRenovada, MontoLiqApoAnt)
	SELECT Tmp.AportacionID,Tmp.AportacionRenovada, IFNULL(SUM(Cons.TotalCons),Var_EnteroCero)
		FROM TMPAPORTVIG AporVig
		INNER JOIN APORTACIONES Tmp ON AporVig.AportacionID = Tmp.AportacionID
		INNER JOIN CONDICIONESVENCIMAPORT CApo ON CApo.AportacionID = Tmp.AportacionRenovada
		INNER JOIN APORTCONSOLIDADAS Cons ON CApo.AportacionID = Cons.AportacionID
		WHERE CApo.ConsolidarSaldos = Var_ValorSI
		  AND CApo.ConsolidarSaldos = Var_ValorSI
		GROUP BY Cons.AportacionID, Tmp.AportacionID;

	UPDATE TMPAPORTVIG Fil
			INNER JOIN TMPMONLIQCON Tmp ON Fil.AportacionID = Tmp.AportacionID
		SET Fil.MontoLiqApoAnt = Tmp.MontoLiqApoAnt;
	-- FIN Monto Liquidación Aportación Anterior para Consolidaciones

	SELECT AportacionID,	TipoAportacionID, 	DescripcionAportacion, 	CuentaAhoID, 		ClienteID,
			FechaInicio,	FechaVencimiento, 	Monto, 					Plazo, 				TasaFija,
			TasaISR, 		Estatus, 			FechaApertura, 			TasaFV, 			Descripcion,
			CalculoInteres, FormulaInteres, 	SobreTasa, 				PisoTasa, 			TechoTasa,
			TasaBase, 		TasaBaseDes, 		NombreCompleto, 		SucursalOrigen, 	NombreSucurs,
			PromotorActual, NombrePromotor, 	FechaAlta, 				PlazoOriginal, 		InteresGenerado,
			InteresRetener, InteresRecibir, 	tipoPagoInt, 			NombreCorto, 		Cantidad,
			MontoGlobal, 	DiaPago, 			InstitucionUno, 		CuentaDestUno, 		InstitucionDos,
			CuentaDestDos, 	InstitucionTres, 	CuentaDestTres, 		TasaSugerida, 		DiferenciaTasa,
			ReinversionAut, Notas, 				SaldoCap, 				Especificaciones,	FechaVenAnt,
			DineroNuevo,	MontoLiqApoAnt,		InteresIncRenov,		InteresPagPeriodo,	InteresDevPeriodo,
			InteresDevMes,	MontoRenovado,		InteresDevNoPagPeriodo,	DescEstatus
	FROM TMPAPORTVIG;

	DROP TABLE TMPAPORTAMOCAPINT;
	DROP TABLE TMPAPORTFILTRO;
	DROP TABLE TMPULTPAGO;
	DROP TABLE TMPVENCIMANTI;
	DROP TABLE TMPINTDEV;
	DROP TABLE TMPMONLIQCON;

END TerminaStore$$