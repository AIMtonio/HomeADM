-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RENOVACIONESCREAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RENOVACIONESCREAGROREP`;
DELIMITER $$

CREATE PROCEDURE `RENOVACIONESCREAGROREP`(
# =======================================================================================================
# --------------- SP PARA OBTENER DATOS DEL REPORTE DE RENOVACIONES DE CREDITO --------------------------
# =======================================================================================================
	Par_FechaInicio			DATE,			-- Fecha Inicial de Busqueda de Renovaciones
	Par_FechaFin			DATE,			-- Fecha Final de Busqueda de Renovaciones
	Par_SucursalID			INT(10),		-- Sucursal de Credito Renovado
	Par_ProductoCreditoID	INT(10),		-- Producto de Credito del Credito Renovado

	Par_EmpresaID			INT(11),    	-- Parametros de Auditoria
    Aud_Usuario				INT(11),		-- Parametros de Auditoria
    Aud_FechaActual			DATETIME,		-- Parametros de Auditoria
    Aud_DireccionIP			VARCHAR(15),	-- Parametros de Auditoria
    Aud_ProgramaID			VARCHAR(50),	-- Parametros de Auditoria
    Aud_Sucursal			INT,			-- Parametros de Auditoria
    Aud_NumTransaccion		BIGINT			-- Parametros de Auditoria
	)
TerminaStore:begin

	-- Declaracion de Contantes
	DECLARE EnteroCero		INT(1);
	DECLARE DecimalCero		DECIMAL(14,2);
	DECLARE FechaVacia		DATE;
	DECLARE EstInactivo		CHAR(1);
	DECLARE EstAutorizado	CHAR(1);
	DECLARE EstVigente		CHAR(1);
	DECLARE EstPagado		CHAR(1);
	DECLARE EstCancelado 	CHAR(1);
	DECLARE EstVencido		CHAR(1);
	DECLARE EstCastigado	CHAR(1);
	DECLARE Inactivo		VARCHAR(20);
	DECLARE Autorizado		VARCHAR(20);
	DECLARE Vigente			VARCHAR(20);
	DECLARE Pagado			VARCHAR(20);
	DECLARE Cancelado		VARCHAR(20);
	DECLARE Vencido			VARCHAR(20);
	DECLARE Castigado		VARCHAR(20);
	DECLARE CreRenovacion	CHAR(1);
	DECLARE EstaDesembolso	CHAR(1);


	-- Declaracion de Variable
	DECLARE	Var_Sentencia	VARCHAR(10000);

	-- Asignacion de Constantes
	SET EnteroCero	  := 0;					-- Constante Entero Cero
	SET DecimalCero   := 0.0;				-- Constante Decimal
	SET FechaVacia	  := '1900-01-01';		-- Constante FechaVacia
	SET EstInactivo   := 'I';				-- Estatus Inactivo
	SET EstAutorizado := 'A';				-- Estatus Autorizado
	SET EstVigente	  := 'V';				-- Estatus Vigente
	SET EstPagado	  := 'P';				-- Estatus Pagado
	SET EstCancelado  := 'C';				-- Estatus Cancelado
	SET EstVencido    := 'B';				-- Estatus Vencido
	SET EstCastigado  := 'K';				-- Estatus Cancelado
	SET Inactivo 	  := 'INACTIVO';		-- Descripcion Estatus Inactivo
	SET Autorizado    := 'AUTORIZADO';		-- Descripcion Estatus Autorizado
	SET Vigente		  := 'VIGENTE';			-- Descripcion Estatus Vigente
	SET Pagado		  := 'PAGADO';			-- Descripcion Estatus Pagado
	SET Cancelado	  := 'CANCELADO';		-- Descripcion Estatus Cancelado
	SET Vencido		  := 'VENCIDO';			-- Descripcion Estatus Vencido
	SET Castigado	  := 'CASTIGADO';		-- Descripcion Estatus Castigado
	SET CreRenovacion	:= 'O';				-- Tipo de tratamiento: Renovacion
    SET EstaDesembolso	:= 'D';				-- Estatus desembolsado de una renovacion


	-- Asignacion de Variable
	SET Par_FechaInicio 		:= ifnull(Par_FechaInicio,FechaVacia);
	SET	Par_FechaFin			:= ifnull(Par_FechaFin,FechaVacia);
	SET	Par_SucursalID			:= ifnull(Par_SucursalID,EnteroCero);
	SET	Par_ProductoCreditoID	:= ifnull(Par_ProductoCreditoID,EnteroCero);

	SET Var_Sentencia :=  'SELECT Cli.ClienteID,		Cli.NombreCompleto,		Res.CreditoOrigenID,		Res.CreditoDestinoID,		CONCAT(ProO.ProducCreditoID,"-", ProO.Descripcion) AS ProductoOrigen, ';
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' CONCAT(ProD.ProducCreditoID,"-", ProD.Descripcion) AS ProductoDestino, 				CreD.FechaMinistrado,
							CASE Res.EstatusCreacion WHEN "',EstInactivo,'" THEN "',Inactivo,
										  '" WHEN "',EstAutorizado,'" THEN "',Autorizado,
										  '" WHEN "',EstVigente,'" THEN "',Vigente,
										  '" WHEN "',EstPagado,'" THEN "',Pagado,
										  '" WHEN "',EstCancelado,'" THEN "',Cancelado,
										  '" WHEN "',EstVencido,'" THEN "',Vencido,
										  '" WHEN "',EstCastigado,'" THEN "',Castigado,
							'" END AS Estatus, ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' IFNULL(Res.NumPagoActual,',EnteroCero,') AS NumPagoSoste, IFNULL(SUM(Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi),',DecimalCero,') AS SaldoTotalCapital, ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' IFNULL(SUM(Amo.SaldoInteresOrd + Amo.SaldoInteresAtr + Amo.SaldoInteresVen + Amo.SaldoInteresPro + Amo.SaldoIntNoConta + Amo.SaldoIVAInteres),',DecimalCero,') AS SaldoInteresTotal,
												  IFNULL(SUM(Amo.SaldoMoratorios + Amo.SaldoIVAMorato + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen),',DecimalCero,') AS SaldoMoratorioTotal,');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' TIME(NOW()) AS Hora, CreD.SucursalID , Suc.NombreSucurs ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' FROM REESTRUCCREDITO Res ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN AMORTICREDITO Amo ON Amo.CreditoID = Res.CreditoDestinoID AND Amo.Estatus != " ', EstPagado, '"');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' INNER JOIN CREDITOS CreO ON Res.CreditoOrigenID = CreO.CreditoID ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' INNER JOIN CREDITOS CreD ON Res.CreditoDestinoID = CreD.CreditoID AND CreD.FechaMinistrado >= ? AND CreD.FechaMinistrado <= ? ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' INNER JOIN CLIENTES Cli ON CreO.ClienteID = Cli.ClienteID');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' INNER JOIN PRODUCTOSCREDITO ProO ON CreO.ProductoCreditoID = ProO.ProducCreditoID ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' INNER JOIN PRODUCTOSCREDITO ProD ON CreD.ProductoCreditoID = ProD.ProducCreditoID ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES Suc ON CreD.SucursalID = Suc.SucursalID ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHERE Res.Origen = "', CreRenovacion, '" AND Res.EstatusReest="', EstaDesembolso,'" ');

	IF(Par_SucursalID != EnteroCero) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' AND CreD.SucursalID = ', Par_SucursalID);
	END IF;

	IF(Par_ProductoCreditoID != EnteroCero) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' AND CreD.ProductoCreditoID = ', Par_ProductoCreditoID);
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' AND CreD.EsAgropecuario = "S" ');


	SET Var_Sentencia :=  CONCAT(Var_Sentencia,	' GROUP BY Res.CreditoDestinoID, Cli.ClienteID, Cli.NombreCompleto, Res.CreditoOrigenID, ProO.ProducCreditoID,',
												'ProO.Descripcion, ProD.ProducCreditoID, ProD.Descripcion, CreD.FechaMinistrado, Res.EstatusCredAnt,',
												'Res.NumPagoActual, CreD.SucursalID, Suc.NombreSucurs;');

	SET @Sentencia	= Var_Sentencia;
	SET @FechaIni	= Par_FechaInicio;
	SET @FechaFin	= Par_FechaFin;

	PREPARE SPRENOVACIONESREP FROM @Sentencia;


	EXECUTE SPRENOVACIONESREP USING @FechaIni, @FechaFin;

	DEALLOCATE PREPARE SPRENOVACIONESREP;

end TerminaStore$$